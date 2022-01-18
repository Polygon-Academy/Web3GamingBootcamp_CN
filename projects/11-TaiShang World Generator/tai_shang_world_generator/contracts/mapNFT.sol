// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MapNFT is ERC721Enumerable, ReentrancyGuard, Ownable {
    string public rule; // setting only once, rule tx_id on arweave.
    string public baseURL; // setting only once
    string public onlyGame; // setting only once
    uint256 tokenId = 1;
    mapping(uint256 => uint256) blockHeight;

    mapping(uint256 => string) tokenInfo;

    function getBlockHeightForToken(uint256 tokenId) public view returns (uint256) {
        return blockHeight[tokenId];
    }

    function getTokenInfo(uint256 tokenId) public view returns (string memory) {
        return tokenInfo[tokenId];
    }

    function setbaseURL(string memory _baseURL) public onlyOwner {
        require(bytes(baseURL).length == 0, "baseURL is already set!");
        baseURL = _baseURL;
    }

    function setRule(string memory _rule) public onlyOwner {
        require(bytes(rule).length == 0, "rule is already set!");
        rule = _rule;
    }

    function setOnlyGame(string memory _onlyGame) public onlyOwner {
        require(bytes(onlyGame).length == 0, "onlyGame is already set!");
        onlyGame = _onlyGame;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[11] memory parts;
        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
        parts[1] = "see map in: ";
        parts[2] = '</text><text x="10" y="40" class="base">';
        parts[3] = baseURL;
        parts[4] = "&amp;token_id=";
        parts[5] = toString(tokenId);
        parts[6] = '</text><text x="10" y="60" class="base">';
        parts[7] = "description: ";
        parts[8] = '</text><text x="10" y="80" class="base">';
        parts[9] = tokenInfo[tokenId];
        parts[10] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(
            parts[0],
            parts[1],
            parts[2],
            parts[3],
            parts[4],
            parts[5],
            parts[6],
            parts[7],
            parts[8],
            parts[9]
            )
        );

        output = string(
            abi.encodePacked(
                output,
                parts[10]
                )
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Map #',
                        toString(tokenId),
                        '", "description": "nfts based on blockHeight.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }

    function claim(uint256 _blockHeight,string memory _tokenInfo) public nonReentrant {
        _safeMint(_msgSender(), tokenId);
        blockHeight[tokenId] = _blockHeight;
        tokenInfo[tokenId] = _tokenInfo;
        tokenId++;
    }

    constructor() ERC721("map", "MAP") Ownable() {
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}
