// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INFTERC721 {
    
    //ERC721 interface
    //safeTransferFrom()中data入参从memory改为calldata类型——外部函数的参数（不包括返回参数）被强制指定为calldata，效果与memory差不多
   
    // ERC721 standard
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    //ERC721 query
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    
    //ERC721 approve
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    
    //ERC721 unsafe transfer
    function transferFrom(address from, address to, uint256 tokenId) external;

    // interfaces from ERC165
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    // NFT metadata extension
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);

    // NFT enumeration extension from ERC165
    //每个支持的接口都有一个对应的bytes4值与之相对应，这个是固定的常量
    function totalSupply() external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
    function tokenByIndex(uint256 index) external view returns (uint256);

}