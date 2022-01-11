// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/utils/Counters.sol";
import "./DragonMutation.sol";

library DragonAffinity {
    function generation(uint attackAffinity , uint defenseAffinity) 
        public 
        pure 
        returns (bool){
        if(attackAffinity == 0 && defenseAffinity == 2){ // 🏆生💧
            return true;
        }else if(attackAffinity == 2 && defenseAffinity == 1){ // 💧生🪵
            return true;
        }else if(attackAffinity == 1 && defenseAffinity == 3){ // 🪵生🔥
            return true;
        }else if(attackAffinity == 3 && defenseAffinity == 4){ // 🔥生🪨
            return true;
        }else if(attackAffinity == 4 && defenseAffinity == 0){ // 🪨生🏆
            return true;
        }else{
            return false;
        }
    }

    function restraint(uint attackAffinity , uint defenseAffinity) 
        public 
        pure 
        returns (bool){
        if(attackAffinity == 0 && defenseAffinity == 1){ // 🏆克🪵
            return true;
        }else if(attackAffinity == 1 && defenseAffinity == 4){ // 🪵克🪨
            return true;
        }else if(attackAffinity == 4 && defenseAffinity == 2){ // 🪨克💧
            return true;
        }else if(attackAffinity == 2 && defenseAffinity == 3){ // 💧克🔥
            return true;
        }else if(attackAffinity == 3 && defenseAffinity == 0){ // 🔥克🏆
            return true;
        }else{
            return false;
        }
    }
}

abstract contract DragonBattle is DragonMutation {
    using Counters for Counters.Counter;
    Counters.Counter private randNonce;
    event DragonBattleResult(uint my, uint target, bool firstAttack, uint winner , uint loser, uint[] damage);    

    function firstAttack(uint _dragonId, uint _targetId) public view returns(bool) {
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        if(myDragon.race == 2){
            return true;
        }else if(targetDragon.race == 2){
            return false;
        }else if(myDragon.race == 0){
            return true;
        }else if(targetDragon.race == 0){
            return false;
        }else if(myDragon.race == 3){
            return true;
        }else if(targetDragon.race == 3){
            return false;
        }else if(myDragon.legs >= targetDragon.legs){
            return true;
        }else if(myDragon.legs < targetDragon.legs){
            return false;
        }else if(myDragon.experience <= targetDragon.experience ){
            return true;
        }else if(targetDragon.experience < myDragon.experience){
            return false;
        }else{
            return true;
        }
    }

    // function battleResult(){

    // }

    function lessZero(uint num, uint minus) public pure returns(uint) {
        if(num <= minus){
            return 0;
        }else{
            return (num - minus);
        }
    }

    function randMod(uint _modulus) internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce.current()))) % _modulus;
    }


    function damage(uint _dragonId, uint _targetId) public view returns (uint) {
        Dragon storage attack = dragons[_dragonId];
        Dragon storage defense = dragons[_targetId];

        bool res = DragonAffinity.restraint(attack.affinity, defense.affinity);
        bool gen = DragonAffinity.generation(attack.affinity, defense.affinity);

        uint attackValue = attack.head;
        uint defenseValue = defense.wing;
        if(res) {
            defenseValue = lessZero(defenseValue ,20);
        }else if(gen) {
            attackValue = attackValue + 20;
        }
        if(randMod(100) < attack.claw) {
            attackValue = attackValue * 2;
        }

        return lessZero(attackValue ,defenseValue);
    }

    // function battleTest(uint _dragonId, uint _targetId) public view returns(uint[] memory) {
    //     bool first = firstAttack(_dragonId, _targetId);
    //     Dragon storage myDragon = dragons[_dragonId];
    //     Dragon storage targetDragon = dragons[_targetId];
    //     uint myHP = myDragon.tail;
    //     uint targetHP = targetDragon.tail;

    //     uint i = 0;
    //     uint256[] memory fight = new uint256[](10);
    //     while(myHP > 0 && targetHP > 0){
    //         uint damageNum = 0;
    //         if(first==true && i%2 == 0) { // 我方先攻，偶数回合
    //             damageNum = damage(_dragonId, _targetId);
    //             targetHP = lessZero(targetHP, damageNum);
    //         }else if(first==false && i%2 == 0) { // 敌方先攻，偶数回合
    //             damageNum = damage(_targetId, _dragonId);
    //             myHP = lessZero(myHP, damageNum);
    //         } else if(first==false && i%2 == 1) { // 敌方先攻，奇数回合
    //             damageNum = damage(_dragonId, _targetId);
    //             targetHP = lessZero(targetHP, damageNum);
    //         } else { // 我方先攻，奇数回合
    //             damageNum = damage(_targetId, _dragonId);
    //             myHP = lessZero(myHP, damageNum);
    //         }
    //         fight[i] = damageNum;
    //         i++;
    //     }

    //     return fight;
    // }

    function battle(uint _dragonId, uint _targetId) public returns(uint[] memory) {
        bool first = firstAttack(_dragonId, _targetId);
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        uint myHP = myDragon.tail;
        uint targetHP = targetDragon.tail;

        uint i = 0;
        uint256[] memory fight = new uint256[](10);
        while(myHP > 0 && targetHP > 0){
            uint damageNum = 0;
            if(first==true && i%2 == 0) { // 我方先攻，偶数回合
                damageNum = damage(_dragonId, _targetId);
                targetHP = lessZero(targetHP, damageNum);
            }else if(first==false && i%2 == 0) { // 敌方先攻，偶数回合
                damageNum = damage(_targetId, _dragonId);
                myHP = lessZero(myHP, damageNum);
            } else if(first==false && i%2 == 1) { // 敌方先攻，奇数回合
                damageNum = damage(_dragonId, _targetId);
                targetHP = lessZero(targetHP, damageNum);
            } else { // 我方先攻，奇数回合
                damageNum = damage(_targetId, _dragonId);
                myHP = lessZero(myHP, damageNum);
            }
            fight[i] = damageNum;
            i++;
        }
        
        if(targetHP <= 0) {
            myDragon.winCount++;
            myDragon.experience++;
            targetDragon.lossCount++;
            string memory timestamp = uint2str(block.timestamp);
            uint rand = uint(keccak256(abi.encodePacked(targetDragon.name, timestamp)));
            mutation(_dragonId, _targetId, rand);
            emit DragonBattleResult(_dragonId, _targetId, first , _dragonId, _targetId, fight);
        }else{
            myDragon.lossCount++;
            targetDragon.winCount++;
            emit DragonBattleResult(_dragonId, _targetId, first ,_targetId, _dragonId, fight);
        }

        return fight;
    }
}