const IERC20Contract = artifacts.require("./IERC20.sol");
const worldContract = artifacts.require("./World.sol");
const farmContract = artifacts.require("./Farm.sol");
const gameManagerContract = artifacts.require("./GameManager.sol");
const aaveULContract = artifacts.require("./AaveV3Underlying.sol");
const emitterContract = artifacts.require("./EmittedResource.sol");
const rmContract = artifacts.require("./ResourceManager.sol");
const wrContract = artifacts.require("./WrappedResource.sol");
const trContract = artifacts.require("./ResourceTransmuter.sol");
const fmContract = artifacts.require("FarmManager.sol");
const v3HelperContract = artifacts.require("./UniswapV3Helper.sol");

module.exports = async (deployer) => {
  var aaveV3Pool = "0x794a61358D6845594F94dc1DB02A252b5b4814aD"
  var USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
  var Weth = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619"
  var WMatic = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270"
  var bal = "0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3"
  var dpi = "0x85955046DF4668e1DD369D2DE9f3AEB98DD2A369"
  var btc = "0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6"
  var uniswapV3Router = "0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45"
  var deployedWorldContract
  var deployedFarmContract
  var deployedGameManager
  var deployedResourceManager
  var deployedEmittedResource
  var deployedTransmuter
  var deployedUniswapV3Helper
  var deployedFarmManager
  var deployedAULContract
  var deployedWrappedResource
  var plot

  deployedGameManager = await gameManagerContract.new()
  console.log("deployedGameManager: " + deployedGameManager.address)

  deployedFarmContract = await farmContract.new()
  console.log("deployedFarmContract: " + deployedFarmContract.address)
  await deployedGameManager.setFarmImplementation(deployedFarmContract.address)

  deployedWrappedResource = await wrContract.new()
  console.log("deployedWrappedResource: " + deployedWrappedResource.address)
  await deployedGameManager.setWrappedResourceImplementation(deployedWrappedResource.address)

  deployedAULContract = await aaveULContract.new()
  console.log("deployedAULContract: " + deployedAULContract.address)
  await deployedGameManager.setAaveV3Implementation(deployedAULContract.address)

  deployedEmittedResource = await emitterContract.new()
  console.log("deployedEmittedResource: " + deployedEmittedResource.address)
  await deployedGameManager.setEmittedResourceImplementation(deployedEmittedResource.address)

  deployedTransmuter = await trContract.new()
  console.log("deployedTransmuter: " + deployedTransmuter.address)
  await deployedGameManager.setTransmuterImplementation(deployedTransmuter.address)

  deployedResourceManager = await rmContract.new(deployedGameManager.address)
  console.log("deployedResourceManager: " + deployedResourceManager.address)
  await deployedGameManager.setResourceManager(deployedResourceManager.address)

  deployedFarmManager = await fmContract.new(deployedGameManager.address)
  console.log("deployedResourceManager: " + deployedResourceManager.address)
  await deployedGameManager.setFarmManager(deployedFarmManager.address)

  var plotPrice = web3.utils.toWei("0")
  deployedWorldContract = await worldContract.new(plotPrice, deployedFarmContract.address, deployedGameManager.address, 1000)
  console.log("deployedWorldContract: " + deployedWorldContract.address)
  await deployedGameManager.setWorld(deployedWorldContract.address)
  
  deployedUniswapV3Helper = await v3HelperContract.new()
  console.log("deployedUniswapV3Helper: " + deployedUniswapV3Helper.address)

  var aaveResouceSetup = {
    'emissionRate': 1,
    'levelUp': 1,
    'underlying': USDC,
    'pool': aaveV3Pool,
    'wrappedName': "DeFi Farm: Apple Tree",
    'wrappedSymbol': "DeAppleTree",
    'emittedName': "DeFi Farm: Apple",
    'emittedSymbol': "DeApple"
  }
  await deployedResourceManager.generateNewAaveResource(aaveResouceSetup)

  aaveResouceSetup = {
    'emissionRate': 1,
    'levelUp': 1,
    'underlying': Weth,
    'pool': aaveV3Pool,
    'wrappedName': "DeFi Farm: Pear Tree",
    'wrappedSymbol': "DePearTree",
    'emittedName': "DeFi Farm: Pear",
    'emittedSymbol': "DePear"
  }
  await deployedResourceManager.generateNewAaveResource(aaveResouceSetup)

  aaveResouceSetup = {
    'emissionRate': 1,
    'levelUp': 1,
    'underlying': bal,
    'pool': aaveV3Pool,
    'wrappedName': "DeFi Farm: Blackberry Bush",
    'wrappedSymbol': "DeBlackberryBush",
    'emittedName': "DeFi Farm: Blackberry",
    'emittedSymbol': "DeBlackberry"
  }
  await deployedResourceManager.generateNewAaveResource(aaveResouceSetup)

  aaveResouceSetup = {
    'emissionRate': 1,
    'levelUp': 1,
    'underlying': dpi,
    'pool': aaveV3Pool,
    'wrappedName': "DeFi Farm: Palm Tree",
    'wrappedSymbol': "DePalmTree",
    'emittedName': "DeFi Farm: Palm Oil",
    'emittedSymbol': "DePalmOil"
  }
  await deployedResourceManager.generateNewAaveResource(aaveResouceSetup)

  var aaveResouceSetup = {
    'emissionRate': 1,
    'levelUp': 1,
    'underlying': WMatic,
    'pool': aaveV3Pool,
    'wrappedName': "DeFi Farm: Orange Tree",
    'wrappedSymbol': "DeOrangeTree",
    'emittedName': "DeFi Farm: Orange",
    'emittedSymbol': "DeOrange"
  }
  await deployedResourceManager.generateNewAaveResource(aaveResouceSetup)

};