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
    | File                              | % Lines        | % Statements   | % Branches    | % Funcs        |
    |-----------------------------------|----------------|----------------|---------------|----------------|
    | script/DeployGuessTheNumber.s.sol | 46.15% (6/13)  | 52.63% (10/19) | 0.00% (0/2)   | 100.00% (1/1)  |
    | script/DeployHelper.s.sol         | 0.00% (0/7)    | 0.00% (0/8)    | 100.00% (0/0) | 0.00% (0/1)    |
    | script/DeployVRFHelper.s.sol      | 5.56% (1/18)   | 4.00% (1/25)   | 100.00% (0/0) | 14.29% (1/7)   |
    | src/GuessTheNumber.sol            | 81.48% (22/27) | 78.38% (29/37) | 60.00% (6/10) | 80.00% (8/10)  |
    | Total                             | 44.62% (29/65) | 44.94% (40/89) | 50.00% (6/12) | 52.63% (10/19) |
2. ~fix TODO test~
3. finish documentation for helper contracts + tests
4. better errors with params
5. extend the project
