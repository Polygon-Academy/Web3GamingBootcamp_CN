// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.7.1;

import "./IERC20.sol";

contract StarsCoins is IERC20 { // inheritance / implementing an interface
    string public _name = "Stars Coins" ;
    string public _symbol = "Stars"; // like CFX
    uint256 public _totalSupply;
    uint8 _decimals;
    address public manager; //for collecting fees?- TBD

    // keep track of account balances and allowances
    mapping (address => uint256) _balances;
    mapping (address => mapping(address => uint256)) allowed;

    //event Transfer(address from, address to, uint256 amount);
    //event Approval(address from, address to, uint256 value);

    constructor() {
        manager = msg.sender;
    }

    // getters
    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }
    
    function decimals() external view returns (uint8) {
        return _decimals;
    }


    function balanceOf(address addr) external view override returns (uint256) {
        return _balances[addr];
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function allowance(address sender, address receiver) external view override returns (uint256) {
        return allowed[sender][receiver];
    }
    
    function approve(address spender, uint256 amount) external override returns (bool){
        require(_balances[msg.sender] >= amount, "Stars: Insufficient balance");
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // transfer between accounts
    function transfer(address receiver, uint256 amount) external override returns (bool){
        require(_balances[msg.sender] >= amount, "Stars: Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    //transfer of allowances 
    function transferFrom(address sender, address receiver, uint256 amount) external override returns (bool){
        require(_balances[sender] >= amount, "Stars: Insufficient balance");
        require(allowed[sender][msg.sender] >= amount, "Stars: Insufficient allowance");
        _balances[sender] -= amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;
        _balances[receiver] += amount;
        emit Transfer(sender, receiver, amount);
        return true;
    }

    function _fromTransfer(address sender, address receiver, uint256 amount) public returns (bool){
        require(_balances[sender] >= amount, "Stars: Insufficient balance");
        _balances[sender] -= amount;
        _balances[receiver] += amount;
        emit Transfer(sender, receiver, amount);
        return true;
    }

    function _mint(
            address receiver, //user conflux addy
            uint256 amount, //user mint amount
            //address fee_address, //sponsor of the token
            uint256 fee //mint fee + receive wallet fee
    ) public{
    require(receiver != address(0), "Stars: Invalid receiver.");
    _totalSupply += amount;
    _balances[receiver] += amount;
    emit Transfer(address(0), receiver, amount);
    
    //TODO: future work
    //_balances[manager] += fee;
    }

    function _burn(
            address sender, //user conflux addy
            uint256 amount, //user mint amount
            uint256 fee //burn fee
    )public{
    require(sender != address(0), "Stars: Invalid sender.");
    require(_balances[sender] >= amount, "Stars: Not enough to burn.");
    _totalSupply -= amount;
    _balances[sender] -= amount;
    emit Transfer(sender, address(0), amount);

    //TODO: future work
    //_balances[manager] += fee;
    
    } 

}