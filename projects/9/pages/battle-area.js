import { ethers } from 'ethers'
import React, { useEffect, useState } from 'react'
import axios from 'axios'
import Web3Modal from "web3modal"
import { useRouter } from 'next/router'

import {
  nftmarketaddress, nftaddress
} from '../config'
import Dragon from './Dragon'

import Market from '../artifacts/contracts/Market.sol/NFTMarket.json'
import NFT from '../artifacts/contracts/Dragon.sol/FiveElementalDragon.json'

export default function Battleground() {
  const router = useRouter()
  const [nfts, setNfts] = useState([])
  const [loadingState, setLoadingState] = useState('not-loaded')
  const [first, setFirst] = useState(true)
  const [damageArray, setDamage] = useState([])
  const [dragon, setDragon] = useState([])
  const [target, setTarget] = useState([])
  const [myLife, setMyLife] = useState(0)
  const [targetLife, setTargetLife] = useState(0)
  const [anime, setAnime] = useState(false)
  const [attackIndex, setAttackIndex] = useState(0)
  const [attackColor, setAttackColor] = useState('#000')
  const [battleResult, setBattleResult] = useState([])
  const [myDamage, setMyDamage] = useState(0)
  const [targetDamage, setTargetDamage] = useState(0)
  const [myResult, setMyResult] = useState('')
  const [targetResult, setTargetResult] = useState('')
  
  useEffect(() => {
    // loadAllNFTs()
    loadDragon()
    loadTarget()
    console.log(router.query.id, router.query.target)
  }, [])
  async function fight() {
    const web3Modal = new Web3Modal({
      network: "mainnet",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
      
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, signer)

    tokenContract.on("DragonBattleResult", (my, target, firstAttack,  winner, loser, damage, event) => {
      console.log(`router.id:${router.query.id} router.target:${router.query.target} my:${my} target:${target}`)
      console.log(`my:${my}`);
      console.log(`target:${target}`);
      console.log(`firstAttack:${firstAttack}`);
      console.log(`winner:${winner}`);
      console.log(`loser:${loser}`);
      console.log(`damage:${damage}`);
      if(Number(my) === Number(router.query.id) && Number(target) === Number(router.query.target)){
        
        setFirst(firstAttack)
        setDamage(damage)
        battleAnimation(damage, Number(winner)===Number(my)?'Win':'Lose', Number(winner)===Number(target)?'Win':'Lose')
      }
    });

    const result = await tokenContract.battle(router.query.id, router.query.target)
    await result.wait()
  }

  async function loadDragon() {
    const web3Modal = new Web3Modal({
      network: "mainnet",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
      
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
    const data = await tokenContract.dragons(router.query.id)
    const tokenUri = await tokenContract.tokenURI(router.query.id)
    setMyLife(Number(data.tail))
    setDragon(data)
    // setAffinity(Number(data.affinity))
    // setPic(tokenUri)
  }

  async function loadTarget() {
    const web3Modal = new Web3Modal({
      network: "mainnet",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
      
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
    const data = await tokenContract.dragons(router.query.target)
    const tokenUri = await tokenContract.tokenURI(router.query.target)
    setTargetLife(Number(data.tail))
    setTarget(data)
    // setAffinity(Number(data.affinity))
    // setPic(tokenUri)
  }

  async function fightTest() {
    const web3Modal = new Web3Modal({
      network: "mainnet",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
      
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, signer)
    const result = await tokenContract.battleTest(router.query.id, router.query.target)
    console.log(`data:`)
    console.log(result)
    
  }

  function battleAnimation(array, myR, targetR) {
    console.log('battleAnimation')
    setAnime(true)
    const timer = setInterval(() => {
      
      
      setAttackIndex((oldValue) => {
        
        if(first===true&&oldValue%2===0){
          console.log('first:me double')
          setTargetLife((temp) => {
            const someNewValue =  temp - Number(array[oldValue])
            return someNewValue
          })
          setTargetDamage(Number(array[oldValue]))
        }else if(first===true&&oldValue%2===1){
          console.log('first:me single')
          setMyLife((temp) => {
            const someNewValue =  temp - Number(array[oldValue])
            return someNewValue
          })
          setMyDamage(Number(array[oldValue]))
        }else if(first===false&&oldValue%2===1){
          console.log('first:enemy single')
          setMyLife((temp) => {
            const someNewValue =  temp - Number(array[oldValue])
            return someNewValue
          })
          setMyDamage(Number(array[oldValue]))
        }else{
          console.log('first:enemy double')
          setTargetLife((temp) => {
            const someNewValue =  temp - Number(array[oldValue])
            return someNewValue
          })
          setTargetDamage(Number(array[oldValue]))
        }

        console.log(oldValue)
        if(oldValue>9){
          setAnime(false)
          clearInterval(timer)
          endGame(array, myR, targetR)
          return 10;
        }
        const someNewValue = oldValue + 1
        return someNewValue
      });
      
    }, 2000)

    // end
    // setAnime(false)
    // clearInterval(timer)
  }

  function endGame(array, myR, targetR){
    console.log('end game')
    setBattleResult(array)
    setAttackIndex(0)
    setMyDamage(0)
    setTargetDamage(0)
    setMyResult(myR)
    setTargetResult(targetR)
    setMyLife(Number(dragon.tail))
    setTargetLife(Number(target.tail))
  }

  function getColor(aff){
    if (aff === 0) {
      return '#FFD700'
    } else if (aff === 1){
      return '#449652'
    } else if (aff === 2){
      return '#00A4DA'
    } else if (aff === 3){
      return '#C30000'
    } else if (aff === 4){
      return '#D2691E'
    }
    return '#FFD700';
  }

  if (loadingState === 'loaded' && !nfts.length) return (<h1 className="py-10 px-20 text-3xl">No assets owned</h1>)
  return (
    <div className="flex justify-center">
      <div className="flex justify-center p-4" style={{flexDirection:'column', alignItems:'center'}}>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4" style={{
          display: 'flex',
          flexDirection: 'row',
          flexWrap: 'wrap',
          justifyContent: 'center'
        }}>
          <div style={{display:'flex', flexDirection:'column', justifyContent:'center', alignItems:'center'}}>
            
            <Dragon dragonID={router.query.id} target={false} guest={true}/>
            <div color={Number(dragon.affinity)===0?'#FFD700'
                      :Number(dragon.affinity)===1?'#449652'
                      :Number(dragon.affinity)===2?'#00A4DA'
                      :Number(dragon.affinity)===3?'#C30000'
                      :Number(dragon.affinity)===4?'#D2691E':'#000'}>{`Life:${myLife}`}</div>
            {myDamage===0?<div/>:<div>{`-${myDamage}`}</div>}
            {myResult.length===0?<div/>:<div>{myResult}</div>}
          </div>
          {
            anime===false?
              <div style={{width:'100px'}}/>:
                attackIndex%2===0&&first===true?<div style={{
                  width:'100px', 
                  display:'flex',
                  justifyContent:'center',
                  alignItems:'center'}}>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -0.5 32 32" shapeRendering="crispEdges">
                    <path stroke={
                      Number(dragon.affinity)===0?'#FFD700'
                      :Number(dragon.affinity)===1?'#449652'
                      :Number(dragon.affinity)===2?'#00A4DA'
                      :Number(dragon.affinity)===3?'#C30000'
                      :Number(dragon.affinity)===4?'#D2691E':'#000'} 
                    d="M12 0h8M12 1h11M13 2h11M14 3h12M13 4h14M9 5h19M6 6h23M7 7h22M9 8h21M11 9h20M13 10h18M14 11h17M10 12h22M6 13h26M2 14h30M0 15h32M2 16h30M6 17h26M10 18h22M14 19h18M13 20h18M11 21h20M9 22h22M7 23h23M6 24h23M9 25h20M13 26h15M14 27h13M13 28h13M13 29h11M12 30h11M11 31h9" />
                  </svg>
                </div>:attackIndex%2===0&&first===false?
                <div style={{
                  width:'100px', 
                  display:'flex',
                  transform: `rotateY(180deg)`,
                  justifyContent:'center',
                  alignItems:'center'}}>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -0.5 32 32" shapeRendering="crispEdges">
                    <path stroke={
                      Number(target.affinity)===0?'#FFD700'
                      :Number(target.affinity)===1?'#449652'
                      :Number(target.affinity)===2?'#00A4DA'
                      :Number(target.affinity)===3?'#C30000'
                      :Number(target.affinity)===4?'#D2691E':'#000'} 
                    d="M12 0h8M12 1h11M13 2h11M14 3h12M13 4h14M9 5h19M6 6h23M7 7h22M9 8h21M11 9h20M13 10h18M14 11h17M10 12h22M6 13h26M2 14h30M0 15h32M2 16h30M6 17h26M10 18h22M14 19h18M13 20h18M11 21h20M9 22h22M7 23h23M6 24h23M9 25h20M13 26h15M14 27h13M13 28h13M13 29h11M12 30h11M11 31h9" />
                  </svg>
                </div>:attackIndex%2===1&&first===true?
                <div style={{
                  width:'100px', 
                  display:'flex',
                  transform: `rotateY(180deg)`,
                  justifyContent:'center',
                  alignItems:'center'}}>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -0.5 32 32" shapeRendering="crispEdges">
                    <path stroke={
                      Number(target.affinity)===0?'#FFD700'
                      :Number(target.affinity)===1?'#449652'
                      :Number(target.affinity)===2?'#00A4DA'
                      :Number(target.affinity)===3?'#C30000'
                      :Number(target.affinity)===4?'#D2691E':'#000'} 
                    d="M12 0h8M12 1h11M13 2h11M14 3h12M13 4h14M9 5h19M6 6h23M7 7h22M9 8h21M11 9h20M13 10h18M14 11h17M10 12h22M6 13h26M2 14h30M0 15h32M2 16h30M6 17h26M10 18h22M14 19h18M13 20h18M11 21h20M9 22h22M7 23h23M6 24h23M9 25h20M13 26h15M14 27h13M13 28h13M13 29h11M12 30h11M11 31h9" />
                  </svg>
                </div>:<div style={{
                  width:'100px', 
                  display:'flex',
                  justifyContent:'center',
                  alignItems:'center'}}>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -0.5 32 32" shapeRendering="crispEdges">
                    <path stroke={
                      Number(dragon.affinity)===0?'#FFD700'
                      :Number(dragon.affinity)===1?'#449652'
                      :Number(dragon.affinity)===2?'#00A4DA'
                      :Number(dragon.affinity)===3?'#C30000'
                      :Number(dragon.affinity)===4?'#D2691E':'#000'} 
                    d="M12 0h8M12 1h11M13 2h11M14 3h12M13 4h14M9 5h19M6 6h23M7 7h22M9 8h21M11 9h20M13 10h18M14 11h17M10 12h22M6 13h26M2 14h30M0 15h32M2 16h30M6 17h26M10 18h22M14 19h18M13 20h18M11 21h20M9 22h22M7 23h23M6 24h23M9 25h20M13 26h15M14 27h13M13 28h13M13 29h11M12 30h11M11 31h9" />
                  </svg>
                </div>
            
          }
          <div style={{display:'flex', flexDirection:'column', justifyContent:'center', alignItems:'center'}}>
            
            <Dragon dragonID={router.query.target} target={true} guest={true}/>
            <div color={Number(target.affinity)===0?'#FFD700'
                      :Number(target.affinity)===1?'#449652'
                      :Number(target.affinity)===2?'#00A4DA'
                      :Number(target.affinity)===3?'#C30000'
                      :Number(target.affinity)===4?'#D2691E':'#000'}>{`Life:${targetLife}`}</div>
            {targetDamage===0?<div/>:<div>{`-${targetDamage}`}</div>}
            {targetResult.length===0?<div/>:<div>{targetResult}</div>}
          </div>
        </div>
        <button onClick={()=>fight()} className="font-bold mt-4 bg-purple-500 text-white rounded p-4 shadow-lg">
          Battle!
        </button>
        {/* <button onClick={()=>fightTest()} className="font-bold mt-4 bg-purple-500 text-white rounded p-4 shadow-lg">
          Test Battle!
        </button>
        <button onClick={()=>battleAnimation([1,1,1,1,1,1,1,1,1,1], 'Win', 'Lose')} className="font-bold mt-4 bg-purple-500 text-white rounded p-4 shadow-lg">
          Test Anime!
        </button> */}
        {battleResult.length===0?<div/>:<div>{`Battle Result:[${battleResult}]`}</div>}
      </div>
    </div>
  )
}