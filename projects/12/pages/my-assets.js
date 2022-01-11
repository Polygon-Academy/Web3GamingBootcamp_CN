import { ethers } from 'ethers'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Web3Modal from "web3modal"

import {
  nftmarketaddress, nftaddress
} from '../config'
import Dragon from './Dragon'

import Market from '../artifacts/contracts/Market.sol/NFTMarket.json'
import NFT from '../artifacts/contracts/Dragon.sol/FiveElementalDragon.json'

export default function MyAssets() {
  const [nfts, setNfts] = useState([])
  const [loadingState, setLoadingState] = useState('not-loaded')
  useEffect(() => {
    loadNFTs()
  }, [])
  async function loadNFTs() {
    const web3Modal = new Web3Modal({
      network: "mumbai",
      cacheProvider: true,
    })
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)
    const signer = provider.getSigner()
    console.log(connection)
    console.log(provider)
    const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
    const data = await tokenContract.fetchMyNFTs(signer.getAddress())
    console.log(`data:`)
    console.log(data)
    const items = await Promise.all(data.map(async i => {
      const tokenUri = await tokenContract.tokenURI(i.toNumber())
      // // const meta = await axios.get(tokenUri)
      // let price = ethers.utils.formatUnits(i.price.toString(), 'ether')
      // let item = {
      //   price,
      //   tokenId: i.tokenId.toNumber(),
      //   seller: i.seller,
      //   owner: i.owner,
      //   image: tokenUri,
      // }
      // return item
      
      return tokenUri
    }))

    console.log(items)
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
              <Dragon key={i} dragonID={nft} target={false}/>
            ))
          }
        </div>
      </div>
    </div>
  )
}