// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";

contract DeployGuessTheNumber is Script {
    function run() external returns (GuessTheNumber) {
        vm.startBroadcast();
        GuessTheNumber guessTheNumber = new GuessTheNumber();
        vm.stopBroadcast();
        return guessTheNumber;
    }
}
