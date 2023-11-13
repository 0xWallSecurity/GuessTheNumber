// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

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

TODO:
1. Implement real randomness with chainlink VRF (CORRECT_GUESS was for testing only)
2. Expand the functionality. Some ideas:
    a) allow more players to play over a specific timeframe. Every player can roll once.
        Prize pool divided among all players who guessed correctly depending on entrance fee payed (higher payment -> higher payout)
    b) 

*/

/**
 * @title GuessTheNumber
 * @author @0xWalle
 * @notice dummy project to get better at solidity
 */
contract GuessTheNumber {

    /** TYPE DECLARATIONS */

    /** STATE VARS */
    /** CONSTANTS */
    uint256 private constant MIN_NUMBER = 0;
    uint256 private constant MAX_NUMBER = 100; // total of 100 numbers are available => 0 to 99
    uint256 private constant CUT_AMOUNT = 5;
    uint256 private constant PRIZE_POOL_AMOUNT = 95;
    uint256 private constant CORRECT_GUESS = 10; // for testing
    /** IMMUTABLES */
    uint256 private immutable i_entranceFee; // ~2 USD entrance fee
    address private immutable i_owner;
    /** STORAGE */
    uint256 private s_prizePool;
    uint256 private s_cutPool;
    address private s_previousWinner;

    /** EVENTS */
    event RaffleWon(address indexed player, uint256 indexed prize);

    /** ERRORS */
    error GuessTheNumber__DidntCallStartGame();
    error GuessTheNumber__NotOwner();
    error GuessTheNumber__GuessNotInRange();
    error GuessTheNumber__PaymentTooLow();
    error GuessTheNumber__FailedToSendPrize();
    error GuessTheNumber__FailedToSendCuts();

    /** MODIFIERS */
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert GuessTheNumber__NotOwner();
        _;
    }

    /** FUNCTIONS */
    /**
     * @param entranceFee the minimum entrance fee that is required to start a raffle
     */
    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
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
     * @param playerGuess the number guessed by the player
     */
    function playGame(uint256 playerGuess) external payable {
        if ((playerGuess < MIN_NUMBER) || (playerGuess > MAX_NUMBER)) revert GuessTheNumber__GuessNotInRange();
        if (msg.value < i_entranceFee) revert GuessTheNumber__PaymentTooLow();
        address payable player = payable(msg.sender);
        uint256 cut = msg.value * CUT_AMOUNT / 100;
        uint256 prize = msg.value * PRIZE_POOL_AMOUNT / 100;
        s_cutPool += cut;
        s_prizePool += prize;
        uint256 guess = contractGuess();
        if (guess == playerGuess) {
            (bool success,) = player.call{value: s_prizePool}("You Won, Congratulations!");
            if(!success) revert GuessTheNumber__FailedToSendPrize();
            s_prizePool = 0;
            s_previousWinner = player;
            emit RaffleWon(player, s_prizePool);
        }
    }

    /**
     * @notice owner can withdraw the contracts cuts at any time; revert, if an error occurs sending the funds to the owner
     */
    function withdraw() public onlyOwner {
        (bool success,) = i_owner.call{value: s_cutPool}("");
        if (!success) revert GuessTheNumber__FailedToSendCuts();
        s_cutPool = 0;
    }

    /**
     * @notice creates a random number between 0 and 99
     * @dev TODO replace with chainlink VRF
     * @return returns the rolled number
     */
    function contractGuess() private pure returns (uint256) {
        return CORRECT_GUESS;
    }


    /** GETTERS */
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
}
