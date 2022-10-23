pragma solidity >=0.8.0;

interface IAaveV3Underlying {
    function initialiser(address _a, address _lp) external;
    function deposit(uint amount) external;
    function withdraw(uint amount) external;
}