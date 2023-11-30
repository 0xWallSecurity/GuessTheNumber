// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { GuessTheNumber } from "../src/GuessTheNumber.sol";
import { DeployGuessTheNumber } from "../script/DeployGuessTheNumber.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {VRFCoordinatorV2Mock} from "./mocks/VRFCoordinatorV2Mock.sol";
import {DeployHelper} from "../script/DeployHelper.s.sol";

contract TestGuessTheNumber is Test {
    GuessTheNumber public guessTheNumber;
    DeployHelper public deployHelper;

    uint256 entranceFee;
    uint64 subId;
    address vrfCoordinatorV2;
    bytes32 keyHash;
    uint256 privateKey;

    function setUp() external {
    }

    function testAnvilConfig() public {
        if (block.chainid == 31337) {
            DeployGuessTheNumber deploy = new DeployGuessTheNumber();
            (guessTheNumber, deployHelper) = deploy.run();
            (entranceFee, subId, , keyHash, privateKey) = deployHelper.deployConfig();
            assertEq(entranceFee, 1e16);
            assertEq(subId, 0);
            assertEq(keyHash, 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc);
            assertEq(privateKey, 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        }
    }
}