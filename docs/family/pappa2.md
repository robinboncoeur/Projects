# Translation Notes


## Start of Project

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

<hr style="height:8px;border-width:0;color:navy;background-color:purple">






## 05 Jul 2025

Some images are over-exposed through the scanning process. The bright light of the scanner makes both sides of the page visible in the resulting .png image: this undermines legibility. Also, the typed documents (P1.png through P3.png) were not centred properly when they were scanned and so portions of words are missing.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 06 Jul 2025

* Trying to get the text entered - doing grammar/spelling-check and translation after the bulk of what **can** be done, done.  
* Case in point: **P12.png** cannot be read at all. It will need to be photographed, not scanned. Both sides show up on one surface (both sides are visible in the image). Together with Dad's unclear handwriting, the document is too difficult to decipher.  
* The first images (P1, P2, P3 and P3plus) are all typed. However, the scan was not well-centred and cut off words on the right margin. Below, I have noted which words appear to be cut off with "-[cut-off word]".  
* Issues with P14 and P14plus, cut-off words and scanned text hard to make out. Needs to be photographed, and centred properly.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 07 Jul 2025   

Tried a translation of **P1.png** using the Gemma3 LLM. I've surrounded the document with my observations of the process. I'm going to leave those notes as an example of what's involved in translating - well, a rather small example, to be honest. We really need to collaborate on context and intent. I've underlined words that raised questions:

* 'operation' vs 'activities'
* 'upright' vs 'as straight as possible'
* the phrase 'didn't have the right weight yet' vs 'didn't weigh enough'

The sentence: 'Ein Urbaier in Lederhosen, seine Frau – in wir Jungens sofort alle verliebten – kam jeden Sonntag mit.' should probably read: 'He was a typical Bavarian in lederhosen: his wife – who we boys immediately fell in love with – accompanied him every Sunday."

At least Gemma tries to explain her reasoning, which is a step up from the hallucinations of LLMs such as older versions of ChatGPT or even DeepSeek-v1, which also 'explained' its thought-process, however erroneous it turned out to be.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 08 Jul 2025

I've decided the image downloads would be quicker - and the page would *'weigh'* less if I converted the .pngs to .jpgs. I'll put the originals in a 'Origs' subfolder in case someone wants to see the original scanned image.  

- Page 17 (P17.png) seems to be a fragment.

- Pages 22 and 22plus need to be photographed (vs scanned): enhancing the text brings out the text from the other side of the page, making it impossible to read.

- Pages 35 through 46 appear at first blush to be private correspondence between Dad and Mom... not sure how appropriate it would be to enter this private stuff. Even the stuff on P31 is a bit... iffy.  
I'm going to start with running some of these entries through Gemma3 after reviewing them again. I've taken to surrounding words I'm not sure about with square brackets: '[ ]'. I've also replaced most of the .pngs with .jpgs for faster load times.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 28 Sep 2025

Did a fair bit of translating today:

