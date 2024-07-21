\ Used for examining IFF files.
\
\ Show contents of all chunks.
\ Author: Phil Burk
\ Copyright 1991 All Rights Reserved.

getmodule includes
include? picture jiff:load_pic
include? ANHD JANIM:ANIM.J

ANEW TASK-DumpIFF

decimal

: .BYTE ( byte -- , print as two digits )
	s->d <# # #S #> type space
;

: ?STOP ( -- flag , true if user wants out )
	?terminal dup
	IF
		drop >newline
		key drop \ from ?terminal
		." Hit 'Q' to QUIT, any other key to continue."
		key cr
		dup ascii q = swap ascii Q = or
	THEN
;

variable DIF-DLTA-COUNT
variable DIF-BODY-COUNT
256 constant DIF_PAD_SIZE
create DIF-PAD DIF_PAD_SIZE allot 0 ,

: DUMP.DATA { addr size -- , dump showing offset into data }
	>newline
	base @ >r  $ 10 base !
\
\ print header
	8 spaces
	16 0
	DO
		i 3 .r
	LOOP
	cr
\
\ print data
	size 16 / 1+ 0
	DO
		i 16 * dup 6 .r 3 spaces
		addr +  ( address of next byte )
		16 0
		DO
			dup c@ .byte
			1+
		LOOP
		drop cr
		?stop IF iff-stop on LEAVE THEN
	LOOP
	r> base !
;
	
: DIF.DUMP.DATA { size chunkid -- }
	size dif_pad_size >
	IF
		dif_pad_size -> size ." Only showing part of "
		chunkid .chkid ."  chunk!" cr
	THEN
	dif-pad size iff.read size -
	IF
		." ANIM.DUMP.CHUNK - Truncated "
		chunkid .chkid ."  chunk!" cr
	THEN
	dif-pad size dump.data
;

: DUMP.BMHD ( bitmapheader -- )
	>r
	>newline
	." X,Y     = " r@ s@ bmh_x . r@ s@ bmh_x . cr
	." W,H     = " r@ s@ bmh_w . r@ s@ bmh_h . cr
	." NPlanes = " r@ s@ bmh_nplanes . cr
	." Masking = " r@ s@ bmh_masking . cr
	." Compres = " r@ s@ bmh_compression . cr
	." TransColor = " r@ s@ bmh_transparentcolor . cr
	." Page W,H = " r@ s@ bmh_pagewidth .
	r@ s@ bmh_pageheight . cr
	rdrop
;

: DUMP.ANHD ( Animheader -- )
	>r
	>newline
	." Operatn = " r@ s@ ah_operation . cr
	." Mask    = " r@ s@ ah_mask  . cr
	." X,Y     = " r@ s@ ah_x . r@ s@ ah_x . cr
	." W,H     = " r@ s@ ah_w . r@ s@ ah_h . cr
	." ABSTime = " r@ s@ ah_abstime . cr
	." RELTime = " r@ s@ ah_reltime . cr
	." Interlv = " r@ s@ ah_interleave . cr
	." Bits    = " r@ s@ ah_bits . cr
	." Pad16:" cr r@ .. ah_pad16 16 dump.data
	rdrop
;

: DUMP.DPAN ( DPAN_chunk -- , from Deluxe Paint, mysterious )
	>r
	>newline
	." Code    = " r@ s@ dp_code . cr
	." #Frames = " r@ s@ dp_frames  . cr
	." Rate    = " r@ s@ dp_rate . cr
	." Mode    = " r@ s@ dp_mode . cr
	." Dur (?) = " r@ s@ dp_dur . cr
	rdrop
;
: ANIM.DUMP.CHUNK { size chunkid -- , default handler used to parse }
	chunkid
	CASE
		'BMHD'
		OF
			dif-pad size iff.read sizeof() BitMapHeader -
			IF ." ANIM.DUMP.CHUNK - Oddly sized BitMapHeader!" cr
			THEN
			dif-pad dump.BMHD
		ENDOF
		'BODY'
		OF
			size chunkid dif.dump.data
			1 dif-body-count +!
		ENDOF
		'CMAP'
		OF
			size dif_pad_size >
			IF dif_pad_size -> size ." Only showing part of CMAP chunk!" cr
			THEN
			dif-pad size iff.read size -
			IF ." ANIM.DUMP.CHUNK - Truncated CMAP chunk!" cr
			THEN
			
			size 3 / 0
			DO
				i 8 .r space
				base @ >r hex
				i 3 * dif-pad +
				dup c@ 3 .r 1+
				dup c@ 3 .r 1+
				c@ 3 .r cr
				r> base !
				?stop IF iff-stop on LEAVE THEN
			LOOP
		ENDOF
		'GRAB'
		OF
			dif-pad size iff.read 4 -
			IF ." Oddly sized GRAB" cr
			THEN
			." X = " dif-pad w@ .hex
			." , Y = " dif-pad 2+ w@ .hex cr
		ENDOF
		'CAMG'
		OF
			dif-pad size iff.read 4 -
			IF ." Oddly sized CAMG" cr
			THEN
			dif-pad @ .hex cr
		ENDOF
		'ANHD'
		OF
			dif-pad size iff.read sizeof() ANHD -
			IF ." ANIM.DUMP.CHUNK - Oddly sized ANHD" cr
			THEN
			dif-pad dump.ANHD
		ENDOF
		'DPAN'
		OF
			dif-pad size iff.read sizeof() DPAN -
			IF ." ANIM.DUMP.CHUNK - Oddly sized DPAN" cr
			THEN
			dif-pad dump.DPAN
		ENDOF
		'DLTA'
		OF
			size chunkid dif.dump.data
			1 dif-dlta-count +!
		ENDOF
\
\ default handling
		size chunkid dif.dump.data
	ENDCASE
	?stop IF iff-stop on THEN
;

: ANIM.PRINT.CHUNK  { size chunkid -- }
\ indent
	iff-stop @ 0=
	IF
		>newline
		ascii - 40 emit-to-column cr
		iff-nested @ 5 * spaces	chunkid .chkid space size . cr
		size chunkid iff.special? not
		IF
			size chunkid anim.dump.chunk
		THEN
	THEN
;

: DIF.STATS ( -- )
	ascii - 40 emit-to-column cr
	." File contains:" cr
	dif-body-count @ 8 .r ."  BODY chunks" cr
	dif-dlta-count @ 8 .r ."  DLTA chunks" cr
;

: $DUMPIFF ( $filename -- , print chunks )
	>newline
	." DumpIFF V1.0 by Phil Burk, written in JForth." cr
	." DumpIFF may be freely redistributed." cr
	0 dif-body-count !
	0 dif-dlta-count !
\
	what's iff.process.chunk >r
	' anim.print.chunk is iff.process.chunk
	$iff.dofile?
	IF
		." Error encountered!" cr
	ELSE
		dif.stats
	THEN
	r> is iff.process.chunk
;

: DUMPIFF ( <filename> -- , print chunks )
	fileword $DUMPIFF
;

cr
." Enter:   DUMPIFF filename" cr
." to see contents." cr
