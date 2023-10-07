\ Play a note on every instrument.
\ Play extra Breath Noise notes at end.
\
\ (C) 2006 Mobileer Inc

ANEW QA_ALL_INS.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: SONG
	
	122 0
	DO
		\ select channel
		i 7 and 1+ mc!
		
		\ all instruments
		i 1+ mp!
		
		\ play ascending semitones
		1/16 60 i 7 and 2* + note
	LOOP
	
	62 note
	64 note
	_ff 62 note
	_pp 62 note
	_mf 72 note
;

: MSMF
	PLAYNOW
    rtc.rate@ 2* tpw!
    \ There are two beats in a second by default.
    rtc.rate@ 2/ ticks/beat !
	1 mc!
	0 midi.pitch.bend
	7 127 midi.control
	" all_ins_t4.mid" $midifile1{ song }midifile1
;
