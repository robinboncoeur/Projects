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
