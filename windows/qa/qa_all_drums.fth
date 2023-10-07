\ Play a note on every instrument.
\
\ (C) 2006 Mobileer Inc

ANEW QA_ALL_DRUMS.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: SONG
	10 mc!
	82 35
	DO
		1/16 i note
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
	" all_drums.mid" $midifile1{ song }midifile1
;
