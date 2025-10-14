# Browser Issues

## Background Colour

Got you, Robyn. YouTube’s theme can be stored per-account (server-side) or per-browser via cookies/local storage. If that storage gets blocked/cleared—or you’re switching Google profiles—it snaps back to light. Here’s a tight fix list that usually nails it:

1. Set it to “Dark” (not “Use device theme”)

* On YouTube, click your avatar → Appearance → pick Dark (explicitly).
* Refresh the page. If you switch Google accounts/channels, set it for each one.

2. Reset YouTube’s site data (cache isn’t enough)

* **Chrome**: YouTube tab → click the lock icon → Site settings → “Delete data”.
  Or Settings → Privacy & security → Site settings → “View permissions and data stored across sites” → search “youtube” → Remove.
* **Safari**: Settings → Privacy → Manage Website Data… → search “youtube” (and “google”) → Remove.

Then go back to YouTube and set Appearance → Dark again.

3. Make sure nothing auto-clears cookies/site data

* **Chrome**: Settings → Privacy & security → Cookies and other site data → ensure “Clear cookies and site data when you close all windows” is **off**.
  In “Customised behaviours”, add **[*.]youtube.com** and **[*.]google.com** to “Sites that can always use cookies”.
* If you use extensions (uBlock, Privacy Badger, Cookie AutoDelete, etc.), whitelist YouTube so it doesn’t wipe its storage.

4. Quick isolation test

* Open an **Incognito** (or Safari Private) window with **extensions disabled**. Sign into YouTube, set Dark.

  * If it sticks there, an extension or per-site cookie rule in your normal profile is the culprit.

5. Chrome flags (edge case)

* In the address bar: `chrome://flags` → search “Auto Dark Mode for Web Contents”. Set to **Default** or **Disabled** (conflicts can cause odd theme behaviour). Relaunch.

If it’s still reverting after those, tell me your browser (Chrome/Safari/Firefox) and whether you’re signed in or using multiple Google profiles—I’ll tailor exact clicks.

### YouTube Dark Theme Won’t Stick

!!! success "TL;DR"
    Set **Appearance → Dark** (not “Use device theme”), clear **YouTube site data**, and make sure nothing is auto-clearing cookies.

??? tip "Why this happens"
    YouTube stores theme per Google profile and in site storage. If cookies/local storage get wiped or you switch profiles, it reverts.

=== "Chrome"
- YouTube → avatar → **Appearance → Dark**
- URL bar lock → **Site settings → Delete data**
- Settings → Privacy & security → **Cookies** → ensure “Clear cookies on close” **Off**; whitelist `youtube.com`

=== "Safari"
- YouTube → avatar → **Appearance → Dark**
- Settings → **Privacy → Manage Website Data…** → remove `youtube.com` / `google.com`

=== "Firefox"
- YouTube → avatar → **Appearance → Dark**
- Settings → Privacy & Security → **Cookies and Site Data → Manage Data…** → remove `youtube.com`

??? bug "Still not sticking?"
- Try a Private/Incognito window with extensions disabled.  
- In Chrome, check `chrome://flags` → **Auto Dark Mode for Web Contents** = Default/Disabled.
  

<hr style="height:8px;border-width:0;color:green;background-color:green">

[Back to the Main Page](../index.md)

