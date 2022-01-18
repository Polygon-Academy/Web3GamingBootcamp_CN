// SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.7.1;
/**************************************************************************
 * *Version: 1.1
 
 * *Note: 0.01 eth = 1 stars
 **************************************************************************/
import "./StarsCoins.sol";
import "./SponsorWhitelistControl.sol";

contract Lottery {
    //declare required variables
    address public manager;
    address payable[] public players;
    mapping (address => uint256) playersLimit;
    uint lotteryId;
    bool LotteryOpen;

    //play with stars coins
    address payable coinContract = 0x244601afa784179436D45B578c2e12ffcF1D0D0D; //stars
    StarsCoins stars = StarsCoins(coinContract);

    constructor(){     
        //coinContract = _coinContract; // contract of Stars 

        //initialize variables
        manager = msg.sender;
        lotteryId = 1;
        LotteryOpen = false;
    }
    
    //Sponsorship
    address swc_addr = 0x0888000000000000000000000000000000000001; //swc address
    SponsorWhitelistControl swc = SponsorWhitelistControl(swc_addr);

    //annoucements
    event AnnounceWinner(address _winner, uint _id, uint _amount);
    event StakeStatus(address _user, uint _amount);

    //backend call this function to start lottery
    function startLottery() public{
        require(manager == msg.sender, "Lottery: permission denied.");
        LotteryOpen = true;
    }

    //frontend call this function to enter lottery
    function enter(uint amount) public{
        require(LotteryOpen == true, "Lottery: Lottery is not open.");
        
        //mapping 1 to 1 ether to stars: 0.01 eth = 1 stars
        require(playersLimit[msg.sender] + amount <= 6, "Lottery: Exceeded, the maximum number is 6");
        require(amount >= 1 && amount <= 6, "Lottery: Incorrect number of Stars");
        require(stars.balanceOf(msg.sender) >= amount, "Lottery: Insufficient balance of Stars");

        //transfer stars to this contract with amount entered.
        stars._fromTransfer(msg.sender, address(this), amount);
        
        for (uint i = 0; i < amount; i++) {
            playersLimit[msg.sender]++;
            players.push(msg.sender);
        }
        // players.push(msg.sender);

        emit StakeStatus(msg.sender, playersLimit[msg.sender]);
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, players)));
    }

    function pickWinner(uint prize) private returns(address payable){
        require(LotteryOpen == false, "Lottery: Lottery is open.");

        //get random number
        uint index = random() % players.length;

        //tranfer balance to winner
        stars._fromTransfer(address(this), players[index], prize);

        emit AnnounceWinner(players[index], lotteryId, prize);

        return players[index];
    }
    
    function paybackPlayers() private{
        require(LotteryOpen == false, "Lottery: Lottery is open.");
        
        //lottery bets
        uint256 amount = 10;
        //tranfer amount back to players
        for (uint i = 0; i < players.length; i++){
            stars._fromTransfer(address(this), players[i], amount);
        }
    }

    //backend call to end lottery, pay back players and pick winner
    function endLottery(uint prize) public returns(address payable){
        address payable winner;
        require(LotteryOpen == true, "Lottery: Lottery is not open.");
        require(manager == msg.sender, "Lottery: permission denied.");
        //close the lottery
        LotteryOpen = false;

        //pays back players initial bets
        //paybackPlayers();

        //pick the winner
        winner = pickWinner(prize);
        
        //reset players array
        players = new address payable[](0);
        
        lotteryId += 1;

        return winner;
    }

    //helper functions:

    function getPlayers() public view returns(address payable[] memory) {
        return players;
    }

    function getPlayersLimit(address player) public view returns(uint) {
        return playersLimit[player];
    }
    
    function getLotteryId() public view returns(uint) {
        return lotteryId;
    }

    function getPool() public view returns(uint){
        return stars.balanceOf(address(this));
    }

    function getLotteryOpen() public view returns(bool){
        return LotteryOpen;
    }

    function addToWhitelist(address account) public {
        require(msg.sender == manager, "Lottery: Only manager can access");
        address[] memory a = new address[](1);
        //a[0] = 0x0000000000000000000000000000000000000000; //all trans will be sponsored
        a[0] = account; //sponsor specific user
        swc.addPrivilege(a);
    }

    //function enterSponsored(address payable user, uint256 amount) public{
        //mapping 1 to 1 ether to stars: 0.01 eth = 1 stars
      //  require(amount == 10, "Lottery: Incorrect number of Stars");
      //  require(stars.balanceOf(user) >= amount, "Stars: Insufficient balance");

        //transfer stars to this contract with amount entered.
      //  stars._fromTransfer(user, address(this), amount);

      //  players.push(user);
        //check the number of players
      //  if(players.length == 5){
     //       pickWinner();
     //   }
    //}

}