# Managing My OSes

## Windows 11

### TPM2 vs CPU

**2025-09-12**  

Thanks to the looming Windows10 expiry date, I've had to update all our Windows PCs to 11. For some, thanks to them being of recent manufacture, this was reasonably trivial. TPM2.0 was already on the motherboard or in the CPU, so it was a matter of upgrading the OS.

In the case of one machine in particular, however, the issue with why it wouldn't accept the upgrade was a bit harder to nut out. I had ended up getting Julia a current-model CPU/motherboard (and even case) and installed Win 11 from scratch. Everything is on a terrabyte board-mounted SSD—no spinning disks, no 2.5 drives: just all on one drive.

Thought I'd have a look at her 'old' motherboard. It's a [Gigabyte GA-A320M-S2H](https://www.gigabyte.com/Motherboard/GA-A320M-S2H-rev-1x#kf)—(AMD processors). As you can see, no mention of a TPM slot. However, when I examined the board itself, lo and behold: a TPM pinout! WTF? Well, I thought, "cool, I'll go ahead and upgrade this to Win 11 and flog it." Win 10 installed no dramas at all. Win 11? Nope. Tried the [Windows 11 workaround](https://www.youtube.com/watch?v=Yd3isXSBTUs) and it still would work!

So, I figured out the reason. Finally. I think. I **hope**! The CPU is not supported: it needs to be a series 2000 AMD processor or newer. So, I've ordered a R5-2600 Processor 6 Cores 3.4GHz Base 3.9GHz Turbo 19MB Cache AM4 Socket CPU from Alibaba for AUD$40. Worth a try, anyway.

<hr style="height:8px;border-width:0;color:green;background-color:green">














## Linux

### Internet-Facing Server

[Q]  
Hi Emily. For this project I need you to put your Linux tech support hat on. Please think hard about your answers: I need them to be as accurate and detailed as possible. I want to create an internet-facing server. The OS needs to be a 'headless' hardened Linux-based server, preferably Debian-based as I am more familiar with APT than YUM. My challenges include: I connect to the internet using a Telstra FTTP Broadband account... I am not certain that Telstra supports internet-facing servers, hardened or otherwise. I see this as my initial hurtle. The next would be setting up the server, and making sure it is completely separate from all other internet connections. I would like to tackle these challenges first before embarking on anything further.

Hi Robyn—Linux hat on. Let’s tackle the two big hurdles first: (1) whether Telstra FTTP will even let you run an internet-facing box, and (2) how to keep that server totally separate from the rest of your network.

#### 1) Can you run an internet-facing server on Telstra FTTP?

**Short answer: yes, with options.**

* **Public IP / Static IP:** Telstra now offers a *static IPv4* add-on for home NBN/OptiComm for \~\$10/month, which is ideal for hosting. You add it yourself in My Telstra. ([Telstra.com][1])
* **Port forwarding:** Telstra documents port-forwarding on its modems, which implies inbound connections are supported. ([Telstra.com][2])
* **CGNAT:** On *fixed-line* NBN, Telstra typically does **not** put you behind CGNAT (their *mobile* network is CGNAT). A Whirlpool mod confirms this common split. If you ever do encounter CGNAT, there are clean workarounds (below). ([Whirlpool.net.au][3])

**Feasibility checklist (10 minutes):**

1. From any device on your Telstra link:
   `curl -4 ifconfig.co` and note the IP. Then check your router’s **WAN** IP. If they match (and it’s not RFC1918/100.64.0.0/10), you’re not behind CGNAT.
2. If you don’t want to rely on Dynamic DNS, enable Telstra’s **Static IP** add-on. ([Telstra.com][1])
3. Temporary inbound test: on your server `python3 -m http.server 8080`, create a port-forward 8080→server, then hit `http://<your-public-ip>:8080` from your phone on 4G. If it loads, you’re green.

> **Email hosting caution:** Even if port 25 isn’t filtered, deliverability is painful from residential IPs. Use a relay (Mailgun, Postmark, SES) and don’t expose 25/587 publicly unless you really must.

#### 2) Keep the server *completely separate* from everything else

You’ve got three robust patterns; pick one based on budget and risk tolerance:

- A) **Physical isolation (best): second NBN service on another UNI-D port**

