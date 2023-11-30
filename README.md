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
    | File                              | % Lines         | % Statements    | % Branches    | % Funcs        |
    |-----------------------------------|-----------------|-----------------|---------------|----------------|
    | script/DeployGuessTheNumber.s.sol | 100.00% (13/13) | 100.00% (19/19) | 50.00% (1/2)  | 100.00% (1/1)  |
    | script/DeployHelper.s.sol         | 0.00% (0/7)     | 0.00% (0/8)     | 100.00% (0/0) | 0.00% (0/1)    |
    | script/DeployVRFHelper.s.sol      | 80.00% (16/20)  | 77.78% (21/27)  | 100.00% (0/0) | 75.00% (6/8)   |
    | src/GuessTheNumber.sol            | 81.48% (22/27)  | 78.38% (29/37)  | 60.00% (6/10) | 80.00% (8/10)  |
    | Total                             | 76.12% (51/67)  | 75.82% (69/91)  | 58.33% (7/12) | 75.00% (15/20) |
2. ~fix TODO test~
3. finish documentation for helper contracts + tests
  1. ~DeployGuessTheNumber.s.sol~
  2. DeployHelper.s.sol
  3. DeployVRFHelper.s.sol
4. extend the project
  1. save all winners to a list
  2. maybe save all players too?
5. better errors with params
