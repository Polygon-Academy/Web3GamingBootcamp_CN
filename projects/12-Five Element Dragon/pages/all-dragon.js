import { ethers } from 'ethers'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Web3Modal from "web3modal"
import Router from 'next/router'

import {
  nftmarketaddress, nftaddress
} from '../config'
import Dragon from './Dragon'

import Market from '../artifacts/contracts/Market.sol/NFTMarket.json'
import NFT from '../artifacts/contracts/Dragon.sol/FiveElementalDragon.json'

export default function Battleground() {
  const [nfts, setNfts] = useState([])
  const [loadingState, setLoadingState] = useState('not-loaded')
  useEffect(() => {
    loadAllNFTs()
  }, [])
  async function loadAllNFTs() {
    const web3Modal = new Web3Modal({
      network: "mainnet",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
      
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
    const tokenId = await tokenContract._tokenIds()
    let data = [];
    for (let index = 0; index < tokenId; index++) {
      data.push(index)
    }
    console.log(`data:`)
    console.log(Router.query.id)
    console.log(Number(tokenId))
    console.log(data)
    
    setNfts(data)
    setLoadingState('loaded') 
  }
  if (loadingState === 'loaded' && !nfts.length) return (<h1 className="py-10 px-20 text-3xl">No assets owned</h1>)
  return (
    <div className="flex justify-center">
      <div className="p-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4" style={{
          display: 'flex',
          flexDirection: 'row',
          flexWrap: 'wrap',
          justifyContent: 'center'
          // justifyContent: 'flex-start',
          // alignItems: 'flex-start'
        }}>
          {
            nfts.map((nft, i) => (
              <Dragon key={i} guest={true} dragonID={nft} target={false} isBattle={true} selectedId={Router.query.id}/>
            ))
          }
        </div>
      </div>
    </div>
  )
}