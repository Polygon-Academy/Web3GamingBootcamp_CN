describe("createNFTs", function() {
  it("Should create and execute market sales", async function() {
    const NFT = await hre.ethers.getContractFactory("NFT");
    const nft = await NFT.deploy();
    await nft.deployed();
    console.log("NFT(NFT.sol) has been deployed to:", nft.address);

    const MarketRecorder = await hre.ethers.getContractFactory("MarketRecorder");
    const marketRecorder = await MarketRecorder.deploy();
    await marketRecorder.deployed();
    console.log("MarketRecorder(MarketRecorder.sol) has been deployed to:", marketRecorder.address);

    let listingPrice = await marketRecorder.getListingPrice()
    listingPrice = listingPrice.toString()

    const auctionPrice_Grape = ethers.utils.parseUnits('2', 'wat')
    const auctionPrice_Strawberry = ethers.utils.parseUnits('5', 'wat')

    /* Red Grape */
    for (var i=1; i<2001; i++)
    { 
      await nft.createToken("https://www.redGrapelocation"+i+".com")
      await marketRecorder.createMarketItem(nftContractAddress, i, auctionPrice_Grape, { value: listingPrice })
      const [_, buyerAddress] = await ethers.getSigners()
      await marketRecorder.connect(buyerAddress).createMarketSale(nftContractAddress, i, { value: auctionPrice_Grape }) 
    }

    /*Green Grape */
    for (var i=2001; i<4001; i++)
    { 
      await nft.createToken("https://www.greenGrapelocation"+i+".com")
      await marketRecorder.createMarketItem(nftContractAddress, i, auctionPrice_Strawberry, { value: listingPrice })
      const [_, buyerAddress] = await ethers.getSigners()
      await marketRecorder.connect(buyerAddress).createMarketSale(nftContractAddress, i, { value: auctionPrice_Strawberry }) 
    }

    /* Red Strawberry */
    for (var i=4001; i<5001; i++)
    { 
      await nft.createToken("https://www.redStrawberrylocation"+i+".com")
      await marketRecorder.createMarketItem(nftContractAddress, i, auctionPrice_Strawberry, { value: listingPrice })
      const [_, buyerAddress] = await ethers.getSigners()
      await marketRecorder.connect(buyerAddress).createMarketSale(nftContractAddress, i, { value: auctionPrice_Strawberry }) 
    }

    /*Green Strawberry */
    for (var i=5001; i<6001; i++)
    { 
      await nft.createToken("https://www.greenStrawberrylocation"+i+".com")
      await marketRecorder.createMarketItem(nftContractAddress, i, auctionPrice_Grape, { value: listingPrice })
      const [_, buyerAddress] = await ethers.getSigners()
      await marketRecorder.connect(buyerAddress).createMarketSale(nftContractAddress, i, { value: auctionPrice_Grape }) 
    }

    items = await market.fetchMarketItems()
    items = await Promise.all(items.map(async i => {
      const tokenUri = await nft.tokenURI(i.tokenId)
      let item = {
        price: i.price.toString(),
        tokenId: i.tokenId.toString(),
        seller: i.seller,
        owner: i.owner,
        tokenUri
      }
      return item
    }))
    console.log('items: ', items)
  })
})
