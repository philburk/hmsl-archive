\ ANIM support for JForth, advance and display ANIMS
\
\ Utility for ANIM-5 support in JForth
\ that adds to Phil Burk's IFF files
\ in an integrated manner.
\
\ Author: Martin Kees  10/14/90
\ Copyright: 1990 Martin Kees
\ Freely distributable to the JForth Community

\ MOD: MCK 11/5/90  added ANIM.SAVE
\ MOD: MCK 11/8/90  added ?closebox to ANIM.PLAY
\ MOD: MCK 11/8/90  added file open check in ANIM.APPLYDISKDELTA
\ MOD: MCK 11/10/90 used anim.display in anim.advance for hidden
\                   transition support
\ MOD: MCK 2/11/91  ANIM-ERROR support
\ 00001 PLB 11/15/91 Removed calls to pic.?break
\ 00002 PLB 11/15/91 New error handling scheme. Add ANIM.REWIND
\ 00003 PLB 11/15/91 Add ANIM.VIEW, use ANIM.VIEW in ANIM.ADVANCE
\ 00004 PLB 11/17/91 Add ANIM.GOTO.FRAME
\ 00005 PLB 12/4/91 Made ANIM.ADVANCE not display. Added ANIM.DISPLAY.NEXT
\           Removed references to ANIM-DISPLAYFLAG
\ 00006 PLB 1/26/92 Changed ILBM.WRITE.BITMAP to ILBM.WRITE.BITMAP?
\ 00007 PLB 1/28/92 Added ANIM.BLIT, fixed 0 ANIM.GOTO.FRAME,
\           Changed ANIM.REWIND to use 0.

getmodule includes
ANEW TASK-ANIM

: FREELIST? ( memptraddr -- , free a dynamic stack of allocated mem )
	dup @
	IF  dup @ dup freebyte 0
		DO dup i + freevar
			cell
		+LOOP
		drop
		freevar
	ELSE drop
	THEN
;

variable DELTA-BUFF \ holds deltas for disk based anim, only ONE at a time

: ANIM.CHECK ( animation -- , abort if bad )
	..@ an_key
	anim_valid_key -
	abort" Invalid or Empty Animation"
\	pic.?break \ 00001
;

: ANIM.DISPLAY ( anim -- )
	s@ an_displaying pic.display
;

: ANIM.VIEW ( anim -- )
	s@ an_displaying pic.view
;

: ANIM.BLIT ( xpos ypos anim -- , blit current pic ) \ 00007
	s@ an_displaying pic.blit
;

: ANIM.FREE ( animation -- , free all parts of animation )
	dup ..@ an_key
	anim_valid_key =
	IF  >r  ( save on RS )
		r@ pic.free
		r@ .. an_pic1 pic.free
		r@ .. an_DELTAlist freelist?
		r@ .. an_seeklist  freevar
		r@ .. an_sizelist  freevar
		r@ ..@ an_ytable   free.ytable
		r@ .. an_$filename freevar
		r> sizeof() animation erase
	ELSE
		drop
	THEN
;

: ANIM.GET.DEPTH ( animation -- depth )
	..@ pic_bitmap ..@ bm_depth
;


: ANIM.APPLYDELTA { anim | delta bmap  ytab --- }
	anim ..@ an_ytable -> ytab
	anim ..@ an_deltalist
	anim ..@ an_atdelta cells + @ -> delta
	anim ..@ an_hiding dup ..@ pic_bitmap -> bmap
\
	pic.get.depth 0
	DO
		delta i cells + @
		?dup
		IF delta +
			i bmap bmplane[] @ >rel
			ytab
			decode_vkplane
		THEN
	LOOP
	anim ..@ an_atdelta 1+
	dup anim ..@ an_cels = IF drop 1
		THEN
	anim ..! an_atdelta
;

: ANIM.APPLYDISKDELTA? { anim | bmap  ytab --- error? }
	iff-fileid @
	IF
\ get seek position
		anim ..@ an_seeklist
		anim ..@ an_atdelta cells dup>r + @ iff.seek
\
\ read delta
		delta-buff @
		anim ..@ an_sizelist r> + @ iff.read? ?goto.error
\
		anim ..@ an_hiding dup ..@ pic_bitmap -> bmap
		anim ..@ an_ytable -> ytab
		pic.get.depth 0
		DO
			delta-buff @ i cells + @ ?dup
			IF
				delta-buff @ +
				i bmap bmplane[] @ >rel
				ytab
				decode_vkplane
			THEN
		LOOP
		anim ..@ an_atdelta 1+
		dup anim ..@ an_cels =
		IF drop 1
		THEN
		anim ..! an_atdelta
	ELSE \ This is a programmer error so it is OK to abort!
		." ANIM.APPLYDISKDELTA? - Anim file not open! " abort
	THEN
	false
	exit
\
ERROR:
	true
;

