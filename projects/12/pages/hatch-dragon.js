import { useState, useEffect } from 'react'
import { ethers } from 'ethers'
import { create as ipfsHttpClient } from 'ipfs-http-client'
import { useRouter } from 'next/router'
import Image from 'next/image'
import Web3Modal from 'web3modal'
import NoElement from '../Dragon/svg/no.png'

const client = ipfsHttpClient('https://ipfs.infura.io:5001/api/v0')

import {
  nftaddress, nftmarketaddress
} from '../config'

import NFT from '../artifacts/contracts/Dragon.sol/FiveElementalDragon.json'
import Market from '../artifacts/contracts/Market.sol/NFTMarket.json'



export default function CreateItem() {
  const egg0 = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgLTAuNSAzMiAzMiIgc2hhcGUtcmVuZGVyaW5nPSJjcmlzcEVkZ2VzIj4KPG1ldGFkYXRhPk1hZGUgd2l0aCBQaXhlbHMgdG8gU3ZnIGh0dHBzOi8vY29kZXBlbi5pby9zaHNoYXcvcGVuL1hieHZOajwvbWV0YWRhdGE+CjxwYXRoIHN0cm9rZT0iI2ZmM2ViNyIgZD0iTTEzIDFoNE0xMiAyaDZNMTIgM2g2TTExIDRoOE0xMSA1aDhNMTEgNmg4TTIzIDZoMk0xMSA3aDhNMjIgN2g0TTExIDhoOE0yMiA4aDRNMTIgOWg2TTIyIDloNE0xMiAxMGg2TTIyIDEwaDRNMTMgMTFoNE0yMiAxMWg0TTIzIDEyaDJNOCAxNGgyTTcgMTVoNE02IDE2aDZNNiAxN2g2TTE5IDE3aDZNNiAxOGg2TTE3IDE4aDEwTTcgMTloNE0xNiAxOWgxMk04IDIwaDJNMTUgMjBoMTNNMTQgMjFoMTRNMTQgMjJoMTRNMTQgMjNoMTNNMTQgMjRoMTNNMTQgMjVoMTJNMTUgMjZoMTBNMTYgMjdoOE0xNyAyOGg2TTE5IDI5aDMiIC8+CjxwYXRoIHN0cm9rZT0iI2NhZjUwMCIgZD0iTTE3IDFoMk0xMCAyaDJNMTggMmg0TTkgM2gzTTE4IDNoNU04IDRoM00xOSA0aDVNNyA1aDRNMTkgNWg2TTYgNmg1TTE5IDZoNE0yNSA2aDFNNSA3aDZNMTkgN2gzTTI2IDdoMU01IDhoNk0xOSA4aDNNMjYgOGgxTTQgOWg4TTE4IDloNE0yNiA5aDJNNCAxMGg4TTE4IDEwaDRNMjYgMTBoMk00IDExaDlNMTcgMTFoNU0yNiAxMWgyTTMgMTJoMjBNMjUgMTJoNE0zIDEzaDI2TTMgMTRoNU0xMCAxNGgxOU0zIDE1aDRNMTEgMTVoMThNMyAxNmgzTTEyIDE2aDE3TTMgMTdoM00xMiAxN2g3TTI1IDE3aDRNMyAxOGgzTTEyIDE4aDVNMjcgMThoMk0zIDE5aDRNMTEgMTloNU0yOCAxOWgxTTQgMjBoNE0xMCAyMGg1TTQgMjFoMTBNNCAyMmgxME01IDIzaDlNNSAyNGg5TTYgMjVoOE03IDI2aDhNOCAyN2g4TTkgMjhoOE0xMCAyOWg5TTEzIDMwaDYiIC8+Cjwvc3ZnPg=='
  const egg1 = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgLTAuNSAzMiAzMiIgc2hhcGUtcmVuZGVyaW5nPSJjcmlzcEVkZ2VzIj4KPG1ldGFkYXRhPk1hZGUgd2l0aCBQaXhlbHMgdG8gU3ZnIGh0dHBzOi8vY29kZXBlbi5pby9zaHNoYXcvcGVuL1hieHZOajwvbWV0YWRhdGE+CjxwYXRoIHN0cm9rZT0iI2ZmM2ViNyIgZD0iTTEzIDNoNE0xMiA0aDZNMTIgNWg2TTExIDZoOE0xMSA3aDhNMTEgOGg4TTIzIDhoMk0xMSA5aDhNMjIgOWg0TTExIDEwaDhNMjIgMTBoNE0xMiAxMWg2TTIyIDExaDRNMTIgMTJoNk0yMiAxMmg0TTEzIDEzaDRNMjIgMTNoNE0yMyAxNGgyTTcgMTVoNE02IDE2aDZNNiAxN2g2TTE5IDE3aDZNNiAxOGg2TTE3IDE4aDEwTTcgMTloNE0xNiAxOWgxMk04IDIwaDJNMTUgMjBoMTNNMTQgMjFoMTRNMTQgMjJoMTRNMTQgMjNoMTNNMTQgMjRoMTNNMTQgMjVoMTJNMTUgMjZoMTBNMTYgMjdoOE0xNyAyOGg2TTE5IDI5aDMiIC8+CjxwYXRoIHN0cm9rZT0iI2NhZjUwMCIgZD0iTTE3IDNoMk0xMCA0aDJNMTggNGg0TTkgNWgzTTE4IDVoNU04IDZoM00xOSA2aDVNNyA3aDRNMTkgN2g2TTYgOGg1TTE5IDhoNE0yNSA4aDFNNSA5aDZNMTkgOWgzTTI2IDloMU01IDEwaDZNMTkgMTBoM00yNiAxMGgxTTQgMTFoOE0xOCAxMWg0TTI2IDExaDJNNCAxMmg4TTE4IDEyaDRNMjYgMTJoMk00IDEzaDlNMTcgMTNoNU0yNiAxM2gyTTMgMTRoMjBNMjUgMTRoNE0zIDE1aDRNMTEgMTVoMThNMyAxNmgzTTEyIDE2aDE3TTMgMTdoM00xMiAxN2g3TTI1IDE3aDRNMyAxOGgzTTEyIDE4aDVNMjcgMThoMk0zIDE5aDRNMTEgMTloNU0yOCAxOWgxTTQgMjBoNE0xMCAyMGg1TTQgMjFoMTBNNCAyMmgxME01IDIzaDlNNSAyNGg5TTYgMjVoOE03IDI2aDhNOCAyN2g4TTkgMjhoOE0xMCAyOWg5TTEzIDMwaDYiIC8+Cjwvc3ZnPg=='
  const [fileUrl, setFileUrl] = useState(null)
  const [formInput, updateFormInput] = useState({ price: '', name: '', description: '' })
  const router = useRouter()
  const [delay, setDelay] = useState(1000)
  const [egg, setEgg] = useState(egg0)

  

  useEffect(() => {
    // var timer = setInterval(function() {
    //   if(bigegg === true){
    //     setBigEgg(false)
    //     setEgg(egg1)
    //   }else{
    //     setBigEgg(true)
    //     setEgg(egg0)
    //   }
    // }, 1000);

    const timer = setInterval(() => {
      if(egg === egg0){
        setEgg(egg1)
      }else{
        setEgg(egg0)
      }
    }, delay)
    return () => clearInterval(timer)
  }, [egg, delay])

  async function createMarket() {
    const { name, description } = formInput
    if (!name ) return
    try {
      createSale(name, description)
    } catch (error) {
      console.log('Error createMarket: ', error)
    }  
  }

  async function createSale(name) {
    console.log('createsale')
    const web3Modal = new Web3Modal()
    const connection = await web3Modal.connect()
    const provider = new ethers.providers.Web3Provider(connection)    
    const signer = provider.getSigner()
    
    /* next, create the item */
    let contract = new ethers.Contract(nftaddress, NFT.abi, signer)
    let transaction = await contract.createRandomDragon(name)
    let tx = await transaction.wait()
    console.log(tx)
    // let event = tx.events[0]
    // let value = event.args[2]
    // let tokenId = value.toNumber()

    // const price = ethers.utils.parseUnits(formInput.price, 'ether')
  
    /* then list the item for sale on the marketplace */
    // contract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
    // let listingPrice = await contract.getListingPrice()
    // listingPrice = listingPrice.toString()

    // transaction = await contract.createMarketItem(nftaddress, tokenId, price, { value: listingPrice })
    // await transaction.wait()
    router.push('/my-assets')
  }

  return (
    <div className="flex justify-center">
      <div className="w-1/2 flex flex-col pb-12 justify-center" style={{alignItems:'center'}}>
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
          src={NoElement}
          style={{zIndex:0}}
          layout="intrinsic"
          // objectFit="cover"
          // quality={100}
        />
        <img width={96} height={96} alt="dragon" src={egg} style={{
          zIndex:3,
          marginTop:'-75%',
        }}/>
        {/* <img alt="" src="data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIC0wLjUgMzIgMzIiIHNoYXBlLXJlbmRlcmluZz0iY3Jpc3BFZGdlcyI+CjxwYXRoIHN0cm9rZT0iI2ZmM2ViNyIgZD0iTTEzIDFoNE0xMiAyaDZNMTIgM2g2TTExIDRoOE0xMSA1aDhNMTEgNmg4TTIzIDZoMk0xMSA3aDhNMjIgN2g0TTExIDhoOE0yMiA4aDRNMTIgOWg2TTIyIDloNE0xMiAxMGg2TTIyIDEwaDRNMTMgMTFoNE0yMiAxMWg0TTIzIDEyaDJNOCAxNGgyTTcgMTVoNE02IDE2aDZNNiAxN2g2TTE5IDE3aDZNNiAxOGg2TTE3IDE4aDEwTTcgMTloNE0xNiAxOWgxMk04IDIwaDJNMTUgMjBoMTNNMTQgMjFoMTRNMTQgMjJoMTRNMTQgMjNoMTNNMTQgMjRoMTNNMTQgMjVoMTJNMTUgMjZoMTBNMTYgMjdoOE0xNyAyOGg2TTE5IDI5aDMiIC8+CjxwYXRoIHN0cm9rZT0iI2NhZjUwMCIgZD0iTTE3IDFoMk0xMCAyaDJNMTggMmg0TTkgM2gzTTE4IDNoNU04IDRoM00xOSA0aDVNNyA1aDRNMTkgNWg2TTYgNmg1TTE5IDZoNE0yNSA2aDFNNSA3aDZNMTkgN2gzTTI2IDdoMU01IDhoNk0xOSA4aDNNMjYgOGgxTTQgOWg4TTE4IDloNE0yNiA5aDJNNCAxMGg4TTE4IDEwaDRNMjYgMTBoMk00IDExaDlNMTcgMTFoNU0yNiAxMWgyTTMgMTJoMjBNMjUgMTJoNE0zIDEzaDI2TTMgMTRoNU0xMCAxNGgxOU0zIDE1aDRNMTEgMTVoMThNMyAxNmgzTTEyIDE2aDE3TTMgMTdoM00xMiAxN2g3TTI1IDE3aDRNMyAxOGgzTTEyIDE4aDVNMjcgMThoMk0zIDE5aDRNMTEgMTloNU0yOCAxOWgxTTQgMjBoNE0xMCAyMGg1TTQgMjFoMTBNNCAyMmgxME01IDIzaDlNNSAyNGg5TTYgMjVoOE03IDI2aDhNOCAyN2g4TTkgMjhoOE0xMCAyOWg5TTEzIDMwaDYiIC8+Cjwvc3ZnPg==" /> */}
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          // zIndex:3,
          marginTop: '50px'
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
              backgroundColor: '#FF6899'
            }}/>
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
              backgroundColor: '#FF6899'
            }}/>
          </div>
          <div style={{
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between',
            alignItems: 'center',
            cursor: 'pointer',
            zIndex:10,
          }} > 
            <div style={{
              height: '30px',
              width: '30px',
              borderRadius: '15px',
              backgroundColor: '#FF6899'
            }}/>
          </div>
        </div>
      </div>
        <input 
          placeholder="Dragon Name"
          className="mt-8 border rounded p-4"
          onChange={e => updateFormInput({ ...formInput, name: e.target.value })}
        />
        {/* <input
          placeholder="Dragon Race"
          className="mt-8 border rounded p-4"
          onChange={e => updateFormInput({ ...formInput, description: e.target.value })}
        /> */}
        {/* <input
          placeholder="Asset Price in Eth"
          className="mt-2 border rounded p-4"
          onChange={e => updateFormInput({ ...formInput, price: e.target.value })}
        /> */}
        {/* <input
          type="file"
          name="Asset"
          className="my-4"
          onChange={onChange}
        /> */}
        {/* {
          fileUrl && (
            <img className="rounded mt-4" width="350" src={fileUrl} />
          )
        } */}
        <button onClick={createMarket} className="font-bold mt-4 bg-purple-500 text-white rounded p-4 shadow-lg">
          Create Digital Asset
        </button>
      </div>
    </div>
  )
}