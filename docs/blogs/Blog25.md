# Blog Posts 2025

<style>
  .flex-container {display: flex; gap: 20px; align-items: flex-start;}
  .column {flex: 1 1 0; min-width: 0;}
  .column--right {border-left: 1px solid var(--md-default-fg-color--lightest); padding-left: 20px; }
</style>

**INDEX**

[September & ComfyUI](#september)  
[Kontext and SRPO](#kontext-and-srpo)  
[Autobiography Stalled](#autobiography-stalled)  
[ComfyUI and SRPO](#comfyui-and-srpo)  
[Trip to Brissie](#trip-to-brissie)  
[Qwen, and How](#gardens-and-qwen)  



---

[Main Page](../index.md)  

<hr style="height:12px;border-width:0;color:pink;background-color:pink">









## September

### Virtual Kalapana

**19.Sep.2025**   
A lot of the improvement has been in model development. Flux has fixed a lot of issues with distorted, missing or excess anatomy although it still happens. What really helps is patience: you simply fix the prompt and re-queue. And modifying the prompt again, and re-queueing. So, I was hoping for Kalapana back in the day. Is it? no way. Feels more like MacKenzie Park with palm trees instead of ironwoods. And those coconuts... really?

<div class="flex-container" markdown>
  <div class="column" markdown>

    <img src="/assets/images/emily/08-Flux1D25.jpg" alt="Girl at Kalapana" style="width: 420px;"/>

    [ Girl at Kalapana 01 ]
  </div>

  <div class="column column-right" markdown>

    Here's the prompt:  
    - This photograph captures a solitary beautiful woman walking towards the viewer on a dark, volcanic black sand beach. She is positioned slightly off-center to the right, facing towards the camera. The woman has long brown hair and wears a black one-piece lycra swimsuit and is carrying a surfboard under her arm. She walks barefoot towards the viewer, leaving small footprints in the wet sand near the shoreline.  
    - The background features a dense cluster of tall, lush palm trees with green fronds and some golden-brown leaves, indicating the tropical location. Under the trees are a few small fallen coconuts, dead coconut tree fronds and black sand, NO shrubs or bushes. The sky above is clear and dark blue, suggesting it is morning with good weather conditions. The black sand contrasts sharply with the white surf at the water's edge on the left side of the image.  
    - The overall composition emphasizes the natural beauty of the beach setting, combining the dark volcanic sand with the vibrant greenery and tall palm trees in the background. The photograph uses bright, vivid colors to enhance the tropical atmosphere and highlights the solitude of the woman amidst the serene environment.

  </div>
</div>

---

<div class="flex-container" markdown>
  <div class="column" markdown>

    <img src="/assets/images/emily/09-Flux1D33.jpg" alt="Girl at Kalapana" style="width: 420px;" />

    [ Girl at Kalapana 02 ]

  </div>
  
  <div class="column column-right" markdown>

    <img src="/assets/images/emily/10-Flux1D34.jpg" alt="Girl at Kalapana" style="width: 420px;" />

    [ Girl at Kalapana 03 ]

  </div>
</div>

---

The prompt is a lot more verbose (wordy). You can add a lot of descriptors. However, it all comes down to what the model wants to do. And will it obey? At times yes, at times no. As they say: YMMV (your mileage may vary).

These are sequential 'queues': one is walking towards, the other: away. I didn't ask for "walking away". I was able to get the coconuts smaller. The bathing suit is a more current style than what the style was back in the day.

Issues? Definitely. What's with the hand at the tip of the bard on the image on the left? And the girl's shadow on the right suggests that the board is no longer intact. Overall, getting there but still a ways to go.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Flux SRPO

**21.Sep.2025**   
So, I wrote the text, and created the images, for the girl on the beach example on *Friday* in the model Flux.1 Dev.


<img src="/assets/images/emily/12-SRPOGirl12.jpg" alt="Girl at Kalapana" style="float: right; width: 450px;
        margin-left: 20px; margin-bottom: 10px;" />


Today is *Sunday*... and a new model has 'dropped': SRPO, which stands for 'Semantic Relative Preference Optimization'. Yep, conveys just about as much information to *my* mind, too.

One of the issues that seems to be at play here is source-of-image. In order to create an image, there has to be something to reference: for example, to be able to create cat images, the developers had poured 'tons and tons' (figuratively-speaking) of cat images into the model, which then, during the image-generation process, gets referenced so the KSampler knows what the prompt is asking for. I've actually created my own 'models' called LoRAs (low ranking adapters) where I create a character based on a set of images of that character at different angles and situations, which images, when paired with relevant text, creates a LoRA through a rather long, tedious process. I can then do a face-swap with what the original model came up with with my character's face (and body, if my LoRA contains that information). This is the process the alarmist media call 'deep-fake', except I use it for consistent character imagery, without which illustrations for stories would be confusing, indeed.

So, nothing about the image to the right is real: nothing. Indeed, the surfboard seems to be delaminating: that would suck. I didn't ask for a delaminating surfboard: I just got given it. Thanks, SRPO. 🤨

Still, overall, the image is an improvement over what I see Flux1.Dev produce. It's still not Kalapana, more like the beach at the bottom of Waipio Valley. But, no question it is an improvement. At least the figure isn't walking away. 

So, there's that.

Here are some of the better of subsequent queues. Simply click the thumbnail to see a larger version.

<style>
  .flex-container {display: flex; gap: 20px;}
  .column {width: 100%;}
</style>


<div class="flex-container">
  <div class="column">

  <a href="/assets/images/emily/13-SRPOGirl17.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/13-SRPOGirl17.jpg" alt="Go" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/14-SRPOGirl20.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/14-SRPOGirl20.jpg" alt="Go" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/15-SRPOGirl21.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/15-SRPOGirl21.jpg" alt="Go" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/16-SRPOGirl22.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/16-SRPOGirl22.jpg" alt="Go" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/17-SRPOGirl23.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/17-SRPOGirl23.jpg" alt="Go" width="100" loading="lazy"></a>

  </div>
</div>


Feels like I've done enough Kalapana for now.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Virtual Paris

**22.Sep.2025**   
So, we're going from Hawaii to Paris. Because: why not. 


<img src="/assets/images/emily/24-Paris01.jpg" alt="Paris" style="float: right; width: 350px;
        margin-left: 20px; margin-bottom: 10px;"/>


So, for the past months I was a total [Flux.1 Dev](https://flux1ai.com/dev) fan: the images it produced were, in terms of accuracy and believability, so far superior to what went before, like Stable-Diffusion 1x and even SDXL, that it made those models *almost* irrelevant. Almost, because I would still use SDXL models for image-to-image (i2i) projects.

Oh, that takes me back.

I started AI-imaging for illustrations in Automatic1111 (A1111) using Stable Diffusion 1.5. Then, along came SDXL and SD 1.5 just sort-of ended up on the skids, as in: I never used it anymore. The base 1.5 models were over 4.5 gig in size, but one could find what were called 'Merge' models that offered improvements and were only a 2.2 gig download. 

Yes, gig. Gigabyte. Which is why you really need a decent internet connection and heaps of hard-drive space. We have fibre to the premises, fortunately. Also, you want to go with SSDs, not HDDs (spinning disc tech).

The original SDXL models weighed in at over 12 gig, but then, no one used the originals: everyone ran 'Merge' models that produced specialised art styles: wanna do Manga? there's an SDXL model for that. Archie-cartoon? yep, can help you with that. All in a 6.6 gig package. Realism was... okay - you just keep re-queueing if there was anything wonky.

One ends up discarding a lot of images, even if they were better than what SD 1.5 had produced. And now the game has changed dramatically, with Flux and SRPO (which is based on Flux). Most images are fine with no really hideous deformities: you decide what to keep based on prompt-adherence.

---


<img src="/assets/images/emily/25-Paris02.jpg" alt="Paris" style="float: left; width: 350px;
        margin-right: 20px; margin-bottom: 10px;"/>


SDXL was my go-to model for ages. To be honest, at the time the improvements over SD 1.5 *were* incredible. By now, AI-imaging had made Poser and Blender as tools for illustrations *completely irrelevant*. You type a few words (the prompt) and run queues until you get your desired result. Those results made truly **EVERYTHING** I had done in 3D software laughably poor.

Here's the thing: once you have that [that rather expensive graphics card](https://www.umart.com.au/pc-parts/computer-parts/graphics-cards-gpu-610?brand=5-61-313&mystock=1-6-7&filter_attr=0.120940-179291-115184.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0), there's nothing else to purchase. Well, except for SDDs... I did have to invest in storage. When I was doing images in Poser (and even Blender) I would suddenly **need** certain 'assets': clothing and hair for your figures, sets for the scenes, etc, which weren't expensive, but it added up after a while. 

None of that is even a thing now. The models are all a free download. Tutorials are available on YouTube.

Of course, nothing is perfect in life. AI art is no different. In this SRPO-based image, hands are great, hair is great, clothing is good, houses and cars and... wait, what about that bicycle? Something about it is... odd.

The instructions (the prompt) for these images was actually created by another AI tool: a large-language model called '[llama-joycaption-beta-one hf-llama:Q4_K_M](https://huggingface.co/mradermacher/llama-joycaption-beta-one-hf-llava-GGUF)'. This incredible model can 'look' at a picture and "describe" it. In other words, it can turn an image into a prompt. 

That's just ... **crazy!!** - **it will create a prompt for you!** The approach I have been taking, then, is to either 'google' or 'pinterest' for a specific image containing the general setting I'm after. Of course, I could just type out a prompt, but LLMs generally do a much better job at this - they know what another LLM is looking for. If it misses the mark (introducing elements I don't want or just plain get the description wrong, which does happen), just run the query again. And again and again until it's close.

I'll sometimes make a few manual changes to the text of the prompt and run a few more queues. Each queue (with the SRPO model) now takes about 5 minutes or so. I usually run at least two or three before I do any adjustments to the prompt and re-run the queue. Rinse and repeat. You can see how time would fly by. The secret sauce is in the prompt: get that right, and you're 'home-n-hosed'.


<img src="/assets/images/emily/26-Paris03.jpg" alt="Paris" style="float: right; width: 350px;
        margin-left: 20px; margin-bottom: 10px;"/>


For these images, the prompt reads as follows...

- This photograph captures a young woman standing on an Parisian street corner at a Metro entrance, leaning against a black metal railing with bicycles parked beside her. She has brown hair in a loose chignon and is wearing a dark navy blue overcoat, gray turtleneck sweater, and light blue skinny jeans. One hand rests on wrought-iron railing while she holds a smartphone to her ear with the other hand.

- The background features a row of classic Parisian-style buildings with beige facades, tall windows, and wrought iron balconies. A red and black "METRO" sign is prominently visible in the upper center of the image. The sky above is overcast, creating a muted light that casts soft shadows on the scene. The street below has a crosswalk and some distant pedestrians. The overall color palette includes neutral tones from the woman's clothing and buildings, contrasted by the bright red Metro sign and bicycles. The photo has a slightly desaturated, almost painterly quality due to the selective use of color and lighting, giving it a timeless urban feel. The composition directs focus toward the woman while incorporating the surrounding cityscape elements.

---

In a few short years, we've gone from [this](https://www.reddit.com/r/StableDiffusion/comments/144clxb/beginner_here_why_are_closeup_photos_of/) to [this](https://www.reddit.com/r/comfyui/comments/1nx5dzd/night_drive_cat/). That's pretty wild.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">








### Adventures

**25.Sep.2025**   
You might have noticed that the person in these images (and indeed in the 'Kalapana' images as well) all seem to be of the same person. When you do illustrations, having a persistent character is desirable. At this point, doing single-figure persistent characters is almost a no-brainer.

My next challenge: having not only two or more persistent figures, but have them interact. Watch this space. 

In the meantime, adventures suggest themselves.


<div class="flex-container">
  <div class="column">
  <a href="/assets/images/emily/27-Distress48.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/27-Distress48.jpg" alt="Where" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/30-Destiny13.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/30-Destiny13.jpg" alt="Do" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/29-Boxcar08.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/29-Boxcar08.jpg" alt="We" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/30-Destiny12.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/30-Destiny12.jpg" alt="Go" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/31-Destiny23.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/31-Destiny23.jpg" alt="Go" width="100" loading="lazy"></a>

  <a href="/assets/images/emily/32-Destiny20.jpg" target="_blank" rel="noopener">
  <img src="/assets/images/emily/32-Destiny20.jpg" alt="Go" width="100" loading="lazy"></a>

  </div>
</div>


```
[![Where]()](/assets/images/emily/27-Distress48.jpg)
{ target="_blank" rel="noopener" }
```

<hr style="height:12px;border-width:0;color:pink;background-color:pink">











## October

### Receipt, Sept 30

**30.Sep.2025**   
Martin's "letter" arrived today. My observations are [documented here](../family/index.md/#30-sep-2025).

<hr style="height:4px;border-width:0;color:pink;background-color:pink">







### Kontext and SRPO

**10.Oct.2025**   
Having another look at Kontext. Trying to change camera angle, but it turned the figure around instead.  


<a href="/assets/images/emily/36-VictTrain.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/36-VictTrain.jpg" alt="Victorian Train-front" width="140" align="left"></a>

<a href="/assets/images/emily/37-VictTrain.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/37-VictTrain.jpg" alt="Victorian Train-back" width="140" align="right"></a>


The prompt looked like this:  
  ```
  Rotate the camera 180 degrees showing the woman's back  
  while maintaining the woman's pose.
  ```

Getting the camera - and not the figure - to move seems to be a bit tricky. However, I can easily remove hats and change the time of day.


<a href="/assets/images/emily/38-VictTrain.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/38-VictTrain.jpg" alt="Victorian Train-front" width="140" align="left"></a>

<a href="/assets/images/emily/39-VictTrain.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/39-VictTrain.jpg" alt="Victorian Train-back" width="140" align="right"></a>


The prompt looked like this:  
  ```
  Remove the girl's hat to show her chignon updo  
  while maintaining the girl's pose. Turn the 
  background into a nighttime train station scene.
  ```
I'll be the first to admit my prompt 'skills' are pretty ordinary. Still. That shows promise. 

One of the fun things to do with Kontext is to try different artist styles. No guarantees, of course. I tried Toulouse Lautrec and Claude Monet and got: blah. Certainly not [Woman with a Parasol](https://upload.wikimedia.org/wikipedia/commons/1/1b/Claude_Monet_-_Woman_with_a_Parasol_-_Madame_Monet_and_Her_Son_-_Google_Art_Project.jpg). Oh well.

AI does reveals about itself and what it learned, as it portrays the world you are requesting. Yep, it has a viewpoint.


<a href="/assets/images/emily/40-Violin.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/40-Violin.jpg" alt="Violinist" width="140" align="left"></a>

<a href="/assets/images/emily/41-Violin.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/41-Violin.jpg" alt="Violinist" width="140" align="right"></a>


 I will take images generated by, say, SRPO (which is a refined Flux model) and then, ask Kontext (also a refined Flux model, but with a different purpose) to ... *fix* things:  
- *Brown hair to black*  
- *High detail, photographic precision*  
- *Reduction mammoplasty*  

And? Well, 2 out 3 ain't bad.

Flux was developed by Black Forest Labs. Yes, **that** Black Forest. Actually, where I was born, literally: Freiburg Im Breisgau. *(they do have a San Francisco office, too)* So, the good folks at Black Forest Labs collected data (images) about, well, human proportions, and they would have gone to local sources, perhaps? A beergarden or two? So, my last request was probably met with a quizzical "sorry, can't parse that, mate."

Of course, character consistency went out that window with Kontext. It's good but sort-of gets lost in the weeds when you start asking for ultra-high detail, whatever. So, not the same person. But one thing did get preserved: did you notice the original violinist forgot to "tighten her bow"? So did the black-haired girl. Mistake faithfully preserved. Now, will Kontext understand me if I put that in the prompt? Here's my prompt:


<a href="/assets/images/emily/42-Violin.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/42-Violin.jpg" alt="Violinist" width="140" align="right"></a>


```
Change the image to ultra-high realistic detail. No male face in this image, only female.  
Make the woman's breasts small. Render skin tones, hair and face makeup in high detail,  
with hyper-realistic textures and photographic precision. Change hair color from brown  
to black. Tighten the violin bow. Tilt the woman's head more to the left.  
```

Nope. No joy. And when I asked it to change the violin to a flute, all I got was a mirthless laugh.

If I had the patience or the time or the **need** to get **exactly**, a specific pose, a precise setup, it could happen. There are options. For example, I can take that last image and run it through my **llama-joycation-beta-one-hf-llava:Q4_K_M** model to analyse the image ... it gives me this:

```
A photograph of a young woman with long black hair playing a violin indoors. She has fair  
skin and is wearing an elegant gray dress with a deep V-neckline adorned with silver lace  
trim, and sheer, bell-shaped sleeves. The dress has a flowing skirt with a slightly gathered  
waist. She holds the violin delicately in her right hand while drawing the bow with her left  
hand, her eyes gently closed as she focuses on playing. The background shows a large window  
with white panes and brown curtains tied back with golden cords. Outside, there is a blurred  
view of greenery and sunlight filtering through the glass. The overall style is romantic and  
classical, evoking an old-world charm. The lighting is soft and natural, highlighting her  
delicate features and the rich color of the violin. The woman appears serene and focused,  
embodying a sense of grace and musical dedication. The image conveys a peaceful, intimate  
atmosphere with its warm, gentle colors and elegant composition. This detailed description  
should provide a clear understanding of the photograph for someone who cannot see it visually. 
```


LLama should write fiction! Now, what I always do is: *first, have a read*! Because Llama does get it wrong, sometimes, which hand is doing what, for example. Let's see what Llama is claiming is happening here:

```
She holds the violin delicately in her right hand while drawing the bow with her left  
hand, her eyes gently closed as she focuses on playing.
```

"Er, no mate, just the opposite, in fact." She holds the violin with her chin and at the neck with her **left** hand and draws the bow with her **right**.

Lesson learnt: can't trust AI. Still, Llama drew a lovely piccie. Let's fix things:


<a href="/assets/images/emily/43-Violin.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/43-Violin.jpg" alt="Violinist" width="140" align="left"></a>

<a href="/assets/images/emily/44-Violin.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/44-Violin.jpg" alt="Violinist" width="140" align="right"></a>


```
This photograph depicts a young woman with long black hair playing a violin  
indoors. She has fair skin and is wearing an elegant Victorian-style (1880s)  
gray dress with a square neckline adorned with silver lace trim, and sheer,  
bell-shaped sleeves mostly covering her small bustline. The dress has a 
flowing skirt with a slightly gathered waist.  

moim3m3grl

She holds the violin delicately in her left hand while drawing the bow with  
her right hand, her head tilted onto the chin rest of the violin and her eyes  
gently closed as she focuses on playing. 

The background shows a large window with white panes and brown curtains tied  
back with golden cords. Outside, there is a blurred view of greenery and  
sunlight filtering through the glass. The overall style is romantic and  
classical, evoking an old-world charm. The lighting is soft and natural,  
highlighting her delicate features and the rich color of the violin. The  
woman appears serene and focused, embodying a sense of grace and musical  
dedication. The image conveys a peaceful, intimate atmosphere with its 
warm, gentle colors and elegant composition. 
... blah-blah-blah ...
```

I keep hearing the TikTok guy: "oohhh, no-no-no-NO!"

It's 11:07pm. Been working today on making headway of Dad's autobiography, and didn't start ComfyUI until after tea. Got a big day tomorrow with Eddie, so I'll make this my last render.  
Cheers.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">







### Autobiography Stalled

**10.Oct.2025**   
Waiting for input from either Jess or Martin on the work done on Sept 30. Trying different approaches to photography of the pages: no obvious options present themselves. Updated links on the index page to all initial translation pages.

Done:  
- Stubbed in Status / Mods / Comments template for each note
- Converted all page photos to clickable links, which will open in a new tab automatically
- Instead of an obscure, meaningless green tick, will get a consensus from all whether or not a page is ready for canon
- Have commenced moving pages where they seem to fit chronologically.

Plan:  
- Going to a stationery shop to pick up a "display book" to house the original document pages.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">







### Back Into Video

**16.Oct.2025**   
I had my GH5 in 'repair': turns out the problem was a dodgy lens. My lovely 12-60mm Lumix Leica blah-blah-blah whatever is now a doorstop. These run AUD $1200.00 new. Doorstop. Can't be repaired. *{sigh}*

The camera itself is fine. I decided it was time to start using it properly. Shot some footage for a quick little video of me making a flat-white (coffee) on my Bezzera Magica.

On this ageing Macbook Pro (2015 vintage), I have a copy of Final Cut Pro, Apple's idea of intelligent video editing software. I still struggle with it. Apple, like Microsoft, have a very clear idea of **HOW** you should use software. Any software. Steve Jobs even said: "You're **holding** it wrong!" Like seriously, WTF? But anyway, I paid a chunk for the software at the time, and haven't used it for a while now. I need to get used to its quirky behaviour and yeah, going to make some videos.

When I recorded my little 'coffee' footage, I installed my GH5 on this industrial-strength, professional-grade fluid-head U-Beaut tripod. You need to see this thing: you could prop up a house with it. Made my GH5 feel like a pimple. Overkill. Thing is: just like with the camera, I need to get familiar with how it works. So, I'll set it up here and there and do footage of stuff. It's just not the sort of tripod for *run-n-gun* stuff.

Anyway, here's a little "Making Coffee" video:


<div style="position:relative;padding-top:56.25%">
  <iframe src="https://customer-ze4n45l8rqsb9yse.cloudflarestream.com/8cd2f116617fd567782e073f7fb11311/iframe"
          allow="accelerometer;gyroscope;autoplay;encrypted-media;picture-in-picture"
          allowfullscreen
          style="border:none;position:absolute;inset:0;width:75%;height:75%"></iframe>
</div>


When Julia has her "Arty-Farty" art groups on Wednesday, I'm the designated barista for their morning tea. This lovely Bezzera -- yes, a proper **Italian-made** expresso machine -- is more than up to the task. New, they run somewhere between AUD $3500 and $5000 ... but I never buy new if I can help it. This one is from a mob who sell and service Bezzera machines: I picked it up for $1600. It will outlast all of us, our cars, most likely even the house. It's built like a tank. And it makes brilliant mochas, capuchinos, lattes, flat whites ... haven't gotten into that whole barista-art thing yet, but the girls get great coffee so no-one's complaining.  

By the way, the music was the 3rd sketch I wrote. There's another thing I want to spend a bit more time doing: writing music. Not enough hours in the day.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">







### ComfyUI and SRPO

**17.Oct.2025**   
Python has this odd behaviour: it will generate error messages that impart exact NIL information to *most* users, and, I would warrant, though I can't be sure, many developers. I've learnt not to trust Emily on things, either ... even some of her css (cascading style sheets) stuff has been a bit dodgy. Remember that old adage: garbage in, garbage out. *Similar to: elect clowns, expect a circus*.

I kept getting this error in one of Sharvin's workflows, in the ImageResizeKJv2 node: it kept spitting the dummy with: "start(0) + length(832) exceeds dimension size(64)". Wrote Sharvin about it: his reply was, "Thanks! I tried it with an image of the same dimensions and didn’t get that error. Would you be able to share the input image and the workflow (with the image added) from when you encountered the error? GitHub link if possible. I can test it on my side to check what’s going on. Yes! I'll be happy to see your version of the workflow!"

I tried the workflow again after a few days, and to my surprise.... no dramas. So, I thought he should know: " @CodeCraftersCorner   Just re-downloaded and re-ran this workflow again. No dramas this time: works a treat. Might tweak it a bit and finally subgraph it ... I've been going absolutely like a house afire converting all my workflows into tidy little subgraphs, thanks to your excellent tutorial on that a few videos back. Thanks Sharvin!"

Yeah, except when I tried it with another image, it gave me the **same error again**.

Something about this rang vaguely familiar. Both images were PNGs, both were 2048 x 2048 px... the only different was that one had an alpha channel, the other did not. The problem seemed to arise with images without an alpha channel, so I added one to the 'defective' image and:

"Just a little observation. This seems to be a case of the Python error revealing nothing to the uninitiated in Python (like me). This is a repeatable error: if I drop, say, a PNG into the load image that has no alpha channel, the ImageResizeKJv2 node spits the dummy with: 'start(0) + length(2048) exceeds dimension size (65)'. The image I loaded was 2048 x 2048px. I loaded the image in GIMP and added an alpha channel. Threw that into the LoadImage and the workflow happily chugged away processing it..."

I like to follow [Sharvin](https://www.youtube.com/@CodeCraftersCorner) because 1. he's cool, 2. he programs in Python and 3. his reviews and subsequent workflows in ComfyUI are next-level.

BTW, so what is an alpha channel? It's what allows 'transparency' in an image. The PNG format supports alpha channels, JPGs do not. However, you cannot assume that every PNG is going to have an alpha channel. Good to know.

---

SRPO is an incredible flavour of Flux1-Dev! I have but barely scraped the epidermis - not even enough to elicit a capillary response - of Flux, let alone any of the subsequent flavours. I'm still messing with Kontext, for cryin' out loud.

Creating low-ranking adaption is enormously rewarding. What is a low-ranking adaption? A LoRA is a tiny model **YOU** build to create a consistent character. If you wish to create a novel with illustrations where the character's looks remain the same, your image generator's ability to respect character consistency is crucial.

Enter the LoRA, which works together with your base model. When you generate an image, you typically provide a prompt, like:


<a href="/assets/images/emily/45-Robyn1.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/45-Robyn1.jpg" alt="Dude" width="280" align="left"></a>

<a href="/assets/images/emily/45-Robyn2.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/45-Robyn2.jpg" alt="Victorian lass" width="280" align="right"></a>


"A portrait of a short somber 16yo youth with long wavy messy brown hair. moimeme3 The person is wearing a fitted white cotton shirt with sleeves turned up and baggy jeans. The person is in a hairdressing salon. He is sweeping up from around the salon chairs. His hair is messy. Background is a room with pale white curtains on the windows and mirrors and roses in vases. Ultra-high detail, photorealistic rendering, sharp focus on on the fine textures on the hair, and rich environmental depth."

And you get the image of a guy in a shirt. Or, you give it this prompt:

"The photograph depicts a Victorian-era woman standing next to an old steam train. She has fair skin, light brown hair styled in a loose updo. Her dress is long-sleeved, black with intricate lace details on the bodice and sleeves, and it features multiple layers of ruffled fabric at the hem covering her shoes so they are barely visible. The dress buttons up the front and she wears black gloves that reach her upper arms. She holds an aged brown leather suitcase with metal clasps and a slightly worn appearance by the handle with her gloved hand. Her facial expression is serious and slightly contemplative. The steam train beside her has a dark metallic exterior with visible rivets and numbers "15" on the side. In the background, another car of the train is visible, painted in maroon with yellow accents. moimeme3 The background shows a dimly lit train station with arched ceilings and hanging lights. The walls are lined with dark wooden panels and vintage posters. The platform extends into the distance, fading into bright light at the far end. A yellow safety line is visible near the edge of the platform. Fallen leaves scatter on the ground beside her. The overall mood is gothic and melancholic, with a sense of timelessness. The photograph emphasizes textures such as the lace of her dress, the polished wood of the station, and the aged leather suitcase. The woman's expression is slightly pensive, adding to the somber atmosphere. The image combines elements of historical fashion with a modern photographic style. The overall color palette of the image includes muted blacks, browns, and grays, with subtle highlights from the golden brooch and metallic elements of the train. The photograph has a slightly dark and moody tone, emphasizing the Victorian era setting. The textures in the image are rich, particularly in the woman's dress fabric and the old leather suitcase."

And, you get the image of a Victorian lass.

Both of these images have one thing in common: the character. In the prompt, the LoRA is referenced with 'moimeme3'. Flux does all the rest. It's pretty amazing how well it works, to be honest.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">








### Trip to Brissie

**17.Oct.2025**   
Decided to have a day away from home. Drove to the Ormiston station, and caught the train. Fifty cents, half a dollar ... like seriously, why wouldn't you take the train?

First stop in going to be 'my' coffee shop in Milton: they're the only place in Brisbane area that serve the Artisti-brand coffee. I can actually ask for the "Delicate" roast, which is the one I get at home.

After that, I might go into the city and call in at Ted's Cameras, see if they have a variable neutral density filter and a hand grip.

The whole point to today is to *walk*! Lots!

---

Which, I did. First stop was 'my' cafe in Milton, the one that serves Artisti coffee. It was closed. As in: the coffee machine was gone. Moving out. No longer trading. 🥺 😢

---

Next stop was Ted's Cameras for an Variable ND filter and a better camera bag. The filter was dear, but I got it anyway. No luck on the bag. Wandered all over Queen St Mall and never found one. Finally decided it was time for a break, and called in at [Room with Roses](https://roomwithroses.com.au/), a charming high tea venue in the heart of the Brisbane Arcade. Even got to say hi to Vicki Pitts, the owner. Finally, much refreshed, decided to call it a day in this hot and humid city.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">







### Garden Work

**19.Oct.2025**  
Finally pulled the finger out and did a [bit of work](../other/Garden25.md#garden-bed-liner) on the last garden bed that needed a liner putting in. Not nearly as much fun as Qwen, to be honest. 🤨🤨🤨🤨🤨




### Qwen, and How!

**19.Oct.2025**  
Another day, another model. This time, it's Qwen. Just starting to explore this.   
*Please note: all images in this section are clickable for a larger version*.

This is **CRAZY** good! The quality of the output has me seriously blown away. I'm just getting started but... expressions:

<!--
<style>
  .flex-container {display: flex; gap: 20px;}
  .column {width: 100%;}
</style>
/-->

<div class="flex-container">
  <div class="column">

    <a href="/assets/images/emily/46-1Serene.jpg" target="_blank" rel="noopener">
    <img src="/assets/images/emily/46-1Serene.jpg" alt="Serene" width="280"></a>

    <a href="/assets/images/emily/46-2Cross.jpg" target="_blank" rel="noopener">
    <img src="/assets/images/emily/46-2Cross.jpg" alt="Cross" width="280"></a>

    <a href="/assets/images/emily/46-3Happy.jpg" target="_blank" rel="noopener">
    <img src="/assets/images/emily/46-3Happy.jpg" alt="Happy" width="280"></a>

  </div>
</div>

Serene, cross and happy.

All I had to do was change the prompt.


<a href="/assets/images/emily/47-1Market.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/47-1Market.jpg" alt="Happy" width="280" align="right"></a>


Okay, how about a change in the background: summertime in an open-air market? And, the hair? A Victorian updo. Change the prompt, and you get output that is truly uncanny ... only because the model actually *obeys* the prompt.

Qwen is unreal. It is open-source, unlike Flux. I haven't even tried it for video yet: just seeing it applied to images -- particularly the **quality** of the output, which is superb! -- has left me speechless.

So, what *IS* Qwen? The [QwenAI blog](https://qwen.ai/blog?id=7a90090115ee193ce6a7f619522771dd9696dd93&from=research.latest-advancements-list) 'explains' it, but yeah, I'm as undamaged by the information as the next person. 

However, when you scroll down that page, it claims you can restore photos. I still have some old family photos from a collection Nathalie sent me -- at least, I *think* it was her. Might have been Esther. Anyway:

<div class="flex-container">
  <div class="column">

    <a href="/assets/images/emily/47-2Tamara.jpg" target="_blank" rel="noopener">
    <img src="/assets/images/emily/47-2Tamara.jpg" alt="Tamara" width="280"></a>

    <a href="/assets/images/emily/47-3Tamara.jpg" target="_blank" rel="noopener">
    <img src="/assets/images/emily/47-3Tamara.jpg" alt="Tamara" width="280"></a>

  </div>
</div>

Need I say more?

---

Okay, off to bed -- need to finish that garden bed tomorrow.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">








### Gardens and Qwen


<a href="/assets/images/emily/48-1Enjoyment.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/48-1Enjoyment.jpg" alt="Where" width="360" align="right"></a>


**23.Oct.2025**  
It's Thursday, and it's going to be hot: 35°C. And it's humid. So, I'm doing *nothing* outside today except watering the garden.

**LoRAs not Happening**  
Yesterday, I was trying to follow Emily's guidance on LoRA creation: we're talking hours of trying this, that and the other. So, it culminated in: my hardware simply wasn't on board with it. A 16gig VRAM graphics card is sort-of a middle-of-the-road graphics card, balancing affordability (if you can justify spending AUD $700+ for a graphics card, then it's *affordable*) and power. Sure, I lust after the 24gig cards, but at the moment they are at a pricepoint (~[AUD $4000](https://www.umart.com.au/pc-parts/computer-parts/graphics-cards-gpu-610?mystock=1-6-7&filter_attr=0.193272.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0)) that put them firmly out of my reach. Working within that framework (16gig VRAM / 64gig RAM) should be plenty for creating basic LoRAs using a few (<25) images in a dataset, I should think. Full-character dataset LoRAs? not so much.

Despite all our tweaking of FluxGym's environment -- FluxGym is the alternative  to Kohya Script, for dummies like me, for creating LoRAs -- I never was able to create a LoRA using a 70-image dataset. So, I think -- and I shared this with Emily at the time -- that > 60 images for my use-case is overkill. It's about a **face**, that's it. The body ... well, Flux.1 or SRPO or even Qwen will probably have some decent suggestions. 

The big challenge now isn't consistent characters: I think I've got that sorted. The image of the lass in the red dress with the glass of red was created using a LoRA I made last night with a 20-image dataset -- after those hours of futility following *Emily's* thinking that >60 images were essential for a decent LoRA -- and I think it works reasonably well.

---

**Art In Practise**  

<a href="/assets/images/emily/48-2Enjoyment.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/48-2Enjoyment.jpg" alt="Where" width="360" align="left"></a>

<a href="/assets/images/emily/48-3Enjoyment.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/48-3Enjoyment.jpg" alt="Where" width="360" align="right"></a>



Explainer: For those who might be curious, thought I'd just throw this out there. I have an email address: robynsveil@gmail.com.  
I [publish music I write](https://musescore.com/robynsveil) under the name 'Robynsveil'.   
**That name has significance, particularly the second bit**. It refers to a person that simultaneously doesn't exist and yet exists. There are aspects of life one would never be able to experience: may I introduce you to **our imagination.**

The tools we have now enable us to explore aspects of life the would have been forever denied us**.


<a href="/assets/images/emily/48-4Enjoyment.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/48-4Enjoyment.jpg" alt="Where" width="360" align="right"></a>


That face of the lass with the wine, as well this lass sitting in a café in Paris, and a lot of faces on this page and elsewhere, ware created using a real-person face (mine) as a *base* using the model Qwen -- through highly laborious, painstaking, multi-queue trials and fits and starts -- but finally, successfully age-regressing (and altering) that face. It retains the original essence of the canonical image (of *me*) but allows an exploration of a new, interesting, compelling existence in the sparkly clouds and sunshine of the imagination. For me at least, this is the purpose of **ART**, *in a way*. After all, what else is art, but a reflection of the artist's view on life: wishful thinking? or an appalled exposé? ... or *something else*? 

I remember my violin instructor, when I told her I was getting into AI-imaging, asking me with a vaguely suspicious look on her face: "what are you going to *do* with it?" Fair question. To be honest, I don't think she believed my answer. It is *SO* natural for people to assume the worst: totally human nature. I get it. So many folks create a lot of slop these day using AI. No question the internet -- and now, AI -- has opened the way for the creation of a lot of horrific stuff ... **BUT** it has also been a doorway to opportunity! I would still be living in the States -- horror of horrors!! -- if it weren't for the internet.

AI, and Flux/SRPO/Stable Diffusion/ComfyUI let me explore the imaginative side of life, write "What If" stories, explore other worlds, other existences. It's *my* practise of art.

---

Got another 'bee-in-my-bonnet'... think I might do a bit of video exploring -- shoot a bunch of footage with my GH5 -- and make some videos to post on YouTube. Just a thought. 

<hr style="height:4px;border-width:0;color:pink;background-color:pink">







### Gardens and Qwen


<a href="/assets/images/emily/48-5Enjoyment.jpg" target="_blank" rel="noopener">
<img src="/assets/images/emily/48-5Enjoyment.jpg" alt="Where" width="360" align="right"></a>


**23.Oct.2025**  
Picked up Eddie from his day-care and took him to his swimming lesson. Got some footage from all that on my GH5: need to edit it first. No one does all that shit anymore. They 'film' and upload and make money. 

So, that makes me weird and pedantic. So be it.

Oh yes. **YES!!** I am definitely pedantic, with a generous side of *weird*. Evidence:   
- I use Linux instead of Windows  
- I avoid social media (FB, Insta, WhatsApp)  
- As a bloke, I wish I weren't, hate the masc. aesthetics (self-cancelling phrase)   
- Basically a hermit, can't do 'small talk', over-think things, 'Woke' writ large  
- Re-use instead of recycle   
- compost all waste biomass  
- Reuse (soak in NappySan) Chux Superwipes
- feed vermin away from the house in the compost tower so they leave our house/garden alone  

I do most of the housework because **I want it done a specific way**  
- Stacking the dishwasher must be done to optimise water flow around dishes  
- I dry clothing on a portable rack *in my office* to prevent clothing sunburn and horsefly bites  
- All clothing is *folded* properly before it is put away, including fitted sheets (there's a technique)  
- Don't even get me started on making coffee   
- Don't go to bed with a dirty kitchen (YUCK!)   
- Empty surfaces are best. Minimal clutter. No shit everywhere. Just **EMPTY**.  
- HUGE on getting rid of stuff -- decluttering. Haven't loved it? Get rid of it!!  
  
And weird in other ways too. Of course.

And, 


<hr style="height:4px;border-width:0;color:pink;background-color:pink">


27701134









<!-- NEXT ENTRY HERE!!!  /-->

**Note**: *New posts will now show up in natural order, as they occur*.

<hr style="height:12px;border-width:0;color:pink;background-color:pink">

[Back to the Main Page](../index.md)
