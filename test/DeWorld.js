const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const baseContract  = artifacts.require ("./DeWorld.sol");

contract("DeWorld", async accounts => {

  var deployedDeWorldContract

  it('should be able to deploy', async () => {
    deployedDeWorldContract = await baseContract.new({from: accounts[0]})
  });

  it('should be able to create a farm', async () => {
    await deployedDeWorldContract.createPlot(0, 0);
  });

});