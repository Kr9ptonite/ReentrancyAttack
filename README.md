# ReentrancyAttack

In this repository, I demonstrate a basic reentrancy vulnerability, how to exploit it, and how to test it using Foundry.
Practicing audit thinking and understanding callstack logic.

## /src:  
      Bank.sol           // Vulnerable smart contract (the "victim")  
      Attacker.sol       // Attack contract that exploits the vulnerability  

## /test:  
      Reentrancy.t.sol   // Foundry test for demonstrating the exploit  

## /other:
      foundry.toml        // Foundry configuration file  
      READMEPROJECT.md     // Project description  (automatic)
      CALLSTACK.md        // Detailed explanation of the callstack  
     .gitignore          // Ignore list for unnecessary files  
