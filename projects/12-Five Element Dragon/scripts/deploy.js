const hre = require("hardhat");
const fs = require('fs');

async function main() {
  const DragonAffinity = await hre.ethers.getContractFactory("DragonAffinity");
  const affinity = await DragonAffinity.deploy();
  await affinity.deployed();
  console.log("affinity deployed to:", affinity.address);

  const NFTMarket = await hre.ethers.getContractFactory("NFTMarket");
  const nftMarket = await NFTMarket.deploy();
  await nftMarket.deployed();
  console.log("nftMarket deployed to:", nftMarket.address);

  const NFT = await hre.ethers.getContractFactory("FiveElementalDragon", {
    libraries: {
      DragonAffinity: affinity.address,
    },
  });
  const nft = await NFT.deploy(nftMarket.address);
  await nft.deployed();
  console.log("nft deployed to:", nft.address);

  let config = `
  export const nftmarketaddress = "${nftMarket.address}"
  export const nftaddress = "${nft.address}"
  `

  let data = JSON.stringify(config)
  fs.writeFileSync('config.js', JSON.parse(data))

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
