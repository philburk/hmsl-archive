\ Edit ANIMBrushes
\ Used to build and manipulate the contents of ANIMBRUSHes

\ by Martin Kees
\ Copyright 1990 Martin Kees

ANEW TASK-EditAnimbr

PICTURE  edpicA
PICTURE  edpicB
variable abdir
variable abmode


: EDPICS.FREE
	edpicA pic.free
	edpicB pic.free
;

: ABR.CUR.DELTA ( abr -- delta-address )
	dup ..@ abr_atdelta cells
	swap ..@ abr_deltalist + @
;

: MEM.GET.INDEX { val memblk -- index , search memblk for val }
	-1
	memblk freebyte 4 / 0
	DO memblk i cells + @
		val =
		IF drop i leave
		THEN
	LOOP
	dup -1 =
	IF ." NOT found" abort
	THEN
;


: ABR.SAVE.STATE ( animbr --- )
	dup ..@ abr_direction abdir !
	..@ abr_flags     abmode !
;

: ABR.RESTORE.STATE ( animbr --- )
	dup ..@ abr_direction abdir @ =
	IF-NOT dup abr.reverse
	THEN
	abmode @ swap ..! abr_flags
;

: ABR.NORM ( animbr --- )
	dup abr.save.state
	dup ..@ abr_direction abr_FORWARD =
	IF-NOT dup abr.reverse
	THEN
	abr_LOOP swap ..! abr_flags
;


