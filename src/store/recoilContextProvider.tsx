"use client"

import { RecoilRoot } from "recoil"
import React, { ReactNode } from "react"

export default function RecoilContextProvider({ children }: { children: ReactNode }) {
  return (
    <RecoilRoot>
      {children}
    </RecoilRoot>

  )
}