Order a **second** NBN service (can be Telstra or another ISP) on UNI-D 2/3/4 of the NBN FTTP NTD. Put a dedicated firewall + server behind it; nothing touches your home LAN. Telstra’s own guide notes that multiple UNI-D ports can be active. ([Telstra.com][4])

**Sketch:**  
ONT(UNI-D1) → Home router/LAN  
ONT(UNI-D2) → Firewall #2 → Hardened server (public site)  

Pros: Total blast-radius separation, clean IP reputation, simple mental model.  
Cons: A second monthly service.

- B) **Single service, *logical* isolation with VLAN/DMZ**

Keep your existing Telstra NBN service but introduce a proper firewall (OPNsense/pfSense/MikroTik) or a Linux router with `nftables`.

* Create **VLAN 10 = LAN**, **VLAN 20 = DMZ** (server).
* **Default deny** DMZ→LAN; allow only DMZ→Internet and *your admin IP* → server SSH.
* Port-forward only 80/443 to the DMZ host.
  Pros: One service, low cost.
  Cons: Slightly more complex to get right; mistakes can bridge networks.

- C) **No inbound ports at all: Cloudflare Tunnel or Tailscale Funnel**

Your server dials **out** to the provider; they terminate TLS and route traffic back to you. Great if CGNAT ever appears or you don’t want to expose your home IP.

* **Cloudflare Tunnel (cloudflared):** free, handles certs, DDoS, WAF; map `site.example.com` → local `127.0.0.1:8080`. ([eddiez.me][5])
* **Tailscale Funnel:** expose a local HTTP/TCP service publicly over HTTPS, toggleable per service. ([tailscale.com][6])
  Pros: No NAT/port-forwarding, hides your IP, easy TLS.
  Cons: You depend on a third-party edge; some self-hosters prefer direct control.

---

#### 3) Headless, hardened **Debian 12** (APT-friendly) baseline

Use this once you’ve picked A/B/C.

**Install & users**

* Minimal install, **OpenSSH server**, no desktop.
* Create admin user, `sudo` only; leave root password blank or lock it: `sudo passwd -l root`.

**SSH hardening (`/etc/ssh/sshd_config`)**

```bash
Port 22
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
AllowUsers <youruser>
```

Then: `sudo systemctl reload ssh`.

**Firewall (UFW over nftables)**

```bash
sudo apt update && sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
# If you’ll admin over Tailscale (recommended):
# sudo ufw allow in on tailscale0 to any port 22 proto tcp
# Otherwise, from your static admin IP only:
# sudo ufw allow from <your-admin-ip>/32 to any port 22 proto tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

**Auto-patching & basics**

```bash
sudo apt install unattended-upgrades fail2ban needrestart chrony apparmor apparmor-utils
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

* `fail2ban` with the stock `sshd` jail is fine to start.
* Keep **AppArmor** enforcing; avoid random “disable apparmor” blog advice.

**Optional but excellent**

* **Tailscale** for admin: lock SSH to `tailscale0` only.
* **Caddy** or **Nginx** as reverse proxy. If you’re not using Cloudflare Tunnel/Tailscale Funnel, let Caddy handle Let’s Encrypt automatically.
* **Backups:** `restic` to Backblaze B2/Object Storage; test restores quarterly.
* **Monitoring:** `uptime-kuma` or just a remote `systemd` watchdog + `logwatch`.

**IPv6**
If Telstra assigns IPv6, be sure your firewall has **matching v6 rules** (UFW handles both if you `set ipv6=yes`). If you don’t want IPv6 exposure yet, disable it server-side until you’re ready.

---

#### 4) A concrete “first week” plan

**Day 1–2: feasibility & isolation choice**

1. Run the **public IP/CGNAT** test above.
2. Decide: **A (second UNI-D)**, **B (VLAN/DMZ)**, or **C (Tunnel)**.
3. If hosting directly, enable **Static IP** in My Telstra. ([Telstra.com][1])

