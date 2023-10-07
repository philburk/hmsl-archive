\ Play notes on different banks.
\
\ (C) 2007 Mobileer Inc


ANEW QA_BANKS.FTH
decimal

: QA.SETUP.TIMING ( -- )
	rtc.rate@ 2* tpw!
	\ There are two beats in a second by default.
	rtc.rate@ 2/ ticks/beat !
;

: BANK! { msb lsb -- }
	0 msb midi.control
	32 lsb midi.control
;

: QA.BANK.SONG { channel bankMSB bankLSB program -- }
	channel midi.channel!
	0 midi.pitch.bend
	bankMSB bankLSB bank!
	program midi.program
	1/4 c3 c4 c5 g4
;

: QA.BANKS.1 ( -- , )
	PLAYNOW
	qa.setup.timing
	" qa_banks_melody_1.mid" $midifile1{
		1  0 0  8 qa.bank.song
		2  0 1  8 qa.bank.song
		3  1 0  8 qa.bank.song
	}midifile1
;

: QA.BANK.PATTERN { bankMSB bankLSB program -- }
	10 midi.channel!
	0 midi.pitch.bend
	bankMSB bankLSB bank!
	program midi.program
	1/4
	35 note \ acoustic bass drum
	38 note \ acoustic snare
;

: QA.BANKS.2 ( -- , )
	PLAYNOW
	qa.setup.timing
	" qa_banks_drum_1.mid" $midifile1{
		0 0  1 qa.bank.pattern
		0 0  2 qa.bank.pattern
		1 0  3 qa.bank.pattern
	}midifile1
;

