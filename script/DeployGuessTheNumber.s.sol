// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";

contract DeployGuessTheNumber is Script {
    uint256 private constant ENTRANCE_FEE = 1e15;
    function run() external returns (GuessTheNumber) {
        vm.startBroadcast();
        GuessTheNumber guessTheNumber = new GuessTheNumber(ENTRANCE_FEE);
        vm.stopBroadcast();
        return guessTheNumber;
    }
}
