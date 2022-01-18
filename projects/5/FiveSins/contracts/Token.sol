pragma solidity ^0.8.3;

import "hardhat/console.sol";

contract Token {
    string public name = "FiveSins Game Token";
    string public symbol = "WAT";
    uint256 public totalSupply = 100000000;
    address public owner;
    mapping(address => uint256) balances;

    constructor() {
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
