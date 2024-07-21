\ ANIM support for JForth, read and write IFF ANIM files.
\
\ Utility for ANIM-5 support in JForth
\ that adds to Phil Burk's IFF files
\ in an integrated manner.
\
\ Author: Martin Kees    10/13/90
\ Copyright: 1990 Martin Kees
\ Freely distributable to the JForth Community

\ MOD: MCK 11/5/90 need @ in $ANIM.LOAD after $anim-file
\ MOD: MCK 11/5/90 more info in error meesage in $anim.load
\ MOD: MCK 11/5/90 added an_CAMG item in anim.load for easier save
\ MOD: MCK 11/10/90 added anim.display to be able to cycle anim hidden
\ MOD: MCK 11/21/90 added anim-dpan structure
\ MOD: MCK 2/11-91  ANIM-ERROR changes
\ 00001 PLB 9/5/91 Disabled ANIM.DISPLAY in $ANIM.LOAD
\ 00002 PLB 10/25/91 Sizeof() does not need [ ] LITERAL
\ 00003 PLB 11/16/91 Extensive revision for new error handlers.
\ 00004 PLB 11/19/91 Don't erase ANIM-HEADER in SAVE.DELTAS
\ 00005 PLB 11/19/91 Set AH_W to #pixels, not #bytes.
\ 00006 PLB 1/28/92 Use 1 ANIM.GOTO.FRAME instead of ANIM.REWIND

ANEW TASK-ANIM_IFF

ANHD anim-header
DPAN anim-dpan
variable $anim-file
variable anim-operation
variable anim-interleave
variable anim-bits
variable anim-scanflag
variable deltaptr
variable seekptr
variable sizeptr
variable deltacount

: ANIM.READ.ANHD? ( size --- error? , read anim header )
	dup sizeof() ANHD <
	IF " Short AnimHeader!" cr
		drop TRUE
	ELSE
		anim-header swap
		iff.read?
	THEN
;

: ANIM.PARSER ( size chkid -- , recursively parse ANIM )
	2dup iff.special?
	IF 2drop
	ELSE ( -- size chkid )
	CASE
		'ANHD'
		OF anim-header @ \ Is this NOT the first ANHD in the file?
			IF
				anim.read.anhd? ?goto.error
				anim-header ..@ ah_operation
				anim-operation @ =
				anim-header ..@ ah_interleave
				anim-interleave @ =
				anim-header ..@ ah_bits
				anim-bits @ =
				and and
				IF-NOT anim-scanflag off
				THEN
			ELSE
				anim.read.anhd? ?goto.error
				anim-header ..@ ah_operation
				anim-operation !
				anim-header ..@ ah_interleave
				anim-interleave !
				anim-header ..@ ah_bits
				anim-bits !
			THEN
		ENDOF
		'DLTA'
		OF
			1 deltacount +!
			drop
		ENDOF
	drop
	ENDCASE
	THEN
	exit
ERROR:
	iff-stop on
	iff-error on
;

: ANIM.HANDLER ( size chkid -- , handles ANIM specific chunks, eg. DLTA )
	'DLTA' =
	IF
		iff.read.data deltaptr @ push
	ELSE drop
	THEN
;

: ANIM.DISK.HANDLER ( size chkid -- , handles ANIM specific chunks )
	'DLTA' =
	IF
		sizeptr @ push
		iff.where seekptr @ push
	ELSE drop
	THEN
;

: $ANIM.PREP? ( $filename --- error? )
	anim-header sizeof() ANHD erase
	$anim-file freevar
	anim-operation off
	anim-interleave off
	anim-bits off
	anim-scanflag ON
	deltacount off
	deltaptr freelist?
	seekptr freevar
	sizeptr freevar
\
\ save filename
	dup c@ 1+ MEMF_PUBLIC swap allocblock
	dup 0=
	IF
		." No Memory for filename?" cr
		2drop TRUE
	ELSE
		dup $anim-file !
		$move
		FALSE
	THEN
;

: ANIM.ALLOC.YTABLE? { animatn -- error? , alloc mult table }
	animatn ..@ pic_bitmap
	dup ..@ bm_bytesperrow
	swap ..@ bm_rows
	alloc.ytable
	dup animatn ..! an_ytable
	0=
	IF
		." No memory for anim Y-table." cr
		TRUE
	ELSE FALSE
	THEN
;

: $ANIM.SCAN? ( $filename --- error? )
	$anim.prep?
	IF
		TRUE
	ELSE
		what's iff.process.chunk
		' anim.parser is iff.process.chunk
		$anim-file @ $iff.dofile?
		swap is iff.process.chunk
	THEN
	anim-scanflag @ 0= AND  \ also incorporate this mysterious error flag
;

: $ANIM.LOAD? { $filename animatn  --- error? }
	$filename $anim.scan? ?goto.error
\
\ validate ANIM format
	anim-operation @ 5 =
	anim-interleave @ 0 =
	anim-bits @ 0 =
	and and NOT
	IF \ Bad format!
		$anim-file @ $type
		." : Anim-file is not of correct format!" cr
		anim-operation @ ." OP: " .
		anim-interleave @ ." Interleave: " .
		anim-bits @ ." Bits: " . cr
		goto.error
	THEN
