pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Underlying.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract WrappedResource is ERC20 {

    address public asset;
    address public underlying;
    address public depositToken;
    address public gameManager;
    address public transmuter;
    uint public totalSupplied;    
    address public owner;
    bool initialised;
    string _name;
    string _symbol;

    modifier onlyOwner{
        require(msg.sender == owner, "OnlyOwner");
        _;
    }

    constructor() ERC20("", ""){
        //set the implementation as initialised
        initialised = true;
    }

     function initialiser(string memory __name, string memory __symbol, address _underlying, address _gameManager) public {
        require(initialised == false, "intiailised");
        initialised = true;
        _symbol = __symbol;
        _name = __name;
        underlying = _underlying;
        asset = Underlying(underlying).asset();
        depositToken = Underlying(underlying).depositToken();
        gameManager = _gameManager;
        owner = msg.sender;
    }
    
    function setTransmuter(address _transmuter) external {
        require(transmuter == address(0), "Already set");
        transmuter = _transmuter;
    }

    // Total Interest Gained by This Wrapper
    function getInterest() public view returns(uint){
        return IERC20(Underlying(underlying).depositToken()).balanceOf(address(this)) - totalSupplied;
    }

    // Todo: Reentrancy Guard
    function deposit(uint amount) external {
        mintInterest();

        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(underlying, amount);
        Underlying(underlying).deposit(amount);
        _mint(msg.sender, amount);
        totalSupplied += amount;
    }

    // Todo: Reentrancy Guard
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
            _mint(transmuter, interest);
        }
    }
}
