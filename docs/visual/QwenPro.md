# Qwen Image Edit

## Discussion

[Q]  
Hi Emily. I'm using a new model - Qwen Image Edit All-In-One. It is brillant at combining 3 or even 4 images into one. I struggle with prompting, however. Are you familiar with Qwen's syntax for identifying the subject matter in the 3 images? I typically have one woman in picture 1, 1 girl in picture 2 and a scene in picture 3.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Prompt Basics

[A]  
Hey Robyn! Yep—Qwen Image Edit (the newer “2509 / All-in-One” builds) really can combine multiple inputs, and you can *refer to each image in the prompt* by number or role. Under the hood, this release added true multi-image support (best with 1–3 images) for combos like “person + person,” “person + scene,” and “person + product.” ([huggingface.co][1])

Here’s a prompt pattern that works consistently in ComfyUI:

* **Inputs**

  * Image 1: the *woman* (subject A)
  * Image 2: the *girl* (subject B)
  * Image 3: the *scene* (background)

* **Prompt template**

  > “Place **the woman from image 1** and **the girl from image 2** **into the scene from image 3**.
  > Stand the woman on the **left**, the girl on the **right**.
  > Keep both faces and hairstyles unchanged and photorealistic.
  > Match scene lighting and perspective; cast realistic shadows on the ground.
  > Full-body view, natural posture, looking at the camera.”

You can also be briefer and still be explicit, e.g. “Combine **person in image 1** with **person in image 2** inside **scene in image 3**; woman left, girl right; preserve identities; match lighting/shadows.” Guides and examples show that numbering images (“image 1/2/3”) or labeling them (“person/product/scene”) is the intended style for multi-image edits. ([replicate.com][2])

### ComfyUI tips that help

* **Node wiring:** Use the official multi-image edit workflow (or any fork that batches multiple Load Image nodes into the Qwen VL encoder). Many community graphs label this as **Multi-Image Edit (2509)** and pass an **image batch** plus your text to the Qwen encoder. ([GitHub][3])
* **Identity fidelity:** In your prompt, say “preserve identity/face from image X” and avoid style words that would reshape faces (e.g., “anime,” “caricature”) unless that’s your goal. This model explicitly improved identity consistency vs. earlier releases. ([huggingface.co][1])
* **Positions & relations:** Qwen follows simple layout directives well: “woman **left**, girl **right**, holding hands,” or “girl **in front of** woman,” “woman **sitting**, girl **standing**.” (This matches the “person+person” examples you’ll see in the official demos/tutorials.) ([Stable Diffusion Art][4])
* **Lighting & perspective:** Call these out: “match **late-afternoon warm light** of image 3; **same camera angle** as the scene; add **soft contact shadows**.” That reduces ‘sticker-on-background’ vibes reported by users learning the model. ([Stable Diffusion Art][4])
* **How many images?** 2–3 works best right now. Four can work, but Qwen’s own notes say optimal performance is 1–3 inputs. If you must use 4, consider pre-stitching two references first. ([huggingface.co][1])

### Ready-to-paste prompt snippets

* **Walking together:**
  “Place the **woman from image 1** and the **girl from image 2** into **the street scene from image 3**. Woman on the **left**, girl on the **right**, **holding hands**, mid-step. Preserve both identities and clothing; match scene lighting and color; add soft ground shadows; 3/4 view, waist-up framing.”
* **Portrait in a location:**
  “Use **the woman from image 1** as the subject in **the interior from image 3**. Put **the girl from image 2** **behind her** and slightly out of focus. Match indoor lighting and perspective. Preserve identities, natural skin texture, neutral expression.”
* **Product + people + scene:**
  “Insert **the handbag from image 2** on **the woman from image 1** and place both in **the boutique from image 3**. Shoulder carry, natural strap bend; consistent shadows; keep faces unchanged; high-end editorial color grading.”

### Troubleshooting quirks you might hit

