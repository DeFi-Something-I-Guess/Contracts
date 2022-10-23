pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract GameManager is Ownable {

    address public world;
    address public resourceManager;
    address public farmImplementation;
    address public exchange;
    address public farmManager;
    address public aaveV3Implementation;
    address public emittedResourceImplementation;
    address public wrappedResourceImplementation;
    address public transmuterImplementation;
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

    function setFarmManager(address _farmManager) external onlyOwner {
        require(_farmManager != address(0), "address(0)");
        farmManager = _farmManager;
    }

    function setAaveV3Implementation(address _aaveV3Implementation) external onlyOwner {
        require(_aaveV3Implementation != address(0), "address(0)");
        aaveV3Implementation = _aaveV3Implementation;
    }

    function setEmittedResourceImplementation(address _emittedResourceImplementation) external onlyOwner {
        require(_emittedResourceImplementation != address(0), "address(0)");
        emittedResourceImplementation = _emittedResourceImplementation;
    }

    function setWrappedResourceImplementation(address _wrappedResourceImplementation) external onlyOwner {
        require(_wrappedResourceImplementation != address(0), "address(0)");
        wrappedResourceImplementation = _wrappedResourceImplementation;
    }

    function setTransmuterImplementation(address _transmuterImplementation) external onlyOwner {
        require(_transmuterImplementation != address(0), "address(0)");
        transmuterImplementation = _transmuterImplementation;
    }

    function togglePause(bool _pause) external onlyOwner {
        pause = _pause;
    }

}
