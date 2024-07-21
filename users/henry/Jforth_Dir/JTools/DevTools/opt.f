\ JForth Optimizing Compiler Extensions V1.0, Mike Haas, 12-May-90
\ ----------------------------------------------------------------
\
\ 05/18/90 mdh     Version 1.0 to HMSL BBS
\ 05/26/90 plb/mdh Added CELLS, check for "installed" on compile
\ 05/29/90 mdh     Added CELL+, CELL-
\ 06/07/90 mdh     Added 2* 2/
\ 00005 06-aug-91  mdh     fixed Isconstant? (' SPACE would return -1)
\ 00006 18-aug-91  mdh     Incorporated XBLK
\ 00007 14-nov-91  mdh     added .need XBLK for older JF versions

exists? ifopt? .if
    ifopt? .if
        ." Optimizer on! Must be turned off before recompiling!" abort
    .then
.then

anew task-opt.f

.NEED XBLK   \ 00007
   variable XBLK   XBLK off
.THEN

variable MinOPTS   \ at least this many before optimization kicks in
3 MinOPTS !
variable #Opts

\ -------------- identify words as optimizable...

.NEED OPT_BIT
$ 80,0000 constant OPT_BIT
.THEN

: SETOPT  ( cfa -- )
  cell- dup @  OPT_BIT or swap !
;

: OPT_BIT?  ( cfa -- flag )
  cell- @ opt_bit and
;

: EA,OP  ( reg opcode -- )  or w,  ;

: DN,OP  ( reg opcode -- )  swap 9 shift or w,  ;

: DN,EA,OP  ( regDN regEA opcode -- )
  rot  9 shift  or  or  w,
;

1 constant smallcon
$ 7fff,ffff constant bigcon

: IsConstant?  ( cfa -- flag )
  dup cell- @  bigcon and  dup
  [ ' smallcon cell- @ bigcon and ] literal =
  swap [ ' bigcon cell- @ bigcon and ] literal = or
  IF
     ( -- cfa )  \ 00005 start
     dup @ $ ffff,ff00 and  [ ' smallcon @ $ ffff,ff00 and ] literal =
     ( -- cfa flag )  over cell+ w@ $ 4e75 =  and ( -- cfa flag )
     \
     over @ [ ' bigcon @ ] literal =  ( -- cfa flag flag2 )
     rot [ 2 cells ] literal +  w@ $ 4e75 = and ( -- cfa flag flag2 )
     or  \ 00005 end
  ELSE
     drop false
  THEN
;
  
\ -------------- the optimizing compiler words

50 constant maxLITs   variable numLITs
variable LITs         maxLITs 1- cells allot
variable LitsDone

5 constant numItems  \ number of data registers to cache
1 constant StartDataReg

variable NumCached
numItems array theRegs
numItems array RegUsed

\ normal    item0==tos  numCached == 1

: NumCached?  ( -- numCached )  numCached @  ;

: Reg>Index  ( reg -- ix )
  dup 7 =
  IF
     drop 0
  ELSE
     StartDataReg - 1+
  THEN
;

: Index>Reg  ( ix -- reg )
  dup 0=
  IF
     drop 7
  ELSE
     1-  StartDataReg +
  THEN
;

: MarkRegFree  ( reg -- )
  Reg>Index RegUsed off
;

: GetFreeReg  ( -- reg# )  true
  numItems 0 DO
     i RegUsed @ 0=
     IF
        drop    i Index>Reg   i RegUsed on
        false   leave
     THEN
  LOOP
  IF
     >newline ." Can't GetFreeReg; none left." quit
  THEN
;

: NewReg  ( -- reg# )
  GetFreeReg dup  numCached? theRegs !
  1 numCached +!
;

: Item>Reg  ( stack-item-index -- register )
  dup numCached @ 1- >  \ in range?
  IF
     >newline . ." too large.  Insufficient items cached" quit
  ELSE
     theRegs @
  THEN
;

: EAToTOSReg  ( opcode -- )
  0 Item>Reg swap ea,op
;

: CacheAnother  ( -- , load whatever is empty )
  numCached @  numItems <
  IF
     NewReg  $ 201e  dn,op  \ move.l <dsp>+,dX
  THEN
;

: LoadAtLeast  ( #regs -- )
  dup numItems >
  IF
     >newline ." Can't LoadAtLeast " 0 .r ." ; numItems not high enough."
     quit
  THEN
  dup numCached @ - 0>
  IF
     BEGIN  ( -- #regs )
        CacheAnother  dup numCached @ <=
     UNTIL
  THEN
  drop
;

: FlushLastItem  ( -- )
  numCached? 1-  Item>Reg  dup MarkRegFree
  $ 2d00  ea,op  \ move.l dX,-<dsp>
  -1 numCached +!
;

: InitOpt  ( -- )
  1 numCached !  0 RegUsed on   7 0 theRegs !
  [ 1 RegUsed ] aliteral  [ numitems 1- cells ] literal erase
  LitsDone off
;

: FlushRegs  ( -- , normalize registers )
  numCached? ?dup
  IF
     1- dup 0
     DO
        ( -- last-index )  dup theRegs @
        $ 2d00  ea,op  \ move.l dX,-<dsp>
        1-
     LOOP
     drop
     0 theRegs @ dup 7 -
     IF
        dup  $ 2e00  ea,op  \ move.l dX,tos
     THEN
     drop
  ELSE
     compile drop
  THEN
  InitOpt
;

: DropFromCnt  ( from cnt -- , drop FROM cell COUNT cells )
  2dup +   numCached @ >
  IF
     >newline ." Can't DropFromCount; invalid parameters: " swap . . quit
  THEN
  >r
  cells  0 theRegs  +   ( to-addr )
  dup r@ 0 DO
     dup @ MarkRegFree   cell+
  LOOP
  drop
  dup r@ cells +  tuck  ( from to from )
  0 theRegs  numCached @ cells   +   - abs   move
  r> negate numCached +!
;

: FreeTOS  ( -- , open up space )
  \ do we have to push out a regs?
  numCached? numItems =
  IF
     FlushLastItem
  THEN
  0 theRegs  1 theRegs  [ numItems 1- cells ] literal  move
  1 numCached +!
;

: Get1For2  ( If1Opcode If2Opcode -- )
  1 LoadAtLeast
  numCached @ 1 =
  IF
     0 Item>Reg   2 pick  dn,op  \ ???.l (dsp)+,dx
  ELSE
     0 Item>Reg  1 Item>Reg   2 pick   ( ???.l dX,dY ) dn,ea,op
     1 1 DropFromCnt
  THEN
  2drop
;

: O.+  ( -- )
   $ d09e   $ d080   Get1For2
;
' + setopt

: O.-  ( -- )
  2 LoadAtLeast
  1 Item>Reg  0 Item>Reg  $ 9080  ( sub.l dX,dY )  dn,ea,op
  0 1 DropFromCnt
;
' - setopt

: O.drop   ( -- )
  numCached?
  IF
     0 1 DropFromCnt
  ELSE
     $ 588e w,   \ addq.l  #4,a6
  THEN
;
' drop setopt

: O.swap  ( -- )
  2 LoadAtLeast
  0 theRegs @
  1 theRegs @ 0 theRegs !
  1 theRegs !
;
' swap setopt

: O.dup  ( -- )
  numCached?
  FreeTOS
  GetFreeReg  dup 0 theRegs !  swap  ( -- reg numC )
  IF
     1 theRegs @  $ 2000  dn,ea,op  \ move dX,dY
  ELSE
     $ 2016 dn,op
  THEN
;
' dup setopt

: O.rot  ( -- )
  3 LoadAtLeast
  2 Item>Reg    0 Item>Reg    1 Item>Reg   ( -- r2 r0 r1 )
  2 theRegs !   1 TheRegs !   0 theRegs !
;
' rot setopt

: O.-rot  ( -- )
  3 LoadAtLeast
  0 Item>Reg    1 Item>Reg    2 Item>Reg   ( -- r0 r1 r2 )
  1 theRegs !   0 TheRegs !   2 theRegs !
;
' -rot setopt

: DoToTOS  ( opcode -- )
  numCached?
  IF
     EAToTOSReg  \ xxxq.l #?,dx
  ELSE
     $ ff00 and  $ 96 or w,     \ xxxq.l #?,(dsp)
  THEN
;

: O.1+  ( -- )
  $ 5280  DoToTOS   \ addq.l #1,dx
;
' 1+ setopt

: O.1-
  $ 5380  DoToTOS   \ subq.l #1,dx
;
' 1- setopt

: O.2+
  $ 5480  DoToTOS   \ addq.l #2,dx
;
' 2+ setopt

: O.2-
  $ 5580  DoToTOS   \ subq.l #2,dx
;
' 2- setopt

: O.CELL+  ( -- )
  $ 5880  DoToTOS   \ addq.l #4,dx
;
' cell+ setopt

: O.CELL-
  $ 5980  DoToTOS   \ subq.l #4,dx
;
' cell- setopt

: O.cells
    1 LoadAtLeast
    $ E580 EAToTOSReg
;
' cells setopt

: O.i  ( -- )
  FreeTOS
  GetFreeReg  dup 0 theRegs !
  dup  $ 2005  dn,op  \ move d5,dx
  $ d086  dn,op       \ add d6,dx
;
' i setopt

: O.c@
  1 LoadAtLeast
  FreeTOS
  GetFreeReg  dup 0 theRegs !
  dup $ 7000  dn,op   ( -- 0reg )  \ moveq #0,dx
  $ 1034 dn,op  1 Item>Reg  12 shift $ 0800 or w,  \ move.b 0(a4,dy.l),dx
  1 1 DropFromCnt
;
' c@ setopt

: O.@
  1 LoadAtLeast
  0 Item>Reg  dup $ 2034 dn,op
  12 shift $ 0800 or w,          \ move.l 0(a4,dx.l),dx
;
' @ setopt

: O.over ( -- )
  numCached?
  FreeTOS
  GetFreeReg  dup 0 theRegs !  swap   ( -- reg #C )  ?dup
  IF
     1 =
     IF
        $ 2016  dn,op   \ move.l  (dsp),dx
     ELSE
        2 Item>Reg  $ 2000  dn,ea,op  \ move dX,dY
     THEN
  ELSE
     $ 202e  dn,op 4 w,  \ move.l 4(dsp),dx
  THEN
;
' over setopt

: o.2dup
  o.over  o.over
;
' 2dup setopt

: O.c!
  2 LoadAtLeast
  1 Item>Reg  $ 1980 ea,op
  0 Item>Reg  12 shift  $ 0800 or  w,  \ move.b dx,0(a4,dy.l)
  0 2 DropFromCnt
;
' c! setopt

: O.!
  2 LoadAtLeast
  1 Item>Reg  $ 2980 ea,op
  0 Item>Reg  12 shift  $ 0800   or w,  \ move dx,0(a4,dy.l)
  0 2 DropFromCnt
;
' ! setopt

: O.2drop
  numCached? ?dup
  IF
     1 =
     IF
        0 1 DropFromCnt
        $ 588e w,  \ addq.l  #4,dsp
     ELSE
        0 2 DropFromCnt
     THEN
  ELSE
     $ 508e w,  \ addq.l  #8,dsp
  THEN
;
' 2drop setopt

: O.>r
  numCached?
  IF
     $ 2f00  EAToTOSReg    \ move dx,-(rp)
     0 1 DropFromCnt
  ELSE
     $ 2f1e w,  \ move.l (dsp)+,-(rp)
  THEN
;
' >r setopt

: O.r>
  FreeTOS
  GetFreeReg  dup 0 theRegs !   $ 201f  dn,op    \ move (rp)+,dx
;
' r> setopt

: o.r@
  FreeTOS
  GetFreeReg  dup 0 theRegs !   $ 2017  dn,op    \ move (rp),dx
;
' r@ setopt

: O.lit  ( -- )
  LitsDone @ cells LITs + @  ( -- val )
  FreeTOS
  GetFreeReg  0 theRegs !
  dup -128 127 within?
  IF
     $ ff and  $ 7000 or   0 Item>Reg swap  dn,op
  ELSE
     0 Item>Reg  $ 203c  dn,op  ,
  THEN
  1 LitsDone +!
;
' literal setopt

: O.and  ( -- )
  $ c09e  $ c080  Get1For2
;
' and setopt

: O.or  ( -- )
  $ 809e  $ 8080  Get1For2
;
' or setopt

: O.nip  ( -- )
  numCached? ?dup
  IF
     1 >
     IF
        1 1 DropFromCnt
     ELSE
        $ 588e w,  \ addq.l  #4,dsp
     THEN
  ELSE
     FreeTOS GetFreeReg  dup 0 theRegs !
     $ 2016 dn,op  \ move.l  (dsp),dx
     $ 508e w,  \ addq.l  #8,dsp
  THEN
;
' nip setopt

: o.2*  ( -- )
  1 LoadAtLeast
  0 Item>reg dup  $ d080  dn,ea,op    \ add.l dx,dx
;
' 2* setopt
  
: o.2/  ( -- )
  1 LoadAtLeast
  $ e280 EAToTOSReg   \ asr.l  #1,dx
  $ 6a04 w,           \ bpl  *+6
  $ 6402 w,           \ bpl  *+4
  $ 5280 EAToTOSReg   \ addq.l #1,dx
;
' 2/ setopt


\ -------------- the optimizer's "compilation stack"

50 constant maxOPTs   variable numOPTs
variable OPTs         maxOPTs 1- cells allot

: FlushOPTs  ( -- , do all optimized compilation & flush regs )
  numOPTs @  ?dup
  IF
     dup MINOPTS @ >=
     IF
\ >newline ." Flushing OPTs..." cr
        \ worth doing optimization
        InitOpt  ( -- numOPTs )  0
        DO
           i cells  OPTs + @   ( -- cfa )
           CASE
\
              ' +     OF O.+     ENDOF
              ' -     OF O.-     ENDOF
              ' drop  OF O.drop  ENDOF
              ' swap  OF O.swap  ENDOF
              ' dup   OF O.dup   ENDOF
              ' rot   OF O.rot   ENDOF
              ' 1+    OF O.1+    ENDOF
              ' 2+    OF O.2+    ENDOF
              ' 1-    OF O.1-    ENDOF
              ' 2-    OF O.2-    ENDOF
              ' i     OF O.i     ENDOF
              ' @     OF O.@     ENDOF
              ' c@    OF O.c@    ENDOF
              ' over  OF O.over  ENDOF
              ' 2dup  OF O.2dup  ENDOF
              ' c!    OF O.c!    ENDOF
              ' !     OF O.!     ENDOF
              ' 2drop OF O.2drop ENDOF
              ' >r    OF O.>r    ENDOF
              ' r>    OF O.r>    ENDOF
              ' r@    OF O.r@    ENDOF
            ' literal OF O.lit   ENDOF
              ' -rot  OF O.-rot  ENDOF
              ' and   OF O.and   ENDOF
              ' or    OF O.or    ENDOF
              ' nip   OF O.nip   ENDOF
              ' cell+ OF O.cell+ ENDOF
              ' cell- OF O.cell- ENDOF
              ' cells OF O.cells ENDOF
              ' 2*    OF O.2*    ENDOF
              ' 2/    OF O.2/    ENDOF

\
              >newline ." Illegal CFA found in optimization stack." quit
           ENDCASE
           1 #Opts +!
        LOOP
        FlushRegs
     ELSE
        InitOpt   0 DO
           i cells OPTs + @ dup ' literal =
           IF
              drop
              LitsDone @ cells LITs + @  ( -- val ) [compile] literal
              1 LitsDone +!
           ELSE
              cfa,
           THEN
        LOOP
     THEN
     numOPTs off  numLITs off
  THEN
;


: >OPTs  ( cfa -- )
  numOPTs @ maxOPTs >=
  IF
     FlushOPTs
  THEN
  OPTs numOPTs @ cells +  !
  1 numOPTs +!
;

: >LITs  ( n1 -- )
  numLITs @ maxLITs >=
  IF
     FlushOPTs
  THEN
  ' literal >OPTs
  LITs numLITS @ cells +  !
  1 numLITs +!
;


\ -------------- the new optimizing INTERPRET vector

: INTERPRET.O  ( -- , optimizing INTERPRET )
  TIBEND off
  BEGIN
     bl word find dup       ( -- ?? flag flag )
     IF
        ( -- cfa flag )  STATE @
        IF
           0<     ( -- cfa flag )
           IF
              dup OPT_BIT?
              IF
                 >OPTs
              ELSE
                 dup IsConstant?  numOPTs @ and
                 IF
                    execute >LITs
                 ELSE
                    FlushOPTs  cfa,
                 THEN
              THEN
           ELSE
              here w@ dup $ 015c =  swap $ 0128 = or 0=
              IF
                 FlushOPTs
              THEN
              execute ?stack
           THEN
        ELSE
           drop execute ?stack
        THEN
        0    ( -- notagainflag )
     ELSE
        ( -- here 0 )  2drop   TIBEND @
        IF
           FBLK @ 0=     XBLK @ 0= and ( 00006 )
        ELSE
           here number  dpl @ 1+   ( -- d1 dpl+1 )  \ FlushOPTs
           IF
              FlushOPTs  [compile] dliteral
           ELSE
              drop  numOPTs @
\ dup >newline ." numOPTs = " . cr
              IF
                 >LITs
              ELSE
                 FlushOPTs  [compile] literal
              THEN
           THEN
           ?stack  0
        THEN
     THEN
  UNTIL
;


variable Pre-Opt-Interpret  variable Pre-Opt-quit

: IfOpt?  ( -- flag )
    what's interpret ' interpret.o =
;

: OptQuit  numOPTs off numLITs off  InitOpt  Pre-Opt-Quit @execute  ;

: OPTON  ( -- , install optimizer )
  ifopt?
  IF
     >newline ." Optimizer already installed" cr
  ELSE
     what's interpret Pre-Opt-Interpret !
     ' interpret.o is interpret
     what's quit Pre-Opt-Quit !  ' OptQuit is quit
  THEN
;

: OPT  OptOn ;

: OPTOFF  ( -- , UNinstall optimizer )
  what's interpret  ' interpret.o -
  IF
     >newline ." Optimizer not installed" cr
  ELSE
     Pre-Opt-Interpret @ is interpret
     Pre-Opt-Quit @ is quit
  THEN
;

: NoOPT  OptOff ;

if.forgotten OPTOFF
