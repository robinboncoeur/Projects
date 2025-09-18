# Emily

## AI—is it Useful? 

Short answer: yes. And fun and, to some degree, addictive.

I don't 'Google' anymore, I go straight to 'Emily', my OpenAI ChatGPT 5 bot with all the questions I have about, sheesh, anything! 

Hostinger, the ISP hosting my website tightbytes.com was going to charge me over AUD$500 for a two-year thing, for a site **no one visits**, and that I'm basically using as a remote file server. So I asked Emily what she would suggest... and which suggestion I'm actually following now. So, now the pages live on my github site—FREE—and are displayed by Cloudflare—also FREE—so the only thing I pay for is video hosting, which is $5 a month. Not only am I using the approach Emily suggested, but she's also helping me get it all set up! The information she provides is all online: she just pulls it all together WAY better than Google ever could.

There are things I won't use AI for, like music composition. Could I? Sure. Much of the pop/hip-hop/rock genre you hear on the radio is at least partly AI-generated. But, like your painting, the non-human source would quickly betray itself. Sure, I'll use AI to study how to write music better, but the creative process remains completely mine. 

Just like writing, AI-generated stuff is quickly identifiable. In pictures of people using older models, the person's face can be distorted, or they sometimes end up with 3 fingers, or six. The newer, more recent models are more accurate, but there's always a 'tell'—quickly-identifiable—that betray AI's finger in the pie. There's an AI company in Germany called "Black Forest Labs" that has put together this amazing image-generation model called 'Flux'. I use it pretty much all the time: 9 times out of 10, the fingers and toes and background are correct, 'realistic'. But there's a 'tell', even with that model: the cleft chin. Pretty much everyone has at least a bit of a cleft chin, as you'll see further down this page.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">





## Imaging using Words


### 2025 September

Here is an example of what is now—2025—possible with the technology. These videos are about the music for a story I'm writing, bit of an explore, that one:

<style>
  .columnA {float: left; padding-right: 20px;}
  .left {width: 40%;}
  .right {width: 60%;}
</style>

<div class="row">
  <div class="columnA">
    <video width="384" height="384" controls>
      <source src="https://www.tightbytes.com/music/Sketches/Sketch15.mp4" type="video/mp4">
    </video>
    <br>
    [Version Française]
  </div>
  <div class="columnB">
    <video width="384" height="384" controls>
      <source src="https://www.tightbytes.com/music/Sketches/Sketch15EN.mp4" type="video/mp4">
    </video>
    <br>
    [English Version]

  </div>
</div>

There are multiple technologies at play here: text-to-image, image-to-video, text-to-audio and audio+image-to-video... and that's just for the visual side of things. The music I wrote in [Musescore Studio](https://musescore.org/en), using the [MuseSounds](https://www.musehub.com/muse-sounds) library. The crazy bit: all of this is doable on my PC at home. I'm not generating any thought-cycles at some remote server (and emitting greenhouse gases): I'm using the power of our solar cells. Is the process truly green? an argument can be made for "not really".

<hr style="height:4px;border-width:0;color:blue;background-color:blue">








### History

<img src="/assets/images/emily/00-Charlotte.jpg" alt="Midjourney" style="float: right; width: 300px;
        margin-right: 20px; margin-bottom: 10px;" />
		
