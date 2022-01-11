// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./INFTCore.sol";

interface IWitness{
    
    // event for Mint
    event Mint(address indexed applyer, uint256 indexed tokenId);
    
    function RecordCurrentTokenProps(bytes3) external returns(bool);

    //token URL
    function baseTokenURI() external pure returns (string memory);

    //attention: input is INFTCore instance
    function MintNft(string memory tokenURL) external returns(bool);
}