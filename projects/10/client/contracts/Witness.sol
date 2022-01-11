// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./common/ERC721.sol";
import "./interfaces/IWitness.sol";

/**
 * using NFTERC721 platform.
 */
contract Witness is IWitness, ERC721 {

    //3bytes记录RGB值
    struct Props{
        bytes3 Props_color1;
        bytes3 Props_color2;
        bytes3 Props_color3;
        bytes3 Props_color4;
        bytes3 Props_color5;
    }

    //address => (tokenID => Props)
    mapping (address => mapping(uint256 => Props)) public TokenProps;

    //tokenId => tokenURL
    mapping(uint => string) nftIdMap;

    //token Id
    uint256 private tokenId = 0;

    //Props instance
    Props private _TokenProp;

    constructor()
        ERC721("WitnessLove", "WL")
    {}

    //Record users features by RGB
    function RecordCurrentTokenProps(bytes3 color) external override returns(bool){
        _TokenProp.Props_color1 = color;
        return true;
    }

    //Return token URL
    function baseTokenURI() external pure override returns (string memory) {
        return "";
    }

    //Core Mint
    function MintNft(string memory tokenURL) external override returns(bool) {
        //Mint NFT
        this.mint(msg.sender, tokenId);
        nftIdMap[tokenId] = tokenURL;
        tokenId++;

        //NFT messages output
        emit Mint(msg.sender, tokenId);

        return true;
    }

}