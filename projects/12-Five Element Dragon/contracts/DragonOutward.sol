// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;
import "./DragonBattle.sol";

library DragonStandard{
    string constant empty = '';
    string constant svgHead = '<path stroke="';

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function getLightColor(uint256 target) internal pure returns (string memory) {
        string memory color = '';
        if (target%5 == 0){ // metal
            color = '#FFF8DC';
        }else if(target%5 == 1){ // plant
            color = '#A0CAA7';
        }else if(target%5 == 2){ // water
            color = '#8ED1E9';
        }else if(target%5 == 3){ // fire
            color = '#F08080';
        }else{ // earth
            color = '#FFE4C4';
        }
        return color;
    }

    function getColor(uint256 target) internal pure returns (string memory) {
        string memory color = '';
        if (target%5 == 0){ // metal
            color = '#FFD700';
        }else if(target%5 == 1){ // plant
            color = '#449652';
        }else if(target%5 == 2){ // water
            color = '#00A4DA';
        }else if(target%5 == 3){ // fire
            color = '#C30000';
        }else{ // earth
            color = '#D2691E';
        }
        return color;
    }

    function getDeepColor(uint256 target) internal pure returns (string memory) {
        string memory color = '';
        if (target%5 == 0){ // metal
            color = '#DAA520';
        }else if(target%5 == 1){ // plant
            color = '#4B796B';
        }else if(target%5 == 2){ // water
            color = '#008AC4';
        }else if(target%5 == 3){ // fire
            color = '#A52A2A';
        }else{ // earth
            color = '#A0522D';
        }
        return color;
    }

    function getHead(uint256 head) internal pure returns (string memory) {
        string[7] memory parts;
        string memory color = getColor(head);
        string memory deepColor = getDeepColor(head);
        parts[0] = svgHead;
        parts[1] = color;
        parts[2] = '" d="M17 0h1M18 1h2M19 2h3M20 3h3M19 4h5M18 5h4M23 5h2M18 6h8M17 7h9M17 8h4M17 9h4M18 10h4M18 11h6M19 12h6M19 13h7M19 14h7M19 15h8M21 16h6M21 17h6M21 18h6M21 19h6M21 20h6M21 21h5M21 22h5M21 23h5" />';
        parts[3] = svgHead;
        parts[4] = deepColor;
        parts[5] = '" d="M19 0h1M20 1h2M22 2h1" />';
        parts[6] = '<path stroke="#fffffe" d="M22 5h1" />';
        return string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
    }

    function getWing(uint256 wing, uint16 race) internal pure returns (string memory) {
        string[9] memory parts;
        string memory lightColor = getLightColor(wing);
        string memory color = getColor(wing);
        string memory deepColor = getDeepColor(wing);
        if (race == 1) {
          parts[0] = svgHead; 
          parts[1] = deepColor;
          parts[2] = '" d="M14 3h1M12 4h2M11 5h1" />';
          parts[3] = svgHead;
          parts[4] = color;
          parts[5] = '" d="M16 3h1M14 4h2M12 5h3M11 6h3M10 7h5M9 8h2M12 8h4M8 9h8M8 10h9M13 11h4M13 12h4M13 13h4M13 14h8M13 15h8M13 16h8M13 17h8M13 18h8M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[6] = svgHead;
          parts[7] = '#fffffe';
          parts[8] = '" d="M11 8h1" />';
        } else if(race == 5){
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M6 4h1M12 4h1M7 5h1M12 5h1M8 6h1M13 6h1M9 7h1M13 7h1M9 8h1M14 8h1M3 9h1M10 9h1M14 9h1M4 10h2M11 10h1M15 10h1M6 11h1M12 11h1M15 11h1M7 12h2M13 12h1M15 12h1M9 13h1M14 13h1M16 13h1M10 14h2M14 14h1M16 14h5M12 15h1M15 15h1M17 15h4M13 16h2M16 16h5M15 17h6M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[3] = svgHead;
          parts[4] = lightColor;
          parts[5] = '" d="M11 4h1M6 5h1M8 5h4M6 6h2M9 6h4M6 7h3M10 7h3M5 8h4M10 8h4M4 9h6M11 9h3M6 10h5M12 10h3M7 11h5M13 11h2M9 12h4M14 12h1M10 13h4M15 13h1M12 14h2M15 14h1M13 15h2M16 15h1M15 16h1" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else if(race == 3){
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M19 14h2M18 15h3M18 16h3M16 17h5M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[3] = empty;
          parts[4] = empty;
          parts[5] = empty;
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else if(race == 4){
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M19 14h2M18 15h3M18 16h3M16 17h5M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6M15 24h4M14 25h4M14 26h3M14 27h2M14 28h2M15 29h2M16 30h2" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M19 24h2M18 25h2M17 26h2M16 27h2M16 28h2M17 29h2M18 30h2" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else
        {
          parts[0] = svgHead;
          parts[1] = deepColor;
          parts[2] = '" d="M2 2h7M8 3h2" />';
          parts[3] = svgHead;
          parts[4] = color;
          parts[5] = '" d="M1 3h7M7 4h5M11 5h2M12 6h1M12 7h2M5 8h6M13 8h1M10 9h5M12 10h3M14 11h1M8 12h5M14 12h2M12 13h5M13 14h8M17 15h4M18 16h3M16 17h5M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[6] = svgHead;
          parts[7] = lightColor;
          parts[8] = '" d="M2 4h5M3 5h8M4 6h8M5 7h7M11 8h2M6 9h4M7 10h5M8 11h6M13 12h1M10 13h2M11 14h2M12 15h5M15 16h3" />';
        }
        return string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
    }

    function getClaws(uint256 claw, uint16 race) internal pure returns (string memory) {
        string[9] memory parts;
        string memory color = getColor(claw);
        string memory deepColor = getDeepColor(claw);

        if (race == 1) {
          parts[0] = svgHead; 
          parts[1] = color;
          parts[2] = '" d="M18 24h5M24 24h2M18 25h5M25 25h4M18 26h5M25 26h5M19 27h9M29 27h2M20 28h12M21 29h11M22 30h4" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M27 24h2" />';
          parts[6] = svgHead;
          parts[7] = '#fffffe';
          parts[8] = '" d="M28 27h1" />';
        }else if(race == 3) {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M21 24h2M21 25h2M21 26h2M21 27h2M21 28h2M21 29h3M21 30h4" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M23 24h2M23 25h2M23 26h2M23 27h2M23 28h2M24 29h2M25 30h2" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else{
          parts[0] = svgHead; 
          parts[1] = color;
          parts[2] = '" d="M21 24h2M21 25h2M21 26h2M21 27h2M21 28h4M21 29h1M23 29h1M25 29h1M21 30h1M24 30h1M26 30h1" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M23 24h5M24 25h6M26 26h1M28 26h1M30 26h1M26 27h1M29 27h1M31 27h1" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }
        return string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));

    }

    function getLegs(uint256 legs, uint16 race) internal pure returns (string memory) {
        string[6] memory parts;
        string memory color = getColor(legs);
        string memory deepColor = getDeepColor(legs);

        if(race == 2) {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M12 19h3M9 20h6M9 21h6M8 22h7M9 23h6" />';
          parts[3] = empty;
          parts[4] = empty;
          parts[5] = empty;
        }else if(race == 5) {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M12 19h3M9 20h6M9 21h6M8 22h7M9 23h6" />';
          parts[3] = empty;
          parts[4] = empty;
          parts[5] = empty;
        }else {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M12 19h3M9 20h6M9 21h6M9 22h6M9 23h6M9 24h4M8 25h4M8 26h3M8 27h2M8 28h2M9 29h2M10 30h2" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M13 24h2M12 25h2M11 26h2M10 27h2M10 28h2M11 29h2M12 30h2" />';
        }
        return string(abi.encodePacked( parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]));
        
    }

    function getTail(uint256 tail) internal pure returns (string memory) {
        string[6] memory parts;
        string memory color = getColor(tail);
        string memory deepColor = getDeepColor(tail);
        parts[0] = svgHead;
        parts[1] = deepColor;
        parts[2] = '" d="M4 13h2M3 14h1M2 15h1M2 16h1M3 17h1M3 18h1M4 19h1" />';
        parts[3] = '<path stroke="';
        parts[4] = color;
        parts[5] = '" d="M4 14h1M3 15h1M3 16h2M4 17h1M4 18h2M5 19h4M5 20h4M7 21h2" />';
        return string(abi.encodePacked( parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]));
    }
}

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

abstract contract DragonOutward is DragonBattle {
    function getSvg(uint tokenId) internal view returns (string memory) {
        string[5] memory parts;

        parts[0] = DragonStandard.getHead(dragons[tokenId].affinity);
        parts[1] = DragonStandard.getWing(dragons[tokenId].affinity, dragons[tokenId].race);
        parts[2] = DragonStandard.getClaws(dragons[tokenId].affinity, dragons[tokenId].race);
        parts[3] = DragonStandard.getLegs(dragons[tokenId].affinity, dragons[tokenId].race);
        parts[4] = DragonStandard.getTail(dragons[tokenId].affinity);
        string memory top = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -0.5 32 32" shape-rendering="crispEdges">';
        string memory bottom = '</svg>';
        // return string(abi.encodePacked(top, parts[0], parts[1], parts[2], parts[3], parts[4], bottom));
        return Base64.encode(bytes(string(abi.encodePacked(top, parts[0], parts[1], parts[2], parts[3], parts[4], bottom))));
    }
}