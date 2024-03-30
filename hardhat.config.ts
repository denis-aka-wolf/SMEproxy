import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { hardhatArguments, network } from "hardhat";
require('dotenv').config();

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.23",
        settings: {
          optimizer: {
            enabled: true,
            runs: 32000
          }
        }
      },
      {
        version: "0.8.24",
        settings: {
          optimizer: {
            enabled: true,
            runs: 3200
          }
        }
      },
    ],
  },
  networks: {
    hardhat: {
    },
    polygon: {
      url: "https://polygon.rpc.thirdweb.com/",
      chainId: 137,
      accounts: [vars.get("PK_BNB")]
    },
    sep: {
      url: "https://sepolia.infura.io/v3/",
      chainId: 11155111,
      accounts: [vars.get("PK_BNB")]
    },
    tabit: {
      url: "https://rpc.testnet.tabichain.com",
      chainId: 9789,
      accounts: [vars.get("PK_BNB")]
    },
    bnb:{
      url: "https://rpc.ankr.com/bsc",
      chainId: 56,
      accounts: [vars.get("PK_BNB")]
    }
  }
};

export default config;