[1945: Dortmund](/family/pappa1.md/#1945-dortmund)  
[1946: Herbst](/family/pappa1.md/#1946-herbst)  

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 30 Sep 2025

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


US $66.20 to ship this little document! WTF? That's extortionary. Is that UPS wanker still running USPS?

My Panasonic Lumix G5 is "cactus" (won't focus, will need to be repaired) so I'll be doing the photography with my phone, which is more than up to the job. Here's the project as I see it ...

Stage 1: photos of the pages.  
Stage 2: transcription.  
Stage 3: translation.  
Stage 4: Collaborative analysis and text tweaking before we ...  
Stage 5: organise pages chronologically (as best we can) and insert the text into a book. My vote is to put the original German and the translation side by side, in columns.

To be understood: stages 3 and 4 will be a process in a bit of a loop, and this is where I will need input from "the willing". The idea is to do these memoirs justice. That will remain a key objective.


### Gemma's Version

*= Gemma3: Grammar Revision =*  Zum Kurtchens 15. Geburtstag hatte er nur einen Wunsch von seinem Vater: die Verzichtserklärung zu unterschreiben. Das war ein Dokument, das besagte, daß im Falle eines Unglücksfalls der Staat nicht für den Schaden aufkommen würde. Sein Vater schaute ihm ungläubig an.  
"Was, fliegen willst du lernen? Erst mal richtig laufen!"  
Eine Unterschrift war billig als Geschenk. Vater dachte, das wäre mal nur so eine fixe Idee seines Sohnes. Endlich durfte Kurtchen am Flugbetrieb teilnehmen. Das war aber auch so ziemlich alles.  
Jeden Sonntag traf sich eine Gruppe junger Leute in Weißenfels am sogenannten Idiotenhügel.  
Der Flugapparat, mit dem sich die Jungen den ganzen Tag abmühten, war eine Grunau 9. Das Ding flog tatsächlich. Kurtchen strengte sich zwar an, stets senkrecht zu stehen, nur wurde er immer übersehen. Er war eben zu klein und hatte noch nicht das richtige Gewicht.  
Im nächsten Frühjahr bekamen sie einen neuen Fluglehrer. In der Mittagspause fragte er, wer von euch ist der 'Hahn Kurt'? Dieser Herr Münch war ein Arbeitskollege meines Vaters in den Leunawerken. Ein "Urlauber" in Lederhosen, seine Frau – in wir Jungens sofort alle verliebten – kam jeden Sonntag mit.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">








## 01 Oct 2025

In receipt of the physical documents. I have begun restructuring the translation page to reflect chronology vs image sequence. Some of the chronology of events we will have to determine contextually: we probably won't know exact dates for certain entries.

<hr style="height:2px;border-width:0;color:blue;background-color:blue">








## 02 Oct 2025

Observations on [1940 Flieger](/family/pappa1.md/#1940-flieger) follow.

Here is why I don't worry that AI is going to take over our world by being smarter than us and outwitting us. Consider the following discourse. For example: the last sentence of the original document included the word 'Urbaier', which breaks down to 'Ur' = 'typical'; and 'Baier' = 'person from Bayern (Bavaria)'. Gemma incorrectly translated this to 'Urlauber' = 'tourist'. A key takeaway is that one cannot simply assume LLMs are going to correctly interpret the sense of a phrase. My discussion with Gemma3 continued thus as I requested 'her' to translate into English:  

**Me:** 'Urbaier' is a colloquial term for 'typical Baier'... person from Bavaria. Other than that, well done, thank you. Can you please translation this into English?   
**Gemma3:** You're absolutely right about "Urbaier"! My apologies for the misinterpretation – it's a regional colloquialism that doesn't translate directly. Thanks for clarifying. Here's the English translation of the corrected German text, incorporating that understanding of "Urbaier":  
**Gemma3:** Notes on the Translation: I've translated "Urbaier" as "typical Bavarian tourist" to convey the intended meaning. I’ve tried to maintain the slightly informal and conversational tone of the original German.  

**Me: Fail.** Nice try, though, Gemma.  

By the way, I've rendered the translation a bit less awkward. Like: "A signature was cheap as a gift." ...to... "A signature was a cheap gift."
  
So no, AI isn't going to replace us any time soon. If ever.

BTW, that exchange between him and his dad over the waiver revealed where Dad got his sarcasm from.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 03 Oct 2025

Did a bit of shuffling based on date and even more: context. So, moved 2 entries into 1939, and also 1940. Just did a quick translation... needs to be read more carefully for accuracy.

<hr style="height:2px;border-width:0;color:red;background-color:red">



Took out this bit from [1946: Herbst](/family/pappa1.md/#1946-herbst):

*Faithful translation An autumn of hunger. O dear reader, do you know what hunger is? My Hunger is written with a capital letter. It pulls through your guts. Yes, hunger hurts. It is a pain very close to your soul.  

“Give us this day our daily bread.” There isn’t even a single crust. In the morning you get up and first have to sit on the edge of the bed. It goes black before your eyes and it takes a while before you can stand. The shirt sticks to your body. From the nights you’ve sweated. Whoever has ever eaten his bread with tears, whoever sat weeping through sorrowful nights on his bed—he does not know you, you heavenly powers.  

Yes, those were the good old days. They still had bread. What remained to us were only tears and this accursed hunger. K. had already been waiting ten minutes for his friend Fritz. It was two o’clock at night. Both worked a forty-eight-hour week. With what they earned the two of them couldn’t buy the food they needed. So at night they had to steal what they simply lacked for ordinary nourishment.*

Keeping the literary version, for now. Now that I have the actual hard copy, will try to nut out what [Rute?] is. 

*Translator’s note: the quoted lines echo Goethe’s famous verse (“Wer nie sein Brot mit Tränen aß …”), though here it’s recalled imperfectly. If you’d like, I can normalise the quotation or keep it as-is for authenticity.*

"Köter" is a perjorative word for a dog: similar to the English "mutt" or "cur", dog of mixed breed.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 10 Oct 2025

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

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 31 Dec 2025

### 1941: Sommer (A)
Finally found the moral strength to continue this project. I will invoke 'Emily', my AI bot, to help me with managing this complex document: Gemma3 just wasn't cutting it. For the moment, I'm going to leave Emily's observations on why she translated the way she did on the actual page, above and below the translated text:

[1941: Sommer (A)](/family/pappa1.md/#1941-sommer-a)  

I hope for input from either Jess or Martin or both on this translation. I'm also reviewing hard copy to transcribe that has not been done so far. Oh, and an observation from [Free Association](/family/pappa1.md/#free-association-31):

Tentelfisch wie Drachen.  
Hagfisch.  
Aloha Freitag.  
Die Sprache.  
Die Menschen  
Das Heimweh.  
**Daheim, da ist nichts.**  
Arbeiten auf den Nachbarinseln.  
Verschiden Sand Sandgemählde. 

Daheim, da ist nichts. "At home is... nothing."" Says it all.

---

[Emily's note]  
*Here’s a clean English translation that keeps the tone and the “diary” feel, while also respecting the colloquial bits (and a couple of places where your source text is clearly misspelled or uncertain)*:

---
*(smoothed, natural)*

---
[Further observations - to discuss]  
*Notes on likely originals (so you can sanity-check the reading)*

1) This text has some “heard/written from memory” spellings. These are the spots where the meaning is clear, but the exact word/place is uncertain:

* **“Segelf’ng”** almost certainly means **Segelflug** (gliding).
* **“Meine ‘B’ … erreicht”** very likely refers to a **B-Schein / B-Abzeichen** in gliding (a training/qualification stage). I’ve translated it neutrally as “my ‘B’.”
* **“Flulehrer”** should be **Fluglehrer** (flight instructors).
* **“Kamalitait”** strongly looks like **Kasernalität** (the grim, regimented “barracks life” vibe). That fits the context perfectly: escaping into the kitchen to avoid the drill/indoctrination atmosphere.
* **“schmißen sich in die Brust”** is a mangled spelling of an idiom like **“sich in die Brust werfen / sich in die Brust schlagen”** — i.e., **strutting / beating their chests**.
* **The place name** **“???Punsahran???”** and **“Bergen Saileck?”**: I left these as **[Punsahran?]** and **[Saileck?]** because I don’t want to invent a town. The geography clue is: *on the Saar river, opposite a set of hills/mountains called something like “Saileck.”*

2) If you paste just that one sentence again (the bit with the destination and the hills) and—if possible—anything around it from the manuscript (even one line before/after), I can usually reconstruct the intended place name pretty reliably.

---

*And on the second part:*

[Emily's note]  
*This one’s* **very** *diaristic: lots of phonetic spellings, a few dialecty turns, and a couple of intentionally crude words that tell you exactly what the writer thought of the hierarchy. Below is a faithful English translation first, then a “what this probably was meant to be” unpacking of the grey bits (so you can compare to your hard-copy)*.

*Commentary on the “grey area” words and what they likely are*

1) “Zunacht”  
- Almost certainly **“Zunächst”** (“at first / to begin with”). Your spelling is a very common handwritten/phonetic drift.

2) “Der Küchenbulle”  
- This is slangy and insulting. **Bulle** is “bull” but colloquially it can mean a heavy-handed authority type (later it’s a common insult for police). Here it’s basically: *the kitchen tyrant / kitchen enforcer*. I translated as “kitchen boss” and kept the contempt in the next clause (“pighead”).

3) “Schweinskopf”  
- Literally **“pig’s head”**, idiomatically: *pigheaded jerk*. Strong contempt.

4) “an uns kleinen Scheisern”  
- This is the writer being crude on purpose. It’s essentially “us little shits / small fry” — self-deprecating and resentful at once.

5) “Meine Knoera? den”  
- This is the one most likely to snap into place once you look at the hard copy. My best guess is it’s trying to be **“Meine Kameraden”** (“my comrades”). The phrase “den sagte” should be **“die sagten”** (“they said”). So the intended line is probably:
> **Meine Kameraden sagten:** "Mensch, lass doch nur das Essen anbrennen."

6) “laß doch nur des Eßen anbrennen”  
- Likely **“lass doch nur das Essen anbrennen”** = “just let the food burn.”

