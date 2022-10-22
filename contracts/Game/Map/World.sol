pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "../Player/Farm.sol";
import "../Management/GameManager.sol";
import "hardhat/console.sol";

contract World is Ownable {

    mapping(uint => mapping(uint => address)) map;
    mapping(uint => mapping(uint => uint)) nftId;
    mapping(address => bool) pvp;
    address farmImplementation;
    address gameManager;
    address resourceManager;
    uint maxXY;
    
    uint plotPrice;

    constructor(uint _plotPrice, address _farmImplementation, address _gameManager, uint _maxXY) public {
        plotPrice = _plotPrice;
        farmImplementation = _farmImplementation;
        gameManager = _gameManager;
        maxXY = _maxXY;
    }

    //Very Basic World
    function buyPlot(uint x, uint y) external payable {
        require(map[x][y] == address(0), "Plot Owned");
        require(msg.value >= plotPrice,  "Value Low");
        require(x <maxXY && y < maxXY, "Outside Map");
        map[x][y] = msg.sender;
        deployFarm(x, y);
    }

    function deployFarm(uint x, uint y) internal {
        address deployedAddress = Clones.clone(farmImplementation);
        Farm(deployedAddress).initialise(msg.sender, gameManager, x, y);
        map[x][y] = deployedAddress;
    }

    function getFarmAt(uint x, uint y) external view returns(address){
        return map[x][y];
    }

    function expandMap(uint _newMaxXY) external onlyOwner {
        require(_newMaxXY > maxXY, "Invalid Size");
        maxXY = _newMaxXY;
    } 

    function distance(uint x1, uint x2, uint y1, uint y2) external view returns(uint d){
        uint _x1 = x1 > x2? x1 : x2;
        uint _x2 = x1 > x2? x2 : x1;

        uint xDistance = (_x1 * _x1) - (_x2 * _x2);

        uint _y1 = y1 > y2 ? y1 : y2;
        uint _y2 = y1 > y2 ? y2 : y1;

        uint yDistance = (_y1 * _y1) - (_y2 * _y2);
        
        d = yDistance + xDistance;
    }

    function togglePVP(uint x, uint y) external {
        address plot = map[x][y];
        require(Farm(plot).owner() == msg.sender, "only farm owner");
        pvp[plot] = true;
    }

    receive() external payable {}
    fallback() external payable {}
}