* **One subject dominates:** Add “**equal emphasis for image 1 and image 2**; do not ignore either subject.” If it persists, slightly reword identities: “adult woman from image 1,” “young girl from image 2.” ([RunDiffusion][5])
* **Wrong background details:** Be explicit: “**use only the environment from image 3**; do not reuse backgrounds from images 1 or 2.” ([replicate.com][2])
* **Scene scale mismatch:** Add “**correct scale** so subjects fit naturally into image 3; adjust **perspective** and **shadow direction** to match the scene.” (This is a common fix in multi-image examples.) ([ThinkDiffusion][6])
* **Older workflows vs. 2509:** Early Qwen workflows faked “multi-image” by **stitching** references into one big image. The new 2509 model *natively* supports multi-image conditioning, so prefer a 2509-ready graph if you have it. ([Stable Diffusion Art][4])

If you’d like, tell me how you’re wiring your current ComfyUI graph (node names are fine), and I’ll tailor a drop-in prompt block for your exact setup—woman (img1), girl (img2), scene (img3)—plus small tweaks for identity lock and layout.

[1]: https://huggingface.co/Qwen/Qwen-Image-Edit-2509?utm_source=chatgpt.com "Qwen/Qwen-Image-Edit-2509 · Hugging Face"
[2]: https://replicate.com/qwen/qwen-image-edit-plus?utm_source=chatgpt.com "Qwen Image Edit Plus"
[3]: https://github.com/fblissjr/ComfyUI-QwenImageWanBridge?utm_source=chatgpt.com "fblissjr/ComfyUI-QwenImageWanBridge: qwen-image and ..."
[4]: https://stable-diffusion-art.com/qwen-image-edit-multiple-images/ "Qwen Image Edit: Multiple-image workflow - Stable Diffusion Art"
[5]: https://learn.rundiffusion.com/how-to-use-qwen-image-edit-2509-on-rundiffusion/?utm_source=chatgpt.com "How to Use Qwen Image Edit 2509 on RunDiffusion"
[6]: https://learn.thinkdiffusion.com/qwen-image-edit-2509-combine-multiple-images-into-one-scene-for-fashion-products-poses-more/?utm_source=chatgpt.com "Qwen Image Edit 2509: Combine Multiple Images Into One ..."

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Quick checklist


[Q]  
Sharvin from Code Crafter's Corner showed me how to wire things together - probably one of the simplest workflows in existence. It was prompting that was giving me dramas, Emily. For one, my prompts didn't result in personages I could recognise: they lost their identities. So, I'm going to try your prompt suggestions, one after the other. The first one you suggested has the two characters in the pose you specify, but again, there is signficant erosion of personality. How do I remedy this?


[A]  
Got you, Robyn. When identities “wash out,” it’s usually three things at once: weak references, conflicting style cues, and over-strong edit noise. Here’s a tight plan that fixes it without changing your simple graph.

#### 1) Feed stronger references

* Add **a second copy** of each person as an extra input: a **tight head-and-shoulders crop** (eyes ~300–500 px wide).

  * Image 1a = woman full body (what you already use)
  * **Image 1b = woman face crop** (new)
  * Image 2a = girl full body
  * **Image 2b = girl face crop** (new)
* Order matters: mention the **face crops first** in your prompt so Qwen “locks” them.

#### 2) Use an identity-first prompt (ready to paste)

Try this exactly, then tweak positions after identity is solid:

> **Use the woman’s face from image 1b and the girl’s face from image 2b without any change.**
> The woman’s full appearance comes from image 1a; the girl’s from image 2a.
> Place them into the environment from image 3.
> Woman on the left, girl on the right, standing close, holding hands.
> **Preserve facial identity, bone structure, skin tone, eye shape, nose, mouth, and hairstyles exactly as in 1b and 2b.** No beautification. No makeup changes.
> Match the lighting, perspective, and color of image 3; add soft ground contact shadows.
> Mid-shot (waist-up) framing; subtle smile; natural posture.

**Negative prompt (use if your node supports it):**
“Do not change identity, ethnicity, age, face shape, hairstyle, eye color, or skin texture. No smoothing, no glam, no anime, no stylization, no makeup changes, no face reshaping.”

#### 3) Soften competing aesthetics

