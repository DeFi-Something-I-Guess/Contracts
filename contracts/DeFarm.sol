pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "hardhat/console.sol";

contract DeFarm is Ownable {

    address farmOwner;
    mapping(uint => uint) trees;
    uint maxTrees;

    constructor(address _farmOwner) public {
        farmOwner = _farmOwner;
    }
    receive() external payable {}
    fallback() external payable {}
}
