require("dotenv").config()
import { ethers, upgrades } from "hardhat"

const proxyAddress = process.env.PROXY_ADDRESS;
async function main() {

  const EVMv2 = await ethers.getContractFactory("EVMv2")
  const evmV2 = await upgrades.upgradeProxy(proxyAddress, EVMv2)
  console.log(evmV2);

  const v2address = await evmV2.getAddress()

  console.log("evmV2 address: " + v2address)

}
main()
