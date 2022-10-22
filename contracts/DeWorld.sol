pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract DeWorld is Ownable {

    mapping(uint => mapping(uint => address)) world;
    uint xSize = 1000;
    uint ySize = 1000;

    constructor() public {}
    receive() external payable {}
    fallback() external payable {}

    /*
    *   Deploy a farm contract at (x,y)
    *   Ensure it is in bounds and no farm already exists here 
    */
    function createPlot(uint x, uint y) public {
        require(x < xSize && y < ySize, "Out of Bounds");
        require(world[x][y] != address(0), "A Farm Already Exists");
        _deployFarm();
    }

    /*
    *   internal function used to deploy a farm at (x,y)
    */
    function _deployFarm() internal {

    }



}
