pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract EmittedResource is ERC20 {

    address gameManager;
    uint emissionRate;
    uint minute = 60;
    mapping(address => bool) minters;
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

    function initialiser(string memory __name, string memory __symbol, uint _emissionRate, address _gameManager) public {
        require(initialised == false, "intiailised");
        initialised = true;
        _symbol = __symbol;
        _name = __name;
        emissionRate = _emissionRate;
        gameManager = _gameManager;
        minters[GameManager(gameManager).farmManager()] = true;
        owner = msg.sender;
    }

    function name() public override view returns(string memory){
        return _name;
    }
    
    function symbol() public override view returns(string memory){
        return _symbol;
    }

    function changeMinter(address _minter, bool state) external onlyOwner {
        minters[_minter] = state;
    }

    function mint(address to, uint level, uint time) external {
        require(minters[msg.sender], "!Minter");
        uint amount = mintAmount(level, time);
        _mint(to, amount);
    }

    function mintAmount(uint level, uint time) public view returns(uint amount){
        amount = ((time * emissionRate) * level) / time;
        console.log("minted : %s", amount);
    }

    function burn(address from, uint amount) external {
        require(minters[msg.sender], "!Minter");
        _burn(from, amount);
    }

}
