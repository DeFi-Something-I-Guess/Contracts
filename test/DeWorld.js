const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const baseContract  = artifacts.require ("./DeWorld.sol");

contract("DeWorld", async accounts => {

  var deployedContract

  it('should be able to deploy', async () => {
    deployedContract = await baseContract.new({from: accounts[0]})
  });

});