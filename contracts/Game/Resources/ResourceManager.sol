pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "../Management/GameManager.sol";
import "./Interfaces/IAaveV3Underlying.sol";
import "./Interfaces/IEmittedResource.sol";
import "./Interfaces/IResourceTransmuter.sol";
import "./Interfaces/IWrappedResource.sol";
import "hardhat/console.sol";

struct Resource {
    address asset;
    address underlying;
    address depositToken;
    address resourceToken;
    address emittedResource;
    address transmuter;
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

    
    function addResource(address resourceAddress, address emittedResource, address underlying, address transmuter, uint levelUp) public onlyOwner {
        require(_hasToken[underlying] == false, "Resource Exists");
        _hasToken[underlying] = true;
        
        uint decimals = ITokenInfo(IWrappedResource(resourceAddress).asset()).decimals();
        uint levelValue = (levelUp * 10**decimals) / scaleFactor;

        Resource memory r = Resource({
            asset: IWrappedResource(resourceAddress).asset(),
            underlying: underlying,
            depositToken: IWrappedResource(resourceAddress).depositToken(),
            resourceToken: resourceAddress,
            emittedResource: emittedResource,
            transmuter: transmuter,
            levelUpValue: levelValue
        });
        _resources[totalResources] = r;
        totalResources += 1;
    }

    function generateNewAaveResource(AaveResourceSetup memory aaveResource) external onlyOwner {

        address a = Clones.clone(GameManager(gameManager).aaveV3Implementation());
        IAaveV3Underlying(a).initialiser(aaveResource.underlying, aaveResource.pool);

        address w = Clones.clone(GameManager(gameManager).wrappedResourceImplementation());
        IWrappedResource(w).initialiser(aaveResource.wrappedName, aaveResource.wrappedSymbol, address(a), gameManager);

        address e = Clones.clone(GameManager(gameManager).emittedResourceImplementation());
        IEmittedResource(e).initialiser(aaveResource.emittedName, aaveResource.emittedSymbol, aaveResource.emissionRate, gameManager);

        address t = Clones.clone(GameManager(gameManager).transmuterImplementation());
        IResourceTransmuter(t).initialiser(address(w), address(e));

        IWrappedResource(w).setTransmuter(address(t));
        addResource(address(w), address(e), aaveResource.underlying, address(t), aaveResource.levelUp);
    }
    
    
    function getResource(uint r) external view returns(Resource memory) {
        return _resources[r];
    }
    
}