7) “Denn die Keßel waren mit Glitzerin.”  
- This reads like a mishearing/misspelling of something about the pots being **enamelled / glazed**, i.e. hard to ruin by burning. Most plausible intended word: **“glasiert”** (glazed), or **“mit Glasur”** (with glaze).
So meaning: *You can’t simply scorch them / ruin the pots because they’re enamelled.* (“Glitzer” = glitter doesn’t fit; “Glycerin” doesn’t fit either.)

8) “10 Pfn und Salz.”  
- **“Pfn”** is almost certainly **“Pfund”** (pound). So: *ten pounds of salt*. It’s sabotage-by-inedible-stew.

9) “Keiner konnte den Eintopf fresen.”  
- Should be **“fressen”** (animals’ “to eat,” but used crudely about people: “to scarf down / to wolf down / to be able to stomach”). So:

* literal tone: “No one could **fressen** the stew.”
* English equivalent tone: “No one could stomach the stew.”

10) “Trotzdem schob man mich ab.”  
- **abschieben** = to shove someone off / dump them / transfer them away (often with a sense of “get rid of him”). Your translation should keep that: they disposed of him from the kitchen assignment.

11) “Zuruck … war ich wieder auf der Warteliste.”  
- Clear: he gets put back on the waiting list for flight duty/ops.

