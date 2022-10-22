pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract GameManager is Ownable {

    address public world;
    address public resourceManager;
    address public farmImplementation;
    address public exchange;
    address public treasureManager;
    address public farmManager;
    address public buildingManager;
    address public troopManager;
    bool public pause;

    function setWorld(address _world) external onlyOwner {
        require(_world != address(0), "address(0)");
        world = _world;
    }

    function setResourceManager(address _resourceManager) external onlyOwner {
        require(_resourceManager != address(0), "address(0)");
        resourceManager = _resourceManager;
    }

    function setFarmImplementation(address _farmImplementation) external onlyOwner {
        require(_farmImplementation != address(0), "address(0)");
        farmImplementation = _farmImplementation;
    }

    function setExchange(address _exchange) external onlyOwner {
        require(_exchange != address(0), "address(0)");
        exchange = _exchange;
    }

    function setTreasureManager(address _treasureManager) external onlyOwner {
        require(_treasureManager != address(0), "address(0)");
        treasureManager = _treasureManager;
    }

    function setFarmManager(address _farmManager) external onlyOwner {
        require(_farmManager != address(0), "address(0)");
        farmManager = _farmManager;
    }

    function setBuildingManager(address _buildingManager) external onlyOwner {
        require(_buildingManager != address(0), "address(0)");
        buildingManager = _buildingManager;
    }

    function setTroopManager(address _troopManager) external onlyOwner {
        require(_troopManager != address(0), "address(0)");
        troopManager = _troopManager;
    }

    function togglePause(bool _pause) external onlyOwner {
        pause = _pause;
    }
}
