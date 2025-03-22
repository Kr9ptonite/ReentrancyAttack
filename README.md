# ReentrancyAttack
In this repository I demonstrate a basic reentrancy vulnerability, how to exploit it, and how to test it using Foundry. Practicing audit thinking and understanding callstack logic.


project structure:
/src
 Bank.sol   // Vulnerable contract
 Attacker.sol   // Attack contract

/test
 Reentrancy.t.sol   // Test written in Foundry

/other
foundry.toml   // Foundry config
README.md
.gitignore
