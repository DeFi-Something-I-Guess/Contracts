pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WrappedResource.sol";
import "hardhat/console.sol";

struct Resource {
    address asset;
    address underlying;
    address depositToken;
    address resourceToken;
    address emittedResource;
    uint levelUpValue;
}

interface ITokenInfo {
    function decimals() external view returns(uint);
}

contract ResourceManager is Ownable {

    uint public totalResources = 0;
    uint public scaleFactor = 10000;
    mapping(uint => Resource) private _resources;

    function addResource(address resourceAddress, address emittedResource, uint _levelUp) external onlyOwner {

        uint decimals = ITokenInfo(WrappedResource(resourceAddress).asset()).decimals();
        uint levelValue = (_levelUp * 10**decimals) / scaleFactor;
    

        Resource memory r = Resource({
            asset: WrappedResource(resourceAddress).asset(),
            underlying: WrappedResource(resourceAddress).underlying(),
            depositToken: WrappedResource(resourceAddress).depositToken(),
            resourceToken: resourceAddress,
            emittedResource: emittedResource,
            levelUpValue: levelValue
        });
        _resources[totalResources] = r;
        totalResources += 1;
    }

    function getResource(uint r) external view returns(Resource memory) {
        return _resources[r];
    }
}