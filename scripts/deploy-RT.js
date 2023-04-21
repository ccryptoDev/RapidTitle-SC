const { ethers, upgrades } = require("hardhat");

async function main() {
  const ABCCoinInstance = await ethers.getContractFactory("RTT");
  const ABCCoinContract = await ABCCoinInstance.deploy();
  console.log("RT Contract is deployed to:", ABCCoinContract.address);
}

main();
