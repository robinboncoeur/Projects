# Linux Tips


## Networking Pointers

### Quick Web Server

In Terminal:

```bash
    python3 -m http.server 7050
```

...where "7050" is an arbitrary port number.

<hr style="height:2px;border-width:0;color:gray;background-color:gray">




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

<hr style="height:2px;border-width:0;color:gray;background-color:gray">





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

<hr style="height:2px;border-width:0;color:gray;background-color:gray">




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

<hr style="height:2px;border-width:0;color:gray;background-color:gray">



### Updating PATH

In Ubuntu, edit /etc/environment. Its sole purpose is to store Environment Variables. Originally the $PATH variable is defined here. This is a paste from my /etc/environment file:

- PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

So you can just open up this file as root and add whatever you want.

For **immediate** results, Run (try as normal user and root):

```bash
    source /etc/environment && export PATH
```

<hr style="height:2px;border-width:0;color:gray;background-color:gray">
