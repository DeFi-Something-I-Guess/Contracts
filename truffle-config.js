const HDWalletProvider = require('@truffle/hdwallet-provider')
require('dotenv').config()

module.exports = {
  networks: {
    local: {
      host: 'localhost',
      port: 8545,
      network_id: '31337',
    },
    live: {
      provider: function () {
        return new HDWalletProvider([process.env.ACC_KEY], process.env.RPC_LINK)
      },
      network_id: process.env.NETWORK_ID,
      gas: 4000000,
      gasPrice: process.env.GAS_PRICE,
      skipDryRun: true,
      networkCheckTimeout:999999
    },
  },
  compilers: {
    solc: {
      version: '^0.8.0',
      settings: {
        optimizer: {
          enabled: true,
          runs: 999999,
        },
      },
    },
  },
}
