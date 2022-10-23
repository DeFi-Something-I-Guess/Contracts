pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Underlying.sol";

struct ReserveConfigurationMap {
    uint256 data;
}

struct ReserveData {
    ReserveConfigurationMap configuration;
    uint128 liquidityIndex;
    uint128 currentLiquidityRate;
    uint128 variableBorrowIndex;
    uint128 currentVariableBorrowRate;
    uint128 currentStableBorrowRate;
    uint40 lastUpdateTimestamp;
    uint16 id;
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    address interestRateStrategyAddress;
    uint128 accruedToTreasury;
    uint128 unbacked;
    uint128 isolationModeTotalDebt;
}

interface IAave {
    function supply(address asset,uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function withdraw(address asset,uint256 amount,address to) external;
    function borrow(address asset,uint256 amount,uint256 interestRateMode,uint16 referralCode,address onBehalfOf) external;
    function repay(address asset,uint256 amount,uint256 interestRateMode,address onBehalfOf) external;
    function getReserveData(address asset) external view returns (ReserveData memory);
}

contract AaveV3Underlying is Underlying{
    
    address lendingPool;
    bool initialised;

    constructor(){
        //set the implementation as initialised
        initialised = true;
    }

    function initialiser(address _a, address _lp) public {
        require(initialised == false, "intiailised");
        initialised = true;
        asset = _a;
        lendingPool = _lp;
        ReserveData memory reserve = IAave(lendingPool).getReserveData(asset);
        depositToken = reserve.aTokenAddress;
    }

    // Todo: Reentrancy Guard
    function deposit(uint amount) external override {
        uint startAsset = IERC20(asset).balanceOf(address(this));
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        uint changeAsset = IERC20(asset).balanceOf(address(this)) - startAsset;

        IERC20(asset).approve(lendingPool, changeAsset);

        uint startAToken = IERC20(depositToken).balanceOf(address(this));
        IAave(lendingPool).supply(asset, changeAsset, address(this), 0);
        uint changeAToken = IERC20(depositToken).balanceOf(address(this)) - startAToken; 

        IERC20(depositToken).transfer(msg.sender, changeAToken);
    }

    // Todo: Reentrancy Guard
    function withdraw(uint amount) external override {
        uint startAToken = IERC20(depositToken).balanceOf(address(this));
        IERC20(depositToken).transferFrom(msg.sender, address(this), amount);
        uint changeAToken = IERC20(depositToken).balanceOf(address(this)) - startAToken;

        IERC20(depositToken).approve(lendingPool, changeAToken);

        uint startAsset = IERC20(asset).balanceOf(address(this));
        IAave(lendingPool).withdraw(asset, changeAToken, address(this));
        uint changeAsset = IERC20(asset).balanceOf(address(this)) - startAsset; 

        IERC20(asset).transfer(msg.sender, changeAsset);
    }
}