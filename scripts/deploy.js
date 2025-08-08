const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contract with account:", deployer.address);

  const Ecommerce = await hre.ethers.getContractFactory("Ecommerce");
  const ecommerce = await Ecommerce.deploy();

  await ecommerce.waitForDeployment();

  const contractAddress = await ecommerce.getAddress();
  console.log("Contract deployed to:", contractAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
