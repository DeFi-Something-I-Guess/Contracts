pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

interface IWrappedResource {
    function withdraw(uint redeemAmount) external;
    function asset() external view returns(address);
}

contract ResourceTransmuter {

    address wrappedToken;
    address emittedToken;
    bool initialised;

    constructor(){
        //set the implementation as initialised
        initialised = true;
    }

    function initialiser(address _wrappedToken, address _emittedToken) public {
        require(initialised == false, "intiailised");
        initialised = true;
        wrappedToken = _wrappedToken;
        emittedToken = _emittedToken;
    }

    function exchangeRate() public view returns(uint){
        return IERC20(wrappedToken).balanceOf(address(this)) * 1e18 / (IERC20(emittedToken).totalSupply());
    }

    function redeem(uint amount, bool unwrapToken) external {
        IERC20(emittedToken).transferFrom(msg.sender, address(this), amount);
        uint redeemAmount = (amount * exchangeRate()) / 1e18;
        if(unwrapToken){
            unwrap(redeemAmount);
        }
        else {
            IERC20(wrappedToken).transfer(msg.sender, redeemAmount);
        }
    }

    function unwrap(uint amount) public {
        address asset = IWrappedResource(wrappedToken).asset();
        uint startBalance = IERC20(asset).balanceOf(address(this));
        IWrappedResource(wrappedToken).withdraw(amount);
        uint changeBalance = IERC20(asset).balanceOf(address(this)) - startBalance;

        IERC20(asset).transfer(msg.sender, changeBalance);
    }
}