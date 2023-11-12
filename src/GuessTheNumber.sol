// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

/*
What is this all about?
--> 1. Player pays small fee to enter the game.
  --> 1.1. 5% of fee is taken as cut by contract, 95% goes into prize pool
--> 2. Player picks a number, contract does too
  --> 2.1. Number must be in [0,99]
--> 3.1. If player picked the right number: player wins prize pool
--> 3.2. If player picked wrong number: game ends, prize pool goes up

--> a) contract belongs to owner, who can withdraw the contracts cut at all times
--> b) players cannot withdraw from the contract. The prize pool is payed out automatically
*/

error GuessTheNumber__didntCallStartGame();
error GuessTheNumber__notOwner();

/**
 * @title GuessTheNumber
 * @author @0xWalle
 * @notice dummy project to get better at solidity
 */
contract GuessTheNumber {
    uint256 private constant ENTRANCE_FEE = 1e15; // ~2 USD entrance fee
    uint256 private constant MIN_NUMBER = 0;
    uint256 private constant MAX_NUMBER = 99;
    uint256 private constant CUT_AMOUNT = 5;
    uint256 private constant PRIZE_POOL_AMOUNT = 95;
    address private immutable i_owner;
    uint256 private s_prizePool;
    uint256 private s_cutPool;

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert GuessTheNumber__notOwner();
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    /**
     * @notice can only fund the contract by playing!
     */
    receive() external payable {
        revert GuessTheNumber__didntCallStartGame();
    }

    /**
     * @notice can only fund the contract by playing!
     */
    fallback() external payable {
        revert GuessTheNumber__didntCallStartGame();
    }

    /**
     * @notice player enters the game. If he wins -> prize pool goes to player
     */
    function playGame(uint256 _guess) external payable {
        require((_guess >= MIN_NUMBER) && (_guess <= MAX_NUMBER), "Number must be between 0 and 99!");
        require(msg.value >= ENTRANCE_FEE, "Must pay at least 0.001 ether!");
        address player = msg.sender;
        uint256 cut = msg.value * CUT_AMOUNT / 100;
        uint256 prize = msg.value * PRIZE_POOL_AMOUNT / 100;
        s_cutPool += cut;
        s_prizePool += prize;
        uint256 guess = contractGuess();
        if (guess == _guess) {
            (bool success,) = player.call{value: s_prizePool}("You Won, Congratulations!");
            require(success, "Failed to send contracts prize pool.");
            s_prizePool = 0;
        }
    }

    /**
     * @notice owner can withdraw the contracts cuts at any time
     * @notice revert, if an error occurs sending the funds to the owner
     */
    function withdraw() public onlyOwner {
        (bool success,) = i_owner.call{value: s_cutPool}("");
        require(success, "Failed to withdraw contracts cuts.");
        s_cutPool = 0;
    }

    /**
     * @notice creates a random number between 0 and 99
     * @notice THIS WAY OF CREATING RANDOM NUMBERS IS PREDICTABLE AND VULNERABLE - DO NOT USE THIS CODE!
     * @dev THIS WAY OF CREATING RANDOM NUMBERS IS PREDICTABLE AND VULNERABLE - DO NOT USE THIS CODE!
     * @return returns the rolled number
     */
    function contractGuess() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp))) % MAX_NUMBER;
    }

    /**
     * @notice players can see how big the prize pool currently is
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
}
