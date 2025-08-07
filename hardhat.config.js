require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "0x253e1746bece4f6cf3a46d8f127d23aae7ad704302c2c51dba4f57b82aad77f2"
      ],
    }
  }
};
