import { Contract } from "ethers"
import { atom } from "recoil"

export const contractAtom = atom<Contract | null>({
  key: "contractAtom",
  default: null
})