\
	ilbm.init
	animatn ..@ an_flags
	anim_diskmode and
	IF
\
\ disk mode alocation
		MEMF_PUBLIC deltacount @ cells allocblock
		dup seekptr ! 0=
		MEMF_PUBLIC deltacount @ cells allocblock
		dup sizeptr ! 0=
		or 
		IF
			." No memory for disk pointers!" cr
			goto.error
		THEN
		' anim.disk.handler is ilbm.other.handler
	ELSE
\
\ memory mode allocation
		MEMF_PUBLIC deltacount @ cells allocblock
		dup
		IF deltaptr !
		ELSE
			drop
			" No memory for Deltas!" cr
			goto.error
		THEN
		' anim.handler is ilbm.other.handler
	THEN
\
\ load initial picture
	$anim-file @ animatn $pic.load?
	IF
		." Not able to load ILBM" cr
		goto.error
	THEN
	' 2drop is ilbm.other.handler
\
\ make duplicate image for double buffer
	animatn  dup .. an_pic1 pic.duplicate? ?goto.error
	animatn  dup .. an_pic1 pic.copy
\
\ setup animation
	anim_valid_key animatn ..! an_key
	deltaptr @ animatn ..! an_deltalist
	deltaptr off
	deltacount @ animatn ..! an_cels
	deltacount off
	seekptr @ animatn ..! an_seeklist
	seekptr off
	sizeptr @ animatn ..! an_sizelist
	sizeptr off
\
	ilbm-camg @ animatn ..! an_CAMG
	animatn dup ..!  an_displaying
	animatn .. an_pic1 animatn ..! an_hiding
	0 animatn ..! an_atdelta
\
	animatn anim.alloc.ytable? ?goto.error
\
\ set filename if disk based
	animatn ..@ an_flags
	anim_diskmode and
	IF
		$anim-file @
		animatn ..! an_$filename
		$anim-file off
	ELSE $anim-file freevar
	THEN
	false
	exit
\
ERROR:
	seekptr freevar
	sizeptr freevar
	deltaptr freevar
	$anim-file freevar
	true
;

: $ANIM.DISK.LOAD? ( $filename animation  --- error? )
	dup ..@ an_flags anim_diskmode OR
	over ..! an_flags
	$anim.load?
;


: ANIM.LOAD? ( animation <filename> -- error? )
	fileword swap $anim.load?
;

: ANIM.DISK.LOAD? ( animation <file> -- error? )
	fileword swap $anim.disk.load?
;

: ANIM.SAVE.DELTAS? { animatn -- error? , save delta chunks }
\ This is called for for ANIMBRUSHES!!!
\ Be careful about changing this!
	5 anim-header ..! ah_operation
	1 anim-header ..! ah_reltime
	animatn ..@ pic_bitmap dup
		..@ bm_bytesperrow 8 * anim-header ..! ah_w \ 00005
		..@ bm_rows anim-header ..! ah_h
\
	animatn ..@ an_cels 0
	DO
		'ILBM' iff.begin.form? IF drop goto.error THEN
\
		anim-header sizeof() ANHD 'ANHD'
		iff.write.chunk? IF drop goto.error THEN
\
		animatn ..@ an_deltalist i cells + @
		dup sizemem 'DLTA'
		iff.write.chunk? IF drop goto.error THEN
\
		iff.end.form? ?goto.error
	LOOP
	false
	exit
ERROR:
	." ANIM.SAVE.DELTAS? failed!" cr
	true
;

: $ANIM.SAVE? { $filename animatn --- error? }
	animatn anim.check
	animatn ..@ an_flags
	anim_diskmode and
	IF ." Can't save DISK-MODE anim" abort \ programmer error
	THEN
\
	1 animatn anim.goto.frame \ to generate first and second pic 00006
\
\ setup DPaint chunk
	3 anim-dpan ..! dp_code
	animatn ..@ an_cels 2- anim-dpan ..! dp_frames
	15 anim-dpan ..! dp_rate
	0  anim-dpan ..! dp_mode
	0  anim-dpan ..! dp_dur
\
	$filename new $iff.open? 0= ?goto.error
\
\ this leaves position on stack
	'ANIM' iff.begin.form? IF drop goto.error THEN
\
\ write initial image
	animatn ..@ an_hiding >r  \ use hidden picture
	r@ ..@ pic_bitmap
	r@ ..@ pic_ctable
	r> ..@ pic_num_colors
	animatn ..@ an_CAMG
	anim-dpan
	ilbm.write.ilbm+camg+dpan? IF drop goto.error THEN
\
\ save all deltas
	anim-header sizeof() ANHD erase
	animatn anim.save.deltas? IF drop goto.error THEN
\
	iff.end.form? 	    ?goto.error
	iff.close
\
	FALSE
	EXIT
\
ERROR:
	iff.close
	TRUE
;

: ANIM.SAVE? ( anim <filename> --- error? )
	fileword swap $anim.save?
;


