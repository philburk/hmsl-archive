\ Play all notes on one instrument with different durations.
\ This code uses the HMSL music language.
\
\ (C) 2007 Mobileer Inc


ANEW QA_ALL_NOTES.FTH
decimal

: SONG ( -- , play all possible pitches )
	128 0
	DO
		\ play ascending semitones
		i note
	LOOP
;

: QA.SETUP ( -- )
	rtc.rate@ 2* tpw!
	\ There are two beats in a second by default.
	rtc.rate@ 2/ ticks/beat !
;

\ make array to hold constructed file names
create FILENAME-PAD 256 allot
0 FILENAME-PAD !

: N>$ ( n -- addr count , convert number to 3 digit index string )
	S->D
	<# # # #S #>
;

: QA.WRITE.SONG { program $dirname -- , }
	." Program = " program .
	
	0 FILENAME-PAD !
	$dirname count FILENAME-PAD $append
	" /LIT_" count FILENAME-PAD $append
	program n>$ FILENAME-PAD $append
	" _Test.mid" count FILENAME-PAD $append
	
	." , to file " FILENAME-PAD count type cr
	FILENAME-PAD $midifile1{
		1 midi.channel!
		0 midi.pitch.bend
		program 1+ midi.program
		song
	}midifile1
;

: QA.MAKE.SHORT ( -- , 1/8 notes with normal duty cycle )
	PLAYNOW
	qa.setup
	1/8
	128 0
	DO
		i " sudhu_short" QA.WRITE.SONG
	LOOP
;


: QA.MAKE.LONG ( -- , 1/2 notes played almost legato so we can hear loop )
	PLAYNOW
	qa.setup
	1/2
	110 staccato! \ mostly on to hear loops
	128 0
	DO
		i " sudhu_long" QA.WRITE.SONG
	LOOP
;


: QA.MAKE.GAP  ( -- , 1/2 notes played staccato so we can hear release )
	PLAYNOW
	qa.setup
	1/2
	30 staccato! \ mostly off to hear loops
	128 0
	DO
		i " sudhu_gap" QA.WRITE.SONG
	LOOP
;
