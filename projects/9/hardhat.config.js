require("@nomiclabs/hardhat-waffle");
const fs = require('fs');
const privateKey = '56b9dce84f124bba55494c5fa8a0fad3023dd0753a70f23689767d729149ab2b';
// const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    // hardhat: {
    //   chainId: 31337,
    //   gas: 12000000,
    // },
    // buidlerevm: {
    //   gas: 12000000,
    //   blockGasLimit: 0x1fffffffffffff,
    //   allowUnlimitedContractSize: true,
    //   timeout: 1800000
    // }
    
    mumbai: {
      // Infura
      // url: `https://polygon-mumbai.infura.io/v3/${infuraId}`
      url: "https://matic.getblock.io/testnet/?api_key=f9b203bc-9daf-4ea7-8b3f-db5a1b69f83e",
      accounts: [privateKey],
      gas: 12000000,
    },
    // matic: {
    //   // Infura
    //   // url: `https://polygon-mainnet.infura.io/v3/${infuraId}`,
    //   url: "https://rpc-mainnet.maticvigil.com",
    //   accounts: [privateKey]
    // }
    
  },
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};

