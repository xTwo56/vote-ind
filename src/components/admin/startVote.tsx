"use client"

import { contractAtom } from "@/store/atoms"
import { useState } from "react"
import { useRecoilValue } from "recoil"

export function StartVote() {
  const contract = useRecoilValue(contractAtom)
  const [toggle, setToggle] = useState(false)
  return (
    <button onClick={votingToggle}>
      {!toggle ? "start" : "ongoing"}
    </button>
  )

  async function votingToggle() {
    const response = await contract?.startVoting(1, 1);
    console.log("response: " + response)
    setToggle(!toggle)
  }

}
