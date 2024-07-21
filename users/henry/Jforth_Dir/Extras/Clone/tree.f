
\ TracePFA ( pfa -- ) analyze word, mark as referenced. If word
\ calls others, recursively analyze ALL SUB-words until all are known.

decimal

only forth definitions

ANEW TASK-TREE.F

.need CFATable>
defer CFATable>   ' noop is CFATable>
.then


variable Tracking   \ user turns this on for mem & file allocation tracking
                    \ in his target image

variable NoConsole  \ if true, clone dummy code for
                    \ KEY, EMIT, ?TERMINAL


also TGT definitions


\ Record-keeping Stacks ... entries made for each referenced pfa...


0 DynamicStack References  \ Sorted stack of called addresses...
0 DynamicStack RefPackets  \ 'References' index also index for here...
                           \ index holds address of 'Packet', described below.
128 DynamicStack Substitutes  \ so 'FIND' doesn't run so much
128 DynamicStack SubCFAs

EXISTS? status? .IF
   : NumRefs  ReferencesBase freecell  ;   ' numrefs is #Cloned
.THEN


also forth definitions

: InitClone
  ReferencesVAR FreeStack
  RefPacketsVAR @&FreeBlocks
  SubstitutesVAR FreeStack
  SubCFAsVAR FreeStack
  InitClone
;

previous definitions


variable CFABase  \ holds CFA of word we ate tracing or cloning...

\ and a sample-definition...

\ Global-Defer Sample-Defer   ' (pushadr) is Sample-Defer

: Sample-Defer  (pushadr) @execute  ;  $ 4e75 w,  ' (pushadr)  ,


\ RefPacket definition and handlers ...


:struct RefPacket
   ubyte Ref_IsPFA      \ it non-zero, called address IS a legal pfa.
   ubyte Ref_Resolved   \ true if defined in the targetimage.
   ulong Ref_#Times     \ #times this PFA is called
   ulong Ref_TgtAdr     \ Target relative resolved address
;struct


\   This is a foolproof method for figuring how much space exists from
\ a given location to the following NFA.


variable StartArea    variable MinDiff


.NEED asm
: ClosestNFA?  ( nfa -- )  dup startarea @ >=
  IF
     startarea @ -   mindiff @ min  mindiff !
  ELSE
     drop
  THEN
;
.ELSE
asm ClosestNFA?  ( nfa -- )
     move.l   #[StartArea],a0	never do this, since this code
     cmp.l    0(org,a0.l),tos	will never clone, it's ok here
     blt      1$
       move.l   #[MinDiff],a1	a0=StartArea	
       add.l    org,a1		a1=MinDiff(abs)
       sub.l    0(org,a0.l),tos
       cmp.l    (a1),tos
       bge      1$
         move.l   tos,(a1)
1$:  move.l   (dsp)+,tos
end-code
.THEN

.NEED asm
: ClosestVOC?  ( voc-link -- )
  vlink>'  >name  ClosestNFA?
;
.ELSE
asm ClosestVOC?  ( voc-link -- )
     subq.l  #8,tos
     callcfa >name
     callcfa ClosestNFA?
end-code
.THEN

: NextLFA   ( ?addr -- next-LFA-above )
   StartArea !   [ -1 u2/ ] literal mindiff !
  ' ClosestNFA?  is when-scanned
  ' ClosestVOC?  is when-voc-scanned    scan-all-vocs
  mindiff @  [ -1 u2/ ] literal =
  IF
       here StartArea @ -  0 max  mindiff !
  ELSE
       -4 mindiff +!
  THEN
  StartArea @  mindiff @ +
;

: <ValPFA?>   ( 0 pfa -- flag dummy )
;

: ValidPFA?  ( pfa -- flag )
  0 swap
  dup cell- @  $ 0070,f800 and 0=    ( -- 0 pfa flag )
  IF
     \ a rational size code exists...
     dup >name dup Valid-Name?        ( -- 0 pfa nfa? flag )
     IF 
        \ the name-field seems to make sense...
        name> over =      ( -- 0 pfa flag )
        IF
           \ going back to the pfa gives the original adr, it's good!
           2drop true dup
        THEN
     ELSE
        drop
     THEN
  THEN
  drop
