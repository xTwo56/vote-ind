"use client"

import { contractAtom } from "@/store/atoms/contractAtom"
import { useRecoilState } from "recoil"

export default function Signup() {

  const setContract = useRecoilState(contractAtom)
  console.log(setContract)
  return (
    <div>
      <input placeholder="aadharId" type="text" />
    </div>
  )
}
