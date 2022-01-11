import { ethers } from 'ethers'
import { useEffect, useState } from 'react'
import Web3Modal from "web3modal"
import Image from 'next/image'
import { useRouter } from 'next/router'

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

export default function Dragon({
  dragonID, 
  dragonPic, 
  target = false, 
  isBattle = false, 
  guest = false,
  selectedId = -1,
  forSale = false,
  saleInfo ={
    price: 0,
    itemId: 0,
    seller: '',
    owner: '',
    image: '',
    name: '',
    description: '',
  },
  ...props}) {

  const [dragon, setDragon] = useState([])
  const [affinity, setAffinity] = useState(0)
  const [pic, setPic] = useState('')
  const router = useRouter()

  useEffect(() => {
    loadDragon()
  }, [])

  async function buyNft(nft) {
    console.log('buy')
    const web3Modal = new Web3Modal()
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
    const contract = new ethers.Contract(nftmarketaddress, Market.abi, signer)

    const price = ethers.utils.parseUnits(nft.price.toString(), 'ether')
    const transaction = await contract.createMarketSale(nftaddress, nft.itemId, {
      value: price
    })
    await transaction.wait()
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
    const data = await tokenContract.dragons(dragonID)
    const tokenUri = await tokenContract.tokenURI(dragonID)
    console.log(`Dragon:`)
    console.log(data)
    setDragon(data)
    setAffinity(Number(data.affinity))
    setPic(tokenUri)
  }

  async function sellDragon() {
    const web3Modal = new Web3Modal({
      network: "mumbai",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()

    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, signer)
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
    try {
      const tx = await tokenContract.approve(nftmarketaddress, dragonID)
      console.log(tx)
      let listingPrice = await marketContract.getListingPrice()
      listingPrice = listingPrice.toString()
      const price = ethers.utils.parseUnits('1', 'ether')
      const transaction = await marketContract.createMarketItem(nftaddress, dragonID, price, { value: listingPrice })
      await transaction.wait()
    } catch (error) {
      console.log(error)
    }
    
  }



  return (
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

      {forSale===true?<div style={{marginTop:'30px' ,zIndex:3}}>
          <p className="text-2xl mb-4 font-bold text-white">{saleInfo.price} Matic</p>
          <button className="mt-100px w-full bg-purple-500 text-white font-bold py-2 px-12 rounded" onClick={() => buyNft(saleInfo)}>Buy</button>
        </div>:<div style={{
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
          }} onClick={()=>{
            if(guest===true)
              return
            if(isBattle===false){
              router.push(`/battle-ground?id=${dragonID}`)
            }else{
              router.push(`/battle-area?id=${selectedId}&target=${dragonID}`)
            }
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
        }} onClick={()=>{
          if(guest===true)
            return
          router.push(`/detail?id=${dragonID}`)}}> 
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
          <div style={{fontSize:'8px'}}>Detail</div>
        </div>
      </div>}
      
    </div>
  )
}