12) Dialogue block  
- This is tricky because it’s missing a little glue, but the gist is clear: someone is complimenting Steiner for handling a dangerous situation; Steiner answers evasively (“you know what people think about that”); the speaker insists he witnessed it.

The “Ja den ich habe es gesehen” should likely be:

* **“Ja, denn ich habe es gesehen.”** (“Yes — because I saw it.”)

13) “Schon am ersten Tag hatten wir ein.”  
- This is incomplete as written. It’s almost certainly:  
* **“Schon am ersten Tag hatten wir einen [Zwischenfall/Vorfall/Unfall].”**
  (“Already on the first day we had an incident.”)

Your hard copy will probably show which noun it is.

---
Two optional renderings (choose based on how “literal” you want the translation)  
If you want it **more literal / rough**, the kitchen line could be:  
> “The kitchen bull was a pighead, always looking to exploit his power position on us little shits and to harass us.”

If you want it **more polished but same meaning**, it could be:  
> “The kitchen chief was a pigheaded brute, always trying to throw his weight around and pick on the lowest-ranking boys.”

---

**On document tone, here's Emily's view on Dad's verbiage.**

[Emily]  
A couple of small calibrations:

* **Scheißkopf / Schweinskopf**: in English register, **“arsehole”** is often the closest *social* equivalent (as you put it), because it lands as a blunt character judgement rather than a quirky literal image. **“Shithead”** is also a very direct match when you want the childish/crude sting to stay audible.

  * If the diary voice is meant to feel *spiky and unfiltered*, I’d keep **“shithead”**.
  * If you want the same contempt but in a slightly more natural Australian/UK-feeling cadence, **“arsehole”** works beautifully.

* **“an uns kleinen Scheißern”**: that one is actually slightly different to **Scheißkopf** — it’s not “you are X,” it’s “we are the little Xs,” i.e. self-deprecating, rank-aware, and resentful. In English the closest tones are:

  * **“us little shits”** (very close, keeps the bite)
  * **“us little turds”** (slightly more comic/juvenile)
  * **“us small fry”** (cleaner, loses the crude edge)

So if you want a “dad voice” version that reads like a human English diary (not like a translation), you could legitimately render that kitchen sentence as:

> “The kitchen boss was a complete arsehole — always throwing his weight around and picking on the likes of us.”

Whereas if you want the *rawness* preserved:

> “The kitchen boss was a shithead, always using his position to bully us little shits.”

Both are faithful — they just make different choices about how much literal crudity to keep versus how much to naturalise.

---

If the text is a diary, the *whole point* is that it doesn’t self-edit. The rough edges aren’t decorative; they’re evidence. If you want to keep it “as written” but also make it defensible to a reader who might flinch, there are a couple of tidy ways to frame it without sanitising the translation itself:



#### A good principle

Translate **the insult-strength**, not the literal noun. Your dad didn’t choose refined language, so the English shouldn’t either.

* **Schweinskopf / Scheißkopf** → *“shithead”* is basically perfect when you’re preserving blunt contempt.
* **Bulle** in “Küchenbulle” → keep it as **“kitchen bully”** or **“kitchen enforcer”**; “boss” alone can soften it too much.
* **an uns kleinen Scheißern** → “us little shits” is actually accurate *and* carries the self-deprecation/rank resentment.



#### Two Options

*Two “standing as written” options you can pick from (both diary-accurate)*

**Option 1: hard literal, still natural**

> The kitchen bully was a real shithead, always looking for ways to use his little bit of power against us and to harass us.

**Option 2: even closer to the German rhythm**

> The kitchen bully was a pigheaded shithead, always set on exploiting his position over us little shits and making our lives miserable.

(That second one keeps the German habit of stacking contempt nouns. It’s ugly — but that’s the point.)



#### A compromise

*you don’t have to use, but can offer if needed*

If the desire is for something printable without losing meaning, you can keep the translation “accurate” and move the crudity into a note:

* Text: “The kitchen chief was a bullying brute…”
* Note: “German uses very coarse insults here (‘Scheiß-’, ‘Schweins-’) — tone is explicitly crude.”

But if your instinct is “no, the crudity belongs in the voice,” I’d stick with your approach.

If you paste the full entry once you’ve checked the hard copy (especially the missing noun after “Schon am ersten Tag hatten wir ein…”), I can produce a single, unified translation in consistent diary voice — and then a *side-by-side* sanitized alternative for those who might insist on it, without changing your preferred version.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">







## 15 Jan 2026
### 1941: Sommer (B)

