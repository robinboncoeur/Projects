# Markdown

<hr class="section-break strong" />







## Cheatsheet

... because I forget how to do shit.

Images:

```
![MyPic](/assets/images/pathtopic/picname.jpg)
```

Links to Pages:

```
[myPage](/path/to/myPage.md)
```

Example where the target page is in another folder:

```
[documented here](../family/index.md/#30-sep-2025)
```

Shortcut link example:

```
[Blog 25][b25]
```

...and at the bottom:

```
[b25]: ../visual/Blog25.md
```

<hr class="section-break strong" />








## Clickable Image Links

### Pure Markdown

Makes the image a link to itself and opens in a new tab:

```markdown
[![Alt text](../images/pic.jpg)](../images/pic.jpg){ target="_blank" rel="noopener" }
```

* Replace `../images/pic.jpg` with your path.
* `target="_blank"` opens a new tab; `rel="noopener"` is a good security add-on.
* Works for “thumbnail → full-size” too:

  ```markdown
  [![Alt text](../images/pic_thumb.jpg)](../images/pic_full.jpg){ target="_blank" rel="noopener" }
  ```

### Raw HTML

```text
<a href="../images/pic.jpg" target="_blank" rel="noopener">
  <img src="../images/pic.jpg" alt="Alt text" width="320" loading="lazy">
</a>
```

### Built-in zoom

**(no new tab)**

If you just want a zoom overlay instead of a new tab, Material supports:

```markdown
![Alt text](../images/pic.jpg){ data-zoomable }
```

Shout if you want me to sanity-check the relative path from a specific page.

<hr class="section-break strong" />





<!--  Image references  -->

--8<-- "includes/image-references.md"

🌷
