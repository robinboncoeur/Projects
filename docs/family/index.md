# Family Projects 

## Pappa's Account

### Foreword

This is, for the time being, a living document. As such, it will change pretty much *daily* as the process continues.

The idea of having these pages worked on in the image order simply makes sense... for now. Once all images have been converted to text and the text translated, then the next step - organising the document in some sort of chronological order - will be much easier.

For my part, I will work on transcribing the words on the images - handwritten and typed - into this document as accurately as I can. The chapter headings will be the names of the original image files - e.g., 'P8.png'. I've attached a .jpg version at the bottom of each section: simply right-click and select "Open Image in a New Tab" to see the full-sized version.

I would suggest keeping Dad's account as written in **German** as part of the book for future reference.

<hr style="height:4px;border-width:0;color:black;background-color:black">






### Project Notes

**[ 4 Jul 2025 ]**  
At this stage, the image order doesn't appear to correlate to any sort of order, certainly not what I would assume the original order of Pappa's document would have been. I will therefore take the following approach to translating this document: 

1. transcription / translation, saved to this page (a rough draught, as it were)
2. re-order / organise / edit for context - this will be a collaborative effort

Outlined here are the steps I'm taking:

* adjust image brightness / contrast of the imagescontaining the text in GIMP to try to improve legibility
* type in the words into PhoenixCode, a plain-text document processor
* read the sentence out loud, and adjust based on what it sounds like (e.g., changed 'lieben' to 'lieber')
* "build" the document using [ **cd /Users/me/Sites/projects && mkdocs serve** ]
* copy the 'family' folder to www.tightbytes.com

Additional steps will include:

* bring up the site on my desktop
* copy the German text into the Gradio interface for text-generation-webui, running the Gemmas3 large language model
* Gemma3: do a German-language spelling and grammar check
* Gemma3: translate from German into English
* review the result, adjust for context

We will have to subsequently realign the document pages into some sort of logical order. This will require a collaborative effort.

<hr style="height:4px;border-width:0;color:black;background-color:black">






### Issues & Notes

#### 5 Jul 2025

Some images are over-exposed through the scanning process. The bright light of the scanner makes both sides of the page visible in the resulting .png image: this undermines legibility. Also, the typed documents (P1.png through P3.png) were not centred properly when they were scanned and so portions of words are missing.

---

#### 6 Jul 2025

* Trying to get the text entered - doing grammar/spelling-check and translation after the bulk of what **can** be done, done.  
* Case in point: **P12.png** cannot be read at all. It will need to be photographed, not scanned. Both sides show up on one surface (both sides are visible in the image). Together with Dad's unclear handwriting, the document is too difficult to decipher.  
* The first images (P1, P2, P3 and P3plus) are all typed. However, the scan was not well-centred and cut off words on the right margin. Below, I have noted which words appear to be cut off with "-[cut-off word]".  
* Issues with P14 and P14plus, cut-off words and scanned text hard to make out. Needs to be photographed, and centred properly.

---

#### 7 Jul 2025   

Tried a translation of **P1.png** using the Gemma3 LLM. I've surrounded the document with my observations of the process. I'm going to leave those notes as an example of what's involved in translating - well, a rather small example, to be honest. We really need to collaborate on context and intent. I've underlined words that raised questions:

* 'operation' vs 'activities'
* 'upright' vs 'as straight as possible'
* the phrase 'didn't have the right weight yet' vs 'didn't weigh enough'

The sentence: 'Ein Urbaier in Lederhosen, seine Frau – in wir Jungens sofort alle verliebten – kam jeden Sonntag mit.' should probably read: 'He was a typical Bavarian in lederhosen: his wife – who we boys immediately fell in love with – accompanied him every Sunday."

At least Gemma tries to explain her reasoning, which is a step up from the hallucinations of LLMs such as older versions of ChatGPT or even DeepSeek-v1, which also 'explained' its thought-process, however erroneous it turned out to be.

---

#### 8 Jul 2025

I've decided the image downloads would be quicker - and the page would *'weigh'* less if I converted the .pngs to .jpgs. I'll put the originals in a 'Origs' subfolder in case someone wants to see the original scanned image.  

- Page 17 (P17.png) seems to be a fragment.

- Pages 22 and 22plus need to be photographed (vs scanned): enhancing the text brings out the text from the other side of the page, making it impossible to read.

- Pages 35 through 46 appear at first blush to be private correspondence between Dad and Mom... not sure how appropriate it would be to enter this private stuff. Even the stuff on P31 is a bit... iffy.  
I'm going to start with running some of these entries through Gemma3 after reviewing them again. I've taken to surrounding words I'm not sure about with square brackets: '[ ]'. I've also replaced most of the .pngs with .jpgs for faster load times.

---

#### 30 Sep 2025

US $66.20 to ship this little document! WTF? That's extortionary. Is that UPS wanker still running USPS?

