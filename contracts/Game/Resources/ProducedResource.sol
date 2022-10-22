pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Management/GameManager.sol";

contract ProducedResource is ERC20, Ownable {

    address gameManager;
    mapping(address => bool) minters;

    constructor(string memory _name, string memory _symbol, address _gameManager) ERC20(_name, _symbol) public {
        gameManager = _gameManager;
        minters[GameManager(gameManager).farmManager()] = true;
    }

    function changeMinter(address _minter, bool state) external onlyOwner {
        minters[_minter] = state;
    }

    function mint(address to, uint amount) external {
        require(minters[msg.sender], "!Minter");
        _mint(to, amount);
    }

    function burn(address from, uint amount) external {
        require(minters[msg.sender], "!Minter");
        _burn(from, amount);
    }
}
