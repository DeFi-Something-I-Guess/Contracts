pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Resources/WrappedResource.sol";
import "hardhat/console.sol";

contract ResourceTransmuter is Ownable {

    address token0;
    address token1;

    function exchangeRate() public view returns(uint){
        return IERC20(token0).balanceOf(address(this)) * 1e18 / (IERC20(token1).totalSupply());
    }

    function redeem(uint amount, bool unwrapToken) external {
        IERC20(token1).transferFrom(msg.sender, address(this), amount);
        uint redeemAmount = (amount * exchangeRate()) / 1e18;
        if(unwrapToken){
            unwrap(redeemAmount);
        }
        else {
            IERC20(token0).transfer(msg.sender, redeemAmount);
        }
    }

    function unwrap(uint amount) public {
        uint startBalance = IERC20(WrappedResource(token0).asset()).balanceOf(address(this));
        WrappedResource(token0).withdraw(amount);
        uint changeBalance = IERC20(WrappedResource(token0).asset()).balanceOf(address(this)) - startBalance;

        IERC20(WrappedResource(token0).asset()).transfer(msg.sender, changeBalance);
    }
}