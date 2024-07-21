\ Simple Tests of JANIM:
\
\ Author: Phil Burk
\ Copyright 1992 Phil Burk

include janim:load_anim

ANEW TASK-TEST_CONVERSION

\ Declare some common objects.

10 value FRAME_DELAY

Picture		MY-PIC-1
AnimBrush	MY-ABR-1
Animation	MY-ANIM-1

\ Convert an animbrush to an ANIM

: CAA.TERM ( -- )
	my-abr-1 abr.free
	my-anim-1 anim.free
	my-pic-1 pic.free
	gr.term
;

if.forgotten caa.term

: CAA.SHOW.ABR { abr -- }
	BEGIN
		50 20 abr abr.blit
		abr abr.last.frame?
		?terminal OR
		?closebox OR not
	WHILE
		abr abr.advance
		frame_delay wait.frames
	REPEAT
;

: CAA.SHOW.ANIM { anim -- , show it once }
	anim anim.rewind
	BEGIN
		10 10 anim s@ an_displaying pic.blit
		frame_delay wait.frames
		anim anim.advance? ?goto.error
		anim anim.last.frame?
		?terminal OR
		?closebox OR
	UNTIL
error:
;

: CONVERT.ABR>ANIM ( -- )
	gr.init
	" JPics:Mountains.pic" my-pic-1 $pic.load? ?goto.error
	" JPics:Bird.anbr" my-abr-1 $abr.load? ?goto.error
\
	my-abr-1 abr.stats
\
\ show brush
	my-abr-1 caa.show.abr
\
\ convert animbrush to anim
	my-abr-1 my-anim-1 animbrush>anim? ?goto.error
	." Animbrush converted!" cr
\
	my-anim-1 caa.show.anim
\
	" Ram:newanim" my-anim-1 $anim.save? ?goto.error
	." Saved to Ram:newAnim" cr
	my-anim-1 anim.stats
\
	caa.term
	exit
error:
	." Error!" cr
	caa.term
;


: CONVERT.ANIM>ABR ( -- >
	gr.init
	" JPics:Mountains.pic" my-pic-1 $pic.load? ?goto.error
	" RAM:NewAnim" my-anim-1 $anim.load? ?goto.error
	my-anim-1 anim.stats cr
\
	my-anim-1 caa.show.anim
\
	my-anim-1 my-abr-1 anim>animbrush? ?goto.error
	." Anim converted!" cr
\
\ show new brush
	my-abr-1 caa.show.abr
\
	" Ram:NewAbr" my-abr-1 $abr.save? ?goto.error
	." Saved in Ram:NewAbr" cr
	my-abr-1 abr.stats
\
	caa.term
	exit
ERROR:
	." Error!" cr
	caa.term
;

." Enter: CONVERT.ABR>ANIM" cr
." then:  CONVERT.ANIM>ABR" cr
