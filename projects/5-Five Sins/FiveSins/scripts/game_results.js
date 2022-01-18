import { ethers } from 'ethers'
import { winnerAddress, loserAddress } from '../gameScorer'
import {
  nftmarketaddress, nftaddress
} from '../config'

import MarketRecorder from '../artifacts/contracts/MarketRecorder.sol/MarketRecorder.json'
import Scorer from '../artifacts/contracts/Scorer.sol/Scorer.json'


export default function SettlementGame() {
  const provider = new ethers.providers.Web3Provider(connection)
  const signer = provider.getSigner()
  const marketContract = new ethers.Contract(nftmarketaddress, MarketRecorder.abi, signer)
  const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
  const items_loser = await marketContract.connect(loserAddress).fetchMyNFTs

  for (var i=0; i<items_loser.length; i++)
    { 
      await scorer.connect(loserAddress).froozen(items_loser.itemId)
    }
  
  await scorer.connect(winnerAddress).transferToken(tokenContract)
  await scorer.connect(loserAddress).transferToken(tokenContract)

}