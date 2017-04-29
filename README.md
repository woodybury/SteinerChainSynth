# SteinerChainSynth

## Demo
https://woodburyshortridge.github.io/SteinerChainSynth

Click the canvas to start. Use the up/down arrow keys to change # of circles & frequency. Left/right to adjust speed & sequencing.

## what is this?
While exploring actionscript3 I found this Steiner Chain by Andre Michelle: http://andre-michelle.com/

Steiner Chain is a series of infinite possible number of circles. Each circle is tangent to two other non-intersecting circles. I could not resist attempting to make this thing play music. I started with a simple sine wave. The phase of the wave was set to starting position divided by sampling rate (44100) * 2 pi. To create a tone I used the sine function of this phase times circle radius and speed.  Mapping the circle radius to frequency created a sequencing or arpeggio like effect - as the radius changes when the circles move around, the frequency changes accordingly in steps. Multiplying this times speed creates a transposing effect - as the speed increases, the whole sequence goes up in frequency.

I was not satisfied by the tone generation because it created a popping noise when changing frequency. The pop is because the phase position jumps when creating a sine wave with a different starting position. But, I noticed the sequenced popping sounded like an infrasonic pulse wave so I wondered if I could generate a tones with periodic pops above 20hz? Changing the volume and pan also made glitchy pops. Therefore, I mapped volume to X and pan to Y position. This creates interesting overtones when added to the sine wave, making the synth sound more “synthy”.

Because the pulse wave frequency had a very large range, I was able to create a foldover effect when the circles gain speed and quantity - a circuit-bending type sound as the waves fold over into the next periodic cycle. To me, it is analogous to the wagon-wheel visual effect seen when the circles get so fast they appear to move backwards.
