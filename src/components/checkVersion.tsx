"use client"

import { contractAtom } from "@/store/atoms";
import { useState } from "react"
import { useRecoilValue } from "recoil";

export function CheckVersion() {

  const contract = useRecoilValue(contractAtom)
  const [version, setVersion] = useState<number | undefined>();
  return (
    <div>
      <button onClick={checkVersion}>check version</button>
      {!version ? "" : version}
    </div>
  )

  async function checkVersion() {
    const response = await contract?.checkVersion()
    console.log("response: " + Number(response))
    console.log("response: " + response)
    setVersion(Number(response))
  }
}