* Remove adjectives like *cinematic, ultra-detailed, editorial, HDR, beauty, glamour* until the faces match. Those nudge the model to “improve” faces.
* Avoid style words (film stock, lens effects) on the first pass. Add them later once identity is nailed.

#### 4) Parameter nudges (typical ComfyUI knobs)

* **Denoise/Strength (edit strength):** 0.40–0.55 for composites. If faces drift, go **lower** (e.g., 0.40).
* **CFG/Guidance scale:** 4.5–6.5. High CFG (8–12) tends to rewrite faces; start at ~5.5.
* **Steps:** 28–36 is ample; more steps ≠ better identity.
* **Resolution:** Start identity passes at a **closer crop** (e.g., 768–1024 px tall portrait). Once faces are right, rerun wider framing.

#### 5) Layout choices that help identity

* First pass: **waist-up** or even chest-up. Faces bigger = stronger lock.
* Second pass: widen to full-body *after* identity is good. Re-use the same seed and settings, just adjust camera/framing in the prompt.

#### 6) Two-pass “face lock” recipe (still with your simple graph)

1. **Identity pass:**

   * Inputs: 1b, 2b, 1a, 2a, 3 (in that conceptual order)
   * Prompt = identity-first text above
   * Framing = waist-up
   * Output A
2. **Widening pass:**

   * Feed **Output A** back as your “base image” (if your node allows) or simply re-run with the same prompt but add:
   * “Keep the same faces as the previous result; widen framing to full-body but **do not change faces**.”
   * Add your style words *now* if you want (film stock, lens, etc.).

#### 7) Tiny prompt toggles for stubborn drift

If one face keeps changing:

* Add: “**Give equal attention to image 1b and image 2b; do not ignore either face.**”
* Name them: “**adult woman from 1b**,” “**young girl from 2b**,” which reduces age/feature blending.
* If hair keeps changing: “**Keep the exact hairstyle, hairline, and parting from 1b/2b.**”

#### 8) Quick troubleshooting checklist

* Faces still off? Increase the **relative size** of the face crops (1b/2b). Re-export them sharper (no heavy JPEG compression).
* Over-smoothing? Add “**retain natural skin texture; no skin blur**.”
* Scene overpowering identity? Say “**Use only the background from image 3; do not borrow faces or clothing from 3.**”
* Shadows/scale uncanny? Add “**correct scale and perspective to match image 3; align shadow direction to scene light.**”

If you want, tell me roughly what denoise/CFG you’re running and whether your node exposes a negative prompt—I'll tailor the numbers to your exact setup.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">






### Prompt and Qwen Behaviour

[Q]  
Your suggestions have made a massive difference. Thank you. I have found the more I say about the room, the more the camera zooms out. The more I say about the women, the more it focuses (zooms in) on them.


[A]  
That’s a great read on its behavior—and you can totally steer it. Think of “zoom” as three dials you control: wording, canvas, and strength.

#### 1) Wording: lock the framing in plain English

Drop one clear line near the top of your prompt:

* **Stay wide (don’t zoom in):**
  “**Keep a wide establishing shot; full-body for both subjects; maintain the current camera distance and composition; do not crop faces or feet.**”
* **Medium:**
  “**Waist-up framing for both; keep the camera distance fixed; center-weighted composition.**”
* **Close:**
  “**Tight head-and-shoulders portraits; fill 70–80% of the frame with the faces; shallow depth of field.**”

Then describe the room/people **after** that line. If you notice it creeping, add one more guardrail:

* “**Do not change focal length or camera distance; adjust only poses and lighting.**”
* “**Use rule-of-thirds placement: woman left third, girl right third; leave negative space above.**”

#### 2) Canvas control (preps that beat the model to the punch)

* **Pre-crop or letterbox the scene (image 3)** to the field of view you want. If the background already “looks wide,” the model is less tempted to zoom.
* **Set the aspect ratio** that implies your framing:
  – Full-body two-shot: 3:2 or 16:9
  – Waist-up: 4:3
  – Tight portraits: 1:1 or 5:4
  Mention it: “**Use a 3:2 aspect; keep full-body in frame.**”
