// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./monsterfactory.sol";

/**
 * @title Shrem Contract
 * @author Aaron Guo
 * @notice This contract is about the shrem's basic ability
*/
contract ShremWorld is MonsterFactory{

    /// @dev Trigger this event when new player(address) create a new shrem
    event NewShrem(string name);


    /// @param cooldownTime The search_times will add one each one hour(3,600 seconds)
    /// @param Shrem's ID which is used to local the shrem in the shrem array


    /// @notice Shrem's attributes
    /// @param name The name of this player's shrem 
    /// @param ce The combat effectiveness of the shrem
    /// @param full This variable determines whether the shrem can fight
    /// @param skill_amount The amount of the shrem's learned skill
    /// @param add The public address which this shrem belong to
    /// @param lastTime The time last getting the offline benefits
    /// @param search_times This variable determines whether the shrem can fight
    /// @param weapon The number of the weapon which has got
    /// @param white Proof of eligibility for the white list
    struct Shrem{
        string name;
        uint ce;
        uint full;
        uint skill_amount;
        address add;
        uint lastTime;
        uint search_times;
        uint weapon;
        uint white;
    }


    uint cooldownTime = 1 hours;
    uint internal ID;


    /// @notice Shrem array instance
    Shrem[] internal shrems;


    /// @notice This mapping help confirm this address play this game first time or not
    mapping(address => uint)ownerShremCount;
    

    /// @dev Create a new shrem with initial value for the new player
    /// @notice Each shrem has ID to search in the shrems array
    function createShrem(string calldata _name)public{
        require(ownerShremCount[msg.sender]==0);
        shrems.push(Shrem(_name, 5, 0, 1, msg.sender, block.timestamp, 10, 0, 0));
        ID = shrems.length - 1;
        ownerShremCount[msg.sender]++;
        emit NewShrem(_name);
    }


    /// @dev Search the player's shrem ID value with player's public address
    /// @notice Using the "for" loop
    /// @return ID value
    function getShremId()public view returns(uint){
        for(uint i = 0; i < shrems.length; i++)
            if(shrems[i].add == msg.sender)return i;
        return 0;
    }


    /// @dev For the long-time players
    /// @notice If the address has created a shrem, use haveShrem() to confirm and change ID
    function haveShrem()public{
        require(ownerShremCount[msg.sender]!=0);
        ID = getShremId();
    }


    /// @dev Get the local address
    /// @notice The function can be public called 
    /// @return Address value
    function getAddress()public view returns(address){
        address _add = msg.sender;
        return _add;
    }


    /// @dev Get the shrem's name
    /// @notice The function can be public called 
    /// @return Name value
    function getSname()public view returns(string memory){
        string memory _name = shrems[ID].name;
        return _name;
    }


    /// @dev Get the shrem's combat effectiveness
    /// @notice The function can be public called 
    /// @return Combat effectiveness value
    function getSce()public view returns(uint){
        return shrems[ID].ce;
    }


    /// @dev Get the shrem's full
    /// @notice The function can be public called 
    /// @return Full value
    function getSfull()public view returns(uint){
        return shrems[ID].full;
    }


    /// @dev Get the shrem's skill_amount
    /// @notice The function can be public called 
    /// @return Skill_amount value
    function getSsa()public view returns(uint){
        return shrems[ID].skill_amount;
    }


    /// @dev Get the shrem's search_times
    /// @notice The function can be public called 
    /// @return Search_times value
    function getStimes()public view returns(uint){
        return shrems[ID].search_times;
    }


    /// @dev Set the shrem's name
    /// @notice The function is internal called 
    function setSname(string calldata _name)internal{
        shrems[ID].name = _name;
    }


    /// @dev Set the shrem's combat effectiveness
    /// @notice The function is internal called 
    function setSce(uint _ce)internal{
        shrems[ID].ce = _ce;
    }


    /// @dev Set the shrem's full
    /// @notice The function is internal called 
    function setSfull(uint _full)internal{
        shrems[ID].full = _full;
    }


    /// @dev The shrem's skill_amount adds one
    /// @notice The function is internal called 
    function setSsa()internal{
        shrems[ID].skill_amount++;
    }

}