These notes are from the translation on [1941: Sommer (B)](/family/pappa1.md/#1941-sommer-b). This is a *first-pass* translation. Analysis and re-wording to follow.  

---
Notes on the tricky / vernacular bits (and your cut-offs):

* “B und C” / “A Prüfung”: In gliding context this reads like staged qualifications (A already passed; training for B and C). I’ve kept it as “certificates/tests” rather than inventing an exact modern term.

* “Die Kleinen”: literally “the little ones” (smaller/younger lads). Could also mean “the juniors” or “the small fry.” I kept the plain sense.

* “Parterre”: French loanword used in German for “ground floor.” Here it’s clearly figurative: low-level, near-ground flights. So I translated it as “down low / close to the ground,” and left the cut-off indicated.

* “Briefkastenhöhe”: literally “mailbox height.” Great line. I kept it.

* Cable launch description: very clear: steel cable, winch drum, eight-cylinder engine, pulled up “like a kite.”

* “Platzrunde”: standard aviation/gliding term: a circuit/pattern around the airfield. I used “a circuit of the field.”

* “Landekreuz”: “landing cross” (a marked cross indicating landing point/aiming point). I translated literally.

---

[Emily]  
If you want, paste the missing fragments where you have a-[cut-off word], ger-[cut-off word], di-[cut-off word], zufrie-[cut-off word] and I’ll slot them in and polish the few sentences where the cut-offs probably affect nuance.

**Second Part**

---
Quick notes on a few oddities (dialect / spelling / likely intended meaning)

* “Punschrau”: I’m leaving it as-is (place name). It might be a slightly mangled spelling of a real location; if you want, I can try to identify what it maps to, but I won’t guess inside the translation.

* “verdünnisierte”: not standard German; clearly colloquial for “I made myself scarce / I slipped away.” I translated it that way.

* “poste nam Flugplatz”: reads like “Posten am Flugplatz” (the guard/sentry at the airfield). I translated it as “the sentry at the airfield gate.”

* “Ich war vorne und hinten wie Otto”: idiom-ish. Meaning: busy everywhere / running around doing everything. I kept the flavour.

* “auserwählten Ikarußen”: sarcastic, like “the anointed Icaruses” (the hotshots). I kept it slightly ironic with quotes.

* “der kleine Pimpf”: mildly scornful: “the little squirt / little runt.” (In some contexts it can be harsher; here it reads like contempt for an overconfident trainee.)

* “85 euer”: almost certainly “85-PS” (85 horsepower). The surrounding sentence is a bit scrambled, but it’s clearly about power / tow / winch setup. I rendered it in a way that keeps sense without overcommitting.

[Emily]  
If you paste the sentence around “Nur eben Uwe ließ mich nicht fliegen E * zwei Uhr…” exactly as it appears in the manuscript (even if messy), I can tighten that one paragraph further — that’s the one spot where a couple of stray characters make it hard to be 100% sure of the intended grammar.

<hr style="height:2px;border-width:0;color:red;background-color:red">



### 1945 Lungenentzündung

These notes are from the translation on [1945 Lungenentzündung (pneumonia)](/family/pappa1.md/#1945-lungenentzundung). This is a *first-pass* translation. Analysis and re-wording to follow.  

---

Small notes (for later decisions)

* “Nach 3 × 4 Tagen”: literally “after 3 × 4 days” (i.e., twelve days). He’s thinking in “blocks” of time — probably the way the experience was structured (treatments? rotations? phases of misery). I kept it as “three stretches of four days” rather than converting to “twelve,” because the shape of his thought feels important.

* “Pritsche”: a rough bunk/cot, often in barracks or a sick bay. “Bunk” is the closest natural English.

* “Prov. Dantz”: almost certainly “Prov.” = “Provisorisch” (acting / temporary), i.e., an acting NCO or acting role-holder. I rendered it as “Acting NCO Dantz.” If you later learn his exact rank, we can swap that in.

* “wirdt … vernarbt”: he means the lung will be left with scarring (pneumonia can leave scar tissue). His phrasing is oddly confident (“in two years it will be scarred”), which I preserved rather than medicalising it.

[Emily]  
If you want a slightly grittier version that keeps more of his clipped German rhythm (less “polished English”), tell me and I’ll do an alternate pass.

<hr style="height:2px;border-width:0;color:red;background-color:red">



### Neiße

These notes are from the translation on [1945 Neiße](/family/pappa1.md/#1945-neie). This is a *first-pass* translation. Analysis and re-wording to follow.  

[Q]  
This one has me completely puzzled. No idea what he's on about, here:  
Ja, das war ...

--

[Emily]  
Totally fair to be puzzled — the passage reads like a half-remembered snapshot written in haste, with a couple of words either misread from the manuscript or spelled phonetically. But the overall situation is actually pretty coherent:

* he recognizes Neiße (Nysa) from the air (he’d flown over it months earlier),
* he’s hiding near a railway line, waiting for a train going west,
* he jumps onto the tender (coal/water car behind the locomotive),
* he assumes the crew are German railwaymen, then discovers a Russian officer is right there,
* the crew pretend not to see him because everyone is scared,
* and he’s being set up for something nasty at the end station (“If K had known what awaited him…”).

Below is a translation that keeps the voice, and I’ll bracket the garbled words with my best reconstruction.

<hr style="height:2px;border-width:0;color:red;background-color:red">



#### What I think
*the “mystery words” probably are*

---
1) “Standanim???”

This really looks like a misread of something like:
* “Stadtanblick” (city view / skyline / panorama) — most likely, because it fits perfectly with “he had flown over it” and “he remembered the towers.”
* Less likely: “Standbild” (a statue/monument) — possible, but then “towers and the dam” feels odd.
* Very unlikely: anything “Stand—” technical; the next sentence is purely about recognizing the town from above.

So I’d render the first sentence confidently as:
* “Yes, that was the skyline (panorama) of Neiße.”

---
2) “an der Staumauer??? … erinnern”
* This part is solid: he remembers two towers and the dam (Staumauer). There really was a dam/reservoir near Nysa (Neisse), so this tracks.

3) “Hnehandie??? FW 190 … notgelandet”
* That cluster is almost certainly just a broken “and also / and I remember the” connector, i.e.:
* “Und an die FW 190 …” (“And [I remember] the FW 190…”)

