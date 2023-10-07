\ Test velocity response of synth.
\ Generate two tracks, one with steady full velocity.
\ The other with decreasing velocity.
\
\ (C) 2006 Phil Burk

anew task-test_vel.fth


: pan!  ( pan -- )
    10 swap midi.control
;

: TRACK.STEADY ( -- )
	1 midi-channel !
	17 midi.program
	0 pan!
	127 ns.velocity!
	9 0 DO
	    1/2 b4
	loop
;

: TRACK.DECREASE ( -- )
	2 midi-channel !
	17 midi.program
	127 pan!
	9 0 DO
	    127  i 16 *  -
	    0 max
	    ns.velocity!
	    
	    1/2 b4
	loop
;

: BOTH.TRACKS  ( -- )
	par{
		track.steady
    }par{
    	track.decrease
    }par
;

: TEST.VEL
	playnow both.tracks
;

: MAKE.TEST.VEL
	" test_vel.mid" $midifile1{ playnow test.vel }midifile1
;

' host.midi.write.debug is midi.write
