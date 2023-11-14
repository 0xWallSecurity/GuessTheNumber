//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";
import {VRFCoordinatorV2Mock} from "../test/mocks/VRFCoordinatorV2Mock.sol";

contract DeployHelper is Script {
    uint256 private ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    DeployConfig public deployConfig;

    struct DeployConfig {
        uint256 entranceFee;
        uint64 subId;
        address vrfCoordinatorV2;
        bytes32 keyHash;
        uint256 privateKey;
    }

    constructor() {
        // anvil
        if (block.chainid == 31337) {
            deployConfig = setAnvilConfig();
        }
    }

    function setAnvilConfig() public returns (DeployConfig memory anvilDeployConfig) {
        uint96 baseFee = 1e17;
        uint96 gasPrice = 1e9;

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorV2Mock = new VRFCoordinatorV2Mock(baseFee, gasPrice);
        vm.stopBroadcast();

        anvilDeployConfig = DeployConfig({
            entranceFee: 1e16,
            subId: 0, // need to set this up after deploying
            vrfCoordinatorV2: address(vrfCoordinatorV2Mock),
            keyHash: 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc,
            privateKey: ANVIL_PRIVATE_KEY
        });
    }
}