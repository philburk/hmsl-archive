\ Play a note on every instrument.
\ Play extra Breath Noise notes at end.
\
\ (C) 2006 Mobileer Inc

ANEW QA_ALL_INS.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

\ Play 2*(12+10)=44 breath sounds
: BREATHS ( -- )
	122 mp!
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

: SONG1  { startAt -- }
	." SONG1" cr
	_mf
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
	
	breaths
;


: SONG2  { program -- }
	." SONG2" cr
	_mf
	122 40
	DO
		\ select channel
		i 7 and 1+ mc!
		
		\ all instruments
		program mp!
		
		\ play ascending semitones
		1/16 60 i 7 and 2* + note
	LOOP
	
	breaths
;


: MSMF  { $fileName param 'song -- }
	PLAYNOW
    rtc.rate@ 2* tpw!
    \ There are two beats in a second by default.
    rtc.rate@ 2/ ticks/beat !
	$fileName $midifile1{
		param 'song execute
		param 'song execute
	}midifile1
;


\ play all instruments twice
: T10	" all_ins_t10.mid"   40 'c song1 msmf ;

\ play lots of piano notes
: T11	" all_ins_t11.mid"  1 'c song2 msmf ;

\ play lots of synth notes
: T12	" all_ins_t12.mid"  17 'c song2 msmf ;

\ play lots of Flute notes with RedNoise
: T13	" all_ins_t13.mid"  74 'c song2 msmf ;

\ play lots of Breath note with RedNoise
: T14	" all_ins_t14.mid"  122 'c song2 msmf ;

