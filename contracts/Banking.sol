// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract bankOpen {

constructor() {
  president = msg.sender;
}

address president;

  struct BankAccount {
    address accountnumber;
    uint256 balanace;
    bool Registered;
    bool AccountExecutive;
    address[] authorizedUser;
   //bytes5 password;
  }

  mapping(address => BankAccount) private accountReg;

//Modifiers 
modifier onlyPersident {
        require(msg.sender == president,"Only President can call this function.");
        _;
    }

modifier onlyAdmin {
        require(msg.sender == president, "Only Aministrator can call this function.");
        _;
    }

//Calldata finctions 

//Functions 
function addAdmin() returns {
require(president = msg.sender, "Not autherized")
//add 
}
}