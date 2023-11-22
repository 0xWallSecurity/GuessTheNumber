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
    address public constant PLAYER = address(1);
    uint256 public constant START_BALANCE = 100 ether;

    uint256 entranceFee;
    uint64 subId;
    address vrfCoordinatorV2;
    bytes32 keyHash;
    uint256 privateKey;

    function setUp() external {
        DeployGuessTheNumber deploy = new DeployGuessTheNumber();
        (guessTheNumber, deployHelper) = deploy.run();
        (entranceFee, subId, vrfCoordinatorV2, keyHash, privateKey) = deployHelper.deployConfig();
        vm.deal(PLAYER, START_BALANCE);
        vm.deal(address(guessTheNumber), START_BALANCE);
    }

    function testScriptsOnlyRunOnAnvilYet() public {
        vm.chainId(11155111); // SEPOLIA
        DeployGuessTheNumber deploy = new DeployGuessTheNumber();
        vm.expectRevert();
        (guessTheNumber, deployHelper) = deploy.run(); // Will fail, because our private key is 0
    }

    function testScriptsRunOnAnvilByDefault() public {
        uint256 chainId = 31337;
        assertEq(block.chainid, chainId);
    }
    
}