require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

console.log(process.env.RINKEBY_URL);

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
  }
};