* If it keeps zooming out when you add room details, **move room detail into a separate sentence** like:
  “**Room details are background only; do not widen the shot to include more room.**”

#### 3) Strength & guidance (small nudges that matter)

* **Edit strength/denoise:** Lower = steadier composition. If it zooms when you talk about the room, drop from ~0.55 → **0.40–0.45**.
* **CFG/guidance:** High CFG can over-obey new details (zooming). Try **5–6**.
* **Seed discipline:** When testing framing language, keep seed fixed so changes are attributable to your prompt.

#### Drop-in prompt add-ons (paste as needed)

* **Keep wide:** “**Maintain full-body two-shot; unchanged camera distance; do not crop. Use the background from image 3 without expanding the field of view.**”
* **Keep medium:** “**Waist-up two-shot; maintain composition and subject scale; background is secondary.**”
* **Keep close:** “**Head-and-shoulders; faces fill 75% of frame; background softly defocused; do not pull the camera back.**”
* **If it still drifts:** “**Prioritize subject scale over new environmental details; ignore extra background if it threatens framing.**”

#### A quick workflow trick

Do an **identity pass** tight (waist-up), then a **widening pass**:

1. Pass A: “waist-up, fixed camera distance, preserve identity” → get perfect faces.
2. Pass B: “**reuse these faces unchanged; widen to full-body BUT keep the same camera height and subject scale**” (lower denoise here).

If you send me your current denoise/CFG and typical aspect ratio, I’ll tailor a one-liner you can reuse at the top of every prompt (wide/medium/close versions).

<hr style="height:20px;border-width:0;color:pink;background-color:pink">




## More Ideas

[Q]  
I downloaded this ages ago, Emily: Flux1-schnell-fp8.safetensors. It weighs in at 17.1 gig. Then, I have this NSFW flavour of Flux: flux1DevNSFWUNLOCKEDfp8.safetensors which is only 11.9 gig... actually smaller than schnell.


[A]  
You’re spot on that size ≠ speed. A few quick truths to anchor us:

* **Schnell vs Dev:** Schnell’s UNet is architected to sample faster. Even if a Dev checkpoint is smaller on disk (e.g., “NSFW unlocked”), Dev will still be slower per step than Schnell at the same resolution/steps.
* **File size:** A “fp8” that’s **17.1 GB** is almost certainly an un-“scaled” export or includes extras. It won’t be faster just because it’s fp8. The speedy ones are usually the **fp8 e4m3fn *scaled*** conversions (often ~5–8 GB).
* **Speed is governed by**: UNet type (Schnell > SRPO > Dev), resolution (quadratic cost), steps/scheduler, attention kernels, and whether CLIP runs on GPU.

Here’s how I’d flip your v3 to a snappier “v4” with what you have:

### Do this (fastest wins first)

1. **Switch UNet to Schnell**
   In **UNETLoader** set model path → `Flux1-schnell-fp8.safetensors`.
   (Keep your current DualCLIPLoader + hooks; they’re fine.)

2. **Sampler settings for speed**
   In **KSampler**:

   * `sampler: euler_a`
   * `scheduler: sgm_uniform` (or `simple` if that’s what your build prefers)
   * `steps: 16–18` (start at 18; you likely won’t miss 24)
   * `denoise: 1.0`
   * Keep Flux guidance ~**3.3–3.7** (your 3.5 is perfect)

3. **Resolution**
   You’re at **896×896** now. For speed: try **768×768** (about 26% fewer pixels); if you need more detail, add a tiny **hi-res pass** after (e.g., 768→896 with 0.35–0.45 denoise). One small upsample pass is often faster than running 24+ base steps.

4. **CLIP on GPU for inference**
   In **DualCLIPLoader**, set device **cuda/auto** (not CPU). With your `schedule_clip=false` on both `SetClipHooks`, CLIP won’t re-encode every step, but keeping it on GPU trims latency spikes.

5. **Attention kernels**
   Ensure your Comfy build uses **xFormers/SDPA**. (Most do by default; if there’s a global toggle, keep it on.)

6. **Mask math**
   If you drop base size to 768, scale your **BlurMask** radius from 48 → **32–36** so the blend edge stays similar but cheaper.

