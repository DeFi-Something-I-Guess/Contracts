pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV3 {
    function exactInputSingle(ExactInputSingleParams memory params) external payable returns (uint256 amountOut);
}

interface IWrappedNative {
    function deposit() external payable;
}

struct ExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
}


contract UniswapV3Helper {

    function swapExactTokensForTokens(address router, address tokenIn, address tokenOut, uint24 fee, uint amountIn, uint amountOut, address to) external {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(router, amountIn);

        ExactInputSingleParams memory params =
                ExactInputSingleParams({
                    tokenIn: address(tokenIn),
                    tokenOut: address(tokenOut),
                    fee: uint24(fee),
                    recipient: to,
                    amountIn: amountIn,
                    amountOutMinimum: amountOut,
                    sqrtPriceLimitX96: 0
                });

            IUniswapV3(router).exactInputSingle(params); 

    }

    function deposit(address wrappedNative) external payable {
        IWrappedNative(wrappedNative).deposit{value: msg.value}();
        IERC20(wrappedNative).transfer(msg.sender, msg.value);
    }

    receive() external payable {}
    fallback() external payable {}
}
