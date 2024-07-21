\  ANIM conversion stuff
\
\ These could eventually be used to convert succesive
\ expanded frames to an ANIM.
\

\ MOD: MCK 11/1/90  optimize asm EORplane
\ MOD: MCK 11/5/90  check for zero deltaplane in CALC.DELTA
\ MOD: MCK 11/14/90 make.delta re-allocates minimum sized delta-work
\ MOD: MCK 11/21/90 add deltaplanes for fast mem. No use of a delta picture
\ MOD: MCK 12/2/90  calc deltaplane as needed , cuts down memory needs
\ MOD: MCK 12/2/90  added animbrushTOanim code
\ MOD: MCK 12/2/90  eliminated skips at end of column
\ MOD: MCK 2/9/91   abr name changes
\ MOD: MCK 2/11/91  anim-error support
\ MOD: MCK 4/26/91  ASM pushbyte
\ MOD: MCK 4/26/91  use dwork local in encodeplane words
\ MOD: MCK 4/26/91  ASM encodecol
\ MOD: MCK 4/28/91  New smarter scanforZU and simpler findop
\ MOD: MCK 5/1/91   10% speedup in EORPlane by unrolling loop
\ MOD: PLB 6/24/91  spelling change - c/_CELL/_CEL/
\ MOD: PLB 11/15/91 Add new error handling. Rename some words.
\ MOD: PLB 11/16/91 Eliminate DELTA-WORK, make ROTPlane use RELATIVE
\          plane addresses, allow PARTIAL conversions.
\ 00001 PLB 11/27/91 Fix ASM syntax, thanks to Jarry Kallaus

getmodule includes
anew task-convert

variable deltaplanes  0 ,  \ allows 2 plane pointers, EOR and ABS bitmap
deltaplanes OFF

\ : pushbyte ( byte memblk -- )
\  dup>r
\  dup freebyte + c!
\  1 r> freebytea +!
\ ;

asm PUSHBYTE ( byte memblk -- )
	move.l   tos,a0
	adda.l   org,a0
	move.l   a0,a1
	subq.l   #8,a1
	move.l   (a1),d0
	move.l   (dsp)+,tos
	move.b   tos,0(a0,d0.l)
	addq.l   #1,d0
	move.l   d0,(a1)
	move.l   (dsp)+,tos
end-code

\ ******************** ANIMATION > ANIMBRUSH CONVERSION

\  ScanForZU
\ Look for zeros, uniq runs in data
\ Z = number of zero bytes
\ U = number of unique-nonzero bytes including singleton zero bytes
\     and same runs of 2
ASM ScanForZU ( dataaddr length -- Z U )
	move.l  (dsp)+,a0
	adda.l  a4,a0
	subq.l  #1,d7
	move.l  d7,d0
	moveq.l #0,d1
	move.l  d1,d2
	move.b  (a0),d4
	move.b  d4,d3
	bne.s   2$
	tst.b   1(a0)
	beq.s   1$
	moveq.l #1,d1
	bra.s   2$
9$: cmp.b   d3,d4
	bne.s   8$
	cmp.b   1(a0,d2.w),d4
	bne.s   8$
	tst.l   d0
	bne.s   10$
	addq.l  #1,d2
	bra.s   5$
10$: subq.l #1,d2
	bra.s   5$
8$: exg     d3,d4
2$: addq.l  #1,d2
	move.b  0(a0,d2.w),d4
7$: dbeq.w  d0,9$
	bne.s   5$			\  added to include a singleton zero
	cmp.w   #0,d0		\  in an uniq run
	beq.s   5$			\
	tst.b   1(a0,d2.w) 		\
	beq.s   5$			\
	bra.s   7$			\
1$: addq.l  #1,d1
	tst.b   0(a0,d1.w)
	dbne.w  d0,1$
5$: move.l  d1,-(dsp)
	move.l  d2,d7
END-CODE

\ SameCount = # identical to first byte in buff
ASM CountSames ( buff length -- SameCount )
	move.l  (dsp)+,a0
	adda.l  a4,a0
	subq.l  #1,d7
	move.l  d7,d0
	moveq.l #0,d7
	move.b  (a0),d4
1$: addq.l  #1,d7
	cmp.b   0(a0,d7.w),d4
	dbne.w  d0,1$
END-CODE

: FINDOP  { buffptr len | Z U  --- cnt op }
	buffptr c@
	IF  buffptr len countsames dup
		2 >
		IF   127 min 0 exit
		ELSE drop
		THEN
	THEN
