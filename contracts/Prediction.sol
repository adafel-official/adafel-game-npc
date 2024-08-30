// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Prediction {

  uint256 public totalVotes;
  uint256 public stakeAmount;
  uint256 public gameEndTimestamp;
  uint256 public winner;
  uint256 public winAmount;

  // @notice Address of the contract owner
  address private owner;
  
  // map of NPC index to their votes
  // Vera "Cipher" Kline - 1
  // Leo 'CryptoKing' Moretti - 2
  // Ava 'Oracle' Donovan - 3
  mapping(uint256 => uint256) public npcVotes;
  mapping(address => bool) public hasVoted;
  mapping(address => uint256) public voteByAddress;
  mapping(address => bool) public redeem;
  mapping(address => bool) public whitelistedAddresses;

  constructor(uint256 _initialStakeAmount, uint256 _gameEndTimestamp) {
    stakeAmount = _initialStakeAmount;
    owner = msg.sender;
    gameEndTimestamp = _gameEndTimestamp;
  }

  // @notice Ensures the caller is the contract owner
  modifier onlyOwner() {
      require(msg.sender == owner, "Caller is not owner");
      _;
  }

  modifier onlyWhitelisted() {
      require(whitelistedAddresses[msg.sender], "Caller is not whitelisted");
      _;
  }

  /**
   * Vote for NPC
   * @param npcIndex // index of NPC
   */
  function vote(uint256 npcIndex) public payable {
    require(hasVoted[msg.sender] == false, "VOTED");
    require(msg.value == stakeAmount);
    
    npcVotes[npcIndex] += 1;
    hasVoted[msg.sender] = true;
    voteByAddress[msg.sender] = npcIndex;
  }

  /**
   * Declare winner once game time period finishes 
   * @param npcIndex index of winner NPC
   */
  function updateWinner(uint256 npcIndex) public onlyWhitelisted {
    require(block.timestamp >= gameEndTimestamp);
    winner = npcIndex;

    winAmount = address(this).balance/npcVotes[npcIndex];
  }

  /**
   * Redeem wins for those who voted for winner NPC
   */
  function redeemWin() public {
    require(block.timestamp >= gameEndTimestamp);
    require(voteByAddress[msg.sender] == winner);
    require(redeem[msg.sender] = true);

    payable(msg.sender).transfer(winAmount);
    redeem[msg.sender] = true;
  }
}