: ANIM.DISK.OPEN? { animatn -- error? }
	delta-buff freevar
	animatn ..@ an_$filename $iff.open? 0= ?goto.error
\ find size of largest cel
	animatn ..@ an_sizelist 0
	animatn ..@ an_cels 0
	DO over i cells + @ max
	LOOP
	nip
\
\ allocate buffer for that
	MEMF_PUBLIC swap allocblock delta-buff !
	delta-buff @ 0=
	IF ." Couldn't allocate delta buffer! " cr
		iff.close
		goto.error
	THEN
	false
	exit
\
ERROR:
	true
;

: ANIM.DISK.CLOSE ( --- )
	iff.close
	delta-buff freevar
;

: ANIM.ADVANCE? ( animation -- error? )
	>r
	r@ ..@ an_flags anim_diskmode and
	IF    r@ anim.applydiskdelta?
	ELSE  r@ anim.applydelta false \ no error
	THEN
	r@ ..@ an_hiding
	r@ ..@ an_displaying
	r@ ..! an_hiding
	r@ ..! an_displaying
	rdrop
;

: ANIM.ADVANCE ( animation -- )
	anim.advance?
	IF
		." ANIM.ADVANCE - couldn't!" cr abort
	THEN
;

: ANIM.VIEW.NEXT? ( animation -- error? ) \ 00005
	dup anim.advance? 0=
	IF
		anim.view FALSE
	ELSE
		drop TRUE
	THEN
;

: ANIM.DISPLAY.NEXT? ( animation -- error? ) \ 00005
	dup anim.advance? 0=
	IF
		anim.display FALSE
	ELSE
		drop TRUE
	THEN
;

: ANIM.LAST.FRAME? ( animation --- flag )
	dup ..@ an_cels 1-
	swap ..@ an_atdelta
	=
;

DEFER ANIM.DELAY
' Noop is anim.delay

: ANIM.PLAY { loopflag animatn --- }
	animatn anim.check
	animatn ..@ an_flags anim_diskmode and
	IF animatn anim.disk.open? ?goto.error
	THEN
\
	loopflag
	IF \ loop continuously
		BEGIN
			animatn anim.view.next? \ 00005
			anim.delay
			?terminal  OR
			?closebox OR
		UNTIL
	ELSE \ loop once
		BEGIN
			animatn anim.view.next? \ 00005
			anim.delay
			animatn anim.last.frame? OR
			?terminal OR
			?closebox OR
		UNTIL
	THEN
\
	animatn ..@ an_flags anim_diskmode and
	IF anim.disk.close
	THEN
error:
;

: ANIM.STATS ( animation --- )
	>r
	r@ anim.check
	cr
	." Size: " r@ pic.get.wh swap . ." X " . cr
	." Planes: " r@ anim.get.depth . cr
	." Cells: "  r@ ..@ an_cels 1- . cr
	." Mode: " r@ ..@ an_flags
		anim_diskmode and
		IF ." Disk Mode" cr
		ELSE ." Memory Mode" cr
		THEN
	." Current frame: " r@ ..@ an_atdelta . cr
	rdrop
;


: ILBM.WRITE.ILBM+CAMG+DPAN?  { bmap ctable ctable# camg dpancnk -- error? }
\ This word is needed if writing a screen of data.
	iff-fileid @ 0=
	IF ." You must open an IFF file first using $IFF.OPEN?" cr
		abort
	THEN
	'ilbm' iff.begin.form? ?goto.error  ( -- formpos )
\
\ Write CAMG value.
	camg pad !
	pad 4 'CAMG' iff.write.chunk? ?goto.error
\
\ Generate CMAP and write it.
	ctable
	IF  ctable pad ctable# ctable>cmap  ( use pad to pack cmap )
		pad ctable# 3 * 'CMAP' iff.write.chunk? ?goto.error
	THEN
\
\ Write DPAN chunk
	dpancnk
	IF  dpancnk 8 'DPAN' iff.write.chunk? ?goto.error
	THEN
\
\ Write Bitmap
	bmap ilbm.write.bitmap? ?goto.error \ 00006
\
\ Close out 'FORM'
	( -- formpos ) iff.end.form? ?goto.error
	false
	exit
\
ERROR:
	true
;

: ANIM.GOTO.FRAME { frame# animatn -- , advance to that frame }
	frame# animatn ..@ an_cels <
	IF
\ don't wait for zero because you'll never get there, 00007
		frame# 0=
		IF
			animatn ..@ an_cels 1-  \ that's when cel0 reappears
			-> frame#
		THEN
		BEGIN
			animatn ..@ an_atdelta
			frame# =
		WHILE-NOT
			animatn anim.advance? ?goto.error
		REPEAT
	ELSE
		." ANIM.GOTO.FRAME - frame# too large!" cr
	THEN
	exit
error:
	." ANIM.GOTO.FRAME failed!" cr
;

: ANIM.REWIND ( animation -- , rewind to beginning )
	0 swap anim.goto.frame \ 00007
;


