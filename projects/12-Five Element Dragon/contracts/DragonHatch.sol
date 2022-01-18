// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

struct Dragon {
    string name;
    uint16 race;
    uint256 affinity;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
    uint256 head;
    uint256 wing;
    uint256 claw;
    uint256 legs;
    uint256 tail;
    uint256 experience;
}

abstract contract DragonHatch is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;
    address contractAddress;
    event NewDragon(uint256 dragonId,  uint256 dna);


    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 seconds;
    string empty = '';
    string svgHead = '<path stroke="';

    Dragon[] public dragons;
    mapping (uint => address) public dragonToOwner;
    mapping (uint256 => address) private dragonApprovals;
    mapping (address => uint) ownerDragonCount;
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    
    function _createDragon(string memory _name, uint _dna, address owner) internal {
        uint256 newItemId = _tokenIds.current();
        uint16 race = 0;
        // string memory race = 'Dragon';
        uint256 affinity = _dna % 5;
        uint256 head = ((_dna % 10000) / 100 );
        uint256 wing = ((_dna % 1000000) / 10000 );
        uint256 claw = (_dna % 20);
        uint256 legs = ((_dna % 10000000000) / 100000000 );
        uint256 tail = ((_dna % 1000000000000) / 10000000000);
        uint256 experience = 0;

        dragons.push(Dragon(_name, race, affinity,uint32(block.timestamp + cooldownTime), 0, 0, 
            head ,wing, claw, legs, tail, experience)) ;
        dragonToOwner[newItemId] = owner;
        ownerDragonCount[owner]++;
        _safeMint(owner, newItemId);
        _tokenIds.increment();
        emit NewDragon(newItemId, _dna);
    }

    // function getAffinity(uint256 tokenId) public view returns (uint256) {
    //     Dragon storage myDragon = dragons[tokenId];
    //     uint[] memory affinity = new uint[](5);
    //     affinity[0] = myDragon.head % 5;
    //     affinity[1] = myDragon.wing % 5;
    //     affinity[2] = myDragon.claw % 5;
    //     affinity[3] = myDragon.legs % 5;
    //     affinity[4] = myDragon.tail % 5;

    //     uint same = 0;
    //     for (uint i = 0; i < affinity.length; i++){
    //         for(uint j = 1; j < affinity.length; j++){
    //             if(affinity[i] == affinity[j]){
    //                 same++;
    //             }
    //         }
    //     }

    //     return same;

    // }

    function getLevel(uint256 tokenId) public view returns (uint256) {
        return sqrt(dragons[tokenId].experience);
    }

    function getNumberOfDragons() public view returns (uint256) {
        return dragons.length; 
    }

    function getDragonStats(uint256 tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            dragons[tokenId].affinity,
            dragons[tokenId].head,
            dragons[tokenId].wing,
            dragons[tokenId].claw,
            dragons[tokenId].legs,
            dragons[tokenId].tail,
            dragons[tokenId].experience
        );
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

}