;

: >CFA  ( adr? -- cfa )
  BEGIN
     dup ValidPFA? 0=
  WHILE
     2-
  REPEAT
;

: IsValuePFA?  ( pfa? -- flag )
  dup validpfa?  dup   ( -- adr flag flag )
  IF
     drop dup cell- @  $ f,0000 and VALUE_ID =
  THEN
  swap drop
;

0 .IF
defer  JustForParent  ' justforParent >parent
forget JustForParent
constant DeferParent
.THEN

: GETNAME  ( cfa -- , move fullname to HERE )
  >name   dup c@  $ 1f and dup >r  1+  ( -- nfa count+1 )
  here swap move   r> here c!
;


: SUBSTITUTE?   ( cfa -- cfa' )
  \
  dup >r  dup ValidPFA?
  IF
     dup Substitutes StackFind  ( -- cfa index flag )  2dup 2 x>r
     ( -r- cfa flag index )
     IF
        SubCFAsBASE stack@  ( -- cfa newcfa )
        dup ' Redefs ' RedefsEnd within?   ( -- cfa newcfa flag )
        IF
           drop true
        ELSE
           nip false
        THEN
     ELSE
        drop true
     THEN  ( -- cfa? flag )
     IF
        1 rpick  0=
        IF
           dup r@  ( -- cfa cfa ix )  Substitutes  StackInsert
        THEN
        dup GETNAME
        \
        NoConsole @
        IF
           only IORedefs definitions  here find
           IF
              dup CFABase @ -
              IF
                  ( -- cfa cfa2 )  swap
              THEN
           THEN
           only forth definitions drop
        THEN
        \
        dup 2 rpick =  ( not found in redefs )
        Tracking @ 0= and  ( notracking wanted )
        IF
           only AllocRedefs definitions  here find
           IF
              dup CFABase @ -
              IF
                  ( -- cfa cfa2 )  swap
              THEN
           THEN
           only forth definitions drop
        THEN
        dup 2 rpick =  ( still not found )
        IF
           only redefs definitions  here find
           IF
              dup CFABase @ -
              IF
                  ( -- cfa cfa2 )  swap
              THEN
           THEN
           only forth definitions drop
        THEN
        \
        1 rpick 0=
        IF
           dup r@  ( -- cfa2 cfa2 ix )  SubCFAs  StackInsert
        THEN
     THEN
     2 xrdrop
  THEN
  rdrop
;


: <CreatePacket>   ( pfa index -- address )   >r
  MEMF_CLEAR  sizeof() RefPacket  allocblock?  ( -- pfa pktadr )
  dup r> RefPackets StackInsert       ( -- pfa pktadr )
  swap ValidPFA? over ..! Ref_IsPFA   ( -- pktadr )
;


: <CreateReference>  ( pfa index -- packetaddr )
  2dup  References  StackInsert  ( -- pfa index )   <CreatePacket>
;


variable IfCreateRefs      Global-Defer TrapPacket


: PacketFor  ( pfa -- Packet-Base )
  dup References StackFind   ( -- pfa index flag )
  IF
       \ it exists...
       cells RefPacketsBase + @ ( -- pfa pktaddr )
  ELSE
       IfCreateRefs @
       IF
          \ 1st time referenced ...
          <CreateReference> dup ( -- pktadr pktadr )
       ELSE
          \ error...shouldn't be extending ref tables...
          ( -- pfa pktaddr )  TrapPacket  quit
       THEN
  THEN
  swap drop
;

: CFA>Tgt  ( dictcfa -- tgtadr )
  PacketFor dup ..@ ref_Resolved   ( -- packet flag )
  IF
     ..@ ref_TgtAdr
  ELSE
     \
     \ not built in target yet...
     \
     >newline
     ." DICT>TGT: "  >name ID. ."  referenced but not built" quit 
  THEN
;

: Dict>TGT  ( dictadr -- tgtaddr , call only after everthing built! )
  dup ValidPFA?
  IF
     \
     \ the address IS a cfa
     CFA>Tgt
  ELSE
     dup  defer-size -  ' emit  defer-size  compare 0=
     IF
        ( defered )  defer-size -  CFA>Tgt defer-size +
     ELSE
        \
        \ assume it's referencing some CREATE DOES> child...
        \
        ( -- dictadr  )           dup >CFA
        ( -- dictadr it's-cfa )  dup cell- @  $ f,0000 and
        CASE
           VARIABLE_ID of
              dup [ Tracking ' Tracking - ] literal +
              ( -- dictadr cfa cfa+data ) 2 pick -  endof
           CREATE_ID   of
              2dup -           endof
              >newline over
              ." DICT>TGT: address within "  >name ID.
              ."  can't be derived" quit 
        ENDCASE
        ( -- dictadr cfa diff-from-tgt-adr ) swap
        PacketFor    ( -- dictadr diff pkt )  ..@ ref_TgtAdr +  nip
     THEN
  THEN
;


0 .IF
: CreateDoes?  ( adr -- ??_ID , return ID code if not a colon def )
  \
  \ Check if the SFA has a special_ID marked in the SFA...
  \
  dup PacketFor ..@ ref_IsPFA dup
  IF
      drop dup cell- @ $ f,0000 and
  THEN
  swap drop
;
.THEN


\ the word that cycles thru a PFA...

.need myself

: MYSELF  ( -- , compile self )
  latest name> calladr,
; IMMEDIATE  

.then


: CallingLibOpen?   ( opadr -- flag )
  0 >r  dup @  $ 2d07,2e3c =
  IF
     dup 16 + Calls?
     IF
        ' LibOpen? =
        IF
           rdrop true >r
        THEN
     THEN
  THEN
  drop r>
;

defer DoTracePFA

: TraceIVs  ( class-cfa -- )
  dup >LastIvar @   ( -- classCFA lastivar )
  BEGIN
     ?dup
  WHILE
     ( classCFA lastivar )             do-does-size - dup
     ( classCFA insobjcfa insobjcfa )  >IvarClass @ do-does-size - recurse
     >PrevIvar @
  REPEAT
  ( class-cfa -- )  DoTracePFA
;

: CheckIf:Class  ( cfa -- )
  dup cell- @ :CLASS_BIT and
  IF
     \ it's an ODE :CLASS!
     \
     dup >CFATable  ( -- cfa &cfa's )
     dup >#Methods 0
     DO
        dup @ DoTracePFA  cell+
     LOOP
     drop  ( -- cfa )
\
\
[ 0 .if ]
     dup do-does-size +  @ ( -- xxx &cfa's )  CFATable> TraceIVs
[ .else ]
     dup >LastIvar @
     BEGIN
        ?dup
     WHILE
        do-does-size -   dup  DoTracePFA
        dup >IvarClass @ do-does-size - DoTracePFA
        >PrevIvar @
     REPEAT
[ .then ]
\
\
  THEN
  drop
;

: CheckIfClass  ( cfa -- )
  dup PacketFor ..@ ref_IsPFA  \ ValidPFA?
  IF
     dup cell- @ CLASS_BIT and
     IF
        \ it's an ODE CLASS!
        \
\
\
[ 0 .if ]
        dup do-does-size +  @ ( -- xxx &cfa's )
        dup >#Methods 0
        DO
           dup @ DoTracePFA  cell+
        LOOP
        drop
[ .else ]
        dup do-does-size +  @ ( -- xxx &cfa's )  CFATable> TraceIVs
[ .then ]
\
\
     ELSE
        dup CheckIf:Class
     THEN
  THEN
  drop
;

: PCRel>Dest  ( &pcrel-opcode -- reldestadr )
  2+ dup w@ w->s +
;

: Dest>PCRel  ( reldestadr opcode-adr -- rel-offset )
  - 2-
;


variable do?pause
variable TrapOn

: TracePFA  ( pfa -- )   \ ?pause
  TrapOn @
  IF
     dup TrapOn @ =
     IF
        cr ." TRAPPED: " TrapOn @  .hex
        ." , CfaBase = " CFABASE @ .hex   quit
     THEN
  THEN
  Status?
  IfCreateRefs on
  Substitute?
  CFABase @ swap  dup CFABase !
  dup IsValuePFA? 0=
  over references stackfind swap drop 0= and >r
\
\ Get or create the 'packet' for this pfa...
\
  dup PacketFor         ( -- pfa packet )
\
\ if vectored, pull up executable contents
\
  dup ..@ ref_IsPFA
  IF
     over cell- @ $ f,0000 and   dup USERDEF_ID =  swap GLOBDEF_ID =   or
     IF
        over >is @   myself
     THEN
  THEN
\
\ register the fact that its being called...
\
  dup ..@ ref_#times  1+  over ..! ref_#times  r>
  IF
\
\ start the loop checking for more references
\
       >r  0 >r              ( --  opadr )   ( -r- packetadr hibra )
       dup CheckIfClass
       BEGIN
          do?pause @  IF  ?pause  THEN
          dup w@  $ 4e75 -   r@ or
       WHILE
          dup Calls?
          IF
             ( -- opadr calledadr )  myself
          ELSE
             dup ALit?
             IF
                \ ( -- opadr ref'd-addr )  check if a create/does
                dup 2- w@ $ 4e75 = >r
                dup do-does-size -
                dup cell- @ $ f,0000 and  $ 1,0000 $ 6,0000  within?  >r
                ValidPFA?  r> and  r> and
                IF
                   do-does-size -  myself  \ some kind of data word
                ELSE
                   dup ValidPFA?
                   IF
                      myself  
                   ELSE
                      \ is pointing to some kind of data area (ARRAY?)
                      >CFA myself
                   THEN
                THEN
             ELSE
             	dup w@ dup PCRel?  swap 1 and 0= and  ( can't calc x(pc,??)
             	IF
             	   \ extract addr
             	   dup PCRel>Dest  dup ValidPFA?
                   IF
                      myself  
                   ELSE
                      \ is pointing to some kind of data area (ARRAY?)
                      >CFA myself
                   THEN
             	THEN
             THEN
          THEN
          dup CallingLibOpen?
          IF
             18 +
          ELSE
             dup w@ >r dup +NextOp  ( -- opadr opsize )  ( -r- hibra opc )
             over + swap            ( -- nextopa opadr )
             r> dup BranchOp?       ( -- nextadr opadr opcode flag )
             IF
                  BRAto? dup r@ >   ( -- nextadr dest replaceflag )
                  IF
                       dup r> drop >r
                  THEN
                  drop              ( -- nextadr )
             ELSE
                  2drop
             THEN
             r@ -dup
             IF
                  ( -- nextadr hibra )
                  over <=
                  IF
                       r> drop  0 >r
                  THEN
             THEN
          THEN
       REPEAT
       r> 2drop  r> drop
  ELSE
       2drop
  THEN
  CFABase !
;
' tracepfa is dotracepfa

: .Refs   ( -- , show contents of stacks )
  cr  base @ >r
  ReferencesBase freecell dup . ." PFAs referenced ..." cr  ?dup
  IF
       0
       DO
            i cells ReferencesBase + @   ( -- pfa )
            hex dup 9 .r space
            dup packetfor dup ..@ ref_ISPFA
            IF    over >name id.
            ELSE  ." -- No NFA --"
            THEN  space  ascii .  30 emit-to-column space
            swap drop  ( -- packet )
            ..@ ref_#times   decimal  3 .r  ."  times" flushemit ?pause cr
       LOOP
  THEN
  r> base !
;


: ShowCalls   ( -- , <name> )
  ReferencesVAR FreeStack
  RefPacketsVAR @&FreeBlocks
  [compile] '  TracePFA
  .refs
;


only forth definitions
also TGT

