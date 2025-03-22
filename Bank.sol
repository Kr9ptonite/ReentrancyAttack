// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// Contract is vulnerable bank (contains reentrancy vulnerability)
contract VBank {
    mapping(address => uint256) public balances;


    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");

        (bool success, ) = msg.sender.call{value: amount}(""); // Payment
        require(success, "Transfer failed");

        // VULNERABILITY: Resetting balance after payment, allowing reentrancy
        balances[msg.sender] = 0;
    }
}
