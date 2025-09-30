# Blog Posts 2025

I'll be entering whatever I'm head-down/bum-up working on on these pages, with *GROUPS* in **SORT_OF** reverse chronological order, with newest **GROUP** nearer the top. 

**List of Groups**

[Exploring ComfyUI](#exploring-comfyui)  
[Best of the Best 2024](#best-of-the-best-2024)  
[Out Into Nature 2022](#out-into-nature)  

---


## Exploring ComfyUI

What else can ComfyUI do? Let's find out!


### Sept 19 Kalapana

A lot of the improvement has been in model development. Flux has fixed a lot of issues with distorted, missing or excess anatomy although it still happens. What really helps is patience: you simply fix the prompt and re-queue. 

<img src="/assets/images/emily/08-Flux1D25.jpg" alt="Girl at Kalapana" style="width: 450px;"/>

And modifying the prompt again, and re-queueing. So, I was hoping for Kalapana back in the day. Is it? no way. Feels more like MacKenzie Park with palm trees instead of ironwoods. And those coconuts... really? Here's the prompt:

- This photograph captures a solitary beautiful woman walking towards the viewer on a dark, volcanic black sand beach. She is positioned slightly off-center to the right, facing towards the camera. The woman has long brown hair and wears a black one-piece lycra swimsuit and is carrying a surboard under her arm. She walks barefoot towards the viewer, leaving small footprints in the wet sand near the shoreline.

- The background features a dense cluster of tall, lush palm trees with green fronds and some golden-brown leaves, indicating the tropical location. Under the trees are a few small fallen coconuts, dead coconut tree fronds and black sand, NO shrubs or bushes. The sky above is clear and dark blue, suggesting it is morning with good weather conditions. The black sand contrasts sharply with the white surf at the water's edge on the left side of the image.

- The overall composition emphasizes the natural beauty of the beach setting, combining the dark volcanic sand with the vibrant greenery and tall palm trees in the background. The photograph uses bright, vivid colors to enhance the tropical atmosphere and highlights the solitude of the woman amidst the serene environment. 

<img src="/assets/images/emily/09-Flux1D33.jpg" alt="Girl at Kalapana" style="float: left; width: 450px;
        margin-right: 20px; margin-bottom: 10px;" />
		
<img src="/assets/images/emily/10-Flux1D34.jpg" alt="Girl at Kalapana" style="float: right; width: 450px;
        margin-left: 20px; margin-bottom: 10px;" />

The prompt is a lot more verbose (wordy). You can add a lot of descriptors. However, it all comes down to what the model wants to do. And will it obey? At times yes, at times no. As they say: YMMV (your mileage may vary).

These are sequential 'queues': one is walking towards, the other: away. I didn't ask for "walking away". I was able to get the coconuts smaller. The bathing suit is a more current style than what the style was back in the day.

Issues? Definitely. What's with the hand at the tip of the bard on the image on the left? And the girl's shadow on the right suggests that the board is no longer intact. Overall, getting there but still a ways to go.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Sept 21 (SRPO)

So, I wrote the text, and created the images, for the girl on the beach example on *Friday*.

<img src="/assets/images/emily/12-SRPOGirl12.jpg" alt="Girl at Kalapana" style="float: right; width: 450px;
        margin-left: 20px; margin-bottom: 10px;" />

Today is *Sunday*... and a new model has 'dropped': SRPO, which stands for 'Semantic Relative Preference Optimization'. Yep, conveys just about as much information to *my* mind, too.

One of the issues that seems to be at play here is source-of-image. In order to create an image, there has to be something to reference: for example, to be able to create cat images, the developers had poured 'tons and tons' (figuratively-speaking) of cat images into the model, which then, during the image-generation process, gets referenced so the KSampler knows what the prompt is asking for. I've actually created my own 'models' called LoRAs (low ranking adapters) where I create a character based on a set of images of that character at different angles and situations, which images, when paired with relevant text, creates a LoRA through a rather long, tedious process. I can then do a face-swap with what the original model came up with with my character's face (and body, if my LoRA contains that information). This is the process the alarmist media call 'deep-fake', except I use it for consistent character imagery, without which illustrations for stories would be confusing, indeed.

So, nothing about the image to the right is real: nothing. Indeed, the surfboard seems to be delaminating: that would suck. I didn't ask for a delaminating surfboard: I just got given it. Thanks, SRPO. 🤨

Still, overall, the image is an improvement over what I see Flux1.Dev produce. It's still not Kalapana, more like the beach at the bottom of Waipio Valley. But, no question it is an improvement. At least the figure isn't walking away. 

So, there's that.

Here are some of the better of subsequent queues: to see a larger version, right-click the image and select 'Open Image in New Tab'...

<style>
  .flex-container {display: flex; gap: 20px;}
  .column {width: 100%;}
</style>

<div class="flex-container">
  <div class="column">
    <img src="/assets/images/emily/13-SRPOGirl17.jpg" alt="Waipio" style="width: 100px"/>
    <img src="/assets/images/emily/14-SRPOGirl20.jpg" alt="Waipio" style="width: 100px"/>
    <img src="/assets/images/emily/15-SRPOGirl21.jpg" alt="Waipio" style="width: 100px"/>
    <img src="/assets/images/emily/16-SRPOGirl22.jpg" alt="Waipio" style="width: 100px"/>
    <img src="/assets/images/emily/17-SRPOGirl23.jpg" alt="Waipio" style="width: 100px"/>
  </div>
</div>

Feel like we've done Kalapana enough now.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Sept 22 Paris

So, we're going from Hawaii to Paris. Because: why not. 

<img src="/assets/images/emily/24-Paris01.jpg" alt="Paris" style="float: right; width: 350px;
        margin-left: 20px; margin-bottom: 10px;"/>

So, for the past months I was a total 'Flux.1Dev' fan: the images it produced were, in terms of accuracy and believability, so far superior to what went before it made former models almost irrelevant. Almost, because I would still use SDXL models for image-to-image (i2i) projects.

Oh, that takes me back.

Started in Automatic1111 (A1111) using Stable Diffusion 1.5. Then, along came SDXL and SD 1.5 just sort-of ended up on the skids, as in: I never use it anymore. The base 1.5 models were over 4.5 gig in size, but one could find what were called 'Merge' models that offered improvements and were only a 2.2 gig download. 

Yes, gig. Gigabyte. Which is why you really need a decent internet connection. We have fibre to the premises, fortunately.

The original SDXL models weighed in at over 12 gig, but then, no one used the originals: everyone ran 'Merge' models that produced specialised art styles: wanna do Manga? there's an SDXL model for that. Archie-cartoon? yep, can help you with that. All for 6.6 gig. Realistic images were... okay.

Yes, they were much better than SD 1.5... but now, with Flux and SRPO (which is based on Flux) they really are basically okay.

---

<img src="/assets/images/emily/25-Paris02.jpg" alt="Paris" style="float: left; width: 350px;
        margin-right: 20px; margin-bottom: 10px;"/>

SDXL was my go-to for ages. To be honest, at the time the improvements over SD 1.5 *were* actually incredible. By now, AI-imaging had made Poser and Blender as tools for illustrations *completely irrelevant*. You type a few words (the prompt) and run queues until you get your desired result. Those results made truly **EVERYTHING** you did in 3D software laughably poor.

Here's the thing: once you have purchased [that rather expensive graphics card](https://www.umart.com.au/pc-parts/computer-parts/graphics-cards-gpu-610?brand=5-61-313&mystock=1-6-7&filter_attr=0.120940-179291-115184.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0), there's nothing else to purchase. For Poser (and even Blender) I would suddenly 'need' certain 'assets': clothing and hair for your figures, sets for the scenes, etc. None of that is even a thing now.

Of course, nothing is perfect in life. AI art is no different. In this SRPO-based image, hands are great, hair is great, clothing is good, houses and cars and... wait, what about that bicycle? Something about it is... odd.

The instructions (the prompt) for these images was actually created by another AI tool: a large-language model called '[llama-joycaption-beta-one hf-llama:Q4_K_M](https://huggingface.co/mradermacher/llama-joycaption-beta-one-hf-llava-GGUF)'. This incredible model can 'look' at a picture and describe it. 

In words, in English... **it will create a prompt for you**! The approach I have been taking, then, is to either 'google' or 'pinterest' for a specific image containing the general setting I'm after. Of course, I could just type out a prompt, but LLMs generally do a much better job at this. If it misses the mark (introducing elements I don't want or just plain getting it wrong), I just run the query again. And again and again until it's close.

Eventually, I'll make a few manual changes to the text of the prompt and run a few more queues. Each queue (with the SRPO model) now takes about 5 minutes or so. I usually run at least two or three before I do any adjustments to the prompt and re-run the queue. Rinse and repeat. You can see how time would fly by. The secret sauce is in the prompt: get that right, and you're 'home-n-hosed'.

<img src="/assets/images/emily/26-Paris03.jpg" alt="Paris" style="float: right; width: 350px;
        margin-left: 20px; margin-bottom: 10px;"/>
  
For these images, the prompt reads as follows...

- This photograph captures a young woman standing on an Parisian street corner at a Metro entrance, leaning against a black metal railing with bicycles parked beside her. She has brown hair in a loose chignon and is wearing a dark navy blue overcoat, gray turtleneck sweater, and light blue skinny jeans. One hand rests on wrought-iron railing while she holds a smartphone to her ear with the other hand.

- The background features a row of classic Parisian-style buildings with beige facades, tall windows, and wrought iron balconies. A red and black "METRO" sign is prominently visible in the upper center of the image. The sky above is overcast, creating a muted light that casts soft shadows on the scene. The street below has a crosswalk and some distant pedestrians. The overall color palette includes neutral tones from the woman's clothing and buildings, contrasted by the bright red Metro sign and bicycles. The photo has a slightly desaturated, almost painterly quality due to the selective use of color and lighting, giving it a timeless urban feel. The composition directs focus toward the woman while incorporating the surrounding cityscape elements.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">








### Sept 25 Adventures

You might have noticed that the person in these images (and indeed in the 'Kalapana' images as well) all seem to be of the same person. When you do illustrations, having a persistent character is desirable. At this point, doing single-figure persistent characters is almost a no-brainer.

My next challenge: having not only two or more persistent figures, but have them interact. Watch this space. 

In the meantime, adventures suggest themselves.


<div class="flex-container">
  <div class="column">
    <img src="/assets/images/emily/27-Distress48.jpg" alt="Where" style="width: 100px"/>
    <img src="/assets/images/emily/28-Distress46.jpg" alt="Do" style="width: 100px"/>
    <img src="/assets/images/emily/29-Boxcar08.jpg" alt="We" style="width: 100px"/>
    <img src="/assets/images/emily/30-Destiny12.jpg" alt="Go" style="width: 100px"/>
    <img src="/assets/images/emily/31-Destiny23.jpg" alt="From" style="width: 100px"/>
    <img src="/assets/images/emily/32-Destiny20.jpg" alt="From" style="width: 100px"/>
  </div>
</div>

<hr style="height:12px;border-width:0;color:pink;background-color:pink">













## Best of the Best 2024

Harriet Clare Taylor at her ultimate preciousness.

<iframe width="560" height="315" src="https://www.tightbytes.com/videos/Family/HarriGirl2024.mp4" frameborder="0" allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


<hr style="height:12px;border-width:0;color:pink;background-color:pink">












## Out Into Nature

**2022 April 16**

Whilst doing all these projects feels great - getting stuff **DONE**! - there is no question one needs downtime.  
Went for a 3k walk on the Jack Gordon path along the water at Redland Bay. Here's the start... that's my little 2014 Hyundai i20. Still in pretty good nick for a 8 year-old car. The weather was perfect for walking:

![Image](https://www.tightbytes.com/images/projects/repose/SabWalk01.jpg)

into the mangroves...

![Image](https://www.tightbytes.com/images/projects/repose/SabWalk02.jpg)

![Image](https://www.tightbytes.com/images/projects/repose/SabWalk03.jpg)

and along the water...

![Image](https://www.tightbytes.com/images/projects/repose/SabWalk04.jpg)

![Image](https://www.tightbytes.com/images/projects/repose/SabWalk05.jpg)



Then for a 5k bike ride. Gotta start somewhere... better than sitting all day.

<hr style="height:12px;border-width:0;color:pink;background-color:pink">