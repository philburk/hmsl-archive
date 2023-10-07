\ Play Notes on two channels with different mixer levels.

ANEW TEST_CC7_SEQ.FTH

: MC! midi.channel! ;
: MP! midi.program ;

: SONG  c a g e ;

: PIECE
	1 mc! 1 mp! \ piano on channel 1
	2 mc! 31 mp! \ fuzz guitar on channel 2
	par{ 
		1 mc! 7 127 midi.control
		1/4 song
    }par{
		2 mc! 7 64 midi.control
		1/8 rest 1/4 song
	}par
;
