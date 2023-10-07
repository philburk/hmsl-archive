\ Play a note on Breath Noise instrument.
\ We noticed that this one instrument did not match bits
\ on ARMULATOR and a real ARM946.
\ Use various settings to try to find where in synthesis pipeline the mismatch occurs.
\
\ (C) 2006 Mobileer Inc

ANEW QA_BREATH.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: SONG
	2 mc!
	0 midi.pitch.bend
	7 127 midi.control
	122 mp!  \ Breath Noise
	80 ns.velocity!
	1/16
	
	62 note 62 note
	
	40 ns.velocity! \ change velocity
	62 note rest
	
	80 ns.velocity!
	72 note  rest \ change pitch
	
	7 64 midi.control  \ change mix controller
	80 ns.velocity!
	62 note  rest
	
	10 25 midi.control  \ change pan controller
	62 note  rest
	10 100 midi.control  \ change pan controller
	62 note  rest
	10 64 midi.control  \ reset pan controller
	
	121 mp!  \ play guitar fret noise before
	60 note
	122 mp!
	62 note
;

: MSMF
	PLAYNOW
    rtc.rate@ 2* tpw!
    \ There are two beats in a second by default.
    rtc.rate@ 2/ ticks/beat !
	" breath_noise.mid" $midifile1{ 
		song
	}midifile1
;