\
	buffptr len ScanForZU -> U  -> Z
	Z U >=
	IF    Z 127 min dup
	ELSE  U 127 min dup $ 80 OR
	THEN
;

: ENCODECOL { blck  ht dwork | cntaddr ops ---  }
	0 -> ops
	dwork dup freebyte +  -> cntaddr
	0 dwork pushbyte
	blck c@ 0=
	IF blck ht Countsames ht =
		IF exit
		THEN
	THEN
	BEGIN
		ht
	WHILE
		ht  1 =
		IF
			blck c@
			IF
				$ 81 dwork pushbyte
				blck c@ dwork pushbyte
			ELSE ops 1- -> ops
			THEN
			0 -> ht
		ELSE
			blck ht findop
			dup
			IF dup $ 80 and
				IF   \ uniq op
					dwork pushbyte
					dup
					blck dwork dup freebyte + rot cmove
					dup blck + -> blck
					dup dwork freebytea +!
					ht swap - -> ht
				ELSE  \ skip
					dup ht =
					over 127 =
					IF blck ht countsames ht =
					ELSE 0
					THEN
					OR
					IF ddrop 0 -> ht
						ops 1- -> ops
					ELSE  dwork pushbyte
						dup blck + -> blck
						ht swap - -> ht
					THEN
				THEN
			ELSE  \ Same Run
\          	 over 0= IF quit THEN
				dwork pushbyte
				dup dwork pushbyte
				blck c@ dwork pushbyte
				dup blck + -> blck
				ht swap - -> ht
			THEN
		THEN
		1 ops + -> ops
	REPEAT
	ops cntaddr c!
;

: ENCODEPLANE { addr-plane wide high dwork --- }
	wide 0
	DO
		addr-plane i high * +  high dwork encodeCol
	Loop
;

\ ABSOLUTE plane pointers
\ does rotation columns to rows
\ #rows -> #bytes-wide
ASM EORplane ( ABSpl0 ABSpl1 ABSdeltabuff w h --- )
	movem.l a2/d5,-(rp)
	move.l  (dsp)+,d2	\ width
	move.l  (dsp)+,a2	\ eorbuff
	move.l  (dsp)+,a1	\ pl1
	move.l  (dsp)+,a0	\ pl0
	move.l  d2,d3
\    move.l  d7,d4       \ high
	moveq	#0,d0		\ 00001
	bra.s   7$
2$: move.b  0(a0,d0.w),d1
	move.b  0(a1,d0.w),d5
	eor.b   d1,d5
	move.b  d5,(a2)+
	add.w   d2,d0
5$: move.b  0(a0,d0.w),d1
	move.b  0(a1,d0.w),d5
	eor.b   d1,d5
	move.b  d5,(a2)+
	add.w   d2,d0
4$: dbra.w  d4,2$
	moveq.l #0,d0
	adda.l  #1,a0
	adda.l  #1,a1
7$: move.l  d7,d4
	lsr.l   #1,d4
	bcs.s   3$
	dbra.w  d3,4$
	bra.s   6$
3$: dbra.w  d3,5$
6$: movem.l (rp)+,a2/d5
	move.l  (dsp)+,d7
END-CODE


: ABR.MAKE.DELTA  { pic0 pic1 | Wide High deep dwork --- delta | 0 }
\ as calculated ROTATES columns to rows!
	pic0 ..@ pic_bitmap
		dup ..@ bm_bytesperrow -> wide \ in bytes
		..@ bm_rows  -> high
	pic0 pic.get.depth -> deep
\
\ Allocate deltaplane
	deltaplanes freevar
	memf_clear wide high * allocblock dup deltaplanes !
	0= ?goto.error
\
\ set up delta for PUSHBYTE
	[ MEMF_PUBLIC MEMF_CLEAR | ] literal
	high wide deep * *
	dup 2/ + 64 +                \ allows delta to be 1.5*bitmap+64 size
	allocblock dup -> dwork
	0= ?goto.error
\
\ Calculate EORed  planes with rotation
	64 dwork freebytea !
	deep 0
	DO
		i pic0 ..@ pic_bitmap bmplane[] @
		i pic1 ..@ pic_bitmap bmplane[] @
		deltaplanes  @ >abs
		wide  high EORplane
		deltaplanes  @
		dup c@ 0=
		swap wide high * dup>r CountSames
		r> = AND               \ Check for non-changing plane
		IF-NOT
			dwork freebyte i cells dwork + !
			deltaplanes  @
			wide high dwork encodeplane
		THEN
	LOOP
