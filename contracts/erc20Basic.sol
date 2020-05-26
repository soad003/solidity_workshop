pragma solidity ^0.6.4;
abstract contract ERC20Basic {
  uint256 public totalSupply;
  function transfer(address to, uint256 value) public virtual  returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}