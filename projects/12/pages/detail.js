import { ethers } from 'ethers'
import { useEffect, useState } from 'react'
import Web3Modal from "web3modal"
import Image from 'next/image'
import Router from 'next/router'

import Market from '../artifacts/contracts/Market.sol/NFTMarket.json'
import NFT from '../artifacts/contracts/Dragon.sol/FiveElementalDragon.json'
import Metal from '../Dragon/svg/metal.png'
import Plant from '../Dragon/svg/plant.png'
import Water from '../Dragon/svg/water.png'
import Fire from '../Dragon/svg/fire.png'
import Earth from '../Dragon/svg/earth.png'
import NoElement from '../Dragon/svg/no.png'
import {
  nftmarketaddress, nftaddress
} from '../config'

export default function Detail({dragonID, dragonPic, target=false, ...props}) {

  const [dragon, setDragon] = useState([])
  const [affinity, setAffinity] = useState(0)
  const [pic, setPic] = useState('')
  const [price, setPrice] = useState('')
  

  useEffect(() => {
    loadDragon()
  }, [])


  function updateFormInput(str) {
    setPrice(str)
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
    const data = await tokenContract.dragons(Router.query.id)
    const tokenUri = await tokenContract.tokenURI(Router.query.id)

    console.log(`Dragon:`)
    console.log(data)
    setDragon(data)
    setAffinity(Number(data.affinity))
    setPic(tokenUri)

  }

  async function sellDragon() {
    if(price.length===0){
      alert('Enter price pls')
      return
    }

    const web3Modal = new Web3Modal({
      network: "mainnet",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()

    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, signer)
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
    try {
      const tx = await tokenContract.approve(nftmarketaddress, Router.query.id)
      console.log(tx)
      let listingPrice = await marketContract.getListingPrice()
      listingPrice = listingPrice.toString()
      const priceNum = ethers.utils.parseUnits(price, 'ether')
      const transaction = await marketContract.createMarketItem(nftaddress, Router.query.id, priceNum, { value: listingPrice })
      await transaction.wait()
    } catch (error) {
      console.log(error)
    }
    
  }

  function getColor() {
    if(affinity === 0)
      return '#FFD700'
    else if (affinity === 1)
      return '#449652'
    else if (affinity === 2)
      return '#00A4DA'
    else if (affinity === 3)
      return '#C30000'
    else if (affinity === 4)
      return '#D2691E'
    else
      return '#000'
  }

  return (
    <div style={{display:'flex', flexDirection:'column',justifyContent:'center', alignItems:'center', paddingTop:'20px'}}>
      <div style={{
      // zIndex: -1,
        display:'flex',
        // justifyContent:'center',
        flexDirection:'column',
        alignItems:'center',
        backgroundSize: '100% 100%',
        width: '300px',
        height: '400px',
        // ...props
      }} >
        <Image
          alt="Tama"
          src={affinity===0?Metal:
            affinity===1?Plant:
            affinity===2?Water:
            affinity===3?Fire:
            affinity===4?Earth:NoElement}
          style={{zIndex:0}}
          layout="intrinsic"
          // objectFit="cover"
          // quality={100}
        />
        <img width={96} height={96} alt="dragon" src={pic} style={{
          zIndex:3,
          marginTop:'-75%',
          transform: `rotateY(${target===true?'180deg':'0deg'})`
        }}/>
        <div style={{zIndex:3, color:'white'}}>{dragon.name?dragon.name:''}</div>
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          // zIndex:3,
          marginTop: '20px'
        }}>
          <div style={{
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between',
            alignItems: 'center',
            cursor: 'pointer',
            zIndex:3,
          }}> 
            <div style={{
              height: '30px',
              width: '30px',
              borderRadius: '15px',
              backgroundColor: affinity===0?'#BEB4B7':
              affinity===1?'#76545F':
              affinity===2?'#FF6899':
              affinity===3?'#FFD868':
              affinity===4?'#372A2E':'#FF6899'
            }}/>
            <div style={{fontSize:'8px'}}>Feed</div>
          </div>
          <div style={{
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between',
            alignItems: 'center',
            cursor: 'pointer',
            marginLeft: '10px',
            marginRight: '10px',
            zIndex:3,
          }}> 
            <div style={{
              height: '30px',
              width: '30px',
              borderRadius: '15px',
              backgroundColor: affinity===0?'#BEB4B7':
              affinity===1?'#76545F':
              affinity===2?'#FF6899':
              affinity===3?'#FFD868':
              affinity===4?'#372A2E':'#FF6899'
            }}/>
            <div style={{fontSize:'8px'}}>Battle</div>
          </div>
          <div style={{
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between',
            alignItems: 'center',
            cursor: 'pointer',
            zIndex:10,
          }} onClick={()=>sellDragon()}> 
            <div style={{
              height: '30px',
              width: '30px',
              borderRadius: '15px',
              backgroundColor: affinity===0?'#BEB4B7':
              affinity===1?'#76545F':
              affinity===2?'#FF6899':
              affinity===3?'#FFD868':
              affinity===4?'#372A2E':'#FF6899'
            }}/>
            <div style={{fontSize:'8px'}}>Sell</div>
          </div>
        </div>
      </div>
      <div>
        <div style={{color:getColor()}}>Race: {Number(dragon.race)===0
          ?'Dragon':Number(dragon.race)===1
          ?'Hydra':Number(dragon.race)===2
          ?'Amphithere':Number(dragon.race)===3
          ?'Kirin':Number(dragon.race)===4
          ?'Salamander':Number(dragon.race)===5?'SeaSerpent':''}</div>
        <div style={{color:getColor()}}>Attack: {dragon.head?Number(dragon.head):''}</div>
        <div style={{color:getColor()}}>Defense: {dragon.wing?Number(dragon.wing):''}</div>
        <div style={{color:getColor()}}>Critical: {dragon.claw?Number(dragon.claw):''}</div>
        <div style={{color:getColor()}}>Speed: {dragon.legs?Number(dragon.legs):''}</div>
        <div style={{color:getColor()}}>Life: {dragon.tail?Number(dragon.tail):''}</div>
        <div style={{color:getColor()}}>WinCount: {dragon.winCount?Number(dragon.winCount):'0'}</div>
        <div style={{color:getColor()}}>LossCount: {dragon.lossCount?Number(dragon.lossCount):'0'}</div>
        <div style={{color:getColor()}}>Exp: {dragon.experience?Number(dragon.experience):'0'}</div>
      </div>
      <input
        placeholder="How much Matic?"
        className="mt-2 border rounded p-4"
        value={price}
        onChange={e => updateFormInput( e.target.value )}
      />
      <button onClick={()=>sellDragon()} className="font-bold mt-4 bg-purple-500 text-white rounded p-4 shadow-lg">
        Sell
      </button>
    </div>
    
  )
}