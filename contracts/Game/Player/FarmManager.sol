pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Resources/ResourceManager.sol";
import "../Resources/WrappedResource.sol";
import "../Resources/EmittedResource.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract FarmManager is Ownable {

    address gameManager;

    mapping(uint => address) allFarms;
    mapping(address => uint) farmNftNumber;
    mapping(address => bool) validFarms;

    mapping(address => mapping(uint => uint)) resourceLevels;
    mapping(address => mapping(uint => uint)) lastHarvest;
    mapping(address => mapping(uint => uint)) buildingLevels;

    constructor(address _gameManager) {
        gameManager = _gameManager;
    }

    function levelUpResource(address farm, uint resource) external {
        harvestResource(farm, resource);
        ResourceManager resourceManager = ResourceManager(GameManager(gameManager).resourceManager());

        Resource memory r = resourceManager.getResource(resource);
        uint _currentLevel = resourceLevels[farm][resource];
        uint required = r.levelUpValue;

        //todo: User Buys Asset To Upgrade Level
        uint underlyingBefore = IERC20(r.asset).balanceOf(address(this));
        console.log(IERC20(r.asset).balanceOf(address(this)));
        console.log(IERC20(r.asset).balanceOf(address(msg.sender)));
        console.log(r.asset);
        console.log(required);
        IERC20(r.asset).transferFrom(msg.sender, address(this), required);
        uint underlyingChange = IERC20(r.asset).balanceOf(address(this)) - underlyingBefore;

        IERC20(r.asset).approve(r.resourceToken, underlyingChange);

        uint resourceTokenBefore = IERC20(r.resourceToken).balanceOf(address(this));
        WrappedResource(r.resourceToken).deposit(underlyingChange);
        uint resourceTokenChange = IERC20(r.resourceToken).balanceOf(address(this)) - resourceTokenBefore;

        IERC20(r.resourceToken).transfer(farm, resourceTokenChange);

        resourceLevels[farm][resource] += 1;
        lastHarvest[farm][resource] = block.timestamp;
    }

    function harvestResource(address farm, uint resource) public {
        uint time = block.timestamp - lastHarvest[farm][resource];
        if(time > 0) {
            lastHarvest[farm][resource] = block.timestamp;
            ResourceManager resourceManager = ResourceManager(GameManager(gameManager).resourceManager());
            Resource memory r = resourceManager.getResource(resource);

            uint level = resourceLevels[farm][resource];
            
            console.log("Balance Before: %s", IERC20(r.emittedResource).balanceOf(farm));
            EmittedResource(r.emittedResource).mint(farm, level, time);
            console.log("Balance After: %s", IERC20(r.emittedResource).balanceOf(farm));
            
        }
    }

    //Harvest the resources of a farm that are pending
    function harvestAll(address farm) public {
        ResourceManager resourceManager = ResourceManager(GameManager(gameManager).resourceManager());

        for(uint i=0; i<resourceManager.totalResources(); i++){
            harvestResource(farm, i);
        }
    }

}
