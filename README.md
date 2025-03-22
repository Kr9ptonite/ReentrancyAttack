# ReentrancyAttack
In this repository I demonstrate a basic reentrancy vulnerability, how to exploit it, and how to test it using Foundry. Practicing audit thinking and understanding callstack logic.


/src  
       Bank.sol            // Vulnerable contract  
       Attacker.sol        // Attack contract  
       IBank.sol           // Interface (optional, if needed)  

/test  
      Reentrancy.t.sol    // Foundry test for the attack  

/other 
   foundry.toml            // Foundry config  
   README.md               // Project description  
   .gitignore              // Ignore config for unnecessary files  