-or-
* “Ich erinnere mich an die FW 190 …”

In other words: the important content is the FW 190 emergency landing on a frozen lake — the garble is just the lead-in.

---

#### What’s “going on”
*in plain terms*

This reads like a postwar/late-war escape vignette:

* “K” is either your dad referring to himself in the third person (some diarists do this), or a comrade whose initial is K.
* He’s trying to ride a westbound train without permission (classic stowaway move: tender ladder).
* He believes the crew are German (and they probably are), but the presence of a Russian officer suggests the train is under Soviet control/inspection, or transporting personnel, or moving through a zone where Soviet officers ride/carry authority.
* The railwaymen “don’t see him” because acknowledging him is dangerous: helping could be punished, and denouncing might also backfire. So everyone acts blind.

That last line (“If K had known what awaited him at the terminal…”) is a classic setup for arrest / interrogation / detention / forced labor / being handed over.

---

#### Tiny polishing suggestion
(if you’re editing for readability later)

If you want the English to feel as clipped and punchy as his German, this paragraph works beautifully with short sentences:

He waited in the bushes for hours. The station was on the far side.  
He jumped for the tender ladder. Two pairs of eyes watched him.  
Germans. He’d heard them speaking German.  
Then he looked over the edge — and met a Russian officer’s fists.  

If you can, type the first line exactly as it appears in the manuscript (even if it looks wrong): “Standanim” might become instantly obvious from the handwriting (e.g., “Stadtanblick”). And if you can recover the cut-off after “Türm-”, I can make that opening image really crisp.

<hr style="height:2px;border-width:0;color:red;background-color:red">


Absolutely — and with this second part, the scene snaps into focus. He’s describing a **post-war rail yard full of liberated (or being transferred) concentration-camp prisoners and POWs**, under chaotic handover conditions, and he’s trying to **pass as one of the “hopeless” prisoners** to avoid being singled out by Soviets/guards/railway authority. It’s grim, but it *is* coherent.

Below is a careful English translation, preserving his blunt, autobiographical cadence. I’ll keep the odd spellings as your dad’s, but I’ll translate the intended meaning. Where a word is garbled (like *Heinitrumsor???*), I’ll mark it and suggest what it might be.

---

#### English translation

**If K had known what awaited him at the terminal station, he certainly would have trusted himself somewhere else.**
But when they finally reached the end of the line, the locomotive driver let him know — incomprehensibly — **“Now you have to get out.”**

Only then could K see where he actually was. His hair stood on end. But that was impossible.

Because three days before his escape they had carefully shaved it off. Even the pubic hair — because of crab lice. Which was very inconvenient when running, as it started to grow back **[scratchy/stubbly]**.

His first thought was: **“Now you’re back inside again.”**

What he saw was a freight yard with several trains of cattle cars. The inhabitants of the wagons were like reapers — emaciated figures, moving heavily, with a voice no normal person has. They wore no German uniforms, but all the same striped prisoner clothing.

The war had been over about six weeks. These people needed medical help and had to vegetate under these inhuman conditions.

K took his hat and wrapped it in his battered jacket. With his bald head, the crude shirt, and the baker’s **[cap/apron/—]**, he looked like one of the hopeless ones.

The midday sun burned on his scalp. God had surely known why we need hair.

Most of all he wanted to run. But no panic. Slowly he began to move. He headed for the western exit of the station.

It stank terribly of human waste. He let his lower jaw hang slack and put on an idiotic expression. At the same time he quietly cursed in Russian — curses he’d learned in captivity. **Don’t look anyone in the eyes.**

They were Polish concentration-camp prisoners waiting for the **[Heinitrumsor???]**. The German prisoners of war had to walk to their destination because the rail wagons couldn’t run — too many bridges had been blown up.