: ABR.DELETE.CEL? { cel# abr | Pdelt Ndelt Rdelt dwork --- error? , delete cel }
\ Saftey Checks
	abr abr.check
	abr ..@ abr_cels 3 <
	IF ." Can't DELETE " goto.error
	THEN
	cel# 0 abr ..@ abr_cels 1- within?
	IF-NOT ." ABR.DELETE.CEL? - Cel out of range!" goto.error
	THEN
\
\ Get previous and next pics
	abr abr.norm
	cel# abr abr.goto.frame
	abr abr.cur.delta -> Ndelt
	abr abr.reverse
	abr abr.cur.delta -> Pdelt
	abr abr.advance			  \ abr is at prev
	abr edpicA pic.duplicate? ?goto.error
	abr edpicA pic.copy
	abr abr.reverse
	abr abr.advance
	abr abr.advance 			  \ abr is at next
	abr abr.cur.delta -> Rdelt
	edpicA abr abr.make.delta -> dwork
	dwork 0= ?goto.error
	edpics.free
\
\ Free unneeded deltas
	Ndelt abr .. abr_deltalist  -stack
	Ndelt freeblock
	Pdelt freeblock
\
	abr ..@ abr_cels 1- abr ..! abr_cels    \ decrement cel count
\
\ find prev delta place
	pdelt abr ..@ abr_deltalist  mem.get.index cells
	abr ..@ abr_deltalist + dwork swap ! \ replace with new delta
	0 -> dwork
	Rdelt abr ..@ abr_deltalist mem.get.index abr ..! abr_atdelta
	abr abr.restore.state
	false
	exit
ERROR:
	true
	exit
;


: ABR.DUP.CEL? { cel# abr | delt Zdelt --- error? }
	0 -> delt 0 -> zdelt  \ 0 in case of error
\ inserts a duplicate cel
\ after cel#
\  First do saftey checks
	abr abr.check
	cel# 0 abr ..@ abr_cels 1- within?
	IF-NOT ." ABR.DUP.CEL? - Cel out of range!" cr
		goto.error \ Programmer error!
	THEN
\
\ Allocate new deltalist 1 cel bigger
	[ MEMF_CLEAR MEMF_PUBLIC | ] literal
	abr ..@ abr_deltalist sizemem cell+ allocblock -> delt
	delt 0= ?goto.error
\
\ Allocate a do-nothing delta
	[ MEMF_CLEAR MEMF_PUBLIC | ] literal
	64 allocblock -> Zdelt
	Zdelt 0= ?goto.error
	64 Zdelt freebytea !
\
\ Copy old deltalist inserting new ZDelta
	cel#  0
	DO
		abr ..@ abr_deltalist
		i cells + @ delt push
	LOOP
	Zdelt delt push
	abr ..@ abr_cels   cel#
	DO
		abr ..@ abr_deltalist
		i cells + @ delt push
	LOOP
\
\ Restore abr to a valid state and cleanup
	abr abr.norm
	abr abr.get.frame
	dup cel# >
	IF 1+
	THEN
	0 abr abr.goto.frame
	abr ..@ abr_deltalist freeblock
	delt abr ..! abr_deltalist
	1 abr ..@ abr_cels + abr ..! abr_cels \ one more cel
	abr abr.goto.frame
	abr abr.restore.state
\
	false
	exit
ERROR:
	delt ?dup
	IF freeblock
	THEN
	zdelt ?dup
	IF freeblock
	THEN
;


: ABR.REPLACE.CEL? { newpic cel# abr | oldcel Pdelt Ndelt dwork --- error? }
\ replaces cel with new-picture
\ First do safety checks
	newpic pic.check
	abr abr.check
\
	cel# 0 abr ..@ abr_cels 1- within?
	IF-NOT ." ABR.REPLACE.CEL? - Cel out of range!" goto.error
	THEN
\
	abr    pic.get.wh
	newpic pic.get.wh
	rot = -rot = and
	IF-NOT ." Picture not same size as animbrush" goto.error
	THEN
\
	abr abr.norm
	abr abr.get.frame -> oldcel
	cel# abr abr.goto.frame
	abr abr.cur.delta -> Ndelt
	abr abr.reverse
	abr abr.cur.delta -> Pdelt
	abr abr.advance
	abr newpic abr.make.delta -> dwork
	dwork 0= ?goto.error
	abr abr.reverse
	abr abr.advance
	abr abr.advance
\
	dwork
	Pdelt abr ..@ abr_deltalist mem.get.index cells
	abr ..@ abr_deltalist + !
	Pdelt freeblock
\
	newpic abr abr.make.delta -> dwork
	dwork 0= ?goto.error
\
	dwork
	Ndelt abr ..@ abr_deltalist mem.get.index cells
	abr ..@ abr_deltalist + !
	Ndelt freeblock
\
	oldcel abr abr.goto.frame
	abr abr.restore.state
	false
	exit
ERROR:
	true
;

: ABR.APPEND.CEL? { newpic abr --- error? , add to end }
	abr ..@ abr_cels 1- abr abr.dup.cel? dup 0=
	IF
		drop newpic
		abr ..@ abr_cels 1- abr abr.replace.cel?
	THEN
;
	
\ Build a two frame animbrush from two pictures
: ABR.BUILD? { pic0 pic1 abr --- error? }
\ check sizes
	abr abr.free
	pic0 pic.get.wh
	pic1 pic.get.wh
	rot = -rot = and
	IF-NOT ." Pics NOT same size!" cr goto.error
	THEN
\
\ allocate deltas
	memf_public 8 allocblock dup abr ..! abr_deltalist
	0= ?goto.error
\
	abr_valid_key abr ..! abr_key
	2 abr ..! abr_cels
	abr_forward abr ..! abr_direction
	abr_loop    abr ..! abr_flags
\
\ alloc YTABLE
	pic0 ..@ pic_bitmap dup ..@ bm_bytesperrow
	swap ..@ bm_rows
	alloc.ytable dup abr ..! abr_ytable
	0= ?goto.error
\
	2 0
	DO  pic0 pic1 abr.make.delta ?dup
		IF
			abr ..@ abr_deltalist push
		ELSE
			goto.error
		THEN
	LOOP
\
\ set current picture
	pic0 abr pic.duplicate? ?goto.error
	pic0 abr pic.copy
\
	false
	exit
ERROR:
	abr abr.free
	true
;
