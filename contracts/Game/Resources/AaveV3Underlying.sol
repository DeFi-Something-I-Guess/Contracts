pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Underlying.sol";


  struct ReserveConfigurationMap {
    uint256 data;
  }

struct ReserveData {
    //stores the reserve configuration
    ReserveConfigurationMap configuration;
    //the liquidity index. Expressed in ray
    uint128 liquidityIndex;
    //the current supply rate. Expressed in ray
    uint128 currentLiquidityRate;
    //variable borrow index. Expressed in ray
    uint128 variableBorrowIndex;
    //the current variable borrow rate. Expressed in ray
    uint128 currentVariableBorrowRate;
    //the current stable borrow rate. Expressed in ray
    uint128 currentStableBorrowRate;
    //timestamp of last update
    uint40 lastUpdateTimestamp;
    //the id of the reserve. Represents the position in the list of the active reserves
    uint16 id;
    //aToken address
    address aTokenAddress;
    //stableDebtToken address
    address stableDebtTokenAddress;
    //variableDebtToken address
    address variableDebtTokenAddress;
    //address of the interest rate strategy
    address interestRateStrategyAddress;
    //the current treasury balance, scaled
    uint128 accruedToTreasury;
    //the outstanding unbacked aTokens minted through the bridging feature
    uint128 unbacked;
    //the outstanding debt borrowed against this asset in isolation mode
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

    constructor(address _a, address _lp) {
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