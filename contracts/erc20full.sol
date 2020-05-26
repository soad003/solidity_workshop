// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.4;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 * Don't do this at home! https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract Token is IERC20 {
    uint constant SUPPLY_MAX = 100000;
    
    mapping(address => uint) balances;
    mapping(address => mapping (address => uint256)) allowances;
    
    
    function totalSupply() external override view returns (uint256) {
        return SUPPLY_MAX;
    }
    
    function balanceOf(address who) external override view returns (uint256){
        return balances[who];
    }
    
    function transfer(address to, uint256 value) external override returns (bool) {
        require(to != address(0), "ERC20: approve to the zero address");
        require(balances[msg.sender] >= value, "Insufficient Funds.");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return allowances[owner][spender];
    }
    
    function approve(address spender, uint256 value) external override returns (bool){
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) external override returns (bool){
        require(balances[from] >= value, "Balance of owner account to small.");
        require(allowances[from][msg.sender] >= value, "allowance of sender account to small.");
        balances[from] -= value;
        balances[to] += value;
        emit Transfer(from, to, value);
        allowances[from][msg.sender] -= value;
        return true;
    }
    
}