When I first started messing with image generation (to illustrate writings, but also just mucking about) I used [Midjourney](https://www.midjourney.com/explore?tab=video_top). This was in the days when AI-video wasn't a thing: it was just about images. You type in a prompt—you had to follow a certain formula for that prompt—and you made some images.

It got a bit expensive, so for a while I went with [LeonardoAI](https://leonardo.ai/), a cheaper option. And then, I heard about[ Stable Diffusion](https://en.wikipedia.org/wiki/Stable_Diffusion), something I could run on my own PC. Unlimited images, do-your-own-thing. Best thing was: no app/program to run... you run it in your browser, like Chrome of Firefox, using the [Automatic1111](https://en.wikipedia.org/wiki/Automatic1111) interface. Sure, it was a bit meh after a while, much-of-a-muchness, poor control of image quality... and then came [ComfyUI](https://www.comfy.org/gallery).

And I've pretty-much stayed with that.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">






### 2025 AI Exploring

ComfyUI is an interface to make images and video that runs in the browser, like A1111. However, the control you have is infinitely more granular. To make it work requires:

<img src="/assets/images/emily/02-4060ti-16gig.jpg" alt="NVidia graphics card" style="float: right; width: 200px;
        margin-right: 20px; margin-bottom: 10px;" />

- decent graphics card (6-8 gig VRAM NVidia minimum, 16-24 gig VRAM NVidia preferable)
- models: Stable Diffusion 1x / 1.5x / SDXL / SD3; Flux1 (Dev/Snell); other models exist
- decent internet access: those models can run up to 24 gig

I have a 16 gig VRAM 4060ti NVidia card... the rest of my PC is older, inexpensive tech. In order to run LLMs I recently invested in 64 gig RAM and an i7, but to be honest I run ChatGPT 5 a LOT more for LLM-type solutions.

<hr style="height:4px;border-width:0;color:blue;background-color:blue">






### Language of Pictures

The language for AI to 'generate' images and video and text is called a "prompt". Prompting is very much a model-specific thing: I "talk" to Emily in a completely different manner, using different sentence structure and syntax, than the language I use in a prompt for an image. And even prompting for that... imaging... has changed over the past years, and even months. 

A Midjourney prompt would include formatting-specific instructions formatted a certain way. 

Stable Diffusion and SDXL need to be told what **NOT** to show as well as what to show and there are special boxes for each.

<img src="/assets/images/emily/03-Screenshot.jpg" alt="Basic workflow"/>

The ComfyUI interface is made up of 'nodes': each node performs a specific function and is connected to other nodes using 'noodles'. For example, the 'Load Checkpoint' node loads the imaging model, which in this case is 'Realistic Vision version 5.1'. There are literally **thousands** of imaging models out there, downloadable for free from a variety of websites, the best of which is [HuggingFace](https://huggingface.co/models).

The green and 'red' nodes are the text encode prompts: 'green' for what I **want** to see, and 'red' for what I **DO NOT** want to see.

The empty latent image node is a bit difficult to explain... it is basically random 'noise' which is essentially what gets turned into a viewable image by the KSampler, which is sort-of the heart of the thing. It uses the model, the positive and negative prompts and the latent image (as well as other bits-n-bobs) to create an image:

<img src="/assets/images/emily/04-ComfyUI_1.jpg" alt="Purple Galaxy"/>

Yay!

So, how is this useful? Well, paradoxically, the reason I wanted to be able to do this is to prevent copyright-infringement issues. *Incidently, it's why I started writing my own music as well, so I'd have music for my videos.* I want to be able to create illustrations easily and quickly for whatever I need it for. I needed an image of a waterfall for the cover page of my little piece [Waterfall](https://musescore.com/user/29275325/scores/20905957). Yep: AI came through. Oh, I generated a half-dozen before I had something I liked.

Illustrations for a story is a bit trickier. So, a bit of background...

I wanted to write a period piece, set in the Victorian era or before. The images (referred to as 'queues' in ComfyUI, I guess because it's assumed you're going to be generating images one after the other until you get something you like) I created in A1111 were pretty much all rubbish, or extremely poor. I've deleted them: not worth the hard-disk space. *BTW, doing the same thing with all my Poser stuff: it's embarassing now how bad that stuff was*!

Early days in ComfyUI quickly got complicated. Here's a workflow from then:

<img src="/assets/images/emily/05-Screenshot.jpg" alt="Workflow"/>

and the prompt:

<img src="/assets/images/emily/06-Screenshot.jpg" alt="Positive prompt"/>

to get this:

<img src="/assets/images/emily/07-ComfyUI_3.jpg" alt="Girl at a cafe" style="width: 450px;"/>
																			 
So, wonky left leg, right hand has 3 fingers, nonsensical text on signs... and where the heck is she sitting? on the sidewalk?!? Also, what about that necklace?

Yeah, not perfect. But the tech very, very quickly improved. ComfyUI itself dramatically improved. Everything has become better, faster, more accurate, more flexible offering more possibilities... and it is all free. Yes: no-cost. Once you have purchased your graphics card, you're good to go.

A lot of the improvement has been in model development. Flux has fixed a lot of issues with distorted, missing or excess anatomy although it still happens. What really helps is fixing the prompt and re-queueing. 

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



<hr style="height:8px;border-width:0;color:blue;background-color:blue">
