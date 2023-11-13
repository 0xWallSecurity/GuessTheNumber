# Guess The Number

## Disclaimer
<b> This project is aimed at learning and sharpening core coding skills in solidity. It is not meant to be a real project deployed to any real net with real money involved. Furthermore, this project has not been audited and may contain vulnerable code parts, that could be exploited. Use this project with caution. </b>

## About
Guess The Number is a simple raffle game, where the user pays a small fee to enter a game and picks a number. If that number is equivalent to the contracts number picked, the user wins the contracts prize pool. The contract takes a 5% cut as a fee of each game, which will not be payed out.

## Set Up
### Prerequesites
This project needs foundry to be installed to run the tests. Check via `forge -V`.
For the `make` commands, make needs to be installed. Check via `make -v`.
Furthermore `make` requires the local anvil node to be running. Open a terminal and run `anvil`.

### make
Run `make runScript` to deploy the contract to your local anvil node. You can then interact with the contract via forge cast or writing your own scripts.
Run `make runTest` or `make runTestVerbose` to run tests. 
