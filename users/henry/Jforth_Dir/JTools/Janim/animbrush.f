\ ANIMBrush support for JForth
\
\ Author: Martin Kees  10/14/90
\ Copyright: 1990 Martin Kees
\ Freely distributable to the JForth Community

\ MOD: PLB 10/20/90 1- in abr.ADVANCE for PINGPONG
\ MOD: MCK 11/5/90  fixed abr.GET.FRAME
\ MOD: MCK 11/5/90  $abr.LOAD  missing @ after $anim-file
\ MOD: MCK 11/5/90  $abr.SAVE added
\ MOD: MCK 2/9/91   change 'animbr' to 'abr' in names
\ MOD: MCK 2/11/91  ANIM-ERROR support
\ MOD: MCK 2/11/91  Removed abr.advance from abr.blit and abr.transblit
\ MOD: PLB 10/25/91 Cosmetic changes.
\ MOD: PLB 11/15/91 Rewrote error handling.
\ 00001 PLB 11/27/91 Make ABR.ADVANCE handle change of mode at ends.
\ 00002 PLB 12/4/91 Added ABR.LAST.FRAME?

anew TASK-ANIMBRUSH

: ABR.CHECK ( animbr -- , abort if bad )
	..@ abr_key
	abr_valid_key -
	abort" Invalid or Empty AnimBrush"
;

: ABR.FREE ( animbr -- , free all parts of animbrush )
	dup ..@ abr_key
	abr_valid_key =
	IF  >r  ( save on RS )
		r@ pic.free
		r@ .. abr_DELTAlist freelist?
		r@ ..@ abr_ytable free.ytable
		r> sizeof() animbrush erase
	ELSE
		drop
	THEN
;

: $ABR.LOAD? { $filename animbr  --- error? }
	animbr ABR.free
	$filename $anim.scan? ?goto.error
\
\ validate ANIMBRUSH format
	anim-operation @ 5 =
	anim-interleave @ 1 = \ !!! for ANIMBRUSH
true \ 	anim-bits @ 2 =       \ !!! for ANIMBRUSH
	and and not
	IF
		$anim-file @ $type
		." : AnimBrush-file is not of correct format!" cr
		anim-operation @ ." OP: " .
		anim-interleave @ ." Interleave: " .
		anim-bits @ ." Bits: " . cr
		GOTO.ERROR
	THEN
\
	MEMF_PUBLIC deltacount @ cells allocblock
	dup
	IF deltaptr !
	ELSE
		." No memory for Delta Pointers!" cr GOTO.ERROR
	THEN
\
\ load initial picture
	ilbm.init
	' anim.handler is ilbm.other.handler
	$anim-file @ animbr $pic.load?
	IF
		." Not able to load ILBM" cr goto.error
	THEN
	' 2drop is ilbm.other.handler
\
\ setup animbrush
	$anim-file freevar
	abr_valid_key animbr ..! abr_key
	deltaptr @ animbr ..! abr_deltalist
	deltaptr off
	deltacount @ animbr ..! abr_cels
	deltacount off
\
	abr_FORWARD animbr ..! abr_direction
	abr_LOOP    animbr ..! abr_flags
	0 animbr ..! abr_atdelta
\
	animbr anim.alloc.ytable? ?goto.error
\
	FALSE
	exit
\
ERROR:
	deltaptr freevar
	$anim-file freevar
	animbr abr.free
	TRUE
;


: ABR.LOAD? ( animbursh <filename> -- error? )
	fileword swap $ABR.load?
;

: ABR.ADVANCE { animbr | delta bmap ytab --- }
	animbr ..@ abr_deltalist
	animbr ..@ abr_atdelta cells + @ -> delta
	animbr ..@ abr_ytable -> ytab
	animbr dup ..@ pic_bitmap -> bmap
\
	pic.get.depth 0
	DO
		delta i cells + @ ?dup
		IF
			delta +
			i bmap bmplane[] @ >rel
			ytab
			decode_xorvkplane
		THEN
	LOOP
\
	animbr ..@ abr_atdelta
	animbr ..@ abr_direction +
	animbr ..@ abr_flags
	CASE
		dup abr_Loop and
		?OF
			dup animbr ..@ abr_cels >=   \ if at end?, goto 0 , 00001
			IF drop 0
			ELSE dup -1 <= \ 00001
				IF
					drop
					animbr ..@ abr_cels 1-
				THEN
			THEN
			animbr ..! abr_atdelta
		ENDOF
\
		dup abr_PingPong and
		?OF
