\ Play Notes various pitch bend settings.
\ Notes should match in pitch.
\
\ (C) 2006 Mobileer Inc

ANEW TEST_BEND_1.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

\ Choose a program that does not have vibrato
\ 1 constant TEST_PROGRAM \ grand piano
 5 constant TEST_PROGRAM \ electric piano
\ 7 constant TEST_PROGRAM \ harpsichord
\ 9 constant TEST_PROGRAM \ celesta
\ 10 constant TEST_PROGRAM \ glock
\ 13 constant TEST_PROGRAM \ marimba

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

: CALC.BEND.OFFSET { semis cents pitch1 pitch2 -- }
	\ calculate how much bend to make notes match
	pitch2 pitch1 -  100 * \ cents difference
	BEND_SCALE
	semis 100 * cents +   \ range in cents
	*/
;

: .TD ( n -- )
	." <td>" . ." </td>" cr
;

: TBNOTES  { semis cents pitch1 pitch2 | bend_offset -- }
	semis cents pitch1 pitch2 calc.bend.offset -> bend_offset
	0 IF
	." <tr>" cr
	semis .td
	cents .td
	pitch1 .td
	pitch2 .td
	bend_offset .td
	." </tr>" cr cr
	THEN
	1/4
	par{
		1 mc!
		semis cents bend.range!
		\ calculate how much bend to make notes match
		bend_offset BEND_SCALE + midi.bend
		120 staccato! 1/4 pitch1 note  rest  1/2 pitch1 note
	}par{
		2 mc!
		semis cents bend.range!
		BEND_SCALE  midi.bend
		120 staccato! 1/4 rest  pitch2 note  1/2 pitch2 note
	}par
	1/16  pitch2 12 + note rest
;

2 0 60 61 calc.bend.offset 4096 - abort" ERROR - bend should be 4096"

: TBEND.SETUP
	1 mc! test_program mp!    
	1 0 midi.control \ turn off modulation
	5 40 bend.range!
	
	2 mc! test_program mp!   
	1 0 midi.control \ turn off modulation
	5 40 bend.range!
;

: TBEND1  { pitch -- }
	tbend.setup
	
	2 0   pitch 1+ dup tbnotes
	2 50  pitch dup 1+ tbnotes
	2 0   pitch dup 1+ tbnotes
	4 73  pitch dup 4 +  tbnotes
	2 25  pitch dup 1+ tbnotes

	2 75  pitch dup 1+ tbnotes
	2 75  pitch dup 1- tbnotes
	2 99  pitch dup 1+ tbnotes
	9 22  pitch dup 7 +  tbnotes
	9 22  pitch dup 7 -  tbnotes
	3 0   pitch dup 1+ tbnotes
	2 120  pitch dup 1+ tbnotes
;

: TBEND2
	tbend.setup
	
	2 0  67 66 tbnotes
	3 0  62 63 tbnotes
	1 50 64 65 tbnotes
	10 0  62 70 tbnotes
	4 33 65 68 tbnotes
;

: MSMF1 PLAYNOW " qa_bend_1.mid" $midifile1{ 60 tbend1 }midifile1 ;
: MSMF2 PLAYNOW " qa_bend_2.mid" $midifile1{ tbend2 }midifile1 ;
