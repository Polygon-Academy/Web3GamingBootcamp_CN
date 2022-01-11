// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./fight.sol";

/**
 * @title Search Contract
 * @author Aaron Guo
 * @notice This contract is about the search part
*/
contract Search is Fight{

    /// @dev Confirm the search_times is more than one
    /// @notice isReady will be used in the other functions
    modifier isReady(){
        require(shrems[ID].search_times > 0);
        shrems[ID].search_times--;
        _;
    }


    /// @dev Players can get the offline benefits
    /// @notice For each offline hour search_times will add one and has a get-limit on ten. Shrem's full will decrease and ce will increase slightly
    function getOffBenefit()public {
        /// @param _time The time from now to last getting the offline benefits
        uint _time = (block.timestamp - shrems[ID].lastTime) / 3600;
        require(_time > 0);
        if(_time >= 10){
            shrems[ID].search_times += 10;
            shrems[ID].lastTime = block.timestamp;
            shrems[ID].ce += shrems[ID].ce/10;
            if(shrems[ID].full > 50)shrems[ID].full -= 50;
            else shrems[ID].full = 0;
        }
        else{
            shrems[ID].search_times += _time;
            shrems[ID].lastTime = _time * 3600 + shrems[ID].lastTime;
        }
    }


    /// @dev To decrease shrem's full percently
    /// @notice The full won't be less than 0
    function decrease(uint _full)internal {
        if(getSfull() > _full)setSfull(getSfull() - _full);
        else setSfull(0);
    }


    /// @dev To increase shrem's combat effectiveness
    /// @notice The combat effectiveness will multiply by combat effectiveness ratio
    function increase(uint _ce)internal{
        uint _Sce = getSce();
        setSce(_Sce * (100+_ce) / 100);
    }


    /// @dev The shrem will get the "king" title if its combat effectiveness is more than 100,000
    /// @notice The "king" will get the white list!!
    /// @return Become "king" successfully will return 1, else 0
    function king()public returns(uint){
        uint _ce = getSce();
        if(_ce > 100000){
            shrems[ID].white = 1;
            return 1;
        }else return 0;
    }


    /// @dev To choose one from two
    /// @notice If random is less than 50, choose 1. If more than 50, choose 2
    /// @return 1 for event 1, 2 for event 2
    function aOrb()internal view returns(uint){
        uint _ab;
        uint randNonce = 0;
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 99;
        if(random <50)_ab = 1;
        else _ab = 2;
        return _ab;
    }


    /// @dev judge11 means "large route 1 and small route 1"
    /// @notice Both decrease shrem's full
    /// @return Which event to choose
    function judge11()public isReady returns(uint){
        uint i = aOrb();
        decrease(15);
        return i;
    }


    /// @dev judge12 means "large route 1 and small route 2"
    /// @notice Both decrease shrem's full
    /// @return Which event to choose
    function judge12()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)decrease(20);
        else decrease(10);
        return i;
    }


    /// @dev judge13 means "large route 1 and small route 3"
    /// @notice Consume some matic to decrease shrem's full by a wide margin using the temporary address
    /// @return Which event to choose
    function judge13()public payable isReady returns(uint){
        address payable _add = payable(0x90863e4e471178d73394aba407255e33470b4Ab0);
        _add.transfer(100000000 gwei);
        decrease(70);
        uint i = aOrb();
        return i;
    }


    /// @dev judge21 means "large route 2 and small route 1"
    /// @notice Related to the offline benefits
    /// @return Which event to choose
    function judge21()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)shrems[ID].lastTime -= 3600 * 3;
        else{
            uint _time = (block.timestamp - shrems[ID].lastTime) / 3600;
            if(_time == 0)shrems[ID].lastTime = block.timestamp;
            else shrems[ID].lastTime += 3600;
        }
        return i;
    }


    /// @dev judge22 means "large route 2 and small route 2"
    /// @notice Related to the search_times
    /// @return Which event to choose
    function judge22()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)shrems[ID].search_times += 2;
        return i;
    }


    /// @dev judge23 means "large route 2 and small route 3"
    /// @notice Related to "weapon". Player will get the white list if "weapon" is more than 5!!
    /// @return Which event to choose
    function judge23()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)shrems[ID].weapon++;
        else{
            if(shrems[ID].weapon < 5)shrems[ID].weapon--;
            else shrems[ID].white = 1;
        }
        return i;
    }


    /// @dev judge31 means "large route 3 and small route 1"
    /// @notice Both increase shrem's combat effectiveness
    /// @return Which event to choose
    function judge31()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)increase(20);
        else increase(10);
        return i;
    }


    /// @dev judge32 means "large route 3 and small route 2"
    /// @notice Decrease shrem's full or do nothing
    /// @return Which event to choose
    function judge32()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)decrease(30);
        return i;
    }


    /// @dev judge33 means "large route 3 and small route 3"
    /// @notice Both decrease shrem's full
    /// @return Which event to choose
    function judge33()public isReady returns(uint){
        uint i = aOrb();
        if(i == 1)decrease(25);
        else decrease(5);
        return i;
    }

}