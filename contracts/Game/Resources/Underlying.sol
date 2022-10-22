pragma solidity >=0.8.0;

contract Underlying {

    address public asset;
    address public depositToken;

    // Todo: Reentrancy Guard
    function deposit(uint amount) external virtual {}

    // Todo: Reentrancy Guard
    function withdraw(uint amount) external virtual {}
}