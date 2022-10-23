pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IEmittedResource is IERC20 {
    function owner() external view returns(address);
    function initialiser(string memory __name, string memory __symbol, uint _emissionRate, address _gameManager) external;
    function changeMinter(address _minter, bool state) external;
    function mint(address to, uint level, uint time) external;
    function mintAmount(uint level, uint time) external view returns(uint amount);
    function burn(address from, uint amount) external;
}
