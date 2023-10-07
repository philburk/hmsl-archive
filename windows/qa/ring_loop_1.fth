\ Play Notes various pitch bend settings.
\ Notes should match in pitch.
\
\ (C) 2006 Mobileer Inc

ANEW RINGER_SUDDEN.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: RPN!  ( msb lsb -- )
	swap
	101 swap midi.control
	100 swap midi.control
;

\ MSB should be sent first.
\ When MSB received then LSB value set internally to zero.
\ So we should not have to send zero LSB.
: DATA!  ( msb lsb -- )
	swap
	6 swap midi.control  \ send MSB
	?dup IF
		6 32 + swap midi.control
	THEN
;

: BEND.RANGE!  ( semis cents -- )
	0 0 rpn!
	data!
;

$ 2000 constant BEND_SCALE

: LEAD.TRACK
	1 mc! 30 mp!
	2 0 bend.range!
	1/4 c4 f g
	1/8 e c
	1/4 a a
	1/4
	BEND_SCALE 2/ midi.pitch.bend
	G# rest
	17 mp! \ write MIDI event at end of measure so we get a well timed repeat
;

: BELL.TRACK
	5 mc! 10 mp!
	rest rest rest c5
	rest rest rest c6
;

: COWBELL 56 note ;
: SNARE 38 note ;
: CUICA 79 note ;
: KICKDRUM 79 note ;
: CLOSED.HIHAT 42 note ;

: DRUM.TRACK
	10 mc!
	par{
		kickdrum snare rest snare
	}par{
		cowbell rest cuica rest
	}par{
		1/8 closed.hihat closed.hihat
		1/4 closed.hihat rest closed.hihat
	}par
;

: SONG
	par{
		lead.track
		\ Turn down mixer on this channel.
		7 40 midi.control
	}par{
		bell.track
		\ Very tiny pitch bend to fill measure
		1 midi.pitch.bend
	}par{
		drum.track drum.track
	}par
;

: MSMF
	PLAYNOW
	rtc.rate@ 8 5 */ tpw!
	1 mc!
	0 midi.pitch.bend
	7 127 midi.control
	" ring_loop_1.mid" $midifile1{ song }midifile1
;

: TIMESONG
	1 mc!
	1/1
	1 midi.program
	d4 c c c
	d4 c c c
	d4 c c c
	1 midi.program
;

: TIMETEST
    PLAYNOW
    rtc.rate@ tpw!
	" time_test.mid" $midifile1{
		timesong
	}midifile1
 ;
 