But those poor people would have been exhausted after the first kilometres. And German prisoners too had died on the roads from exhaustion.

---

#### What’s going on
*(and why it felt baffling before)*

A few key details anchor this:

* **“Viehwagen” (cattle cars)** + **striped “Sträflingskleider”** + **Polish KZ prisoners** = he’s at/near a rail yard handling camp survivors or transfers just after the war.
* He’s shaved head and delousing (“Filzläuse” — he means lice/crabs) match **prisoner processing**.
* He decides to **blend in**: slack jaw, vacant face, avoid eye contact, mutter Russian — a *disguise by demeanour*, not by papers.
* The railwaymen and driver are acting like “not my problem,” which fits the earlier bit where “everyone was afraid of everyone else.”

So the text is not random: it’s a survival manoeuvre in a volatile post-surrender environment.

---

#### Notes on
*specific oddities / probable readings*

* **“Haare waren ihm zu Berge gestanden. Aber das ging ja nicht.”**
  He’s doing a dark little self-correction: “My hair stood on end — but that’s impossible, because they shaved it.”

* **“[soliliselich]”**
  Likely something like *stoppelig / borstig / kitzelig / scheußlich* (stubbly / bristly / itchily). Context: regrowth chafing while walking/running.

* **“Bäcker-[cut-off word]”**
  Could be *Bäckermütze* (baker’s cap) or *Bäckerschürze* (apron) or even *Bäckerjacke* (baker’s jacket). He’s listing costume elements that make him look like a labourer/prisoner rather than an airman/soldier.

* **“Sensenmänner”**
  Literally “grim reapers.” Strong image; he’s describing the survivors as skeletal and not quite “alive” in movement/voice.

* **“Heinitrumsor???”**
  This is the one I can’t responsibly “solve” without seeing the handwriting. Possibilities, based on context (“waiting for the …”):

  * a **transport / handover / repatriation** term,
  * a **place name**,
  * or a **relief organisation** / processing point.

  If you can share just that word as a close-up (or even type what letters you’re confident about), I can usually reconstruct it.

* **“KZ”** = Konzentrationslager (concentration camp). You translated that sense correctly by implication; I’ve rendered it explicitly.

---

[Emily]  
Here’s the **same literal-ish, jagged** style for the *first half* (train/tender/Russian officer), keeping his pacing and his slightly clipped, observational rhythm. I’ll keep the uncertain manuscript bits bracketed.
...and...   
Here’s a **more literal, jagged** version that stays closer to his sentence order, repetition, and the slightly breathless “I’m remembering this as I write it” cadence. I’ll still make it intelligible English, but I won’t smooth away his edges.

<hr style="height:2px;border-width:0;color:red;background-color:red">



#### Literal-ish English
##### First half
(closer to his German)

---

Yes, that was the **[city view / skyline]** of Neiße. Five months earlier he had flown over it. He could still remember exactly the two tower—**[cut off]**—at the dam **[Staumauer]**. And the **FW 190** that had then made an emergency landing on the frozen lake.

There was a train that drove westward. Already for hours he sat in the bushes and waited. The station buildings were on the other side.

K had blisters on his feet from all the walking of the last days. The longing to come home soon was after all stronger than all caution.

When the locomotive at last, after a long waiting, set itself in motion, he jumped up and climbed the ladder of the tender. Two pairs of eyes looked at him. But he knew it were German railwaymen who drove this locomotive. He had simply listened long enough and heard them speak German.

Then K made a big error. Curiosity forced him to look over the edge, and there were the fists of a Russian officer.

Now, so easily K was not to be intimidated. He had after all already had some things behind him. The train drove very slowly. The sign “Picking flowers during the trip” would have been appropriate **[cut off]**. The railwaymen paid attention to him as if he were not present. Everyone had fear of the other.

##### Second half
(keeping his rhythm)

If K had known what would be in store for him at the end station, he surely would have trusted himself somewhere else.

But when they reached the end station after all, the locomotive driver let him know, unintelligibly: **“Now you have to get out.”**

Only then could K see where he actually was. His hair stood on end. But that couldn’t be.

Because they had, three days before his escape, carefully shaved it off. Even the pubic hair because of the crab-lice. Which was very hindering for him when running, when it **[—]** grew back.

His first thought was: **“Now you’re back inside again.”**

What he saw here was a goods station with several trains of cattle wagons. The inhabitants of the wagons were scythe-men: emaciated figures with heavy movements, with a voice that a normal person does not have. They had no German uniforms, but all wore the same striped prisoner clothes.

The war was about six weeks over. These people needed medical help and had to vegetate under these inhuman conditions.

K took his hat and wrapped it in his shot-up jacket. With his bald head, the primitive shirt, and the baker’s **[—]**, he looked like one of the hopeless ones. The midday sun burned on his bald head. God had surely known why we need hair.

