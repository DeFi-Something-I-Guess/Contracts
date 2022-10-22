pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Resources/ResourceManager.sol";
import "../Resources/WrappedResource.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract Farm {

    address owner;
    address gameManager;
    bool initialised;
    uint x;
    uint y;

    function initialise(address _owner, address _gameManager, uint _x, uint _y) external {
        require(!initialised, "Initialised");
        owner = _owner;
        gameManager = _gameManager;
        x = _x;
        y = _y;
    }

    function transferToken(address token, uint amount) external {
        require(msg.sender == GameManager(gameManager).farmManager(), "!Farm Manager");
        IERC20(token).transfer(msg.sender, amount);
    }
}