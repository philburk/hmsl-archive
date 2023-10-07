\ Play a note on every instrument.
\ Add a piano note at the beginning of this version.
\
\ (C) 2006 Mobileer Inc

ANEW QA_ALL_INS.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: SONG
	1/16 1 mp! 60 note
	
	128 0
	DO
		\ select channel
		i 7 and 1+ mc!
		
		\ all instruments
		i 1+ mp!
		
		\ play ascending semitones
		1/16 60 i 7 and 2* + note
	LOOP
;

: MSMF
	PLAYNOW
    rtc.rate@ 2* tpw!
    \ There are two beats in a second by default.
    rtc.rate@ 2/ ticks/beat !
	1 mc!
	0 midi.pitch.bend
	7 127 midi.control
	" all_ins_t2.mid" $midifile1{ song }midifile1
;
