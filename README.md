# Guess The Number

## Disclaimer
<b> This project is aimed at learning and sharpening core coding skills in solidity. It is not meant to be a real project deployed to any real net with real money involved. Furthermore, this project has not been audited and may contain vulnerable code parts, that could be exploited. Use this project with caution. </b>

## About
Guess The Number is a simple raffle game, where the user pays a small fee to enter a game and picks a number. If that number is equivalent to the contracts number picked, the user wins the contracts prize pool. The contract takes a 5% cut as a fee of each game, which will not be payed out.

This project is based on the [Cyfrin Foundry Solidity Course](https://github.com/Cyfrin/foundry-full-course-f23).

## Set Up
### Prerequesites
This project needs foundry to be installed to run the tests. Check via `forge -V`.
For the `make` commands, make needs to be installed. Check via `make -v`.
Furthermore `make` requires the local anvil node to be running. Open a terminal and run `anvil`.

### make
Run `make runScript` to deploy the contract to your local anvil node. You can then interact with the contract via forge cast or writing your own scripts.
Run `make runTest` or `make runTestVerbose` to run tests. 

## TODO
1. expand testing:
    | File                              | % Lines        | % Statements   | % Branches    | % Funcs       |
    |-----------------------------------|----------------|----------------|---------------|---------------|
    | script/DeployGuessTheNumber.s.sol | 0.00% (0/13)   | 0.00% (0/19)   | 0.00% (0/2)   | 0.00% (0/1)   |
    | script/DeployHelper.s.sol         | 0.00% (0/7)    | 0.00% (0/8)    | 100.00% (0/0) | 0.00% (0/1)   |
    | script/DeployVRFHelper.s.sol      | 0.00% (0/18)   | 0.00% (0/25)   | 100.00% (0/0) | 0.00% (0/7)   |
    | src/GuessTheNumber.sol            | 82.14% (23/28) | 78.95% (30/38) | 60.00% (6/10) | 80.00% (8/10) |
    | Total                             | 34.85% (23/66) | 33.33% (30/90) | 50.00% (6/12) | 42.11% (8/19) |
    1.1. fix TODO test
2. finish documentation for helper contracts + tests
    2.1. better errors with params
3. extend the project
