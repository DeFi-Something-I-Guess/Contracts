# DeFi Farmers Contracts

### Contracts
deployedGameManager: 0x7641125FA3AfCD53821eD23513eCe40FB2b0cC95
deployedFarmContract: 0xAE24950EB361C090b3ca289Be3718829f90255Ab
deployedWrappedResource: 0x96Feef21E710b2c8D8CdB7aE3089235966aa21c6
deployedAULContract: 0x467c41FFfed51E9209F49aa8DA06Da505d211116
deployedEmittedResource: 0x47bea397C017a7BE000095375ed568Fb0b69C806
deployedTransmuter: 0xaE1F54061f320Aa953d3D963dc5caD8944F69A68
deployedResourceManager: 0x4622EE9a74284effB35f7e6c327bB09e6dBc22D9
deployedFarmManager: 0x2956682c53C6a9e07331Ce4f2519c08e63Fa7d17
deployedWorldContract: 0xB44F0BC275408ACc33C6142e4C745033CD2D23A2
deployedUniswapV3Helper: 0xb69edcB7dB7877a624F50704880e5EC0393b9556

### Author: Hephyrius

A template repo that I use for quickly starting new solidity projects.

Using hardhat for development and truffle for deployment.

### Install packages

```
yarn
```

### Setting up env variables

create a .env and fill values or use the .env.template and rename to .env

```
ACC_KEY = ""
RPC_LINK = "https://bsc-dataseed.binance.org/"
NETWORK_ID = 56
GAS_PRICE = 5000000000
```

## Test contracts

```
npx hardhat test
```

## Deploy to mainnet

```
truffle migrate --network live
```