---

### When to consider different files

* If you can find a **schnell fp8 *scaled*** export (name often contains “e4m3fn_scaled”), use that over the 17.1 GB one. It’ll load faster and usually runs the same speed/quality.
* The **“NSFW unlocked Dev”** (11.9 GB) may be smaller, but it’s still **Dev**—expect slower sampling than Schnell.

---

### Mini speed preset (drop-in values)

* **UNet:** `Flux1-schnell-fp8.safetensors` (or an fp8 *scaled* variant if you have it)
* **Size:** 768×768 (then optional 1-pass upsample to 896 with denoise ~0.4)
* **KSampler:** `euler_a`, `sgm_uniform`, **steps 18**, denoise 1.0
* **Guidance:** 3.5
* **CLIP device:** cuda
* **BlurMask:** 32–36 @768 (48 @896)

If you want, I can patch your v3 JSON to a “Schnell-optimised v4” (same nodes, just swapped paths/values) so you can drop it in and run.

---

[Q]  
Downloading flux1-schnell-e4m3fn.safetensors now... 11.9 gig. Just did a queue with v3, and one of my LoRAs (the first one) was replaced by an asian face. :-/


[A]  
Nice move grabbing **flux1-schnell-e4m3fn.safetensors** — that’ll help with speed.
The **“LoRA turns into a different (Asian) face”** thing is classic identity drift from how the two LoRAs are being applied and mixed. Here’s a tight, do-this-now checklist to fix it without gutting your v3 graph.

### Fast fixes (in order)

1. **Make sure each LoRA applies only to its subject**

   * If both LoRAs are hitting the **same CLIP/UNet stream** with no spatial separation, they’ll blend and one can “win.”
   * Use your existing split: two **CLIP Text Encode (Prompt)** nodes → two **SetClipHooks** (LoRA A to CLIP A, LoRA B to CLIP B) → **Conditioning Combine/And Mask** with your left/right (or top/bottom) masks → into **KSampler**.
   * Sanity check: each mask should cover only its person; no big overlap.

2. **Set LoRA strengths sanely (per branch)**

   * Start with **UNet: 0.70, CLIP: 0.90** for each LoRA branch.
   * If identity still drifts on a branch, bump that branch’s **CLIP to 1.00–1.10** before touching UNet.
   * Don’t exceed **UNet ~0.85** unless you have to — it starts overriding base model features aggressively.

3. **Turn off CLIP scheduling**

   * On each `SetClipHooks`, set **schedule_clip = false**. (You already tried this earlier — keep it OFF.)
   * This prevents per-step re-encoding that can drift identity.

4. **Put CLIP back on GPU for inference**

   * In `DualCLIPLoader`, set **device = cuda/auto** (not CPU).
   * Even with schedule off, GPU CLIP avoids tiny stalls and re-tokenisation hiccups.

5. **Prompt hygiene (per subject)**

   * Keep each branch **short**, with the **trigger word first**:
     `roxygirl04, 25yo woman, soft lighting, three-quarter headshot, neutral expression`
     `celestesh-01, 25yo woman, soft lighting, three-quarter headshot, neutral expression`
   * Avoid descriptors that can implicitly pull toward another look (e.g., hair/eye colors that fight the LoRA).
   * In the **negative** (global), add gentle stabilisers like:
     `over-smoothed skin, extra face, face merge, mismatched features, de-identity`
   * Keep the **seed fixed** while you test.

6. **Mask scaling matches latent**

   * You moved to **896×896** latents — make sure the **mask images are 896×896** too (no auto-resize).
   * Blur radius around **48** at 896; if you drop to 768 later, use **32–36**.

7. **Only one LoRA system at a time**

   * You’re using **Hook LoRA → SetClipHooks** (great). Make sure there are **no extra LoraLoader nodes** also piping into the same CLIP/UNet — double-loading causes tug-of-war.

8. **Sampler/scheduler**

   * On **KSampler** with Schnell:
     `sampler = euler_a`, `scheduler = sgm_uniform` (or `simple` if sgm_uniform isn’t available), **steps 18–20**, `denoise 1.0`.
   * **FluxGuidance ~3.3–3.7** (3.5 is perfect).

