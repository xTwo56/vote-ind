require("dotenv").config()
import { ethers } from "hardhat";
import evmMetadata from "../artifacts/contracts/evm.sol/EVM.json"
const evmAbi = evmMetadata.abi;
const proxyAddress = process.env.PROXY_ADDRESS;

async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545")
  const signer = await provider.getSigner();
  const evmContract = new ethers.Contract(proxyAddress, evmAbi, signer)

  const totalvotes = await evmContract.getTotalVotes()

  console.log("totalvotes: " + totalvotes)
}
main()
