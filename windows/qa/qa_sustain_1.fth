\ Play Notes with sustain pedal.
\
\ (C) 2006 Mobileer Inc

ANEW TEST_SUSTAIN_1.FTH

: MC! midi.channel! ;
: MP! midi.program ;

: SUS.ON
	64 127 midi.control
;
: SUS.OFF
	64 0 midi.control
;

: SONG 
	1/2 c5 a g e
;

: TSUS
	1 mc! 17 mp! \ organ on channel 1
	sus.off
	song
	sus.on
	song
	sus.off \ all notes should stop now
	c4 c4
;

: MSMF PLAYNOW " qa_sustain_1.mid" $midifile1{ tsus }midifile1 ;
