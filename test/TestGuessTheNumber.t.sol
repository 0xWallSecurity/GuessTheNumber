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

    address vrfCoordinatorV2;

    function setUp() external {
        DeployGuessTheNumber deploy = new DeployGuessTheNumber();
        (guessTheNumber, deployHelper) = deploy.run();
        (, , vrfCoordinatorV2, ,) = deployHelper.deployConfig();
        vm.deal(PLAYER, START_BALANCE);
        vm.deal(address(guessTheNumber), START_BALANCE);
    }

    function testDirectlyFundContract() public {
        vm.prank(PLAYER);
        (bool success, ) = address(guessTheNumber).call{value: 1 ether}("");
        assertEq(success, false);
    }

    function testWithdrawAsNotOwner() public {
        vm.prank(PLAYER);
        vm.expectRevert();
        guessTheNumber.withdraw();
    }

    function testWithdraw() public {
        uint256 guess = 50;
        vm.prank(PLAYER);
        guessTheNumber.playGame{value: 1 ether}(guess);
        uint256 cutPool = 1 ether * 5 / 100;
        assertEq(guessTheNumber.getCutPool(), cutPool);
        vm.prank(msg.sender);
        guessTheNumber.withdraw();
        assertEq(guessTheNumber.getCutPool(), 0);
    }

    function testPrizePoolAtStart() public {
        assertEq(guessTheNumber.getPrizePool(), 0);
    }

    function testCutPoolAtStart() public {
        assertEq(guessTheNumber.getCutPool(), 0);
    }

    function testGetOwner() public {
        assertEq(guessTheNumber.getOwner(), msg.sender);
    }

    function testPlayWithAHundredOne() public {
        uint256 guess = 101;
        vm.prank(PLAYER);
        vm.expectRevert();
        guessTheNumber.playGame{value: 1 ether}(guess);
    }

    function testPlayWithNotEnoughPayed() public {
        uint256 guess = 50;
        vm.prank(PLAYER);
        vm.expectRevert();
        guessTheNumber.playGame{value: 1 wei}(guess);
    }

    modifier addPlayerAndPlay() {
        uint256 wrongGuess = 50;
        address player2 = address(2);
        vm.deal(player2, START_BALANCE);
        vm.prank(player2);
        guessTheNumber.playGame{value: 1 ether}(wrongGuess);
        console.log("Prize Pool: ", guessTheNumber.getPrizePool());
        _;
    }

    function testPlayerWins() public {
        uint256 playerGuess = 61;
        
        vm.prank(PLAYER);
        vm.recordLogs();        
        guessTheNumber.playGame{value: 1 ether}(playerGuess);
        Vm.Log[] memory logs = vm.getRecordedLogs();
        bytes32 requestId = logs[0].topics[2]; // adjust to requestRandomWords emit -> logs[0].topics[2] (probably -> need to test) 
        uint256 startBalance = PLAYER.balance;
        uint256 startPrizePool = guessTheNumber.getPrizePool();
        VRFCoordinatorV2Mock(vrfCoordinatorV2).fulfillRandomWords(uint256(requestId), address(guessTheNumber));

        address recentWinner = guessTheNumber.getRecentWinner();
        uint256 winningNumber = guessTheNumber.getWinningNumber();
        uint256 endBalance = PLAYER.balance;
        uint256 endPrizePool = guessTheNumber.getPrizePool();

        console.log("winning number: ", guessTheNumber.getWinningNumber());
        assertEq(recentWinner, PLAYER);
        assertEq(winningNumber, playerGuess);
        assertEq(endBalance, startBalance + startPrizePool);
        assertEq(endPrizePool, 0);
    }
}
