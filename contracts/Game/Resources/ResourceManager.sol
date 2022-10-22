pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WrappedResource.sol";
import "./EmittedResource.sol";
import "./AaveV3Underlying.sol";
import "hardhat/console.sol";

struct Resource {
    address asset;
    address underlying;
    address depositToken;
    address resourceToken;
    address emittedResource;
    uint levelUpValue;
}

struct AaveResourceSetup{
    uint emissionRate;
    uint levelUp;
    address underlying;
    address pool;
    string wrappedName;
    string wrappedSymbol;
    string emittedName;
    string emittedSymbol;
}

interface ITokenInfo {
    function decimals() external view returns(uint);
}

contract ResourceManager is Ownable {

    uint public totalResources = 0;
    uint public scaleFactor = 10000;
    address public gameManager;
    mapping(uint => Resource) private _resources;
    mapping(address => bool) private _hasToken;

    constructor(address _gameManager) {
        gameManager = _gameManager;
    }

    function addResource(address resourceAddress, address emittedResource, address underlying, uint levelUp) public onlyOwner {
        require(_hasToken[underlying] == false, "Resource Exists");
        _hasToken[underlying] = true;
        
        uint decimals = ITokenInfo(WrappedResource(resourceAddress).asset()).decimals();
        uint levelValue = (levelUp * 10**decimals) / scaleFactor;

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

    function generateNewAaveResource(AaveResourceSetup memory aaveResource) external onlyOwner {
        AaveV3Underlying a = new AaveV3Underlying(aaveResource.underlying, aaveResource.pool);
        WrappedResource w = new WrappedResource(aaveResource.wrappedName, aaveResource.wrappedSymbol, address(a), gameManager);
        EmittedResource e = new EmittedResource(aaveResource.emittedName, aaveResource.emittedSymbol, aaveResource.emissionRate, gameManager);
        addResource(address(w), address(e), aaveResource.underlying, aaveResource.levelUp);
    }

    function getResource(uint r) external view returns(Resource memory) {
        return _resources[r];
    }
}