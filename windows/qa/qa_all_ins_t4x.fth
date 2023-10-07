\ Play a note on every instrument.
\ Play extra Breath Noise notes at end.
\
\ (C) 2006 Mobileer Inc

ANEW QA_ALL_INS.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: SONG  { startAt -- }
	122 startAt
	DO
		\ select channel
		i 7 and 1+ mc!
		
		\ all instruments
		i 1+
		dup . cr
		mp!
		
		\ play ascending semitones
		1/16 60 i 7 and 2* + note
	LOOP
	
	12 0 DO
		50 i 2* +
		dup . cr
		dup note note
	LOOP
	rest
	
	10 0 DO
		i 10 * + ns.velocity! 30 
		62 note 62 note
	LOOP
;

: MSMF  { $fileName startAt -- }
	PLAYNOW
    rtc.rate@ 2* tpw!
    \ There are two beats in a second by default.
    rtc.rate@ 2/ ticks/beat !
	1 mc!
	0 midi.pitch.bend
	7 127 midi.control
	$fileName $midifile1{
		startAt song
	}midifile1
;


: T4	" all_ins_t4.mid"   0 msmf ;
: T5	" all_ins_t5.mid"  16 msmf ;
: T6	" all_ins_t6.mid"  40 msmf ;
: T7	" all_ins_t7.mid"  64 msmf ;
: T8	" all_ins_t8.mid"  80 msmf ;
: T9	" all_ins_t9.mid" 110 msmf ;

