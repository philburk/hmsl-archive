


\ ------------------  CLONECFA ... the big one! -------------------- /
\
\   When an unresolved reference is target compiled, two behaviors are
\ possible:
\
\ 1. Leave 3 words (48 bits) so that  a LONG ABS may be used.  This
\    usually will only be filled with a relative BSR and a NOOP, however.
\    A program will have to significantly exceed 128k, actually, before
\    a LONG ABSOLUTE JSR is required.  Better to try...
\
\ 2. Only leave 32-bit cells on the HIGH probability that all the code
\    will fit under 128k (Target Compiled!).
\
\   The following variable 'IfLeaveLong' allows the selection of either.
\ If set TRUE, it will leave 48-bit holes.  Do NOT change this while
\ Target Compiling is in progress!  Leaving this variable FALSE is heartily
\ reccomended; if your code is huge, wait till the error message, then set it
\ TRUE and start over.

\ 00001 18-jan-91 mdh  fixed problem with ALITERALs  ( added swap )
\ 00002 PLB 1/29/91 Remove duplicate TARGETABS +STACK in ResolveAll
\ 00003 PLB 2/5/91 Add IF.FORGOTTEN INITCLONE
\ 00004 PLB/MDH 2/6/91 Add calls to SizeDiff? in CloneUnresolved
\ 00005 mdh 4/24/91 new defer

only forth definitions

decimal  ANew TASK-Clone.f

variable IfLeaveLong   \ if non-zero, leave 3 words (see above text)...
variable InitialImageSize  ( starting size to avoid expansion )
variable IfLongBranch

also TGT definitions


\ flags and general variables...

variable PktBase       \ address of the 'attribute' packet for this CFA...
variable TargetBase    \ the address of this word in the target...
variable HiBranch      \ an RTS without a branch around means done...
variable CurrentDiff   \ current difference in pfa size
variable ThisOp
variable SPECIAL_ID
variable TargetDataStart

1 array testarray

\ stacks ...

  0 DynamicStack UnResolved  \ to 'remember' calls to the non-existant ones...
  0 DynamicStack TargetABS   \ for tracking required Long Relocations...
128 DynamicStack DiffSizes   \ addrs of size diffs and the diffs...
  8 DynamicStack BranchAdrs  \ local stack pointing to the Branch opcodes...
  0 DynamicStack OpenCells   \ will be resolved to an address...
128 DynamicStack ?DOIndexes
  8 DynamicStack ValueRefs
  8 DynamicStack CFATables
  8 DynamicStack TGTCFATables
  8 DynamicStack :ClassCFAS
  8 DynamicStack DictPCRels
  8 DynamicStack ImagePCRels
  8 DynamicStack FromCFAs

also forth definitions

: InitClone
  UnResolvedVAR FreeStack
  TargetABSVAR  FreeStack
  DiffSizesVAR  FreeStack
  BranchAdrsVAR FreeStack
  OpenCellsVAR  FreeStack
  ?DOIndexesVAR FreeStack
  ValueRefsVAR  FreeStack
  CFATables     FreeStack
  TGTCFATables  FreeStack
  :ClassCFAS    FreeStack
  DictPCRels    FreeStack
  ImagePCRels   FreeStack
  FromCFAs      FreeStack
  InitClone
;

if.forgotten initclone \ 00003

previous definitions

.need K
: K 1024 * ;
.then

