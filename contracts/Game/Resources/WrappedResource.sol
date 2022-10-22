pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Underlying.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract WrappedResource is ERC20 {

    address public underlying;
    address public asset;
    address public depositToken;
    address public resourceToken;
    address public gameManager;
    uint public totalSupplied;

    constructor(string memory _name, string memory _symbol, address _underlying, address _gameManager) ERC20(_name, _symbol) public {
        underlying = _underlying;
        asset = Underlying(underlying).asset();
        depositToken = Underlying(underlying).depositToken();
        gameManager = _gameManager;
    }

    // Total Interest Gained by This Wrapper
    function getInterest() public view returns(uint){
        return IERC20(Underlying(underlying).depositToken()).balanceOf(address(this)) - totalSupplied;
    }

    // Todo: Reentrancy Guard
    // Todo: Underlying action
    function deposit(uint amount) external {
        mintInterest();

        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(underlying, amount);
        Underlying(underlying).deposit(amount);
        _mint(msg.sender, amount);
        totalSupplied += amount;
    }

    // Todo: Reentrancy Guard
    // Todo: Underlying action
    function withdraw(uint amount) external {
        mintInterest();

        require(balanceOf(msg.sender) >= amount, "Insufficient");
        _burn(msg.sender, amount);
        IERC20(depositToken).approve(address(underlying), amount);
        Underlying(underlying).withdraw(amount);
        totalSupplied -= amount;
        IERC20(asset).transfer(msg.sender, amount);
    }

    // Mint Interest
    function mintInterest() public {
        uint interest = getInterest();
        if(interest > 0){
            _mint(GameManager(gameManager).treasureManager(), interest);
        }
    }
}
