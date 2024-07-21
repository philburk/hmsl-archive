\ Demonstrate various features of the JForth ANIM system.

include? choose ju:random
include? picture jiff:load_pic
include? anim janim:load_anim

ANEW TASK-TEST_ANIMBRUSH

\ You may substitute your own files here if you wish.
: $BACKG.FILENAME  " JPics:Mountains.pic" ;
: $HEADS.FILENAME  " JPics:Bird.anbr" ;

\ Declare structures needed
picture backg0
picture backg1
animbrush BigBird
animbrush testabr

10 value xp
10 value yp
7 value dx
7 value dy

\ Test LOAD and SAVE
: TEST.LOAD&SAVE ( <infilename> <outfilename>-- )
	testabr abr.load? ?goto.error
	testabr abr.stats
	BEGIN
		testabr abr.advance
		8 wait.frames
		?closebox ?terminal OR
	UNTIL
	testabr abr.save? ?goto.error
	testabr abr.free
	exit
ERROR:
	." Error!" cr
	testabr abr.free
;

: SHOW.ABR ( <infilename> -- )
	gr.init
	testabr abr.load? ?goto.error
	testabr abr.stats
	BEGIN
		testabr abr.advance
		8 wait.frames
		?closebox ?terminal OR
	UNTIL
	testabr abr.free
	gr.term
	exit
ERROR:
	." Error!" cr
	testabr abr.free
	gr.term
;

\ Show animbrush over a picture.
: TAB.INIT ( -- error? )
	gr.init
	$BACKG.FILENAME backg0 $pic.load  \ load two buffers
	$BACKG.FILENAME backg1 $pic.load
	$HEADS.FILENAME BigBird $abr.load? ?goto.error
\
	abr_pingpong BigBird ..! abr_flags
	BigBird abr.stats
	0 BigBird pic.alloc.backup? ?goto.error
	1 BigBird pic.alloc.backup? ?goto.error
	xp yp 0 BigBird pic.backup.nth
	xp yp 1 BigBird pic.backup.nth
	FALSE
	EXIT
ERROR:
	TRUE
;

: TAB.TERM
	backg1 pic.free
	backg0 pic.free
	BigBird abr.free
	gr.term
;
if.forgotten tab.term

: TAB.MOVE ( -- )
\ calculate new position, reflect off boundarys
\ let it go off screen to test clipping
	xp 300 >  xp -20 < OR
	IF
		dx negate -> dx
	THEN
	dx +-> xp
	yp 160 >  yp -30 < OR
	IF
		dy negate -> dy
	THEN
	dy +-> yp
;

: TAB.NEXT.SPIN { pict N -- }
	pict pic.drawto
	N BigBird pic.restore.nth
	xp yp N BigBird pic.backup.nth
	xp yp BigBird abr.trans.blit
	pict pic.display \ or you can call PIC.VIEW for speed but
	\ watch out for strange Intuition effects.
	2 wait.frames
\
	BigBird abr.advance
	tab.move
;

: TAB.SPIN ( -- )
	BEGIN
		backg0 0 tab.next.spin
		backg1 1 tab.next.spin
		?terminal ?closebox OR
	UNTIL
;

: TAB
	tab.init 0=
	IF
		tab.spin
	THEN
	tab.term
;

\ Test editing

animbrush newabr
picture pic0
picture pic1

: TABED.TERM
	newabr abr.free
	pic0 pic.free
	pic1 pic.free
	tab.term
;
if.forgotten tabed.term

: TABED.INIT ( -- error? )
	tab.init dup 0=
	IF
		drop
		" JPics:Ship.br" pic0 $pic.load?
	THEN
;

: TABED.MAKE ( -- error? , make animbrush from pictures )
	pic0 pic1 pic.duplicate? dup 0=
	IF
		drop
		pic0 pic1 pic.copy  \ only needed for old bad PIC.DUPLICATE
		pic1 pic.drawto
		4 gr.color!
		0 0 20 10 gr.rect
		backg0 pic.drawto
		pic0 pic1 newabr abr.build?
	THEN
;

: TABED.CHANGE ( -- error? , insert new picture )
	0 newabr abr.dup.cel? dup 0=
	IF
		drop
		pic1 pic.drawto
		7 gr.color!
		10 10 40 30 gr.rect
		backg0 pic.drawto
		pic1 1 newabr abr.replace.cel?
	THEN
;

: TABED.SHOW
	BEGIN
		0 0 backg1 pic.blit
		120 40 newabr abr.trans.blit
		newabr abr.advance
		30 wait.frames
		?terminal ?closebox OR
	UNTIL
;

: TABED.DELETE ( -- error? )
	1 newabr abr.delete.cel?
;

: TABED
	tabed.init ?goto.error
		." TABED - INIT passed!" cr
	tabed.make ?goto.error
		." TABED - MAKE passed!" cr
	tabed.change ?goto.error
		." TABED - CHANGE passed!" cr
\
	tabed.show
	tabed.delete ?goto.error
		." TABED - DELETE passed!" cr
	tabed.show
\
ERROR:
	tabed.term
;

." Enter:   TAB or TABED" cr

