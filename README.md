# evm.la - Emoji 👻 Wallet

## Test

```bash
forge test --gas-report
```

```bash
[⠔] Compiling...
No files changed, compilation skipped

Running 2 tests for test/EMJ.t.sol:EMJTest
[PASS] testMint() (gas: 286026)
[PASS] testMintFail() (gas: 266260)
Test result: ok. 2 passed; 0 failed; finished in 1.19ms

Running 3 tests for test/SBT.t.sol:SBTTest
[PASS] testMint() (gas: 244237)
[PASS] testMintFail() (gas: 22111)
[PASS] testUpdate() (gas: 266680)
Test result: ok. 3 passed; 0 failed; finished in 1.35ms
```

| src/EMJ.sol:EmojiWallet contract |                 |        |        |        |         |
| -------------------------------- | --------------- | ------ | ------ | ------ | ------- |
| Deployment Cost                  | Deployment Size |        |        |        |         |
| 2541195                          | 12862           |        |        |        |         |
| Function Name                    | min             | avg    | median | max    | # calls |
| mint                             | 254963          | 260684 | 260684 | 266405 | 2       |

| src/SBT.sol:SBT contract |                 |        |        |        |         |
| ------------------------ | --------------- | ------ | ------ | ------ | ------- |
| Deployment Cost          | Deployment Size |        |        |        |         |
| 1229971                  | 6702            |        |        |        |         |
| Function Name            | min             | avg    | median | max    | # calls |
| getMetadataBySoul        | 6961            | 6961   | 6961   | 6961   | 1       |
| mint                     | 7408            | 151963 | 224241 | 224241 | 3       |
| update                   | 10539           | 10539  | 10539  | 10539  | 1       |
