// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./MyERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract myerc20b is MyERC20 {

//User information 
struct UserInfo {
  address user;
  uint256 balance;
}

// User Registry 
mapping(address => UserInfo) public UserReg;

function addUser() public {
  UserInfo memory newUser = UserInfo({user: msg.sender, balance: 0});
  UserReg[msg.sender] = newUser;
}

function mint(address to, uint256 amount) public override {
  MyERC20.mint(to, amount); //addts the minted amount to the existing balance. 
  uint256 balance;
  balance = IERC20(address(this)).balanceOf(to); //balance is current 
  //this is the real balance before adding amount. 
  UserInfo storage user = UserReg[to];
  user.balance = balance; 


 //UserInfo memory newUser = UserInfo({user: to, balance: amount});
//need to get balances from first contract and add to them. 
//UserReg[to] = newUser;
  UserInfo storage user = UserReg[to];
  user.balance = user.balance + amount;
  
}

}


