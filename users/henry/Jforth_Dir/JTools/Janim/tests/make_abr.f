\ Make an ANIMBRUSH from a single picture.
\
\ Author: Phil Burk
\ Copyright 1991 Phil Burk
\
\ 00001 PLB 1/28/92 Use multiples of 16 for ANIMBRUSHES

include? choose ju:random
include? picture jiff:load_pic
include? anim janim:load_anim

ANEW TASK-MAKE_ABR

\ Declare structures needed
picture tiled-pic
picture pic0
picture pic1
animbrush newabr
0 value MAB_DX
0 value MAB_DY
3 value MAB_NX
2 value MAB_NY
mab_nx mab_ny * value MAB_NCELS

create $MAB-INFILE 64 allot
create $MAB-OUTFILE 64 allot

: MAB.TERM
	newabr abr.free
	tiled-pic pic.free
	pic0 pic.free
	pic1 pic.free
;
if.forgotten mab.term

: PIC.CALC.TILEXY { nx ny pict | pw ph dx dy --> dx dy }
\ calculate X and Y values for subpictures
	pict pic.get.wh -> ph -> pw
	pw nx / \ calc dx
	16 / 16 * \ adjust to multiple of 16 for Bitmaps 00001
	-> dx
\
	ph ny / -> dy
\ autoreturn locals
;

: MAB.CALC.XY ( N -- x y , set X,Y in tiled pic )
	mab_nx /mod ( -- col row )
	swap mab_dx *
	swap mab_dy * 
;

: MAB.GET.NTH { N pict -- , put in small-pic }
	N mab.calc.xy tiled-pic pic.put.xy
	pict pic.drawto
	0 0 tiled-pic pic.blit
;

: GR.RECT.XYWH { x0 y0 w h -- }
	x0 y0
	x0 w 1- 1 max + \ 10 wide goes from 10 to 19, not 10 to 20, so 1-
	y0 h 1- 1 max +
	gr.rect
;

: MAB.CLEAR.NTH ( N -- clear X,Y in tiled pic )
	tiled-pic pic.drawto
\
	gr.color@ >r \ save old color
	0 gr.color!
	mab.calc.xy ( x0 y0 )
	tiled-pic pic.get.wh ( x0 y0 w h )
	gr.rect.xywh
	r> gr.color!
;
	
: MAB.MAKE.ABR  ( -- error? , make an ANIMBRUSH from tiles )
\ build initial animbrush
	0 pic0 mab.get.nth
	1 pic1 mab.get.nth
	pic0 pic1 newabr abr.build? ?goto.error
	0 mab.clear.nth
	1 mab.clear.nth
\
\ draw fake close gadget
	1 gr.color!
	0 0 10 10 gr.rect
	0 gr.color!
	4 4 6 6 gr.rect
	1 gr.color!
\
\ append the remaining pictures
	mab_nx mab_ny *
	mab_ncels MIN    2
	DO
		i pic0 mab.get.nth
		pic0 newabr abr.append.cel? ?goto.error
		i mab.clear.nth
	LOOP
	tiled-pic pic.drawto
\
	false
	exit
ERROR:
	newabr abr.free
	true
;

: GET.NEXT.PARAM ( <optional_param> -- N TRUE | FALSE )
	bl word dup c@ 0>
	IF
		dup number?
		IF drop nip TRUE
		ELSE ." Bad parameter = " count type cr FALSE
		THEN
	ELSE
		drop FALSE
	THEN
;

: MAB.HELP ( -- , give help )
	cr
	." Convert a tiled picture to an ANIMBRUSH!" cr
	." Usage:   MAB infile outfile {nx} {ny} {ncels}" cr
	."    infile  = an ILBM picture file name" cr
	."    outfile = a new ANIMBRUSH file name" cr
	."    nx    = number of X columns (optional, default = 3)" cr
	."    ny    = number of Y rows    (optional, default = 2)" cr
	."    ncels = number of cels      (optional, default = NX*NY)" cr
;

: MAB.GET.PARAMS ( <infile> <outfile> {nx} {ny} {ncels} -- error? )
	>newline
	." MAB - by Phil Burk, Version 1.0, written in JForth" cr
\ get filenames
	fileword dup c@ 62 <
	IF  $mab-infile $move
	ELSE ." Input Filename too long, > 62 chars" cr
		count type cr
	THEN
\
	fileword dup c@ 62 <
	IF  $mab-outfile $move
	ELSE ." Output Filename too long, > 62 chars" cr
		count type cr
	THEN
\
\ get optional values from command line
	get.next.param
	IF
		dup 1 32 within?
		IF -> mab_nx
		ELSE drop ." 1 <= NX <= 32" cr goto.error
		THEN
	THEN
	get.next.param
	IF
		dup 1 32 within?
		IF -> mab_ny
		ELSE drop ." 1 <= NY <= 32" cr goto.error
		THEN
	THEN
	get.next.param
	IF
		1 max -> mab_ncels
	ELSE
		mab_nx mab_ny * -> mab_ncels \ set default
	THEN
	false exit
	ERROR:
	mab.help
	true
;

: MAB.INIT ( -- error? )
	$mab-infile tiled-pic $pic.load? ?goto.error
	mab_nx mab_ny tiled-pic pic.calc.tilexy
	-> mab_dy -> mab_dx
	mab_dx mab_dy tiled-pic pic.put.wh  \ set window into large picture
\
\ make small pictures for parts
	0 0 tiled-pic pic.get.depth
	mab_dx mab_dy pic0 pic.make? ?goto.error
\
	0 0 tiled-pic pic.get.depth
	mab_dx mab_dy pic1 pic.make? ?goto.error
\
	false
	exit
ERROR:
	mab.help
	true
;

: MAB.STATS ( -- , report statistics )
	." Tiled picture = "
	tiled-pic dup pic.whole pic.get.wh
	swap . ."  by " . cr
\
	." Each CEL = " mab_dx . ."  by " mab_dy . cr
\
	newabr abr.stats
;

: MAB ( <infile> <outfile> {nx} {ny} {ncels} -- )
	gr.init
	mab.get.params ?goto.error
	mab.init ?goto.error
	mab.make.abr ?goto.error
\
\ show new animbrush
	BEGIN
		20 30 newabr abr.blit
		newabr abr.advance
		20 wait.frames
		?terminal ?closebox OR
	UNTIL
\
\ save it to disk
	$mab-outfile newabr $abr.save? ?goto.error
	mab.stats
\
ERROR:
	mab.term
	gr.term
;

cr ." Enter:  MAB <infile> <outfile> {nx} {ny} {ncels}" cr
