require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "0x9462fd50626fcbfa5ca62d6406a50f58b49a5086ac298d320c116a0c6fd6b426"
      ],
    }
  }
};
