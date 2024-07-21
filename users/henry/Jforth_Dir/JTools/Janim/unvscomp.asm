\ JForth Port of Jim Kent's unvscomp.asm
\ by Martin Kees
\ The original docs:
\ unvscomp.asm  Copyright 1987 Dancing Flame all rights reserved.
\
\ This file contains a single function which is set up to be called from
\ C.  Ie the parameters are on the stack instead of registers.
\       decode_vkplane(in, out, linebytes)
\ where in is a bit-plane's worth of vertical-byte-run-with-skips data
\ and out is a bit-plane that STILL has the image from last frame on it.
\ Linebytes is the number of bytes-per-line in the out bitplane, and it
\ should certainly be noted that the external pointer variable ytable
\ must be initialized to point to a multiplication table of
\ 0*linebytes, 1*linebytes ... n*linebytes  before this routine is called.
\ 
\ The format of "in":
\   Each column of the bitplane is compressed separately.  A 320x200
\   bitplane would have 40 columns of 200 bytes each.  The linebytes
\   parameter is used to count through the columns, it is not in the
\   "in" data, which is simply a concatenation of columns.
\
\   Each columns is an op-count followed by a number of ops.
\   If the op-count is zero, that's ok, it just means there's no change
\   in this column from the last frame.
\   The ops are of three classes, and followed by a varying amount of
\   data depending on which class.
\       1. Skip ops - this is a byte with the hi bit clear that says how many
\          rows to move the "dest" pointer forward, ie to skip. It is non-
\          zero
\       2. Uniq ops - this is a byte with the hi bit set.  The hi bit is
\          masked down and the remainder is a count of the number of bytes
\          of data to copy literally.  It's of course followed by the
\          data to copy.
\       3. Same ops - this is a 0 byte followed by a count byte, followed
\          by a byte value to repeat count times.
\   Do bear in mind that the data is compressed vertically rather than
\   horizontally, so to get to the next byte in the destination (out)
\   we add linebytes instead of one!
\
anew task_decode

400 value ytablesize          \ defaults for 320x200 display
 40 value ybytesize  
v: ytable ytable OFF   


: calc.ytable ( -- )
  ytable freevar
  MEMF_PUBLIC ytablesize allocblock ytable !
  ytable @ IF-NOT ." No memory for ytable"
                abort
           THEN
  0
  ytablesize 2/ 0 do dup 
                     ytable @ i 2* + w! 
                     ybytesize +
                  loop
  drop
;


ASM decode_vkplane ( in out linebytes --- )
	movem.l	a2-a3/d5,-(rp)  ; save registers 
	move.l	(dsp)+,a2
	adda.l  a4,a2 
	move.l	(dsp)+,a0
	adda.l  a4,a0
	move.w	d7,d2
	move.l  (dsp)+,d7
	callcfa ytable
	move.l  $0(a4,tos.l),tos 
	move.l  d7,a3
	adda.l  a4,a3
	move.w	d2,d4	\ make a copy of linebytes to use as a counter
	bra	1$	\ And go to the "columns" loop
	
2$:	move.l	a2,a1     \ get copy of dest pointer
	clr.w	d0	  \ clear hi byte of op_count
	move.b	(a0)+,d0  \ fetch number of ops in this column
	bra	3$	  \ and branch to the "op" loop.

4$:	clr.w	d1	  \ clear hi byte of op
	move.b	(a0)+,d1  \ fetch next op
	bmi	5$        \ if hi-bit set branch to "uniq" decoder
	beq     6$	  \ if it's zero branch to "same" decoder

			  \ otherwise it's just a skip
	add.w	d1,d1	  \ use amount to skip as index into word-table
	adda.w	0(a3,d1.w),a1
	dbra.w	d0,4$     \ go back to top of op loop
	bra	7$        \ go back to column loop

			\ here we decode a "vertical same run"
6$:	move.b	(a0)+,d1  \ fetch the count
	move.b	(a0)+,d3  \ fetch the value to repeat
	move.w	d1,d5     \ and do what it takes to fall into a "tower"
	asr.w	#3,d5     \ d5 holds # of times to loop through tower
	and.w	#7,d1     \ d1 is the remainder
	add.w	d1,d1
	add.w	d1,d1
	neg.w	d1
	jmp	34(pc,d1.w)            \ why 34?  8*size of tower
                                     \ instruction pair, but the extra 2's
                                     \ pure voodoo.
8$:	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	move.b	d3,(a1)
	adda.w	d2,a1
	dbra.w	d5,8$
	dbra.w	d0,4$
	bra.l	7$

                          \ here we decode a "unique" run
5$:	and.b	#$7f,d1   \ setting up a tower as above....
	move.w	d1,d5
	asr.w	#3,d5
	and.w	#7,d1
	add.w	d1,d1
	add.w	d1,d1
	neg.w	d1
	jmp	34(pc,d1.w)
9$:	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	move.b	(a0)+,(a1)
	adda.w	d2,a1
	dbra.w	d5,9$      \ branch back up to "op" loop
3$:     dbra.w	d0,4$      \ branch back up to "column loop"

	\  now we've finished decoding a single column
7$:	addq.l	#1,a2  \ so move the dest pointer to next column
1$:	dbra.w	d4,2$  \ and go do it again what say?
	movem.l	(rp)+,a2-a3/d5
	move.l  (dsp)+,d7
end-code
