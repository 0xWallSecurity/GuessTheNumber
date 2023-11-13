// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { GuessTheNumber } from "../src/GuessTheNumber.sol";
import { DeployGuessTheNumber } from "../script/DeployGuessTheNumber.s.sol";

contract TestGuessTheNumber is Test {
    GuessTheNumber guessTheNumber;
    address public constant PLAYER = address(1);
    uint256 public constant START_BALANCE = 100 ether;

    function setUp() external {
        DeployGuessTheNumber deploy = new DeployGuessTheNumber();
        guessTheNumber = deploy.run();
        vm.deal(PLAYER, START_BALANCE);
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

    function testPlayerWins() public addPlayerAndPlay() {
        uint256 correctGuess = 10;
        assertEq(guessTheNumber.getPrizePool(), 1 ether * 95 / 100);
        vm.prank(PLAYER);
        guessTheNumber.playGame{value: 1 ether}(correctGuess);
        assertEq(guessTheNumber.getPrizePool(), 0);
        uint256 playerBalance = 100 ether - 1 ether + 2 * (1 ether * 95 / 100); // we started at 100 eth, played for 1 eth and won 2*0,95eth
        assertEq(address(PLAYER).balance, playerBalance);
    }

    function testPlayerLoses() public addPlayerAndPlay() {
        uint256 wrongGuess = 50;
        assertEq(guessTheNumber.getPrizePool(), 1 ether * 95 / 100);
        vm.prank(PLAYER);
        guessTheNumber.playGame{value: 1 ether}(wrongGuess);
        assertEq(guessTheNumber.getPrizePool(), 2 * (1 ether * 95 / 100));
        assertEq(address(PLAYER).balance, 99 ether);
    }
}
