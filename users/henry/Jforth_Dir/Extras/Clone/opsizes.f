\ OpSizes ... this file defines OPSIZE  ( opcode -- #bytes )
\
\ All Rights Reserved ... Mike Haas, 1987

\ MOD: MDH/PLB 8/15/89 Fixed sizes for BSET, EORI, LINK
\ MOD: PLB 7/21/90 Fixed mask in +DEST
\ 00001 28-nov-91 mdh      Integrated M. Kees float coprocessor support

only forth definitions

ANEW TASK-OPSIZES.f

also TGT definitions


decimal


: ALIT?   ( opcode-addr -- referenced-adr true / false )
  dup cell- @  $ 2d07,4e71 =   \ push tos followed by nop?
  IF
     2+ @ true
  ELSE
     drop false
  THEN
;


: CALLS?  ( opcode-addr -- called-pfa true / false )
  dup 2+ swap w@  dup >r
  CASE
    \
    \ --------------------------  Origin relative?
    $ 4eac OF     w@   true
           ENDOF
    \
    \ --------------------------  +64k relative?
    $ 4eab OF     w@ w->s  [ 64 1024 * ] literal +   true
           ENDOF
    \
    \ --------------------------  LONG PC relative?
    $ 6100 OF     dup w@  w->s  +    true
           ENDOF
    \
    \ --------------------------  Absolute?
    $ 4eb9 OF     @ >rel   true
           ENDOF
    \
    \ --------------------------  SHORT PC Relative?
    $ ff00 and
    $ 6100 OF     r@ $ ff and b->s + true
           ENDOF
    \
    \ NOCALL ...
    2drop  false dup
  ENDCASE
  r> drop
;


: ShortBRA?  ( opcode -- 0 OR offset )
  dup $ 5fff >  swap $ ff and  and
;

: BRATo?  ( OpcodeAdr BranchOpcode -- DestAdr )
  ShortBRA?  ?dup
  IF
       b->s
  ELSE
       dup 2+ w@ w->s
  THEN
  + 2+
;


: BranchOp?  ( Opcode -- flag )
  dup  $ f000 and  $ 6000 =        ( -- op flag )
  over $  f00 and  $  100 -  and   ( -- op flag )
  swap $ f0f8 and  $ 50c8 =  or
;


: Branches?  ( opadr -- false / destadr true )
  dup w@ BranchOp?
  IF
     dup w@ BRATo?  true
  ELSE
     drop false
  THEN
;

asm PCRel?  ( opcode -- flag )
		move.w	tos,d0		copy opcode
		and.w	#$3e,d0		is the mode, reg field even correct?
		cmp.w	#$3a,d0
		bne		100$
\
		move.w	tos,d0		copy opcode
		moveq.l	#12,d1
		lsr.w	d1,d0		get hinib
		cmp.w	#8,d0		greater than 7?
		blt		1$
\
		cmp.w	#$0a,d0		yes, >7, less than 10?
		blt		51$
		beq		100$		ret false if equal to 10?
		cmp.w	#$0e,d0
		bge		100$		ret false if greater than 0d?
\
51$:	btst	#8,tos		hinib == 8,9,b,c or d. bit 8 set?
		bne		2$
		bra		101$		ret true if bit 8==0
\
2$:		move.w	tos,d0		ret true if bits 7&6==11
		and.w	#$c0,d0
		cmp.w	#$c0,d0
		beq		101$
		bra		100$
\
1$:		cmp.w	#5,d0		ret false if greater than 5?
		bge		100$
		cmp.w	#4,d0		hinib == 0-4, is it 4?
		beq		7$
\
		tst.w	d0			is it 0?
		beq		7$
		bra		101$		ret true if 1,2 or 3
\
7$:		and.w	#$ffc0,tos	mask mode
		cmp.w	#$0800,tos	ret true if btst static?
		beq		101$
		cmp.w	#$44c0,tos	ret true if move-to-ccr?
		beq		101$
		cmp.w	#$46c0,tos	ret true if move-to-sr?
		beq		101$
		cmp.w	#$4840,tos	ret true if pea?
		beq		101$
		cmp.w	#$4e80,tos	ret true if jsr?
		beq		101$
		cmp.w	#$4ec0,tos	ret true if jmp?
		beq		101$
\
		move.w	tos,d0		copy tos
		and.w	#$fe00,d0	mask bit 8
		cmp.w	#$4c80,d0	ret true if movem->reg
		beq		101$
\
		move.w	tos,d0		copy tos
		and.w	#$f1c0,d0	mask bits 11,10,9
		cmp.w	#$0100,d0	ret true if btst-dynamic
		beq		101$
		cmp.w	#$41c0,d0	ret true if lea
		beq		101$
		and.w	#$f140,d0	ret false if != chk?
		cmp.w	#$4100,d0
		bne		100$
\
101$:	moveq.l	#-1,tos
		bra	102$
100$:	moveq.l	#0,tos
102$:	rts
end-code

: MODE>SIZE  ( op -- size , most instruction work this way )
  dup >r     ( save opcode )
  $ 38 and  -3 shift   ( -- opmode )
  dup 5 <
  IF
       2    \ its either DN, AN, (AN), (AN)+, or -(AN)
  ELSE
       dup 7 <
       IF
            4   \ its either d(AN) or d(AN,?N)
       ELSE
            drop r@ 7 and   ( get reg# )
            dup 1 =
            IF
                 6   ( its ABS.L )
            ELSE
                 dup 0=  over 2 = or  over 3 = or
                 IF
                      4   \ its either ABS.W, d(PC) or d(PC,?N)
                 ELSE
                      ( its immediate )
                      r@ $ c0 and  $ c0 =
                      IF
                           6  ( its #LONG )
                      ELSE
                           4  ( its #SHORT )
                      THEN
                 THEN
            THEN
       THEN
  THEN
  swap r> 2drop
;


: 0NIB  ( opcode -- size )
  >r
  r@ $ 38 and 8 =
  IF
       4  ( its MOVEP )
  ELSE
       r@ mode>size
       r@  $ ff00 and $ 0800 =
       IF
            2+ ( static bit )
       ELSE
            r@ $ 3C and  $ 3C -   ( not immediate or SR,CCR )
            r@ $ f100 and  $ 100 = 0= and ( and not dynamic bit ) 
            IF
                 r@ $ c0 and  -5 shift  2 max  +
            THEN
       THEN
  THEN
  r> drop
;

: +DEST  ( opcode #src+op -- #bytes-added-for-dest-operand )
  swap
  dup  $ 1c0 and  -3 ashift \ move mode from dest to src
  swap $ E00 and  -9 ashift \ move reg from dest to src
  or  mode>size 2- +
;

: 1NIB  ( opcode -- size )
  dup $ ff3f and mode>size     \ calc size w/ source
  +dest
;


: 2NIB  ( opcode -- size )
  dup $ 00c0 or  mode>size     \ calc size w/ source
  +dest
;


: 3NIB  ( opcode -- size )
  1nib
;


: 4NIB  ( opcode -- size )
  dup $ 4afc =   ( op flag )
  over $ ffC0 and  $ 4e40 =  or  ( TRAP thru RTR )
  IF
       dup $ FFF8 and $ 4E50 =  ( LINK ? )
       IF 4
       ELSE  2  \ one of specials with '4' in hinib.
       THEN
  ELSE
       dup mode>size  over  ( op size1 op )
       dup $ ff80 and dup $ 4c80 =      ( op size1 op op' flag )
       swap $ 4880 =  rot $ 38 and and  ( op size1 flag flag' )  or
       IF
           2+  \ its MOVEM
       THEN
  THEN
  nip
;


: 5NIB  ( opcode -- size )
  dup BranchOP?
  IF
     drop 4
  ELSE
     mode>size
  THEN
;


: 6NIB  ( opcode -- size , branches )
  $ ff and
  IF
       2  \ SHORT BRA
  ELSE
       4
  THEN
;


: 7NIB  ( opcode -- size )
  drop 2
;


: ENIB  ( opcode -- size )
  dup  $ c0 and $ c0 -
  IF
       drop 2
  ELSE
       mode>size
  THEN
;

\ start 00001

: FNIB ( opadr opcode -- opadr size )
  $ F23C =
  IF
     dup 2+ w@ $ 1c00 and -10 shift
     CASE       \ size of immediate + 4 byte opcode
        0 OF 8  \ .l long
          ENDOF
        1 OF 8  \ .s single
          ENDOF
        2 OF 16 \ .x extended
          ENDOF
        3 OF 16 \ .p packed d r
          ENDOF
        4 OF 6  \ .w word
          ENDOF
        5 OF 12 \ .d double
          ENDOF 
        6 OF 6  \ .b byte but stored as word
          ENDOF
        over 
         ." Strange F-line instuction at $"  .hex
        4 swap
     ENDCASE
  ELSE
     4
  THEN
;

\ end 00001


: OPSIZE  ( opcode -- #bytes )
  dup $ f000 and
  CASE
       $    0 OF   0nib  ENDOF
       $ 1000 OF   1nib  ENDOF
       $ 2000 OF   2nib  ENDOF
       $ 3000 OF   3nib  ENDOF
       $ 4000 OF   4nib  ENDOF
       $ 5000 OF   5nib  ENDOF
       $ 6000 OF   6nib  ENDOF
       $ 7000 OF   7nib  ENDOF
       $ e000 OF   enib  ENDOF
       $ f000 OF   fnib  ENDOF \ MOD to allow F-line instructions 00001
       drop mode>size dup
  ENDCASE
;


variable $op
    
: +NextOp  ( OpAdr -- #bytes )  $op off
  dup >r
  dup w@ OpSize over + swap  Calls?
  IF
       ( nextopadr pfa )
       dup  ' (.")        =
       over ' (")         = or
       over ' ($")        = or
       over ' (?warning") = or
       swap ' (?abort")   = or   ( -- nextopadr flag )
       IF
            dup c@ 1+ even-up +  $op on
       THEN
  THEN
  r> -
;

  
: sdism  ( addr -- )
  BEGIN
         ?pause
         dup w@ >r   ( addr )  ( -r- opcode )
         dup dism-word?  2drop
         r> dup $ 4e75 -
  WHILE
         ( addr opcode )
         opsize +
  REPEAT
  2drop
;

only forth definitions
also TGT
