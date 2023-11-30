// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { GuessTheNumber } from "../src/GuessTheNumber.sol";
import { DeployGuessTheNumber } from "../script/DeployGuessTheNumber.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {VRFCoordinatorV2Mock} from "./mocks/VRFCoordinatorV2Mock.sol";
import {DeployHelper} from "../script/DeployHelper.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../script/DeployVRFHelper.s.sol";

contract TestGuessTheNumber is Test {

     error InvalidSubscription();

    CreateSubscription public createSub;
    FundSubscription public fundSub;
    AddConsumer public addConsumer;
    VRFCoordinatorV2Mock public VRFV2CoordinatorMock;

    function setUp() external {

        createSub = new CreateSubscription();
        fundSub = new FundSubscription();
        addConsumer = new AddConsumer();
    }

    function testSubIdOnAnvil() public {
        uint64 subId = createSub.run(); // we are expecting this to return a valid sub id
        address mockAddress = createSub.getVRFCoordinatorV2Address();
        console.log(subId);
        console.log(mockAddress);

        // if it did NOT return a valid sub id this call reverts
        (, , address owner, ) = VRFCoordinatorV2Mock(mockAddress).getSubscription(subId);
        assertEq(owner, msg.sender); // make sure you are setting --sender in your forge test
    }
}