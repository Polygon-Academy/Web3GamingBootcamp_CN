// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./shremworld.sol";

/**
 * @title Fight Contract
 * @author Aaron Guo
 * @notice This contract is about the fighting part
*/
contract Fight is ShremWorld{

    /// @notice Having tried to change keccak256 into ChainLink's VRF algorithm, but failed because of not matching with the high version
    uint public random = 0;
    uint public randNonce = 0;


    /// @dev Fight contract use a random number ranging from 30 to 70 to calculate the combat effectiveness ratio
    /// @notice The shrem's attributes and the monster's ce will be changed after fighting
    function fight()public{
        random = 0;
        uint _full =  shrems[ID].full;
        require(_full < 100);
        setSfull(100 * monster.ce / shrems[ID].ce + _full);
        setSce(shrems[ID].ce + monster.ce);
        setSsa();
        while(random<30||random>70){
            random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 100;
            randNonce++;
        }
        setMce(shrems[ID].ce*random/100);
    }

}