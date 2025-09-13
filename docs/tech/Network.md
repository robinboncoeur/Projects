# Networking Essentials

## Everyday Home Network Checklist

[Thanks, Emily (ChatGPT)]

**2025:August — Windows 11** 🖥️

🌸 Here’s a neat **Everyday Home Network Checklist** you can keep handy — it’s the “dogs-body’s guide” to keeping Julias2025 and your PC friendly without having to wrestle Windows every time.

### 1. Confirm Discovery & Sharing

* **Settings → Network & Internet → Advanced network settings → Advanced sharing settings**

  * **Private network**: ON for *Network discovery* and *File and printer sharing*
  * **All networks**: *Password-protected sharing OFF* (since you’ve chosen the easy route)

✅ Do this once, stays set.

<hr style="height:4px;border-width:0;color:green;background-color:green">





### 2. Share a Folder Properly

* On the PC hosting files (e.g. Jules2025):

  1. Right-click folder → **Properties → Sharing → Advanced Sharing → Share this folder**.
  2. Give it a simple share name (no spaces, e.g. `SharedDocs`).
  3. Set **Permissions** → Everyone → Read (or Read/Write if needed).

<hr style="height:4px;border-width:0;color:green;background-color:green">






### 3. Access Shared Folders

* On your PC, open File Explorer → type in the bar:

  ```bash
  \\Julias2025\SharedDocs
  ```

  or (if names act up):

  ```bash
  \\192.168.x.x\SharedDocs
  ```

  *(replace with Julias2025’s actual IP, found via `ipconfig`)*

<hr style="height:4px;border-width:0;color:green;background-color:green">





### 4. Map it as a Drive (for convenience)

* In File Explorer:

  * Right-click **This PC** → **Map network drive…**
  * Choose a letter (say `Z:`).
  * Folder = `\\Julias2025\SharedDocs`.
  * Tick **Reconnect at sign-in**.

➡️ Now it’ll appear as a normal drive every time you log in.

<hr style="height:4px;border-width:0;color:green;background-color:green">





### 5. If It Breaks…

* **Check the basics first:** are both PCs awake, on the same Wi-Fi/LAN?
* **If prompted for credentials again:**

  * Go to *Control Panel → User Accounts → Credential Manager → Windows Credentials*
  * Delete any `Julias2025` entries.
  * Retry with `\\Julias2025\SharedDocs`.
* **If name lookup fails:** use the IP address.
* **If still stubborn:** run `net use * /delete` in Command Prompt to flush connections.

<hr style="height:4px;border-width:0;color:green;background-color:green">





### 6. Optional Safety

* If one day you want more control:

  * Turn *Password-protected sharing* back ON.
  * Create a simple local account (e.g. `ShareUser`) with its own password just for sharing.
  * Then use `Julias2025\ShareUser` when prompted.


<hr style="height:8px;border-width:0;color:green;background-color:green">









## Linux Pointers

### Quick Web Server

In Terminal:

```bash
    python3 -m http.server 7050
```

...where "7050" is an arbitrary port number.

<hr style="height:4px;border-width:0;color:green;background-color:green">






### Renewing IP Address

Often when you’re having Wi-Fi issues, this is because there are issues with your IP address, the set of numbers that identifies your location online. The reasons for this can be any of dozens, but thankfully the fix is always the same, namely resetting your IP address.

To do so, you first need to know your current IP address. You can do so using the following command:

```bash
  ip address
```

Alternatively, some Linux distros will allow you to do this within the desktop environment, check out our article on how to find your IP address in Ubuntu. Though it’s not necessary, you may want to take note of this IP address as after we’re done we need to check that it’s been changed.

Next, we need to request a new IP address through your DHCP server. We have a full explainer on what DHCP is, but the short version is that it’s a protocol that handles IP assignments. It usually does this on a daily basis, so your network gets a new IP every 24 hours. What we’re going to do is ask if we can renew it now.

To do so you need a program called dhclient, which is installed by default on Linux systems. Run it to find out what your system is running now, using the “verbose” command (-v) to make sure you get some output:

```bash
  sudo dhclient -v
```

This lets you know what IP was requested (DHCPREQUEST) and when it will expire, in my case 40157 seconds from now, which is about 11 hours. Now, we need to release the IP address, which means we ask dhclient to trash it. This is done with the -r command, and I recommend you add another “verbose” command to see what’s happening:

```bash
  sudo dhclient -v -r
```

With that done, now request a new IP address, with the same command as before:

```bash
  sudo dhclient
```

<hr style="height:4px;border-width:0;color:green;background-color:green">







### Resetting Network Settings

Sometimes renewing the IP address isn’t enough, though. The next thing you can try is to reset your network interface entirely in the hope that whatever setting is causing the issue is returned to its default state. To do so, we’re going to use a program called ip. This is a very powerful tool that lets you control networking on your device. We have a full guide on using the ip command, though for now we only need three commands.

The first is to show the interfaces present on your device. For that, type this:

```bash
  ip link show
```

You’ll get a list of interfaces. For most people it’s the second one (enp0s3 in my case), so let’s try resetting that first. To do so, you need to switch the interface off:

```bash
  sudo ip link set <interface_name> down
```

That turns it off, you can check with the “link show” command from earlier. Now you can turn the interface back on again:

```bash
  sudo ip link set <interface_name> up
```

<hr style="height:8px;border-width:0;color:green;background-color:green">


