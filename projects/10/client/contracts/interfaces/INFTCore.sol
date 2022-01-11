// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./INFTERC721.sol";

interface INFTCore is INFTERC721 {

    //Core Mint 
    function mint(address to, uint256 tokenId) external returns(bool);
    function burn(uint256 tokenId) external;

}