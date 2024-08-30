import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@xyrusworx/hardhat-solidity-json";
import "solidity-docgen";
import "./tasks/whitelist";
import "./tasks/deploy";
import "./tasks/e2e";
import "./tasks/functions";
import "./tasks/deployPrediction";

require("dotenv").config();

const adafelDevnet = [];
if (process.env.PRIVATE_KEY_ADAFEL) {
  adafelDevnet.push(process.env.PRIVATE_KEY_ADAFEL);
}
const localhostPrivateKeys = [];
if (process.env.PRIVATE_KEY_LOCALHOST) {
  localhostPrivateKeys.push(process.env.PRIVATE_KEY_LOCALHOST);
}

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true, // Enable the IR optimization to work around the "Stack too deep" error
    },
  },
  networks: {
    adafel: {
      chainId: 3995596960668836,
      url: "https://testnet-rpc.adafel.com",
      accounts: adafelDevnet,
    },
    hardhat: {
      chainId: 1337,
    },
    localhost: {
      chainId: 31337,
      url: "http://127.0.0.1:8545",
      accounts: localhostPrivateKeys,
    },
  },
};

export default config;
