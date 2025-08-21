
# Study of Harmony

[Original Document by Pyotr Ilyich Thaikovsky](https://imslp.org/wiki/Guide_to_the_Practical_Study_of_Harmony%2C_TH_255_(Tchaikovsky%2C_Pyotr))


## Revisionist's Notes

### Overview

This readability revision is a **living document**. Its main focus is to make this great and important study of harmony by one of the greatest composers of all time - **Pyotr Ilyich Tchaikovsky** - somewhat more accessible, in language a bit easier to grasp - at least, for me - than the *translated-from-German* version.


### Features of this Document

All examples - shown as images - are links to playable Musescore files. To download, click on the caption below the image, e.g., "Fig. 1". Please note: *you will need a current copy (freeware download) of the* [Musescore](https://musescore.org/en) *software to play the examples*.

I have prefaced the text I've revised with a ♫.



### Methodology

**June 10, 2025**

This **completely personal, unofficial** revision was performed using AI. We ran the text through the gemma3:12b model in the Gradio UI to assist in the revision. The [original document](https://imslp.org/wiki/Guide_to_the_Practical_Study_of_Harmony%2C_TH_255_(Tchaikovsky%2C_Pyotr)) had been translated back in 1900 from German: I personally found the style confrontingly formal and unnecessarily laborious to read. I thought the valuable information on harmony that Tchaikovsky had given us had to be more accessible, more easily read; hence, this document.

Any changes we made are marked with "♫" before the revised text - a copy of the original can be found on [IMSLP](https://imslp.org/wiki/Guide_to_the_Practical_Study_of_Harmony%2C_TH_255_(Tchaikovsky%2C_Pyotr)) - we found the *optimised* version easier to work with.

The approach I used in the Gemma3 LLM was the following. The bit that's in bold was the query; the bit in quotes, an example of text to be revised:

**Please convert the following sentence into a simpler to understand English, but preserving the rules of music theory:  
"Minor intervals are half a tone smaller than major intervals; augmented intervals are half a tone larger than either major or perfect ones; while diminished intervals are half a tone smaller than minor or perfect intervals. All intervals having for their fundamental tone the first degree of the major scale are either major or perfect.**"

The result offered by the LLM was accompanied by its logic, viz:

Here's a simpler version, aiming for clarity while still respecting music theory concepts:

"A minor interval is a half-step smaller than a major interval. An augmented interval is a half-step larger than a major or perfect interval. A diminished interval is a half-step smaller than a minor or perfect interval. If an interval starts on the first note of a major scale, it will be either a major or a perfect interval."

**Here’s why these changes were made, focusing on the balance between simplicity and accuracy:**

  * **Removed "A" at the beginning of each sentence:** Starting each sentence with "A" felt repetitive and unnecessarily formal.
  * **Kept "half-step":** While "a little smaller/larger" is more conversational, "half-step" is a specific, important musical term that accurately describes the difference. Eliminating it would lose precision.
  * **Maintained "major or perfect interval":** This accurately represents the possibilities and avoids oversimplification.
  * **Replaced "starts on" with "If an interval starts on":** This clarifies the conditional nature of the final statement.

The goal here was to prioritize accurate musical terminology alongside improved readability.

Large language models (LLMs) these days are pretty amazing, particularly when they share their approach to solving a problem, as gemma3 does. However, an LLM can still miss the mark occasionally. I proof-read each revision, but more eyes = better accuracy, so please read the original document - [the one on IMSLP](https://imslp.org/wiki/Guide_to_the_Practical_Study_of_Harmony%2C_TH_255_(Tchaikovsky%2C_Pyotr)) - and use this document as an additional perspective.

I've moved my documents from Sphinx to markdown (mkdocs)... easier to maintain. The steps taken to build this document are:

  * Copy the text from the original pdf, noting location of examples (images)
  * Fix spelling issues from the copy process
  * Recreate the Examples in Musescore / and screencap to image
  * Run obscure / unclear text through gemma3:12b
  * Build document using ""mkdocs build**, and then upload the pages to my site (tightbytes.com/pages)

Note: *only statements that we found unclear or awkward were run through gemma3 for readability: the revised paragraph is prefaced in the document by the little notes icon "♫"*.


### Finally

Please review and if you discover any glaring discrepancies, feel free to leave a comment on my **Projects** [Issues Page](https://github.com/robinboncoeur/Projects/issues).

<hr style="height:4px;border-width:2;color:blue;background-color:blue">








## Introduction

### Intervals

♫ Before we dive into the study of Harmony, it's important to make sure we're all on the same page when it comes to the basics. Even though it’s assumed that anyone starting the study of composition already has a solid understanding of music theory, it’s still a good idea to begin with a quick review of intervals. If your understanding of intervals is a little shaky, it can make learning harmony more difficult than it needs to be.

♫ An interval is simply the relationship between two notes, based on where they sit in the scale. The lower of the two notes is called the root (or historically, "fundamental") tone. The names we give to intervals come from Latin ordinal numbers—like second, third, fourth—which count the number of steps from the lower note to the higher one.


![Intervals](http://www.tightbytes.com/images/projects/harmony/Aa-Intervals001.png){width=880px}

[Fig. 1](http://www.tightbytes.com/images/projects/harmony/mscz/Examples001.mscz)


♫ Changing how high or low an interval sounds doesn't change what we call it. It just makes the distance between the notes bigger or smaller. To understand this better, we're going to organize these intervals into two different groups.

  1. Large (major), small (minor), augmented and diminished intervals; (to which belong Seconds, Thirds, Sixths and Sevenths)
  2. perfect, augmented and diminished intervals; (to which belong: Primes, Octaves, Fifths and Fourths) 
  
♫ A minor interval is a half-step smaller than a major interval. An augmented interval is a half-step larger than a major or perfect interval. A diminished interval is a half-step smaller than a minor or perfect interval. If an interval starts on the first note of a major scale, it will be either a major or a perfect interval. Now, let's find out how many whole and half steps are in each of these intervals. This will give us a way to compare all intervals to each other:


![Intervals](http://www.tightbytes.com/images/projects/harmony/Aa-Intervals002.png){width=880px}

[Fig. 2](http://www.tightbytes.com/images/projects/harmony/mscz/Examples002.mscz)


♫ Now that we understand different types of musical intervals and how to measure them, we can create any relationship we want between two notes. To show you how, we'll make a table showing all the intervals that start with the note C:

  * A major Second  contains 1      whole tone
  * A major Third   contains 2      whole tones
  * A pure  Fourth  contains 2 1/2  whole tones
  * A pure  Fifth   contains 3 1/2  whole tones
  * A major Sixth   contains 4 1/2  whole tones
  * A major Seventh contains 5 1/2  whole tones
  * A pure  Octave  contains 6      whole tones
  * A pure  Prime   contains 0      whole tones

♫ This shows us that a major or perfect interval can become a minor, diminished, or augmented interval by either raising or lowering the higher note. Alternatively, we can change the interval by raising or lowering the lower note, while keeping the higher note the same. For example: 


![Intervals](http://www.tightbytes.com/images/projects/harmony/Aa-Intervals003.png){width=880px}

[Fig. 3](http://www.tightbytes.com/images/projects/harmony/mscz/Examples003.mscz)


♫ Intervals larger than an octave are just repeats of the relationships found within an octave. The 'ninth' is the only interval that has a unique and important role in harmony. 


![Intervals](http://www.tightbytes.com/images/projects/harmony/Aa-Intervals004.png){width=880px}

[Fig. 4](http://www.tightbytes.com/images/projects/harmony/mscz/Examples004.mscz)


♫ An interval's inversion is created by moving the higher note down an octave or moving the lower note up an octave. The resulting relationships is shown in the following graph.

+-------------------------------------------------------------------------------+
|                                                                               |
+=========+=========+=========+=========+=========+=========+=========+=========+
|    1    |    2    |    3    |    4    |    5    |    6    |    7    |    8    |
+---------+---------+---------+---------+---------+---------+---------+---------+
|    8    |    7    |    6    |    5    |    4    |    3    |    2    |    1    |
+---------+---------+---------+---------+---------+---------+---------+---------+

The inverted Prime becomes an Octave, the Second a Seventh, the Third a Sixth, the Fourth a Fifth, the Fifth a Fourtb, the Sixth a Third, the Seventh a Second, the Octave a Prime. 


![Intervals](http://www.tightbytes.com/images/projects/harmony/Aa-Intervals005.png){width=880px}

[Fig. 5](http://www.tightbytes.com/images/projects/harmony/mscz/Examples005.mscz)


Major intervals become minor, while minor intervals become major; augmented intervals become diminished, diminished intervals augmented; pure intervals however remain pure. 


![Intervals](http://www.tightbytes.com/images/projects/harmony/Aa-Intervals006.png){width=880px}

[Fig. 6](http://www.tightbytes.com/images/projects/harmony/mscz/Examples006.mscz)


♫ Depending on how they sound, intervals are categorized as *Consonances* and *Dissonances*. Consonances sound complete and create a sense of rest. Dissonances, on the other hand, create a feeling of movement and need to be resolved by the next interval.

♫ Major and minor intervals of the octave, perfect fifth, major third, minor third, major sixth, and minor sixth are considered consonances. The octave, perfect fifth, major third, and minor third are called *perfect* consonances, while major and minor sixths are *imperfect* consonances. Seconds, sevenths, and all intervals that are augmented or diminished are dissonances. A perfect fourth has qualities of both consonance and dissonance, but leans more towards dissonance.

<hr style="height:4px;border-width:2;color:blue;background-color:blue">







## Harmony

♫ **§ 1**. Musical tones can be combined in two ways: first, by playing them one after the other, and second, by playing them at the same time. The first combination is called "Melody," and the second is called "Harmony." Melody, Harmony, and Rhythm (which controls their timing) together make up the core of music. This guide will focus specifically on Harmony, which is the combination of tones played simultaneously. 


### First Part

♫ **§ 2**. When three, four, or five musical tones sound together, they form a *chord*. The most basic and important chord is a *triad*, which consists of three tones. Because triads contain harmonious intervals (thirds and fifths), they sound pleasing. Chords with more tones often contain dissonant intervals and therefore usually need to be supported by or resolved into a more harmonious chord or triad. 


### Consonant chords--Triads

**§ 3**. The triad, or common chord consists of three tones, separated each from the other by the interval of a Third. 


![Triads](http://www.tightbytes.com/images/projects/harmony/Ab-Chords007.png){width=880px}

[Fig. 7](http://www.tightbytes.com/images/projects/harmony/mscz/Examples007.mscz)


♫ In a triad, the lowest note is called the *fundamental tone* or *bass*, the middle note is the *third*, and the highest note is the *fifth*. Triads are classified based on the types of thirds and fifths they contain. A *major* triad consists of a major third and a perfect fifth (a). A *minor* triad is made up of a minor third and a perfect fifth (b); a *diminished* triad contains a minor third and a diminished fifth (c). 

<hr style="height:4px;border-width:2;color:blue;background-color:blue">









## Chapter I

### The Major Scale Triads

*§ 4*. If we construct a triad on each successive degree of the diatonic major scale, we obtain the following chords:


![Triads](http://www.tightbytes.com/images/projects/harmony/Ac-Triads008.png){width=880px}

[Fig. 8](http://www.tightbytes.com/images/projects/harmony/mscz/Examples008.mscz)


On the 1st, 4th and 5th degree we find major triads: 


img 9


These triads, representing the most essential constituents of the major scale, bear the names of those degrees of the scale, on which they are based:

* The triad on the 1st degree is termed the Tonic triad
* The triad on the 4th degree is termed the Subdominant triad
* The triad on the 5th degree is termed the Dominant triad 

♫ **§ 5** We’ve just mentioned that the three major triads built on the 1st, 4th, and 5th degrees of the major scale are the most important chords in that key. Together, these chords use all the notes of the major scale, and because they are so closely related, they clearly establish the key. They’re also enough to harmonize any melody that stays within that key. These triads are strongly connected because of how closely related their home keys are. Specifically, the chords on the 4th (Subdominant) and 5th (Dominant) degrees of a key are also the tonic (I) chords in their own respective keys. And these keys happen to be the closest neighbors to the original key in the **Circle of Fifths**. *Therefore, the close relationship between these three major triads (I, IV, V) in any key reflects the close relationship between their keys in the Circle of Fifths. Their similarity is even clearer when you realise they share many of the same notes — especially in their tetrachords (four-note scale fragments).*

§ 6. In the major scale minor triads are also found, namely on the 2nd, 3rd and 6th degrees. The minor Third imparts to tbese triads a soft, weakened character; hence they cannot command the importance possessed by the major triads" However, they furnish us with a beautiful contrast to the latter, emphasizing their strength! Their mutual afflnity is the same as that of the major triads, as they possess the same proximity in the Circle of Fifths. 


img 10


Of the degree of their relationship to the major triads we may say it is the same as that existing hetween parallel keys; for the chords on the 1st and 6th degrees, the 5th and 3rd degree and the 4th and 2nd degree respectively are separated by a minor third.


img 11


The whole mass of major and minor triads may be grouped into three sets of two triads each:

a) The tonic group viz: the triads on the 1st and 6th degrees
b) The duminant group viz: the triads on the 5th and 3rd degrees and
c) The subdominant group viz: the triads on the 4th and 2nd degrees

§ 7. In marked contrast to the other triads stands the diminished triad on the 7th degree, because of its dissonant character. We shall return to this chord later on, having first entirely mastered the connection of the other six triads. 

<hr style="height:4px;border-width:2;color:blue;background-color:blue">









## Chapter II

### Connection of Major Scale Triads

§ 8. In music chords are either used in masses, that is with manifold repetitions of one and the same interval -- as is the case in compositions for orchestra and Pianoforte -- or they are set for several, single, distinct voices. "Four-voiced-writing" is the commonest and most normal form, as it denotes the four different human voices, namely: Soprano, Alto, Tenor and Bass. So, in our study of Harmony we shall keep to this disposition of the voices. The highest voice, Soprano -- and the deepest voice -- Bass, are called the two outer voices. The two intermediate voices: Alto and Tenor: the two inner voices.

§ 9. Turning now to the practical application of the above treated chords, we will begin with placing the fundamental tone in the Bass. In the higbest voice any of the three tones of the chord, the fundamental tone, the Tbird or the Fifth may be used. For the two inner voices we will use respectively the intervals of the triad nearest to the Soprano. The C major triad would thus appear as follows: 


img 12


These three cases are called the *positions* of the chord. According to the interval of the triad which appears in the Soprano, these positions are called the fundamental position or position of the octave, the position of the Third, and the position of the Fifth.

§ 10. From the above example we see that in each of the three positions the fundamental tone is used twice, while the third and fifth appear but once. Shall this always be the case? By no means! In a free leading of the voices the composer may double any tone of the chord at will. For the present, however, we cannot avail ourselves of this liberty, since according to § 9, we must place the inner voices as close as possible to the upper voice. Indeed, the doubling of the fundamental tone will always be the most common, as it is most natural to the triad [1].

§ 11. We have already mentioned (§ 6) the internal relationship of the triads of the scale. Now, there is still another and purely external connection of these triads, growing out of the tones they have in common.

The triads c, e, g and g, b, d for instance have the tone g in common, while the triad f, a, c shares the tone c with the triad c, e, g. In fact, each triad has one or two tones in common with every other triad constructed on steps of the same scale, except in the case where the fundamentals are directly succeeding steps. So, the triad on C has no tone in common with the triads on b and d; the triad on d, none with the triads on c and e, and so on. The mutual relationship of the triads with regard to their external connection is shown in the following table: 


img 13


To effect a connection of two triads at once correct and satisfying to the ear, it is necessary to retain the common tone of the triads in the same voice. Conscientious application of this rule imparts fluency, euphony and unity to the harmony; moreover it enables the pupil to avoid many grave errors, which, otherwise, he would of necessity commit. Take for instance the triad on c in the octave position, and let us connect it successively with other triads containing tones in common with it. Which positions of the new chords must we then choose? Obviously those which enable us to retain the oom- mon tone, or tones in the same voice. Consequently the G major triad must appear in position of the third, F major in the position of the fifth, A minor in position of the third and E minor again in position of the fifth.


img 14


The progression and position, therefore, of the three upper voices is influenced by the common tones. Meanwhile the Bass may progress upward or downward at liberty. Should we have to choose between a skip of a sixth and one of a third, we prefer the latter [2].

Footnotes:
  
  [1] The major triads are indicated by capital letter; minor triads by small letters

  [2] Having a purely practical aim in this work, we shall avoid minute explanations and justifications of the different rules. It were well for the pupil to search out instinctively, as it were, the justification of the several rules. For this purpose he should thoroughly test them by ear on the piano. A true musical instinct will at once convince him, that all these rules originated in the demands of his own ear. 


img 15


I Remark. In addition to these examples, which consist in supplying the remaining three voices to a given bass, it is very beneficia! to construct a table, which shall contain all the possible connections of all triads with one another, in every position. To this end the example (M 13) begun in this paragraph on C should be carried on further. The pupil must not be disheartened, when he finds that at the very beginning of his study, 20 chords must be written out in one key alone. In the first place the labor is merely a mechanical one, and in the second place it is important that by thoroughgoing explanations of the rudiments we should dispel at the start the superstitious awe that prevails regarding the so-called "Theory" or "Thorough Bass"

II. Remark: In harmonizing a bass, care should be taken not to lead the voices too high; therefore one must not choose too high a position of the tonic triad at the start. 

<hr style="height:4px;border-width:2;color:blue;background-color:blue">








## Chapter III

### Connection of Triads, no external agreement

§ 12. Jn the preceding chapter we spoke of the beauty of harmonies connected by common tones. This absolute completeness in chord-connection, however, does not exclude the admissibility of certain connections, which, while perhaps less pleasing, satisfy us by very reason of their sharpness or coarseness. This we can understand if we consider the aim of Music, which is, to picture the many various emotions of the soul: and these cannot always be expressed by dulcet soothing means. For this reason Harmony admits also such chord-connections, which show no outer relationship - though they may bear an inner relationship to one another. (§ 5 ).

§ 13. Should we not, when connecting two chords not outwardly related chose again those positions, that permit a melodious, fluent leading of the voices? Should we not, to avoid jumps, lead eMh voice info the nearest interval, a second up or down? For instance as follows: 


img 16


Before answering these questions, however, let us see, what different kinds of voice-motions there are.

We perceive the three following kinds:
    1) Parallel motion (motus rectus), in which two voices progress in one and the same direction, that is, upwards or downwards 


img 17


    2) Oblique motion (motus obliquus), in which one voice remains stationary, while the other moves onward: 


img 18


    3) Contrmy motion (motus contrarius); one voice progresses upwards, the other downwards. 


img 19


All these various motions are admissible in every succession of harmonies. Observe, however, the so-called Parallelisms occurring in the motus rectus; these are progressions, in which the two voices move not only in the same direction, but also in the same interval; for instance: when two voices progress upward or downward in Seconds or Fourths.


img 20


Some of these Parallelisms are indeed very euphonious and, therefore, like the other motions, entirely permissible. Others, however, are to be avoided partly because they do not satisfy the musical ear and again, because they counteract the independent movement of the voices. Such forbidden progressions are Parallel Fifths and Octaves.


img 21


Remark. To comprehend clearly the reason for prohibiting parallel Fifths and Octaves, it must be borne in mind that we have to deal not with the massive harmonization of orchestra or piano composition, but with 4 separate independent voices, which do not permit of extensive doubling. Should the question arise whether only parallel octaves and fifths are forbidden, and parallel dissonant intervals permitted, we may add, that for the present we are familiar only with tone-combinations, in which such progressions do not occur. Once for all, then, let it be said that in Harmony progressions of parallel fifths and octaves are prohibited.

Now only are we in a position to answer the question put at the beginning of this paragraph. lf we wish to connect two triads having no external relationship, we can not lead all the voices a second upwards or downwards, as parallel fifths and octaves would arise. 


img 22


To avoid this fault we must employ contrary motion, without, however, proceeding in great skips. The fault is by no means corrected, if we replace the step of a second by a skip of a seventh in the opposite direction (contrary motion), as in that case the fifths and octaves really remain. 


img 23


Moreover, we obtain a very unmelodious skip of a seventh in the Bass.

So we will allow the Bass to retain its melodious step of a second, and, employing contrary motion, lead each of the other voices into the nearest interval of the following chord:


img 24


We have now learned, how to connect, within its own limits, all the consonant chords of the major scale in all positions. Besides working out the following written exercises, we chould advise the pupil to form at the piano all manners of chord-combinations in all the keys, in order to master them more thoroughly. 

Exercises:










