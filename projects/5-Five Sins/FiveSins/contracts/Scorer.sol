pragma solidity ^0.8.3;

contract Scorer is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _gameIds;
  Counters.Counter private _itemsFroozen;

  address payable winnerAddress;

struct Game {
    uint gameId;
    uint gameTurn;
    address tokenContract;
    address payable winnerAddress;
    address payable loserAddress;
    uint256 winPrice;
    uint256 losePrice;
  }

function froozenNFT(
    uint256 itemId
    ) public payable nonReentrant {
    
  }

function transferToken(
    address tokenContract,
    address payable winnerAddress,
    address payable loserAddress,
    uint256 winPrice,
    uint256 losePrice
  	)  public payable nonReentrant {

  }

