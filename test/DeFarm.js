const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const worldContract  = artifacts.require ("./DeWorld.sol");
const farmContract  = artifacts.require ("./DeFarm.sol");

contract("DeFarm", async accounts => {

  var deployedDeWorldContract
  var deployedFarmContract

  it('should be able to deploy', async () => {
    deployedDeWorldContract = await worldContract.new({from: accounts[0]})
  });

  it('should be able to create a farm', async () => {
    await deployedDeWorldContract.createPlot(0, 0);

    plot = await deployedDeWorldContract.getPlot(0, 0);

    deployedFarmContract = await farmContract.at(plot)
    console.log(plot)
  });


});