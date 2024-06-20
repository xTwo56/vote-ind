
import { ethers, upgrades } from "hardhat"

async function main() {
  const EVM = await ethers.getContractFactory("EVM");
  const proxy = await upgrades.deployProxy(EVM);

  await proxy.waitForDeployment();

  const proxyAddress = await proxy.getAddress()
  const implementationAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress)

  console.log("proxyAddress: " + proxyAddress);
  console.log("implementationAddress: " + implementationAddress);

}
main()
