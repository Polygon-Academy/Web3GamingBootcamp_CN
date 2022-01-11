// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;
import "./DragonOutward.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FiveElementalDragon is ERC721, DragonOutward {
    mapping (uint => address) dragonApprovals;

    constructor(address marketplaceAddress ) ERC721("Five Elemental Dragon", "FED") {
        contractAddress = marketplaceAddress;
    }

    function balanceOf(address _owner) override public view returns (uint256 _balance) {
        return ownerDragonCount[_owner];
    }

    function ownerOf(uint256 _tokenId) override public view returns (address _owner) {
        return dragonToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) override internal {
        ownerDragonCount[_to]++;
        ownerDragonCount[_from]--;
        dragonToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) override public onlyOwnerOf(_tokenId) {
        dragonApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenID) override public {
        // require(dragonApprovals[tokenID] == msg.sender, "ERC721: transfer caller is not owner nor approved");
        // require(to == msg.sender);
        _transferFrom(from, to, tokenID);
    }

    function _generateRandomDna(string memory _str) internal view returns (uint) {
        string memory timestamp = uint2str(block.timestamp);
        uint rand = uint(keccak256(abi.encodePacked(_str, timestamp)));
        return rand % dnaModulus;
    }

    function createRandomDragon(string memory _name) public {
        // require(ownerDragonCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        // randDna = randDna - randDna % 100;
        _createDragon(_name, randDna, msg.sender);
    }

    function fetchMyNFTs(address _owner) public view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerDragonCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < dragons.length; i++) {
            if (dragonToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function _clearApproval(uint256 dragonId) private {
        if (dragonApprovals[dragonId] != address(0)) {
            dragonApprovals[dragonId] = address(0);
        }
    }

    function _transferFrom(address from, address to, uint256 dragonId) internal {
        require(ownerOf(dragonId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");
        _clearApproval(dragonId);
        ownerDragonCount[from]--;
        ownerDragonCount[to]++;

        dragonToOwner[dragonId] = to;

        emit Transfer(from, to, dragonId);
    }


    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string memory svgData = getSvg(tokenId);
        string memory output =  string(abi.encodePacked('data:image/svg+xml;base64,', svgData));
        return output;

        // string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "MY NFT", "description": "", "image_data": "', bytes(svgData), '"}'))));
        // return string(abi.encodePacked('data:application/json;base64,', json));
    }

    
}