My Panasonic Lumix G5 is "cactus" (won't focus, will need to be repaired) so I'll be doing the photography with my phone, which is more than up to the job. Here's the project as I see it ...

Stage 1: photos of the pages.  
Stage 2: transcription.  
Stage 3: translation.  
Stage 4: Collaborative analysis and text tweaking before we ...  
Stage 5: organise pages chronologically (as best we can) and insert the text into a book. My vote is to put the original German and the translation side by side, in columns.

To be understood: stages 3 and 4 will be a process in a bit of a loop, and this is where I will need input from "the willing". The idea is to do these memoirs justice. That will remain a key objective.

#### 1 Oct 2025

In receipt of the physical documents. I have begun restructuring the translation page to reflect chronology vs image sequence. Some of the chronology of events we will have to determine contextually: we probably won't know exact dates for certain entries.

---

#### 2 Oct 2025

Observations on [1940 Flieger](/family/pappa1.md/#1940-flieger) follow.

Here is why I don't worry that AI is going to take over our world by being smarter than us and outwitting us. Consider the following discourse. For example: the last sentence of the original document included the word 'Urbaier', which breaks down to 'Ur' = 'typical'; and 'Baier' = 'person from Bayern (Bavaria)'. Gemma incorrectly translated this to 'Urlauber' = 'tourist'. A key takeaway is that one cannot simply assume LLMs are going to correctly interpret the sense of a phrase. My discussion with Gemma3 continued thus as I requested 'her' to translate into English:  

**Me:** 'Urbaier' is a colloquial term for 'typical Baier'... person from Bavaria. Other than that, well done, thank you. Can you please translation this into English?   
**Gemma3:** You're absolutely right about "Urbaier"! My apologies for the misinterpretation – it's a regional colloquialism that doesn't translate directly. Thanks for clarifying. Here's the English translation of the corrected German text, incorporating that understanding of "Urbaier":  
**Gemma3:** Notes on the Translation: I've translated "Urbaier" as "typical Bavarian tourist" to convey the intended meaning. I’ve tried to maintain the slightly informal and conversational tone of the original German.  

**Me: Fail.** Nice try, though, Gemma.  

By the way, I've rendered the translation a bit less awkward. Like: "A signature was cheap as a gift." ...to... "A signature was a cheap gift."
  
So no, AI isn't going to replace us any time soon. If ever.

BTW, that exchange between him and his dad over the waiver revealed where Dad got his sarcasm from.

---

#### 3 Oct 2025

Did a bit of shuffling based on date and even more: context. So, moved 2 entries into 1939, and also 1940. Just did a quick translation... needs to be read more carefully for accuracy.

---

Took out this bit from [1946: Herbst](/family/pappa1.md/#1946-herbst):

*Faithful translation An autumn of hunger. O dear reader, do you know what hunger is? My Hunger is written with a capital letter. It pulls through your guts. Yes, hunger hurts. It is a pain very close to your soul.  

“Give us this day our daily bread.” There isn’t even a single crust. In the morning you get up and first have to sit on the edge of the bed. It goes black before your eyes and it takes a while before you can stand. The shirt sticks to your body. From the nights you’ve sweated. Whoever has ever eaten his bread with tears, whoever sat weeping through sorrowful nights on his bed—he does not know you, you heavenly powers.  

Yes, those were the good old days. They still had bread. What remained to us were only tears and this accursed hunger. K. had already been waiting ten minutes for his friend Fritz. It was two o’clock at night. Both worked a forty-eight-hour week. With what they earned the two of them couldn’t buy the food they needed. So at night they had to steal what they simply lacked for ordinary nourishment.*

Keeping the literary version, for now. Now that I have the actual hard copy, will try to nut out what [Rute?] is. 

*Translator’s note: the quoted lines echo Goethe’s famous verse (“Wer nie sein Brot mit Tränen aß …”), though here it’s recalled imperfectly. If you’d like, I can normalise the quotation or keep it as-is for authenticity.*

"Köter" is a perjorative word for a dog: similar to the English "mutt" or "cur", dog of mixed breed.

---

#### 28 Sep 2025

Did a fair bit of translating today:

[1945: Dortmund](/family/pappa1.md/#1945-dortmund)  
[1946: Herbst](/family/pappa1.md/#1946-herbst)  

---

#### 30 Sep 2025

Got a lot of translating done:

[1924: Meine Eltern](/family/pappa1.md/#1924-meine-eltern)  
[1924: Das Haus Cojas](/family/pappa1.md/#1924-das-haus-cojas)  
[1939: Installateur](/family/pappa1.md/#1939-installateur)  
[1939: Erbgut](/family/pappa1.md/#1939-erbgut)  
[1941: Der Letzte](/family/pappa1.md/#1941-der-letxte)
[1945: Das Fieber](/family/pappa1.md/#1945-das-fieber)  
[1945: Nicht Aufgeben](/family/pappa1.md/#1945-nur-nicht-aufgeben)  
[1945: Flucht](/family/pappa1.md/#1945-flucht)  
[1945: Nach West](/family/pappa1.md/#1945-weg-nach-west)  

---

#### 10 Oct 2025

Did a bit more:

[1945: Gefangenschaft](/family/pappa1.md/#1945-gefangenschaft)  
[1945: Flug Zum Osten](/family/pappa1.md/#1945-flug-zum-osten)  

Waiting for input from either Jess or Martin or both on the work done on Sept 28, 30 and Oct 10. Trying different approaches to photography of the pages: no obvious options present themselves. Updated links on the index page to all initial translation pages.

Done:  
- Stubbed in Status / Mods / Comments template for each note  
- Converted all page photos to clickable links, which will open in a new tab automatically  
- Instead of a meaningless green tick, will get a consensus from all whether or not a page is ready for canon  
- Have commenced moving pages where they seem to fit chronologically.

Plan:  
- Going to a stationery shop to pick up a "display book" to house the original document pages.







<hr style="height:8px;border-width:0;color:black;background-color:black">

[Back to the Main Page](../index.md)