\ turn around if at either end, don't repeat end. 00001
			dup animbr ..@ abr_cels 1- >= \ on last one?, go backward
			IF 
				drop animbr ..@ abr_cels 2-  \ second from end 
				abr_BACKWARD animbr ..! abr_direction
			ELSE dup -1 <=
				IF
					drop 0
					abr_FORWARD animbr ..! abr_direction
				THEN
			THEN
			animbr ..! abr_atdelta
		ENDOF
	ENDCASE
;

: ABR.GET.FRAME ( animbr --- current-frame )
	dup>r
	..@ abr_atdelta
	r@ ..@ abr_direction
	abr_FORWARD =
	IF rdrop exit
	ELSE
		1+ dup r> ..@ abr_cels =
		IF drop 0
		THEN
	THEN
;

: ABR.REVERSE ( animbr --- , reverse direction of advance )
	dup>r
	..@ abr_cels 1-
	0
	r@ ..@ abr_direction
	dup negate r@ ..! abr_direction
	abr_BACKWARD =
	IF swap
	THEN
\
	r@ ..@ abr_atdelta =
	IF r@ ..! abr_atdelta
	ELSE
		drop
		r@ ..@ abr_direction
		r@ ..@ abr_atdelta
		+
		r@ ..! abr_atdelta
	THEN
	rdrop
;

: ABR.STATS ( animbrush --- )
	dup>r
	ABR.check
	cr
	." Size: " r@ pic.get.wh swap . ." X " . cr
	." Planes: " r@ pic.get.depth . cr
	." Cells: "  r@ ..@ abr_cels . cr
	." Direction: " r@ ..@ abr_direction
	CASE
		abr_FORWARD OF ." Forward " cr
			ENDOF
		abr_BACKWARD
			OF ." Backward " cr
			ENDOF
		." NOT defined" cr
	ENDCASE
	." Mode: " r@ ..@ abr_flags
	CASE
		abr_loop OF ." Looping " cr
			ENDOF
		abr_pingpong
			OF ." Ping Pong" cr
			ENDOF
		." NOT defined" cr
	ENDCASE
	." Current Frame: " r@ ABR.get.frame . cr
	." Next Delta: " r@ ..@ abr_atdelta . cr
	rdrop
;

: ABR.BLIT ( x y animbr --- )     \ Blits
	pic.blit
;

: ABR.TRANS.BLIT ( x y animbr --- ) \ Blits transparently
	dup>r
	ABR.check
	r@ ..@ pic_shadow 0=
	IF
		r@ pic.alloc.shadow?
		IF
			." No shadow memory" cr
			rdrop exit
		THEN
	THEN
	r@ pic.cast.shadow
	r> pic.trans.blit
;

: ABR.GOTO.FRAME ( frame animbr --- )
	dup>r
	ABR.check
	dup 0 r@ ..@ abr_cels 1-
	within?
	IF
		BEGIN
			dup r@ ABR.get.frame
			=
		WHILE-NOT
			r@ ABR.advance
		REPEAT
		drop
	ELSE
		." Frame:" . ."  is Not in range! "
	THEN
	rdrop
;


: ABR.SAVE.DELTAS ( animbr -- error? )
	anim.save.deltas?
;

: $ABR.SAVE? { $filename animbr --- error? }
	animbr abr.check
\
	0 animbr abr.goto.frame
\
\ setup DPaint chunk
	3 anim-dpan ..! dp_code
	animbr ..@ abr_cels  anim-dpan ..! dp_frames
	0  anim-dpan ..! dp_rate
	0  anim-dpan ..! dp_mode
	animbr ..@ abr_cels  anim-dpan ..! dp_dur
\
	new $filename $iff.open? 0= ?goto.error
\
\ this leaves position on stack
	'ANIM' iff.begin.form? 	IF drop goto.error THEN
\
\ write initial image
	animbr ..@ pic_bitmap
	animbr ..@ pic_ctable  animbr ..@ pic_num_colors
	0
	anim-dpan
	ilbm.write.ilbm+camg+dpan? IF drop ?goto.error THEN
\
\ specific to ANIMBRUSHES
	anim-header sizeof() ANHD erase
	1 anim-header ..! ah_interleave
	2 anim-header ..! ah_bits
\
\ save all deltas
	animbr anim.save.deltas? IF drop goto.error THEN
\
	iff.end.form? ?goto.error
	iff.close
\
	FALSE
	exit
ERROR:
	iff.close
	TRUE
;


: ABR.SAVE? ( animbr <filename> --- )
	fileword swap $ABR.save?
;


: ABR.LAST.FRAME? ( abr -- flag ) \ 00002
	dup ..@ abr_cels 1-
	swap ..@ abr_atdelta =
;

