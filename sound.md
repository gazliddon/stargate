
# Notes on host sound system


A sound effect has the following properties

* Priority
    * Single byte
    * Has to be >= to current sound to play
* Sequence
    * A sequence of individual sounds
    * Each sequence step has
        * how many times the sound will repeat
        * A number of frames to stay on this step
        * A sound to send to the WMS sound board
    * The sequence is terminated by a zero byte

This is the definition for the sound the game makes when a coin is inserted

        CNSND       FCB $FF,$01,$18,$19,0                ; COIN SOUND

Priority = $ff (always plays)

Step 0
    repeat count = 0
    frames = $18
    sound = $19

Step 1 = terminates


tries to sequence a new sound
SNDLD

