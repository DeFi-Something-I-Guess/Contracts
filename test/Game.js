const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const IERC20Contract    = artifacts.require ("./IERC20.sol");
const worldContract    = artifacts.require ("./World.sol");
const farmContract   = artifacts.require ("./Farm.sol");
const gameManagerContract   = artifacts.require ("./GameManager.sol");
const aaveULContract   = artifacts.require ("./AaveV3Underlying.sol");
const emitterContract  = artifacts.require ("./EmittedResource.sol");
const rmContract       = artifacts.require ("./ResourceManager.sol");
const wrContract       = artifacts.require ("./WrappedResource.sol");
const fmContract       = artifacts.require ("FarmManager.sol");
const prContract       = artifacts.require ("ProducedResource.sol");
const v3HelperContract = artifacts.require ("./UniswapV3Helper.sol");


contract("Game", async accounts => {

  var aaveV3Pool      = "0x794a61358D6845594F94dc1DB02A252b5b4814aD"
  var USDC            = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
  var Weth            = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619"
  var WMatic          = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270"
  var uniswapV3Router = "0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45"
  var deployedWorldContract
  var deployedFarmContract
  var deployedGameManager
  var deployedResourceManager
  var deployedEmittedResource
  var deployedUniswapV3Helper
  var deployedFarmManager
  var deployedAULContract
  var deployedWrappedResource
  var plot

  it('should be able to deploy farm', async () => {
    deployedGameManager = await gameManagerContract.new({from: accounts[0]})
  });

  it('should be able to deploy farm', async () => {
    deployedFarmContract = await farmContract.new({from: accounts[0]})
    await deployedGameManager.setFarmImplementation(deployedFarmContract.address)
  });

  it('should be able to deploy resource manager', async () => {
    deployedResourceManager = await rmContract.new( {from: accounts[0]})
    await deployedGameManager.setResourceManager(deployedResourceManager.address)
  });

  it('should be able to deploy farm manager', async () => {
    deployedFarmManager = await fmContract.new(deployedGameManager.address, {from: accounts[0]})
    await deployedGameManager.setFarmManager(deployedFarmManager.address)
  });

  it('should be able to deploy an underlying resource adapter for aave', async () => {
    deployedAULContract = await aaveULContract.new(USDC, aaveV3Pool, {from: accounts[0]})
  });

  it('should be able to deploy a wrapped resource', async () => {
    deployedWrappedResource = await wrContract.new("DeAppleTree", "DeFi Farm: Apple Tree", deployedAULContract.address, deployedGameManager.address, {from: accounts[0]})
  });

  it('should be able to deploy an emitter resource', async () => {
    deployedEmittedResource = await emitterContract.new("DeApple", "DeFi Farm: Apple", 0.001e5, deployedGameManager.address, {from: accounts[0]})
  });

  it('should be able to add resources to the manager', async () => {
    var level = 10000
    await deployedResourceManager.addResource(deployedWrappedResource.address, deployedEmittedResource.address, level)
    var res = await deployedResourceManager.getResource(0)
    console.log(res)
  });

  it('should be able to deploy world', async () => {
    var plotPrice = web3.utils.toWei("1")
    deployedWorldContract = await worldContract.new(plotPrice, deployedFarmContract.address, deployedGameManager.address, 1000, {from: accounts[0]})
    await deployedGameManager.setWorld(deployedWorldContract.address)
  });

  it('should be able to buy a plot', async () => {
    await deployedWorldContract.buyPlot(0, 10, {value: web3.utils.toWei("1")})
    plot = await deployedWorldContract.getFarmAt(0, 10)
    console.log("Plot : " + plot)
  });

  it('should be able to get some USDC via Uni v3', async () => {
    deployedUniswapV3Helper = await v3HelperContract.new()
    await deployedUniswapV3Helper.deposit(WMatic, {value :web3.utils.toWei("1000")})
    var WMaticContract = await IERC20Contract.at(WMatic)
    await WMaticContract.approve(deployedUniswapV3Helper.address, web3.utils.toWei("10000"))
    await deployedUniswapV3Helper.swapExactTokensForTokens(uniswapV3Router, WMatic, USDC, 3000, await WMaticContract.balanceOf(accounts[0]), 0, accounts[0])
  });

  it('should be able to lvl up resource', async () => {
    var usdc = await IERC20Contract.at(USDC)
    await usdc.approve(deployedFarmManager.address, await usdc.balanceOf(accounts[0]))
    console.log(Number(await usdc.balanceOf(accounts[0])))
    await deployedFarmManager.levelUpResource(plot, 0)
  });

  it('should be able to harvest all resources', async () => {
    await deployedFarmManager.harvestAll(plot)
  });

  it('should be able to harvest all resources', async () => {
    await deployedFarmManager.harvestAll(plot)
  });

});