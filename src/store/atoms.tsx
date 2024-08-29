import { Contract, Provider, Signer } from "ethers"
import { atom } from "recoil"

export const contractAtom = atom<Contract | null>({
  key: "contractAtom",
  default: null
})

export const providerAtom = atom<Provider | Signer | null>({
  key: "providerAtom",
  default: null
})
