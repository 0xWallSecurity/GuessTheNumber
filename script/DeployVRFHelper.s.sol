//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";
import {VRFCoordinatorV2Mock} from "../test/mocks/VRFCoordinatorV2Mock.sol";
import {DeployHelper} from "./DeployHelper.s.sol";

/**
 * @title CreateSubscription
 * @author @0xWalle inspired by Patrick Collins
 * @notice creates a subscription to chainlink VRF and returns its subId
 */
contract CreateSubscription is Script {

    address public vrfCoordinatorV2;

    /**
     * @notice auto runs on contract creation
     * @return subId via createSubscriptionWithConfig
     */
    function run() external returns (uint64) {
        return createSubscriptionWithConfig();
    }

    /**
     * @notice creates the subscription to chainlink VRF
     * @param _vrfCoordinatorV2 the address of the vrfCoordinator
     * @param privateKey the anvil deploy private key (index 0)
     * @return subId
     */
    function createSubscription(address _vrfCoordinatorV2, uint256 privateKey) public returns (uint64) {
        vrfCoordinatorV2 = _vrfCoordinatorV2;
        vm.startBroadcast(privateKey);
        uint64 subId = VRFCoordinatorV2Mock(_vrfCoordinatorV2).createSubscription();
        vm.stopBroadcast();
        return subId;
    }

    /**
     * @notice retrieves the vrfCoordinator and anvil deploy key from the deployHelper
     * @return subId via createSubscription
     */
    function createSubscriptionWithConfig() private returns (uint64) {
        DeployHelper deployHelper = new DeployHelper();
        ( , , address _vrfCoordinatorV2, , uint256 privateKey) = deployHelper.deployConfig();
        return createSubscription(_vrfCoordinatorV2, privateKey);
    }

    /**
     * @return address of the VRFCoordinatorMock-address
     */
    function getVRFCoordinatorV2Address() public view returns (address) {
        return vrfCoordinatorV2;
    }
}

/**
 * @title FundSubscription
 * @author @0xWalle inspired by Patrick Collins
 * @notice funds a subscription to chainlink VRF and returns its subId
 */
contract FundSubscription is Script {
    uint96 private constant FUND_AMOUNT = 1 ether;
    /**
     * @notice auto runs on contract creation
     */
    function run() external {
        fundSubscriptionWithConfig();
    }

    /**
     * @notice funds the subscription to chainlink VRF
     * @param subId the subscriptionId
     * @param vrfCoordinatorV2 the address of the vrfCoordinator
     * @param privateKey the anvil deploy private key (index 0)
     */
    function fundSubscription(uint64 subId, address vrfCoordinatorV2, uint256 privateKey) public {
        vm.startBroadcast(privateKey);
        VRFCoordinatorV2Mock(vrfCoordinatorV2).fundSubscription(subId, FUND_AMOUNT);
        vm.stopBroadcast();
    }

    /**
     * @notice retrieves the subId, vrfCoordinator and anvil deploy key from the deployHelper
     */
    function fundSubscriptionWithConfig() private {
        DeployHelper deployHelper = new DeployHelper();
        ( , uint64 subId, address vrfCoordinatorV2, , uint256 privateKey) = deployHelper.deployConfig();
        fundSubscription(subId, vrfCoordinatorV2, privateKey);
    }
}

/**
 * @title AddSubscription
 * @author @0xWalle inspired by Patrick Collins
 * @notice adds a consumer
 */
contract AddConsumer is Script {
    /**
     * @notice adds the consumer
     * @param vrfConsumerContract the consumer contract
     * @param subId the subscriptionId
     * @param vrfCoordinatorV2 the address of the vrfCoordinator
     * @param privateKey the anvil deploy private key (index 0)
     */
    function addConsumer(address vrfConsumerContract, uint64 subId, address vrfCoordinatorV2, uint256 privateKey) public {
        vm.startBroadcast(privateKey);
        VRFCoordinatorV2Mock(vrfCoordinatorV2).addConsumer(subId, vrfConsumerContract);
        vm.stopBroadcast();
    }
}