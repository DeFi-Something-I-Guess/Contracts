pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface IWrappedResource is IERC20 {
    function initialiser(string memory __name, string memory __symbol, address _underlying, address _gameManager) external;
    function setTransmuter(address _transmuter) external;
    function getInterest() external view returns(uint);
    function deposit(uint amount) external;
    function withdraw(uint amount) external;
    function mintInterest() external;
    function owner() external view returns(address);
    function totalSupplied() external view returns(uint);
    function transmuter() external view returns(address);
    function gameManager() external view returns(address);
    function depositToken() external view returns(address);
    function underlying() external view returns(address);
    function asset() external view returns(address);
}