: CALCCALL  ( calledOpAdr callingOpAdr -- opcode data #bytes )
  \ is it within relative-distance range?
  \
  2dup 2+ -  [ decimal ]  dup -32769 >  over 32768 < and
  ( -- cldop clngop rel-displacement flag )
  IF
     -rot 2drop   $ 6100  swap  4
  ELSE
     drop
     over  [ 32 k ] literal <
     IF
        \
        \ Origin relative...
        \
        drop $ 4eac swap 4
     ELSE
        \
        \ if 32k - 96k, use +64k relative...
        \
        over  [ 96 k ] literal <
        IF
           drop  [ 64 k ] literal -  $ 4eab swap   4
        ELSE
           \
           \ Push CallingOpAdr+2 on TargetABS stack for relocation.
           2+ TargetABS +stack  $ 4eb9 swap 6
        THEN
     THEN
  THEN
;


\ ----------- AllotData ------------------------------------------
\

: AllotDATA  ( areastart -- )
  NextLFA drop
  Mindiff @  4 max            \ TargetAllot
  cell /mod swap IF 1+ THEN   ( -- #cells )
  StartArea @ swap 0
  DO
     dup @ Target, cell+
  LOOP
  drop
;


: RegisterDiff  ( #bytes -- )  currentdiff +!
\    TargetHere 2+  TargetBase @ -  DiffSizes  +stack
       ThisOp @ 2+     CFABase @ -  DiffSizes  +stack
     currentdiff @  DiffSizes  +stack
;


: SizeDiff?  ( opadr #bytes -- )
  0 >r   swap w@ swap  ( opcode #bytes )  over BranchOp?
  IF
     ( -- opc #bytes )  over  ShortBRA? 0= 0=  IfLongBranch @ and
     IF
        rdrop 2 >r
     THEN
  ELSE
     over $ 4eb9 =    over 4 =  and
     IF
        \
        \ original call was Absolute (6 bytes), targeted will be 4...
        \
        rdrop -2 >r
     ELSE
        over $ 4eb9 = 0=  over 6 =  and
        IF
           \
           \ original was relative (4 bytes), targeted will be 6...
           \
           rdrop 2 >r
        THEN
     THEN
  THEN
  r> ?dup
  IF
     ( -- opc #bytes amt-diff )  RegisterDiff
  THEN
  2drop
;

: Special?  ( cfa -- ??_ID , return ID code if not a colon def )
  \
  \ Check if the SFA has a special_ID marked in the SFA...
  \
  dup PacketFor ..@ ref_IsPFA dup
  IF
      drop dup cell- @ $ f,0000 and
  THEN
  swap drop
;

: LITERALADDR?  ( cfa -- flag , true if literal references to a data area )
  Special? dup VARIABLE_ID = swap USER_ID = or
;

: CloneExisting  ( opadr tgtcalled calledcfa -- opadr )
  LiteralAddr?
  IF
     $ 2d07 targetw, \ put in move.l tos,-(dsp)
     2 RegisterDiff
     $ 2e3c          \ opcode for move.l  # ...
     swap   6        ( -- opadr opcode data #bytes )
  ELSE
     TargetHERE      ( -- opadr tgtcalled tgtcalling )
     CalcCall        ( -- opadr opcode data #bytes )
  THEN
  3 pick over        ( -- opadr opcode data #bytes opadr #bytes )
  SizeDiff?          ( -- opadr opcode data #bytes )
  rot TargetW,       ( -- opadr data #bytes )
  4 =
  IF
     TargetW,
  ELSE
     Target,
  THEN
;


: CloneUnresolved  ( opadr calleda -- opadr )
  \
  \ 1. Store called native PFA in opcode 'hole'
  \ 2. Push Target Address of 'hole' on the 'UnResolved' stack.
  \
  dup LiteralAddr?  dup >r
  IF
     $ 2d07 targetw,   2  RegisterDiff
  THEN
  TargetHERE  UnResolved   +stack
  ( -- calleda )  Target,
  IfLeaveLong @  r> or
  IF
     $ 4e71 TargetW,
     dup 6 SizeDiff?  \ 00004
  ELSE
     \ calc change in size for 4 byte BSR or JSR
     ( -- opadr )  dup 4 SizeDiff? \ 00004
  THEN
;


: ResolveCells
  OpenCellsBase freecell  ( -- #unreslvds )  0
  DO
     \
     \ Get the address containing the native PFA...
     \
     OpenCellsBase i cells + @
     \
     \ Get the NATIVE pfa we need to locate in the target...
     \
     dup Target@  ( -- tgtadr nativepfa )
     \
     \ Find its TargetAdr
     \
     abs PacketFor  dup  ..@ ref_Resolved 0=
     IF
        ( -- tgtadr pkt )
        >newline ." UnResolved reference to RESIDENT address " over target@
        base @ >r hex 0 .r ." , from cell " over . r> base !  cr
     ELSE
        ( -- tgtadr pkt )
        dup ..@ ref_TgtAdr  2 pick Target!
     THEN
     2drop
  LOOP
  OpenCellsBase FreeByteA off
;


: ResolveODE  ( -- )
  :ClassCFASBase freecell 0
  DO
     i :ClassCFASBase stack@
     ( -- :classCFA ) dup PacketFor ..@ ref_TGTAdr >r
     >LastIvar @  ?dup
     IF
        dup do-does-size -   ( -- ivardata ivarcfa )
        PacketFor ..@ ref_TgtAdr do-does-size + r@ >LastIvar  Target!
        ( -- ivardata )
        BEGIN
           do-does-size -  ( ivcfa )
           dup PacketFor ..@ ref_TgtAdr >r  ( -r- tgtivcfa )  
           dup >IvarClass @ do-does-size - PacketFor
           ..@ ref_TgtAdr do-does-size +  ( ivcfa tgtivclass )
           r@ >IvarClass Target!          ( ivcfa )
           >PrevIvar @ ?dup
        WHILE
           dup  do-does-size - PacketFor
           ..@ ref_TgtAdr do-does-size +  ( previvar tgtPrevIvar )
           r> >PrevIvar Target!           ( previvar )
        REPEAT
        rdrop
     THEN
     rdrop
  LOOP
;

: ResolvePCRels ( -- )
  DictPCRelsBase freecell 0
  DO
     ( -- )
     i DictPCRelsBase stack@  ( -- &dictop )
     PCRel>Dest  ( -- ref-dict-adr )
\ >newline hex .s
     Dict>TGT  ( -- ref-tgt-adr )
     i ImagePCRelsBase stack@  ( -- rta &tgtopcode )  dup>r
     Dest>PCRel dup $ ffff,8000 <  over $ 7fff > or
     IF
        >newline ." Destination PC-relative address too far away: "
        i DictPCRelsBase stack@ .hex  drop
     ELSE
        r@ 2+ TargetW!
     THEN
     rdrop
  LOOP
;


: ResolveAll  ( -- )
  ResolveCells
  UnResolvedBase freecell  ( -- #unreslvds )  0
  DO
     \
     \ Get the address containing the native PFA...
     \
     UnResolvedBase i cells + @
     \
     \ Get the NATIVE pfa we need to locate in the target...
     \
     dup Target@  ( -- tgtopadr nativepfa )  dup >r
     \
     \ Find its TargetAdr
     \
     abs PacketFor  dup >r  ..@ ref_Resolved 0=
     IF
        ( -- tgtopadr )  ( -r- nativepfa??neg pkt )
        >newline ." UnResolved reference to RESIDENT address " dup target@
        base @ swap hex 0 .r ." , from " over . base !  cr
     ELSE
        ( -- tgtopadr )  ( -r- cfa packet )
        r@ ..@ ref_TgtAdr   1 rpick 0<
        IF
           true  ( address literals are saved NEGATEd )
        ELSE
           1 rpick LiteralAddr?
        THEN
        ( -- tgtopadr tgtadr flag )
        IF
           $ 2e3c 2 pick targetW!
           over 2+  Target!
        ELSE
           over
           ( -- calling calledtgtadr callingadr )   CalcCall
           ( -- calling opcode data #bytes )   6 =
           IF
              IfLeaveLong @ 0=
              IF
                 2drop >newline
                 ." LONG RELOCATIONS are necessary; the variable IFLEAVELONG" cr
   ( 00001 )     ."      must be set TRUE; then INITCLONE and try again." cr
              ELSE
                 ( -- calling opcode called )    swap 2 pick TargetW!
\ already stacked!  ( -- calling called )      over 2+ dup TargetABS +stack
                 ( -- calling called )      over 2+  \ 00002
                 ( -- calling called calling+2 )    Target!
              THEN
           ELSE
              ( -- opadr opcode displacement )  swap 2 pick TargetW!
              over 2+ TargetW!  ( -- opadr )
           THEN
        THEN
     THEN
     r> 2drop  r> drop
  LOOP
  UnResolvedBase FreeByteA off
  ResolveODE
  ResolvePCRels
;


: CloneCall  ( opadr calledadr -- opadr )
  \
  \ This address calls 'nother...   ( -- opadr calledadr )
  \
  dup PacketFor dup ..@ ref_Resolved
  ( -- opadr calledadr calledpkt  flag )
  IF
     \
     \ the word exists in the target...
     \
     ..@ ref_tgtadr  ( -- opadr calleda tgta )
     swap            ( -- opadr tgtcalled calledcfa )
     CloneExisting
  ELSE
     \
     \ the word has NOT been built in the Target yet.
     \
     ( -- opadr calleda calledpkt )
     drop CloneUnresolved
  THEN
  \
  \ Is this call followed by a string?
  \
  ( -- opadr )  dup +NextOp drop $op @
  IF
     >r
     r@ dup w@ opsize dup >r +   ( -- $startaddr )  ( -r- opadr oplen )
     r> r@ +NextOp swap -        ( -- $start $len )
     2/ 0
     DO
        dup w@  ( dup hex . ) TargetW,  2+
     LOOP
     drop r>
  THEN
;


: CloneALit  ( opadr referenced-adr -- opadr )  Substitute?
  dup do-does-size - IsValuePFA?
  IF
     $ 2e3c Targetw,  TargetHERE  ValueRefs +stack   Target,
     ( targetdataAddr = dictdataaddr  ValueRefsStack = TargetDataAddr )
  ELSE
     dup ValidPFA?
     IF
        \
        \ the address IS a cfa
        \
        dup PacketFor dup ..@ ref_Resolved   ( -- opadr ref-adr packet flag )
        IF
           $ 2e3c TargetW,
           ..@ ref_TgtAdr  Target,
           drop
        ELSE
           \
           \ not built in target yet...
           \
           drop
           TargetHERE UnResolved +stack              \ save tHERE as unrslvd
           negate  ( negative=flag for ALit) Target, \ install dict adr in img
           $ 4e71 Targetw,
        THEN
     ELSE
        \
        \ assume it's referencing some CREATE DOES> child...
        \
        ( -- opadr refadr )           dup >CFA
        ( -- opadr refadr it's-cfa )  dup cell- @  $ f,0000 and
        CASE
           VARIABLE_ID of
              dup [ PktBase ' PktBase - ] literal +
              ( -- opadr refadr cfa cfa+data ) 2 pick
              swap ( 00001 )      -  endof
           CREATE_ID   of
              2dup -           endof
           >newline ." ALITERAL points to ????, can't CLONE opcode at "
           ThisOp @ hex u. quit
        ENDCASE
        ( -- opadr refadr cfa diff-from-tgt-adr ) swap
        PacketFor    ( -- opadr refadr diff pkt )  ..@ ref_TgtAdr +
        $ 2e3c TargetW,  Target,   drop
     THEN
  THEN
;

0 .IF
: CloneBranch  ( opadr destadr -- opadr )
  dup hibranch @ max hibranch !
  over w@ ( -- opadr destadr opcode )
  dup ShortBRA?
  IF
     2 pick 4 SizeDiff?
  THEN
  targetHERE  BranchAdrs   +stack
  dup $ 5fff >
  IF
     $ ff00 and
  THEN Targetw,
  \
  \ after the opcode, save the dict-cfa-relative address referenced...
  \
  CFABase @ -  Targetw,
;


: FixBranch  ( TGTopadr -- )
  \
  \ get the dict-rel-addr being called...
  \
  2+ dup Targetw@  ( -- tgtdispadr reldest )
  DiffSizesBase     ( -- tgtdispadr reldest base )
  dup freebyte +
  BEGIN
     [ 2 cells ] literal -  dup @  2 pick <=
  UNTIL
  cell+ @  ( -- disptgtadr reldest sizediff )  + targetbase @ +
  over - swap targetw!
;
.ELSE
: CloneBranch  ( opadr destadr -- opadr )
  2 x>r
  \           1      0
  \  ( -r- destadr opadr )
  \
  1 rpick  hibranch @ ( hex .s ?pause decimal )  max hibranch !
  r@ w@ dup >r   ShortBRA? >r
  \
  \           3      2      1      0
  \  ( -r- destadr opadr opcode ifshort )
  \
  IfLongBranch @
  IF
     r@
     IF
        2 rpick 4 SizeDiff?
     THEN
  THEN
  \
  targetHERE  BranchAdrs   +stack
  1 rpick dup  $ 5fff >  IfLongBranch @ and
  IF
     $ ff00 and
  THEN
  Targetw,
  \
  \ after the opcode, save the dict-cfa-relative address referenced...
  \
  3 rpick  CFABase @ -  FromCFAs  +stack
  r@  IfLongBranch @ 0=  and  0=
  IF
     0 Targetw,
  THEN
  2 xrdrop r> rdrop

;

: FixBranch  ( TGTopadr branch# -- )
  2 x>r
  \           1        0
  \  ( -r- branch# TGTopadr )  
  \
  \ get the dict-rel-addr being called...
  \
  1 rpick FromCFAsBase stack@  ( -- reldest )
  DiffSizesBase     ( -- reldest base )
  dup freebyte +
  BEGIN
     [ 2 cells ] literal -  dup @  2 pick <=
  UNTIL
  cell+ @  ( -- reldest sizediff )  + targetbase @ +
  ( -- tgtaddr )  r@ 2+ -  >r
  \
  \           2        1          0
  \  ( -r- branch# TGTopadr displacement)  
  \
  1 rpick Targetw@ ShortBRA?
  IF
     r@ 127 >   r@ -128 <  OR
     IF
        >newline
        ." Too far for SHORT BRANCH...aborting CLONE operation." cr
        ." To successfully CLONE this program..." cr
        ." 1. Enter:   INITCLONE  IFLONGBRANCH ON  <return>" cr
        ." 2. Restart CLONE as before" quit
     ELSE
        1 rpick targetw@  $ ff00 and
        r@ $ 0ff and  or  1 rpick targetw!
     THEN
  ELSE
     r@  1 rpick 2+  targetw!
  THEN
  3 xrdrop
;

.THEN

: Set?DO   ( dict-ix-addr -- )  dup @  over 8 + +  ( -- ixadr dict-dest )
  CFABase @ -   ( -- ixadr dict-cfarel-dest )
  targetHERE cell-  dup ?DOIndexes +stack    Target!  drop
;

: Fix?DO  ( ixTGTadr -- )  dup Target@  ( -- ixadr dict-rel-addr )
  DiffSizesBase     ( -- tgtixadr reldest base )
  dup freebyte +
  BEGIN
     [ 2 cells ] literal -  dup @  2 pick <=
  UNTIL
  cell+ @  ( -- tgtixadr reldest sizediff )  + targetbase @ +
  over 8 + - swap target!
;


: FixValues  ( -- , references registered on ValueRefs stack )
  ValueRefsBase dup freecell 0
  DO
     i over stack@    ( -- base &tgtlit )
     dup Target@      ( -- base &tgtlit &dictdata )
     dup do-does-size - PacketFor dup ..@ ref_resolved 0=
     IF
        ( -- base &tgtlit &dictdata pkt )
        TargetHERE over ..! ref_TgtAdr
        true over ..! ref_resolved
        over @ Target,
     THEN
     ( -- base &tgtlit &dictdata pkt )  swap drop
     ..@ ref_TgtAdr swap Target!  ( -- base )
  LOOP freebytea off
;


: IfCall   ( opadr flag -- opadr flag' )
  dup 0=
  IF
      drop dup calls?  dup
      IF
          drop dup ' ((?DO)) =
          IF
             ( -- opadr called )  over cell-  Set?DO
          ELSE
             Substitute?
          THEN
          CloneCall true
      THEN
  THEN
;


: IfBranch   ( opadr flag -- opadr flag' )
  dup 0=
  IF
      drop dup Branches?  dup
      IF
          drop CloneBranch true
      THEN
  THEN
;


: IfALit   ( opadr flag -- opadr flag' )
  dup 0=
  IF
      drop dup ALit?  dup
      IF
          drop CloneALit  true
      THEN
  THEN
;


: IfInline   ( opadr flag -- opadr flag' , last check! )
  dup 0=
  IF
     drop
     dup dup w@ dup $ 4e71 =
     IF
        2drop true      \ do not include 'nop's
        -2 RegisterDiff
     ELSE
        opsize  dup TargetAllot  ( -- opadr opadr size )
        TargetHere over -  TargetImageBase + swap move
        \
        \ Last instruction?
        \
        dup w@ $ 4e75 =  over hibranch @ >=   and 0=
     THEN
  THEN
  ( -- opadr flag , flag=false if end of this pfa )
;


: IfLibOpen?  ( opadr flag -- opadr' flag' )
  dup 0=
  IF
     >r ( -- opadr )   dup CallingLibOpen?
     IF
        16 +   -20 RegisterDiff    16 ThisOp +!
        rdrop  true >r
     THEN
     r>
  THEN
;

: IfPCRel  ( opadr flag -- opadr' flag' )
  dup 0=
  IF
     drop  dup w@ dup PCRel?  ( -- opadr opcode flag )
     over 1 and 0= and   \ can't calc xx(pc,??)
\ >newline .s ?pause
     IF
        over DictPCRels +stack
        TargetHERE ImagePCRels +stack
        TargetW,   0 TargetW,
        true
     ELSE
        drop false
     THEN
  THEN
;

: CloneOpcode   ( opadr -- opadr flag , true=more to do )
  dup thisOp !  false
  IfCall        ( -- opadr flag , true if processed )
  IfBranch      ( -- opadr flag )
  IfALit        ( -- opadr flag )
  IfLibOpen?    ( -- opadr flag )
  IfPCRel       ( -- opadr flag )
  IfInLine      ( -- opadr flag )
;

.need CFATABLE>
defer CFATABLE>
.then

: CloneIV  ( objbase class-cfa -- )
  dup >LastIvar @   ( -- objbase classCFA lastivar )
  BEGIN
     ?dup
  WHILE
     ( objbase classCFA lastivar )              dup @ 3 pick +
     ( objbase classCFA lastivar nextobjbase )  over do-does-size -
     ( objbase classCFA lastivar nextobjbase instobjcfa )
     >IvarClass @ do-does-size -   recurse
     do-does-size - >PrevIvar @
  REPEAT
  ( objbase class-cfa -- )
  >CFATable
  dup CFATables stackfind   ( -- objbase &table ix flag )
  IF
     cells TGTCFATables     @ ( fix by Phil )   + @ >r
  ELSE
     2dup CFATables stackinsert   ( -- objbase &table ix )
     TargetHERE dup >r
     swap TGTCFATables stackinsert  ( -- objbase &table )
     dup >#methods 0
     DO
        dup @ Substitute?
        PacketFor ..@ Ref_TgtAdr Target,  cell+
     LOOP
  THEN
  drop  ( -- objbase )  CFABase @ -  TargetBase @ +  r> swap Target!
;

: CloneHighLevel  ( -- )
  CFABase @      ( -- pfa )
  BEGIN
     \
     \ piece up the code, opcode at a time...
     \
     ( -- opadr )  CloneOpcode  ( -- opadr flag )
  WHILE
     dup +NextOp +
  REPEAT
  drop
  BranchAdrsBase dup freecell 0
  DO
     dup @ i FixBranch cell+
  LOOP
  drop  BranchAdrsBase Freebytea off   FromCFAsBase Freebytea off
  ?DOIndexesBase dup freecell 0
  DO
     dup @ Fix?DO cell+
  LOOP
  drop  ?DOIndexesBase Freebytea off
  FixValues
[ 0 .if ]
  CFABase @ dup
  Special?  dup CREATE_ID = swap GLOBDEF_ID = or
  swap ' sample-defer = or
[ .else ]
  CFABase @   Special?  dup  CREATE_ID =
[ .then ]
  IF
     drop
     \
     \ calc beginning of data area...
     \
     do-does-size  TargetHERE TargetBase @ - - TargetALLOT
     \
     \ calc length of data area...
     \
     TargetHERE TargetDataStart !
     CFABase @   do-does-size +  AllotData
     \
     \ Check if it is a CLASS definition...
     \
     CFABase @ cell- @ CLASS_BIT and
     IF
        \ get the addr of the CFAs table...
        \
        CFABase @ do-does-size + dup @  ( -- objbase CFATable )
        CFATable>  CloneIV     ( -- )
     ELSE
        \ Check if it is a :CLASS definition...
        \
        CFABase @ cell- @ :CLASS_BIT and
        IF
           \ get the addr of the CFAs table...
           \
           CFABase @ dup dup :ClassCFAS StackLocate :ClassCFAS StackInsert
           >CFATable  dup CFATables stackfind  ( -- tbl ix flag )
           drop   2dup CFATables stackinsert   ( -- &table ix )
           TargetBase @ >CFATable  dup >r
           swap TGTCFATables stackinsert  ( -- &table )
           dup >#methods   r> swap 0
           DO
              ( -- &table &TGTtable )  over @ substitute?
              ( -- &table &TGTtable rescalledadr )
              dup PacketFor dup ..@ ref_Resolved
              IF
                 ( tbl tgttbl called pkt )
                 ..@ Ref_TgtAdr  swap drop  over Target!
              ELSE
                 drop
                 over dup OpenCells +stack   Target!
              THEN
              cell+ swap cell+ swap
           LOOP
           2drop
        THEN
     THEN
  ELSE
     \ is it adefered word?
     GLOBDEF_ID =
     IF
        TargetHERE TargetDataStart !
        \
        \ CFABase @   defer-size +  AllotData
        cell TargetAllot
     THEN
  THEN
;


: CloneVARIABLE  ( -- )
  TargetHERE TargetDataStart !
  CFABase @  [ clicommand  ' clicommand - ] literal +  AllotData
;


: CloneUSER  ( -- )
  TargetHERE TargetDataStart !
  CFABase @execute @ Target,
;


: SetDefered  ( -- )
  CFABase @  >is @
  Substitute?  ( -- calledadr )
  dup PacketFor dup ..@ ref_Resolved  ( -- called pkt flag )
  IF
     ..@ Ref_TgtAdr  TargetDataStart @  Target!  drop
  ELSE
     drop
     TargetDataStart @ dup OpenCells +stack   Target!
  THEN
;


: CloneGLOBDEF  ( -- )
  CloneHighLevel  SetDefered
;

0 .IF
: CloneUSERDEF  ( -- )  CFABase @ >r
  ' SAMPLE-DEFER CFABase !
  IfCreateRefs on
  CloneHighLevel
  r>  CFABase !    SetDefered
  IfCreateRefs off
  ' SAMPLE-DEFER  References  StackFind
  IF
     dup cells RefPacketsBase + @ freeblock
     dup References StackRemove
     dup RefPackets StackRemove
  THEN
  drop
;
.ELSE
: CloneUSERDEF  ( -- )  CloneGLOBDEF  ;
.THEN

: CloneSpecial  ( ??_ID -- )
  CASE
     VARIABLE_ID of CloneVARIABLE       endof
     USER_ID     of CloneUSER           endof
     CREATE_ID   of CloneHighLevel      endof
     USERDEF_ID  of CloneUSERDEF        endof
     GLOBDEF_ID  of CloneGLOBDEF        endof
\    VALUE_ID    of CloneVALUE          endof
       >newline ." Undefined 'DATA'_ID:" dup .hex
       ."   Cloning:"  CFABase @ .hex
  ENDCASE
;


: CloneReference  ( cfa -- )   dup IsValuePFA? 0=
  IF
     \
     \ Initializations...
     \
     dup PacketFor PktBase !   CFABase ! 
     DiffSizesBase FreeByteA off \ init the sizediffs stacks...
     0  DiffSizes  +stack
     0  DiffSizes  +stack
     CurrentDiff off             \ no difference at start...
     TargetHERE TargetBase !     \ save the start tgt adr...
     HiBranch off                \ no branches yet!
     \
     \ not a normal colon def?
     \
     CFABase @ Special? -dup
     IF
        CloneSpecial
     ELSE
        CloneHighLevel
     THEN
     PktBase @ >r
     TargetBase @  r@  ..! ref_TgtAdr
     true          r>  ..! ref_Resolved
  ELSE
     drop
  THEN
;

: CLONE.SETUP.TARGET  ( size -- , preallocate target to save RAM )
    InitialSize @
    swap InitialSize !
    TargetImage  ( allocate data )
    0= abort" Couldn't Allocate InitialImageSize Target Area!"
    InitialSize !
;

: CLONECFA  ( cfa -- )
  \
  InitialImageSize @ ?dup
  IF  clone.setup.target
  THEN
  \
  CFABase off
  ' noop dup is UserCleanUp   is ErrorCleanup
  \
  \ Make sure 'StartJForth' is first code word assembled...
  \
  ' StartJForth  references StackFind  swap drop 0=
  IF
     ' StartJForth TracePFA
     ' StartJForth CloneReference
     ' StartJForth myself
     ' StartJForth PacketFor   1 swap ..! ref_#Times
  THEN
  \
  \ ( -- cfa )  Check if this word must be redefined...
  \
  Substitute?
  \
  \ ( -- cfa )  get all called definitions...
  \
  TracePFA    ( -- )
  \
  \ Replace @execute for DEFER-EXECUTE...
  \
[ 0 .if ]
  ' defer-execute references StackFind  ( -- index flag )  swap drop
  IF
     ' sample-defer  TracePFA
     ' defer-execute references StackFind  ( -- index flag )  drop
     dup cells RefPacketsBase + @    ( -- defix pkt )
     over  References  StackRemove
     swap  RefPackets  StackRemove   ( -- pkt )
     dup ..@ ref_#Times swap freeblock
     ' @execute PacketFor dup ..@ ref_#Times   ( -- #times1 pkt #times2 )
     rot + swap ..! ref_#Times
  THEN
  ' SAMPLE-DEFER  References  StackFind
  IF
     dup cells RefPacketsBase + @ freeblock
     dup References StackRemove
     dup RefPackets StackRemove
  THEN
  drop
[ .THEN ]
  IfCreateRefs off   
  \
  \ Build from lowest cfa to highest...
  \
  References @ freebyte  ( -- #references*4 )  0
  DO
     RefPackets @ i + @  ( -- addr-of-pkt )
     ..@ ref_resolved 0=
     IF
        Status?
        References @ i + @
        \
        \ ( -- cfa )  this word needs built in the target.
        \
        CloneReference
     THEN
     cell
  +LOOP
  \
  \ Now take care of the kernal words that forward referenced...
  \
  ResolveAll
;

also Forth Definitions

: CLONE.FWARNING ( -- , warn if files open )
    fcloseatbye @ memcells? 0>
    fblk @ 0= AND
    IF  >newline ." WARNING - Files Open during Clone!" cr
        ."   Any files used by a Cloned program must be opened" cr
        ."   by that program when run." cr
    THEN
;

: CLONE  ( <name> -- , create royalty free image )
  >newline
  clone.fwarning
  MaxImageSize @
  IF
     ." NOTE: the VARIABLE 'MaxImageSize' is no longer used by CLONE."
     cr
  THEN
  [compile] '  cr
  " 1m" CSIType
  ."   CLONE (version 1.4)  by Mike Haas, 20-Jan-92"
  " 0m" CSIType  cr  InitStatus
  CloneCFA  .status   cr cr   ;

previous definitions

: (TrapPacket)   ( cfa refix -- )  base @ >r   hex
  >newline cr   ." REFERENCE ERROR:  cloning "
  CFABase @  1 .r   ." , the opcode at "
  ThisOp  @  1 .r   cr
  ." is trying to create a reference to "  swap u.
  cr TargetHERE  ." TargetHERE = " u.
  r> base !
  quit
;

' (TrapPacket) is TrapPacket

only forth definitions
also TGT
