// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;
import "./DragonHatch.sol";

abstract contract DragonMutation is DragonHatch {
    // mapping (address => address) DragonMutationTarget;
    uint evolution = 100;

    modifier onlyOwnerOf(uint _dragonId) {
        require(msg.sender == dragonToOwner[_dragonId]);
        _;
    }

    function _triggerCooldown(Dragon storage _dragon) internal {
        _dragon.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Dragon storage _dragon) internal view returns (bool) {
        return (_dragon.readyTime <= block.timestamp);
    }

    function _isDragon(Dragon storage _dragon) internal view returns (bool) {
        return _dragon.race == 0;
    }

    function _determineRace(Dragon storage _dragon) internal {
        
        if(_dragon.head >= evolution){ // Hydra
            _dragon.race = 1;
        }else if(_dragon.wing >= evolution){ // Amphithere
            _dragon.race = 2;
        }else if(_dragon.claw >= evolution){ // Kirin
            _dragon.race = 3;
        }else if(_dragon.legs >= evolution){ // Salamander
            _dragon.race = 4;
        }else if(_dragon.tail >= evolution){ // SeaSerpent
            _dragon.race = 5;
        }
    }
    
    function mutation(uint _dragonId, uint _targetId, uint targetParts) internal onlyOwnerOf(_dragonId) {
    // function mutation(uint _dragonId, uint _targetId, uint targetParts) public onlyOwnerOf(_dragonId) {
        
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        require(_isDragon(myDragon), "You have grown up not a baby dragon.");
        // require(_isReady(myDragon));
        uint newPart = 0;
        if(targetParts == 0){
            newPart = targetDragon.head / 2 + myDragon.head;
            myDragon.head = newPart;
        }else if(targetParts == 1){
            newPart = targetDragon.wing / 2 + myDragon.wing;
            myDragon.wing = newPart;
        }else if(targetParts == 2){
            newPart = targetDragon.claw / 2 + myDragon.claw;
            myDragon.claw = newPart;
        }else if(targetParts == 3){
            newPart = targetDragon.legs / 2 + myDragon.legs;
            myDragon.legs = newPart;
        }else {
            newPart = targetDragon.tail / 2 + myDragon.tail;
            myDragon.tail = newPart;
        }
        
        _determineRace(myDragon);
        _triggerCooldown(myDragon);
    }

    function changeRace(uint _dragonId, uint16 _newRace) external onlyOwnerOf(_dragonId) {
        dragons[_dragonId].race = _newRace;
    }
}