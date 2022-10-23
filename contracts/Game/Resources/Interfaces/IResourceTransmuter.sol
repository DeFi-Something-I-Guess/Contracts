pragma solidity >=0.8.0;

interface IResourceTransmuter {
    function initialiser(address _wrappedToken, address _emittedToken) external;
    function exchangeRate() external view returns(uint);
    function redeem(uint amount, bool unwrapToken) external;
    function unwrap(uint amount) external;
}