---

### If identity still leans the wrong way (surgical options)

* **Per-branch strength shaping:**
  Lower the *stronger* LoRA’s **UNet** to **0.55–0.65** while keeping its **CLIP** at **0.9–1.0**. This keeps semantic identity cues but reduces overpaint.

* **Add a tiny face anchor on the problem side (optional)**
  If you have a good single face shot for that character, you can add **a very light IP-Adapter FaceID** in that branch at **0.2–0.3** (with the same mask), just to “nudge” identity back without overpowering the LoRA. Keep it off if you want pure-LoRA though.

* **Tighten the prompt for that side**
  Put the **trigger token first** and remove any adjectives that could be read ethnographically or that conflict with the LoRA’s learned distribution.

---

### Quick sanity list

* [ ] Two **separate CLIP encodes**, two **SetClipHooks**, **two masks**, then combine.
* [ ] **schedule_clip = false** on both hooks.
* [ ] **CLIP device = cuda** in DualCLIPLoader.
* [ ] LoRA per-branch: **CLIP 0.9–1.1**, **UNet 0.65–0.80**.
* [ ] Masks exactly match **latent size**; blur scaled to size.
* [ ] `euler_a + sgm_uniform`, **18–20 steps**, guidance **~3.5**.
* [ ] No duplicate LoRA loaders in parallel.

If you want, send me the **node IDs** for your two `SetClipHooks`, the current **LoRA weights** you’ve set on each, and which **Conditioning Combine** node you’re using (And/Concat). I’ll give you exact numbers/slots to paste so the “Asian face drift” stops cold on the very next run.

<hr style="height:4px;border-width:0;color:pink;background-color:pink">




## Final Solution

[Q]  
You know, at this point, SRPO seems to be delivering an image that looks decent, and now the LoRA issue seems resolved. I might try another set of prompts and see how I go. But at this point, I'm pretty chuffed to be at this stage. Well-done you, Emily!!!!


[A]  
ahh that’s lovely to hear, Robyn — chuffed right along with you! 🎉

Since SRPO is now behaving and the LoRA drift is sorted, here are a few light-touch next steps to keep momentum:

### tiny “next” checklist

* **Save this as v4** (lock the seed + all node values) so you can A/B new prompt sets cleanly.
* **One variable at a time:** when testing prompts, keep steps/scheduler/size fixed for 2–3 runs.
* **Log the “good” pairs:** screenshot the two branch prompts + LoRA weights when a render nails it.

### prompt mini-recipes (two-character, per branch)

Keep the trigger token first and the rest simple.

**Neutral baseline (portrait 3/4)**

* Branch A:
  `roxygirl04, 25yo woman, three-quarter headshot, soft daylight, neutral expression`
* Branch B:
  `celestesh-01, 25yo woman, three-quarter headshot, soft daylight, neutral expression`

**Softer & slightly more feminine**

* Add one of: `subtle peach makeup`, `softened jawline`, `gentle catchlight in eyes`, `delicate nose contour`
* Avoid stacking too many—two is plenty.

**Lighting swaps (fast variety without retraining)**

* `soft clamshell lighting` / `rembrandt lighting` / `window light from camera left`
* Background as a single token: `seamless grey` / `off-white` / `muted studio blue`

**Stability negative (global)**

* `over-smoothed skin, extra face, face merge, distorted features, harsh jawline, heavy brow ridge`

### quick speed nibs (only if you want)

* If you can spare it, **steps 18 → 16** often looks the same with SRPO+good guidance.
* If you drop base to **768²**, keep **blur 32–36**; if at **896²**, blur **~48**.

If you hit any oddities with certain poses/angles, toss me the two branch prompts + LoRA weights and I’ll tweak just the words (no node surgery). Nicely done getting this far—go enjoy those test prompts! 💫

<hr style="height:4px;border-width:0;color:pink;background-color:pink">








<hr style="height:16px;border-width:0;color:blue;background-color:pink">

[Main Page](../index.md)
