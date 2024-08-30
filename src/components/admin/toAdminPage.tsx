"use client"

import { useRouter } from "next/navigation"

export function ToAdminPage() {

  const router = useRouter()
  return (
    <button onClick={adminpageNavigator}>to admin page</button>
  )

  function adminpageNavigator() {
    router.push("/admin")
  }
}
