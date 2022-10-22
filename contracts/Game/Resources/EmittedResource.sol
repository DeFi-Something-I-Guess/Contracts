pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract EmittedResource is ERC20, Ownable {

    address gameManager;
    uint emissionRate;
    uint minute = 60;
    mapping(address => bool) minters;

    constructor(string memory _name, string memory _symbol, uint _emissionRate, address _gameManager) ERC20(_name, _symbol) public {
        emissionRate = _emissionRate;
        gameManager = _gameManager;
        minters[GameManager(gameManager).farmManager()] = true;
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
