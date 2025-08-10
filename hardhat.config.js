require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "0x382b3dfd43574dbcf38891c2d1bddb3f3c0acad554fd9cc68860e6ddde604e08",
        "0x8644d41057f3c0495c5551c748ecd1bec3876bed707d0c1e1096d39014a3168c"
      ],
    }
  }
};
