//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";

contract DeployHelper is Script {
    uint256 private ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    DeployConfig private deployConfig;

    struct DeployConfig {
        uint256 privateKey;
    }

    constructor() {
        // anvil
        if (block.chainid == 31337) {
            deployConfig = setAnvilConfig();
        }
    }

    function setAnvilConfig() public  returns (DeployConfig memory anvilDeployConfig) {
        anvilDeployConfig = DeployConfig(ANVIL_PRIVATE_KEY); 
    }
}