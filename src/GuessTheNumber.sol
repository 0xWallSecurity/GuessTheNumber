// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/*
What is this all about?
--> 1. Player pays small fee to enter the game. -- DONE
  --> 1.1. 5% of fee is taken as cut by contract, 95% goes into prize pool -- DONE
--> 2. Player picks a number, contract does too -- DONE
  --> 2.1. Number must be in [0,99] -- DONE
--> 3.1. If player picked the right number: player wins prize pool -- DONE
--> 3.2. If player picked wrong number: game ends, prize pool goes up -- DONE

--> a) contract belongs to owner, who can withdraw the contracts cut at all times -- DONE
--> b) players cannot withdraw from the contract. The prize pool is payed out automatically -- DONE

@todo
1. Implement real randomness with chainlink VRF (CORRECT_GUESS was for testing only) -- DONE
2. Expand the functionality. Some ideas:
    a) allow more players to play over a specific timeframe. Every player can roll once.
        Prize pool divided among all players who guessed correctly depending on entrance fee payed (higher payment -> higher payout)

    b) 

*/

/* IMPORTS */
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";


/**
 * @title GuessTheNumber
 * @author @0xWalle inspired by Patrick Collins
 * @notice dummy project to get better at solidity
 */
contract GuessTheNumber is VRFConsumerBaseV2 {

    /* TYPE DECLARATIONS */

    /* STATE VARS */
    /* VRF VARS */
    VRFCoordinatorV2Interface immutable i_vrfCoordinator;
    uint64 private immutable i_subId;
    bytes32 private immutable i_keyHash;
    uint32 private constant CALLBACK_GAS_LIMIT = 100000;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 public s_requestId;

    /* CONSTANTS */
    uint256 private constant MIN_NUMBER = 0;
    uint256 private constant MAX_NUMBER = 100; // total of 100 numbers are available => 0 to 99
    uint256 private constant CUT_AMOUNT = 5;
    uint256 private constant PRIZE_POOL_AMOUNT = 95;
    uint256 private constant CORRECT_GUESS = 10; // for testing
    /* IMMUTABLES */
    uint256 private immutable i_entranceFee; // ~2 USD entrance fee
    address private immutable i_owner;
    /* STORAGE */
    uint256 private s_prizePool;
    uint256 private s_cutPool;
    address private s_previousWinner;
    uint256 private s_playerNumber;
    uint256 private s_winningNumber;
    address payable s_player;

    /* EVENTS */
    event RaffleWon(address indexed player, uint256 indexed prize);
    event RaffleRandomNumberRequested(uint256 indexed requestId);
    event ReturnedRandomness(uint256[] indexed randomWords);

    /* ERRORS */
    // @todo MAKE THESE BETTER WITH PARMS
    error GuessTheNumber__DidntCallStartGame();
    error GuessTheNumber__NotOwner();
    error GuessTheNumber__GuessNotInRange();
    error GuessTheNumber__PaymentTooLow();
    error GuessTheNumber__FailedToSendPrize();
    error GuessTheNumber__FailedToSendCuts();

    /* MODIFIERS */
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert GuessTheNumber__NotOwner();
        _;
    }

    /* FUNCTIONS */
    /**
     * @param entranceFee the minimum entrance fee that is required to start a raffle
     */
    constructor(uint256 entranceFee, uint64 subId, address vrfCoordinator, bytes32 keyHash) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_subId = subId;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_keyHash = keyHash;
        i_owner = msg.sender;
    }

    /**
     * @notice can only fund the contract by playing!
     */
    receive() external payable {
        revert GuessTheNumber__DidntCallStartGame();
    }

    /**
     * @notice can only fund the contract by playing!
     */
    fallback() external payable {
        revert GuessTheNumber__DidntCallStartGame();
    }

    /**
     * @notice player enters the game. If he wins -> prize pool goes to player
     * @param playerNumber the number guessed by the player
     */
    function playGame(uint256 playerNumber) external payable {
        if ((playerNumber < MIN_NUMBER) || (playerNumber > MAX_NUMBER)) revert GuessTheNumber__GuessNotInRange();
        if (msg.value < i_entranceFee) revert GuessTheNumber__PaymentTooLow();
        uint256 cut = msg.value * CUT_AMOUNT / 100;
        uint256 prize = msg.value * PRIZE_POOL_AMOUNT / 100;
        s_cutPool += cut;
        s_prizePool += prize;
        s_player = payable(msg.sender);
        s_playerNumber = playerNumber;
        s_requestId = i_vrfCoordinator.requestRandomWords(i_keyHash, i_subId, REQUEST_CONFIRMATIONS, CALLBACK_GAS_LIMIT, NUM_WORDS);
    }

    /**
     * @notice owner can withdraw the contracts cuts at any time; revert, if an error occurs sending the funds to the owner
     */
    function withdraw() public onlyOwner {
        (bool success,) = i_owner.call{value: s_cutPool}("");
        if (!success) revert GuessTheNumber__FailedToSendCuts();
        s_cutPool = 0;
    }

    function fulfillRandomWords(uint256 /* requestId */, uint256[] memory randomWords) internal override {
        s_winningNumber = randomWords[0] % MAX_NUMBER;
        emit ReturnedRandomness(randomWords);
        if (s_winningNumber == s_playerNumber) {
            (bool success,) = s_player.call{value: s_prizePool}("You Won, Congratulations!");
            if (!success) revert GuessTheNumber__FailedToSendPrize();
            emit RaffleWon(s_player, s_prizePool);
            s_prizePool = 0;
            s_previousWinner = s_player;
        }
    }

    /* GETTERS */
    /**
     * @return minimum entrance fee to start a raffle
     */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
    /**
     * @dev might not want to enable/use this feature
     * @return returns the current prize pool amount
     */
    function getPrizePool() external view returns (uint256) {
        return s_prizePool;
    }

    /**
     * @return returns the current cut pool
     */
    function getCutPool() external view returns (uint256) {
        return s_cutPool;
    }

    /**
     * @return returns the current owner of the contract
     */
    function getOwner() external view returns (address) {
        return i_owner;
    }
    /**
     * @return returns the winner of the previous raffle
     */
    function getRecentWinner() external view returns (address) {
        return s_previousWinner;
    }
    /**
     * @return returns the winning number of the last raffle
     */
    function getWinningNumber() external view returns(uint256) {
        return s_winningNumber;
    }
}
