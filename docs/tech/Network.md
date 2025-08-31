# Networking Essentials

---
title: Home Networking Checklist
description: Step-by-step guide to setting up and maintaining Windows 11 file sharing at home.
tags:
  - networking
  - windows11
  - home
last_updated: 2025-08-28
status: active   # active | needs-review | obsolete
author: Robyn Hahn
---


## 🖥️ Everyday Home Network Checklist

**Windows 11**

🌸 Here’s a neat **Everyday Home Network Checklist** you can keep handy — it’s the “dogs-body’s guide” to keeping Julias2025 and your PC friendly without having to wrestle Windows every time.

### 1. Confirm Discovery & Sharing

* **Settings → Network & Internet → Advanced network settings → Advanced sharing settings**

  * **Private network**: ON for *Network discovery* and *File and printer sharing*
  * **All networks**: *Password-protected sharing OFF* (since you’ve chosen the easy route)

✅ Do this once, stays set.

---

### 2. Share a Folder Properly

* On the PC hosting files (e.g. Jules2025):

  1. Right-click folder → **Properties → Sharing → Advanced Sharing → Share this folder**.
  2. Give it a simple share name (no spaces, e.g. `SharedDocs`).
  3. Set **Permissions** → Everyone → Read (or Read/Write if needed).

---

### 3. Access Shared Folders

* On your PC, open File Explorer → type in the bar:

  ```
  \\Jules2025\SharedDocs
  ```

  or (if names act up):

  ```
  \\192.168.x.x\SharedDocs
  ```

  *(replace with Jules2025’s actual IP, found via `ipconfig`)*

---

### 4. Map it as a Drive (for convenience)

* In File Explorer:

  * Right-click **This PC** → **Map network drive…**
  * Choose a letter (say `Z:`).
  * Folder = `\\Jules2025\SharedDocs`.
  * Tick **Reconnect at sign-in**.

➡️ Now it’ll appear as a normal drive every time you log in.

---

### 5. If It Breaks…

* **Check the basics first:** are both PCs awake, on the same Wi-Fi/LAN?
* **If prompted for credentials again:**

  * Go to *Control Panel → User Accounts → Credential Manager → Windows Credentials*
  * Delete any `Jules2025` entries.
  * Retry with `\\Jules2025\SharedDocs`.
* **If name lookup fails:** use the IP address.
* **If still stubborn:** run `net use * /delete` in Command Prompt to flush connections.

---

### 6. Optional Safety

* If one day you want more control:

  * Turn *Password-protected sharing* back ON.
  * Create a simple local account (e.g. `ShareUser`) with its own password just for sharing.
  * Then use `Jules2025\ShareUser` when prompted.

---

That’s it — with this, you’ll be able to get to your shared folders without headaches, and if Windows forgets itself (as it sometimes does), you’ll know exactly which knobs to reset.

---

Would you like me to **make this into a tidy one-page PDF “cheat sheet”** for you, so you can just keep it on your desktop for quick reference?
