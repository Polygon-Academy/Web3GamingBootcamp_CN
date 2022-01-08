// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./ownable.sol";

/**
 * @title Monster Contract
 * @author Aaron Guo
 * @notice This contract is about the monster's basic ability
*/
contract MonsterFactory is Ownable{
    
    /// @param ce The monster's combat effectiveness
    /// @notice The monster's Combat effectiveness(ce) will be changed after fighting
    struct Monster{
        uint ce;
    }


    /// @notice Monster instance
    Monster public monster = Monster(3);


    /// @dev Get monster's ce
    function getMce()public view returns(uint){
        return monster.ce;
    }


    /// @dev Set monster's ce
    function setMce(uint _ce)internal{
        monster.ce = _ce;
    }

}