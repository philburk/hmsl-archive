\  YTABLE allocator for JForth ANIM-5 support
\
\ YTABLEs are fast multiplication tables used to speed up
\ decoding of packed ANIMs.
\
\ Author: Martin Kees 10/13/90
\ Copyright 1990 Martin Kees
\ Freely Distributable to the JForth Community
\
\ MOD: MCK 11/8/90 cleanup ALLOC.YTABLE with no recurse
\ MOD: MCK 11/8/90 fixed FIND.YTABLE logic/stack error
\ MOD: MCK 11/8/90 used variable instead of v:
\ MOD: MCK 1/11/91 NO need for ytables with more than 128 entries!
\                  Since Skips are a max of 127 lines
\ MOD: MCK 1/11/91 uses larger table if already allocated
\ MOD: MCK 2/11/91 anim.error added to anim.init
\                  other errors reflected in flag returned on stack
\ 00001 PLB 11/16/91 New error handling system,
\					renamed ALLOC.ANIM-YTABLE to ALLOC.YTABLE.TRACKER
anew TASK-YTABLE

variable ANIM-YTABLE
128 constant MAX_YTABS  \ Increase this if you run out of YTABLES

: ALLOC.YTABLE.TRACKER ( -- tracker )
	anim-ytable @ ?dup
	IF
		." ANIM seems to be intitialized already."  cr
		\ non-fatal error
	ELSE
		[ MEMF_PUBLIC MEMF_CLEAR | ] literal
		Max_ytabs cells allocblock
		dup anim-ytable ! 0=
		IF
			." No memory for Ytables!" cr
		THEN
		anim-ytable @
	THEN
;

: CREATE.YTABLE { byteoffset linesize | ytab --- ytab | 0 }
	[ MEMF_PUBLIC MEMF_CLEAR | ] literal
	linesize 128 min dup -> linesize
	2* allocblock -> ytab
	ytab
	IF 0
\ generate multiplication table
		linesize 0
		DO dup ytab i 2* + w!
			byteoffset +
		LOOP
		drop
	THEN
	ytab
;

: FIND.YTABLE { byteoffset linesize | ytab --- ytab | 0 , find match }
	0 -> ytab
	anim-ytable @
	dup freebyte 0
	DO
		dup i + @ ?dup
		IF
			dup @ byteoffset =
			IF
				dup sizemem 2/ linesize 128 min >=
				IF -> ytab
					LEAVE
				THEN
			THEN
			drop
		THEN
		cell
	+LOOP
	drop
	ytab
;

: ADD.YTABLE.USER  ( ytable -- , increment user counter )
	1 swap freebytea +!
;

: ALLOC.YTABLE { byteoffset linesize | ytable -- ytable | 0 }
	0 -> ytable
	anim-ytable @ 0=
	IF alloc.ytable.tracker 0= ?goto.error
	THEN
\
\ Try to find a matching table
	byteoffset linesize find.ytable dup -> ytable
	IF ytable add.ytable.user
	ELSE
\
\ Is there room to keep track of another YTABLE ?
		anim-ytable @ freebyte 4 /
		Max_ytabs = \ are we full
		IF 
			." ALLOC.YTABLE - exceeded MAX_YTABS!" cr
			goto.error
		ELSE
\
\ Create a new one.
			byteoffset linesize create.ytable dup -> ytable
			IF
				ytable anim-ytable @ push
				1 ytable freebytea !
			ELSE
				." ALLOC.YTABLE - insufficient memory!" cr
				goto.error
			THEN
		THEN
	THEN
	ytable
	exit
ERROR:
	0
;

: FREE.YTABLE ( ytable --- )
	>r
	-1 r@ freebytea +!
	r@ freebytea @
	IF rdrop
	ELSE r@ freeblock
		r> anim-ytable -stack
	THEN
;