Most of all he would have liked to run away. But no panic. Slowly he set himself in motion. He aimed for the west exit of the station.

It stank horribly of human excretions. He let his lower jaw hang and made an idiotic face. In doing so he quietly cursed Russian curses that he had learned in captivity. Just don’t look anyone in the eyes.

They were Polish concentration-camp prisoners who were waiting for the **[Heinitrumsor???]**. The German prisoners of war had to walk to their place of destination because the rail wagons could not run, because of the many blown bridges.

However these poor people would already have been exhausted after the first kilometres. Also German prisoners had died on the roads from exhaustion.

---

---

**Tiny word-note (just so you can decide later)**

* **“was ihm … blüht”** is an idiom meaning “what awaits him / what’s in store for him,” but he uses it in that slightly grim, ironic way. In literal mode I kept it as “would bloom for him” once, because it’s very *him*, and also because it echoes the later joke-sign about “picking flowers.”

If you paste the two cut-offs (**“Türm-…”** and the bit after **“wäre angebracht genese-”**) I can lock those lines down tightly while still keeping the literal voice.



### Flieger

These notes are from the translation on [1940 Flieger (b)](/family/pappa1.md/#1940-flieger-b). This is a *first-pass* translation. Analysis and re-wording to follow.  

[Emily]  
Yes — this is almost certainly from his **glider training** (sailplane) period. The giveaways are the training context, the talk of single-seaters/no two-seaters, “Hochstart” (a winch/aerotow *high start*), “Knüppel” (stick), and the “negative” (negative angle/attitude, or negative g-load / pitch-down) leading to an impact.

A couple of the aircraft names are misspelled in his text, but the meaning is clear.

Below is a smooth translation first, then (as you’ve liked) a more literal “his voice” version, plus notes on the puzzling terms.

---

#### Natural English
*translation*

This Steiner was a tightly wound sort of person. Nobody really took him seriously. But I only had two and a half weeks left to get my flying done. How I actually managed it, I still don’t know to this day.

Steiner was an excellent instructor and pilot. We flew the **Grunau Baby**. There were no two-seaters available. Often I thought of Mr Münch: either you fly — or you fly — or you land on your face.

Now, one of us wasn’t as lucky or as gifted as we were — a certain Bone. The poor boy was a stutterer and had to endure a lot of mockery. Who knows whether it was suicide, or just a cramp/panic reaction.

On a high launch he pushed the stick forward. At a negative of about ten **[degrees]** he crashed into the turf. In my whole life I have been afraid of loops **[or aerobatics]**, and I avoided every one of them.

---

#### Literal-ish English
(keeping his rhythm)

This Steiner was a cramped-up person. Nobody took him properly seriously. I, however, had only two and a half weeks time left to get my flying. How I actually managed that I still don’t know to this day.

Steiner was an excellent instructor and pilot. We flew the **Grunau Baby**. There were no two-seaters available. Often I thought of Mr Münch: either you fly, either you fly, or you fall on your snout.

Now one of us was not so happy or gifted as we were. A certain Bone. The poor boy was a stutterer and had to endure much mockery. Who knows whether it was suicide or only cramping.

With a high start he pushed the stick forward. Into a negative of about ten he crashed into the grass sod. In my whole life I have had fear of loops, and avoided every one.

---

#### Notes on
the “what is he on about?” bits

* **“mein zu fliegen”**: he means *to get my required flights in* (to complete the remaining flying time/requirements).
* **“Wir flogen das Gropanbabey.”**: this is almost certainly **Grunau Baby** (often written “Grunau Baby” / “Grunau Baby II”), a classic German training glider. His spelling looks phonetic.
* **“keine Doppelsitzer”**: important detail — he’s saying there were no dual-control trainers, which makes his rapid progress feel more precarious.
* **“Hern Münch…”**: he’s recalling a hard-edged instructor mantra. The German is garbled but the sense is: *you either learn by doing, or you eat dirt.*
* **“Hochstart”**: a winch launch / high start — glider accelerates hard; pushing the stick forward at the wrong moment can drive the nose down dangerously.
* **“In eine negativen von etwa 10”**: most likely **10 degrees nose-down** (negative pitch attitude). In a low-altitude launch phase, that’s fatal.
* **Last line (“Angsträuns”)**: almost certainly **“Angst vor Loopings”** (fear of aerobatic loops). He’s saying that accident cemented his aversion to aerobatics.

If you can confirm whether the name is **“Bone”** or something like **“Böhne / Bohne”**, I can adjust the tone (because “Bohne” in German can sound like a nickname and might sharpen the social cruelty he’s describing).





<hr style="height:4px;border-width:0;color:blue;background-color:blue">



## xx Jan 2026





<hr style="height:16px;border-width:0;color:navy;background-color:purple">

[Main Page](../index.md)
