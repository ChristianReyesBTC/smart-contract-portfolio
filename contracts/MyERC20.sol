// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//Contract module which provides a basic access control mechanism, where there is an account (an owner) that can be granted exclusive access to specific functions. By default, the owner account will be the one that deploys the contract.

//MODIFIERS
//onlyOwner()- which can be applied to your functions to restrict their use to the owner.

//FUNCTIONS
//constructor()
//owner()
//_checkOwner()
//renounceOwnership()
//transferOwnership(newOwner)
//_transferOwnership(newOwner)

//ownable Simple mechanism with a single account authorized for all privileged actions
contract MyERC20 is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 20 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public  onlyOwner {
        _mint(to, amount);
    }

    
}

//balances are stored here 