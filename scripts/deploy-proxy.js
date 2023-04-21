const { ethers, upgrades } = require("hardhat");

async function main() {
  const InstanceV2 = await ethers.getContractFactory(
    "TransparentUpgradeableProxy"
  );
  const contract = await InstanceV2.deploy(
    "0x1C1e0b9Ac5C3687a007221B48286d4438483c8fC",
    "0x1Dd037cf671af4cd461CCf86100016CAAa5c5255",
    []
  );
  console.log("Box upgraded", contract.address);
}

main();
