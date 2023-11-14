// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";
import {DeployHelper} from "./DeployHelper.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./DeployVRFHelper.s.sol";

contract DeployGuessTheNumber is Script {
    uint256 private constant ENTRANCE_FEE = 1e15;
    function run() external returns (GuessTheNumber) {
        DeployHelper deployHelper = new DeployHelper();
        AddConsumer addConsumer = new AddConsumer();
        (uint256 entranceFee, uint64 subId, address vrfCoordinatorV2, bytes32 keyHash, uint256 privateKey) = deployHelper.deployConfig();

        if (subId == 0) {
            CreateSubscription createSub = new CreateSubscription();
            subId = createSub.createSubscription(vrfCoordinatorV2, privateKey);
            FundSubscription fundSub = new FundSubscription();
            fundSub.fundSubscription(subId, vrfCoordinatorV2, privateKey);
        }

        vm.startBroadcast(privateKey);
        GuessTheNumber guessTheNumber = new GuessTheNumber(entranceFee, subId, vrfCoordinatorV2, keyHash);
        vm.stopBroadcast();

        addConsumer.addConsumer(address(guessTheNumber), subId, vrfCoordinatorV2, privateKey);

        return guessTheNumber;
    }
}
