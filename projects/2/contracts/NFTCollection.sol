//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTCollectible is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;

    uint public constant MAX_SUPPLY = 10000;
    uint public constant PRICE = 0.01 ether;
    uint public constant MAX_PER_MINT = 3;
    
    string public baseTokenURI;
    
    // 构造函数，输入jsonURI
    constructor(string memory baseURI) ERC721("NFT Collectible", "NFTC") {
        setBaseURI(baseURI);
    }

    // 合约所有者，免费生成10个NFT
    function reserveNFTs() public onlyOwner {
        uint totalMinted = _tokenIds.current();

        require(
            totalMinted.add(10) < MAX_SUPPLY, "Not enough NFTs"
        );

        for (uint i = 0; i < 10; i++) {
            _mintSingleNFT();
        }
    }
    
    // 查看jsonURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
    
    // 改变jsonURI
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    // 输入要mint的nft数量，批量获得nft
    function mintNFTs(uint _count) public payable {
        uint totalMinted = _tokenIds.current();
    
        require(
            totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs!"
        );

        require(
            _count > 0 && _count <= MAX_PER_MINT, 
            "Cannot mint specified number of NFTs."
        );
    
        require(
            msg.value >= PRICE.mul(_count), 
            "Not enough ether to purchase NFTs."
        );

        for (uint i = 0; i < _count; i++) {
            _mintSingleNFT();
        }
    }

    // 铸造1个nft
    function _mintSingleNFT() private {
        uint newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
    }

    // 获取特定地址拥有的所有令牌id
    function tokensOfOwner(address _owner) external view returns (uint[] memory) {
        uint tokenCount = balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);

        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
     
        return tokensId;
    }

    // 提取合约中所有余额
    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");

        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
}