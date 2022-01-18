pragma solidity ^0.6.0; 

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract GovManager is Ownable {
    address public GovernerContract;

    modifier onlyOwnerOrGov() {
        require(msg.sender == owner() || msg.sender == GovernerContract, "Authorization Error");
        _;
    }

    function setGovernerContract(address _address) external onlyOwnerOrGov{
        GovernerContract = _address;
    }

    constructor() public {
        GovernerContract = address(0);
    }
}

// SPDX-License-Identifier: GPL-3.0
contract Game is GovManager {
    uint public totalPlayer;
    mapping(uint=>address) public players;

    uint public totalBlock;

    mapping(uint=>GameBlock) public GameBlocks;

    struct GameBlock{
        uint startTime;
        address payable winner;
        uint topGrade;
        uint startId;
        uint endId;
        mapping(address=>Player) Players;
    }

    struct Player{
      uint playId;
      address playerAddr;
      uint  grade;
    }

    constructor () public{
        totalPlayer = 0;
        totalBlock = 0;
    }

    event payEvent(uint time,address sender,uint eventType,uint value);

    function StartGame() public payable {
        require(msg.value >= 5*10**17,"matic value error");
        if(address(this).balance>10**22){
            // transfer to winner
            address payable winner = GameBlocks[totalBlock].winner;
            distribution(winner);
            totalBlock = totalBlock + 1;
            GameBlocks[totalBlock].startTime = now;
            GameBlocks[totalBlock].startId = totalPlayer;
        }
        GameBlocks[totalBlock].endId = totalPlayer;
        GameBlocks[totalBlock].Players[msg.sender].playId = totalPlayer;
        GameBlocks[totalBlock].Players[msg.sender].playerAddr = msg.sender;
        players[totalPlayer] = msg.sender;
        totalPlayer = totalPlayer + 1;
    }

    function distribution(address payable winner) internal {
        winner.transfer(10**22);
    }

    function Expand() public payable {
        require(msg.value >= 5*10**17,"matic value error");
        emit payEvent(now,msg.sender,1,msg.value);
    }

    function PostData(uint grade) public {
        GameBlocks[totalBlock].Players[msg.sender].grade = grade;
        if(grade>GameBlocks[totalBlock].topGrade){
            GameBlocks[totalBlock].topGrade = grade;
            GameBlocks[totalBlock].winner = msg.sender;
        }
    }

    function getNow() public view returns(uint){
        return now;
    }

    function getTopPlayer() public view returns(address,uint){
        return (GameBlocks[totalBlock].winner,GameBlocks[totalBlock].topGrade);
    }

    /**
    * @notice Generates a random number between 0 - 100
    * @param seed The seed to generate different number if block.timestamp is same
    * for two or more numbers.
    */
    function importSeedFromThird(uint256 seed) public view returns (uint) {
        uint8 randomNumber = uint8(
            uint256(keccak256(abi.encodePacked(block.timestamp, seed))) % 500
        );
        return randomNumber;
    }
}