**Day 3–4: network build**

* **A:** Order second service on UNI-D2; plug a small firewall (OPNsense box) → server. ([Telstra.com][4])
* **B:** Introduce firewall, create VLANs, move server into DMZ; set strict rules.
* **C:** Install **cloudflared** or **tailscale**; create the tunnel/funnel mapping. ([eddiez.me][5])

**Day 5–7: server hardening & smoke tests**

* Install Debian 12 headless; apply SSH/UFW/fail2ban/unattended-upgrades.
* Reverse proxy + TLS (Caddy), or rely on Tunnel/Funnel TLS.
* Probe from outside: `curl -I https://your-domain/` on mobile data; watch logs; load test lightly.

---

#### Quick answers to your initial concerns

**“Does Telstra allow it?”** There’s no current Telstra doc forbidding self-hosting, and they actively document port-forwarding and sell a Static IP add-on for NBN—both are signs they expect inbound hosting use-cases.  
**“Full separation from my other internet connections?”** The cleanest path is **a second service on another UNI-D port** (true physical separation). Logical isolation with VLAN/DMZ is also strong if done carefully.   **“What if CGNAT pops up?”** Use **Cloudflare Tunnel** or **Tailscale Funnel**—no inbound ports, public HTTPS, and you keep your home IP private.  

If you want, I can sketch a DMZ ruleset (OPNsense or plain `nftables`) and a minimal Caddy reverse-proxy config for Debian next.

<hr style="height:4px;border-width:0;color:green;background-color:green">











### Grub-Customising

**Updated: 2024-01-21**

Dual-boot systems use GRUB to allow booting to one OS or another. Grub-customizer by [Daniel Richter](https://launchpad.net/~danielrichter2007/+archive/ubuntu/grub-customizer) is quite nice but somehow doesn't work for me. So, to get GRUB2 to look decent, we need to first address /etc/default/grub - I've removed all the commented-out stuff so just the really important stuff remains:

```bash
    GRUB_DEFAULT=0
    GRUB_TIMEOUT_STYLE=hidden
    GRUB_TIMEOUT=15
    GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
    GRUB_CMDLINE_LINUX=""

    GRUB_GFXMODE=1920x1080
    GRUB_FONT=/boot/grub/fonts/unifont.pf2
```

Key points to look at are the resolution - in this case 1920x1080 - and font, which lives in /boot/grub/fonts. So:

- change the resolution to read: **GRUB_GFXMODE=1920x1080**
- add the line: **GRUB_FONT=/boot/grub/fonts/unifont.pf2**

...ensuring, of course, that the file and path actually exist.

The next thing to look at is look in the /etc/default/grub.d folder, which will hopefully contain the following files, or something similar:

- 50_linuxmint.cfg
- 63_mint-theme-2k.cfg

In this case, the 63x file held the key to which theme is used by GRUB. If none of that sort of file exist, you might need to go to the Software Manager and load an alternate theme to the default, such as Grub2-theme-mint. Invoke:

```bash
    sudo update-grub
```

 and the missing files should appear. In that file (or one similar to it) are a two lines of interest:
 
- GRUB_FONT="/boot/grub/fonts/UbuntuMono32.pf2"
- GRUB_THEME="/boot/grub/themes/creek/theme.txt"
 
The second line will tell **update-grub** where to find the theme. Save your changes and nvoke:

```bash
    sudo update-grub
```

and you should be good.

[WHV5M3XPNX]

<hr style="height:4px;border-width:0;color:green;background-color:green">





### Updating PATH

In Ubuntu, edit /etc/environment. Its sole purpose is to store Environment Variables. Originally the $PATH variable is defined here. This is a paste from my /etc/environment file:

- PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

So you can just open up this file as root and add whatever you want.

For **immediate** results, Run (try as normal user and root):

```bash
    source /etc/environment && export PATH
```

<hr style="height:8px;border-width:0;color:green;background-color:green">
