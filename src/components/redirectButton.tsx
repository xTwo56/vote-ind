"use client"

import { useRouter } from "next/navigation"

export function RedirectButton() {
  const router = useRouter()

  return (
    <button className="m-2 p-2 bg-green-200 rounded-xl hover:bg-green-300"
      onClick={() => {
        router.push("/auth/user/signup")
      }}> signup </button>
  )
}