\
\ Re-allocate and copy Delta in minimum sized area
	MEMF_PUBLIC dwork freebyte allocblock -> high
	high 0= ?goto.error
	dwork high over freebyte cmove
	high sizemem high freebytea !
	dwork freeblock 0 -> dwork
	high -> dwork
\
\ Free EOR delta plane
	deltaplanes  freevar
\
	dwork
	exit
\
ERROR:
	dwork ?dup
	IF freeblock
	THEN
	deltaplanes  freevar
	0
;


\ Anim loaded
\ AnimBrush empty
: ANIM>ANIMBRUSH.PARTIAL? { first_frame# last_frame# anim animbr --- error? }
\ check inputs
	anim anim.check
	animbr abr.free
	first_frame# last_frame# max anim ..@ an_cels 1- >
	IF ." ANIM>ANIMBRUSH - Frame# too large!" cr goto.error
	THEN
\
	anim ..@ an_flags
	ANIM_diskmode =
	IF anim anim.disk.open? ?goto.error
	THEN
\
	first_frame# anim anim.goto.frame
\
\ validate and allocate room for CEL delta pointers
	abr_valid_key animbr ..! abr_key
	[ MEMF_public MEMF_clear | ] literal
	anim ..@ an_cels 1-
	first_frame# -
	last_frame# +
	dup animbr ..! abr_cels
	cells allocblock dup animbr ..! abr_deltalist
	0=
	IF
		0 animbr ..! abr_key
		." No mem for deltalist in animbrush" cr
		anim ..@ an_flags ANIM_diskmode AND
		IF  anim.disk.close
		THEN
		goto.error
	THEN
\
	anim ..@ an_ytable
	dup animbr ..! abr_ytable
	add.ytable.user
\
	0 animbr ..! abr_atdelta
	abr_FORWARD animbr ..! abr_direction
	abr_LOOP    animbr ..! abr_flags
\
\ Make all the deltas, loop until we get to where we started.
	BEGIN
		anim ..@ an_hiding
		anim ..@ an_displaying
		abr.make.delta dup 0= IF drop goto.error THEN
		animbr ..@ abr_deltalist push
		anim anim.advance? ?goto.error
		anim ..@ an_atdelta
		last_frame# =
	UNTIL
\
\ make animbrush match anim
	animbr pic.free
	anim ..@ an_hiding animbr pic.duplicate? ?goto.error
	anim ..@ an_hiding animbr pic.copy
	anim ..@ an_flags ANIM_diskmode AND
	IF  anim.disk.close
	THEN
	false
	exit
\	
error:
	animbr abr.free
	anim ..@ an_flags ANIM_diskmode AND
	IF  anim.disk.close
	THEN
\
	true
;

: ANIM>ANIMBRUSH? ( anim animbrush -- error? , convert all of it )
	>r >r 1 1 r> r>
	anim>animbrush.partial?
;

\ *********************  ANIMBRUSH>ANIMATION CONVERSION

\ S = number of non changing bytes
\ U = number of uniq changing bytes
ASM ScanForSU ( srcaddr destaddr length -- S U )
	move.l  (dsp)+,a0           \ dest ptr
	adda.l  a4,a0
	move.l  (dsp)+,a1           \ src ptr
	adda.l  a4,a1
	subq.l  #1,d7
	move.l  d7,d0
	moveq.l #0,d1               \ zero
	move.l  d1,d2               \ counts
	cmpm.b  (a0)+,(a1)+
	beq.s   1$
2$: addq.l  #1,d2
	cmpm.b  (a0)+,(a1)+
7$: dbeq.w  d0,2$
	bne.s   5$			\  added to include a singleton same
	cmp.w   d1,d0		\  in an uniq run
	beq.s   5$			\
	move.b  (a0),d3 		\
	cmp.b   (a1),d3             \
	beq.s   5$			\
	bra.s   7$			\
1$: addq.l  #1,d1
	cmpm.b  (a0)+,(a1)+
	dbne.w  d0,1$
5$: move.l  d1,-(dsp)
	move.l  d2,d7
END-CODE


\ op = Kent VSkip OPcode, see decode.asm
: FINDOPA  { buffptr destptr len | S U  --- cnt op }
	buffptr destptr len scanforSU -> U -> S
	U
	IF
		destptr len countsames dup 2 >
		IF   127 min 0 exit
		ELSE drop
		THEN
	THEN
\
	S
	IF
		S  1 =
		IF
			len 1 =
			IF 1 1 exit
			ELSE
				buffptr 1+
				destptr 1+ len 1-
				ScanForSU nip
				1+ -> U
			THEN
		ELSE  S 127 min dup exit
		THEN
	THEN
\
	U 3 <
	IF    U dup $ 80 OR exit
	ELSE  0
		destptr U 3 - + destptr
		DO
			i 3 countsames
			2 >
			IF drop i LEAVE
			THEN
		LOOP
		?dup
		IF
			destptr  - -> U
			U 0 =
			IF
				destptr
				buffptr 1+ destptr 1+
				len 1-
				scanforSU nip
				1+
				countsames
				0 exit
			THEN
			U 1 =
			IF
				buffptr c@ destptr c@ =
				IF
				1 1 exit
				THEN
			THEN
		THEN
	THEN
	U 127 min dup $ 80 OR
;

: EncodeAbsCol { blk0 blk1  ht dwork | cntaddr ops ---  }
	0 -> ops
	dwork dup freebyte +  -> cntaddr
	0 dwork pushbyte
	blk0 c@ blk1 c@ =
	IF
		blk0 blk1 ht scanforSU drop ht =
		IF exit
		THEN
	THEN
\
	BEGIN
		ht
	WHILE
		ht  1 =
		IF  blk0 c@ blk1 c@ =
			IF-NOT $ 81 dwork pushbyte
				blk1 c@ dwork pushbyte
			ELSE   ops 1- -> ops
			THEN
			0 -> ht
		ELSE
			blk0 blk1 ht findopa
			dup
			IF dup $ 80 and
				IF   \ uniq op
					dwork pushbyte
					dup
					blk1 dwork dup freebyte + rot cmove
					dup blk0 + -> blk0
					dup blk1 + -> blk1
					dup dwork freebytea +!
					ht swap - -> ht
				ELSE  \ skip
					dup  ht  =
					over 127 =
					IF blk0 blk1 ht scanforSU drop ht =
					ELSE 0
					THEN
					OR
					IF ddrop 0 -> ht
						ops 1- -> ops
					ELSE  dwork pushbyte
						dup blk0 + -> blk0
						dup blk1 + -> blk1
						ht swap - -> ht
					THEN
				THEN
			ELSE  \ Same Run
				dwork pushbyte
				dup dwork pushbyte
				blk1 c@ dwork pushbyte
				dup blk0 + -> blk0
				dup blk1 + -> blk1
				ht swap - -> ht
			THEN
		THEN
		1 ops + -> ops
	REPEAT
	ops cntaddr c!
;

: EncodeAbsPlane { plane1 plane2 wide high dwork --- }
	wide 0 DO   i high *
		plane1 over + swap plane2 +  high dwork encodeabsCol
	Loop
;

\ RELATIVE plane pointers
\ does rotation columns to rows
\ #rows -> #bytes-wide
ASM ROTplane ( relpl  relbuff w h --- )
	move.l  (dsp)+,d2	\ width
	move.l  (dsp)+,a1	\ buff
	adda.l  org,a1		\ convert to absolute
	move.l  (dsp)+,a0	\ pl
	adda.l  org,a0		\ convert to absolute
	move.l  d2,d3
	move.l  d7,d4       \ high
	moveq.l #0,d0
	bra.s   3$
2$: move.b  0(a0,d0.w),d1
	move.b  d1,(a1)+
	add.w   d2,d0
4$: dbra.w  d4,2$
	moveq.l #0,d0
	adda.l  #1,a0
	move.l  d7,d4
3$: dbra.w  d3,4$
	move.l  (dsp)+,d7
END-CODE


: ANIM.MAKE.DELTA { pic0 pic1 | Wide High deep dwork --- delta }
	0 -> dwork
\
\ as calculated ROTATES columns to rows!
	pic0 ..@ pic_bitmap
		dup ..@ bm_bytesperrow -> wide
		..@ bm_rows  -> high
	pic0 pic.get.depth -> deep
\
\ Allocate deltaplanespad
	2 0
	DO
		memf_clear wide high * allocblock dup 0=
		IF
			drop ." ANIM.MAKE.DELTA - insufficient memory!" cr
			goto.error
		THEN
		i cells deltaplanes + \ calc address
		dup freevar \ free old
		! \ save new
	LOOP
\
\ set up delta for PUSHBYTE
	[ MEMF_PUBLIC MEMF_CLEAR | ] literal
	high wide deep * *
	dup 2/ + 64 +                \ allows delta to be 1.5*+64 bitmap size
	allocblock dup -> dwork
	0= ?goto.error
	
	64 dwork freebytea !
\
	deep 0
	DO
\ rotate information in planes
		i pic0 ..@ pic_bitmap bmplane[] @ >rel
		deltaplanes @
		wide  high ROTplane
\
		i pic1 ..@ pic_bitmap bmplane[] @ >rel
		deltaplanes cell+ @
		wide  high ROTplane
\
		deltaplanes @ deltaplanes cell+ @
		wide high * dup>r scanforSU drop
		r> =                      \ Check for non-changing plane
		IF-NOT
			dwork freebyte i cells dwork + !
			deltaplanes @ deltaplanes cell+ @
			wide high dwork encodeabsplane
		THEN
	LOOP
\
\ Re-allocate and copy Delta in minimum sized area
	MEMF_PUBLIC dwork freebyte allocblock -> high
	high 0= ?goto.error
\
\ copy information
	dwork high over freebyte cmove
	high sizemem high freebytea !
	dwork freeblock 0 -> dwork
	high -> dwork
\
\ Free abs delta planes
	deltaplanes  freevar
	deltaplanes cell+ freevar
	dwork
	exit
\
ERROR:
	dwork ?dup
	IF freeblock 0 -> dwork
	THEN
	deltaplanes  freevar
	deltaplanes cell+ freevar
	0 \ no delta allocated
;

\ animbrush loaded
\ anim empty
: ANIMBRUSH>ANIM.PARTIAL?
{ first_frame# last_frame# animbr anim | frm direction mode dwork -- error? }
	animbr abr.check
	anim anim.free
\
\ save ANIMBRUSH characteristics for later restoration
	animbr abr.get.frame -> frm \ frame number
	animbr ..@ abr_direction -> direction
	animbr ..@ abr_flags -> mode
\
	abr_LOOP animbr ..! abr_flags
	direction abr_BACKWARD = IF animbr abr.reverse
		THEN
\
\ start at beginning
	first_frame# animbr abr.goto.frame
\
\ duplicate resolution, etc.
	animbr anim pic.duplicate? ?goto.error
	animbr anim .. an_pic1 pic.duplicate? ?goto.error
	anim_valid_key anim ..! an_key
\
\ allocate memory for delta list
	[ MEMF_public MEMF_clear | ] literal
	animbr ..@ abr_cels
	first_frame# -
	last_frame# +
	dup anim ..! an_cels
	cells allocblock dup anim ..! an_deltalist
	0= ?goto.error
\
\ use its ytable
	animbr ..@ abr_ytable
	dup anim ..! an_ytable
	add.ytable.user
	0 anim ..! an_atdelta
\
\ calculate delta between first and second frame
\	animbr anim pic.clone
animbr anim pic.copy
	animbr abr.advance
\	animbr anim .. an_pic1 pic.clone
animbr anim .. an_pic1 pic.copy
	anim animbr anim.make.delta ?dup
	IF
		anim ..@ an_deltalist push
	ELSE goto.error
	THEN
\
	animbr abr.advance
	anim animbr anim.make.delta ?dup
	IF
		anim ..@ an_deltalist push
	ELSE goto.error
	THEN
\
\ loop through remaining frames pushing deltas
	BEGIN
\		anim .. an_pic1 anim pic.clone
\		animbr anim .. an_pic1 pic.clone
		anim .. an_pic1 anim pic.copy
		animbr anim .. an_pic1 pic.copy
		
		animbr abr.advance
\
		anim animbr anim.make.delta ?dup
		IF
			anim ..@ an_deltalist push
		ELSE goto.error
		THEN
		animbr abr.get.frame
		last_frame# =
	UNTIL
\
\ restore animbrush characteristics
\	anim .. an_pic1 anim pic.clone
	anim .. an_pic1 anim pic.copy
	mode animbr ..! abr_flags
	direction animbr ..@ abr_direction =
	IF-NOT animbr abr.reverse
	THEN
	frm animbr abr.goto.frame
	anim anim ..! an_displaying
	anim .. an_pic1 anim ..! an_hiding
\
	false
	exit
\
ERROR:
	anim anim.free
	true
;

: ANIMBRUSH>ANIM? ( animbr anim -- error? )
	>r >r 0 1 r> r>
	animbrush>anim.partial?
;

\ You need to set screen resolution for the created anim
\ in order to save and load it again i.e
\ HIRES LACE | myanim ..! an_CAMG
