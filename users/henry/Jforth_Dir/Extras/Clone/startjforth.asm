
\ Mike Haas
\
\    'StartJForth' is the very first to execute in any target-compiled
\ image.  It initializes the virtual-machine CPU registers so that
\ high-level code can get up and running quickly.
\
\    While definitions are previous to 'StartJForth' in this file,
\ the Target Compiler assembles 'StartJForth' first, and later
\ resolves the references to these words.
\
\
\ Register assignments and names used in JForth 1.2 Assembler...
\
\     a0 = 0ar = temp0     d0 = 0dr = \
\     a1 = 1ar = temp1     d1 = 1dr = |
\     a2 = 2ar = loc       d2 = 2dr = |-- available data regs, unnamed
\     a3 = 3ar = +64k      d3 = 3dr = |
\     a4 = 4ar = org       d4 = 4dr = /
\     a5 = 5ar = up        d5 = 5dr = iloop
\     a6 = 6ar = dsp       d6 = 6dr = jloop
\     a7 = 7ar = rp        d7 = 7dr = tos
\
\ MODS:
\ 00000  03-dec-88  mdh  Add allocation of the DOS0 buffer (oops!)
\ 00001  04-mar-89  mdh  use shorter, more efficient opcode
\ 00002  15-aug-89  mdh  implicit >newline in ExitJForth
\ 00003  27-nov-91  plb  fix ASM syntax error, thanks Jerry Kallaus
\ 00004  12-jan-92  mdh  Incorporate CLILOCK
\ 00005  13-jan-92  mdh  changed wb_lib to workbench_lib

only forth definitions

anew Task-StartJForth.asm

variable StackSize        4096 StackSize      !
variable DictionarySize    256 DictionarySize !
variable Enable_Cancel    \ set true to allow ^C,^D,^E or ^F cancels

.NEED UserCleanUP
defer UserCleanUP   ' noop is UserCleanUp
.THEN

also TGT definitions


decimal

max-inline @     6 max-inline !
verify-libs @    verify-libs off

variable _main            \ will hold target address of 'main'
variable StackBlock       \ saves the addr gotten for Data stack
variable DOSBlock         \ block allocated for dos0 buffer
variable CMDBlock         \ block allocated for DOSCOMMAND/TIB

\ variable DPBlock          \ block allocated for dictionary


: ExitFreeBlocks  ( -- )  fcloseatbye  @&closefiles  ;
: ExitCloseFiles  ( -- )  freeatbye    @&freeblocks  ;
: ExitCloseLibs   ( -- )  CloseAllLibs ;


: ExitFree?  ( var -- )
  @  -dup
  IF
     XFreeBLK
  THEN
;


: ReturnStuff  ( -- )
  what's UserCleanUp
  ' noop dup is UserCleanUp  is ErrorCleanUp
  execute
  ExitFreeBlocks
  ExitCloseFiles
  ExitCloseLibs
  StackBlock ExitFree?
  CMDBlock   ExitFree?
\ DPBlock    ExitFree? 
  DOSBlock   ExitFree?
  WBMESSAGE @  dup>r
  IF            \ 00004
     WBLOCK
  ELSE
     CLILOCK
  THEN
  dup>r @ call dos_lib CurrentDir  dup r> @ -
  IF
     call dos_lib UnLock
  THEN
  drop
  dos_lib -lib
  r@
  IF
        call Exec_lib Forbid   drop
     r@ call Exec_lib ReplyMsg drop
  THEN
  rdrop
;


asm ExitJForth   ( get oudda here! )
    CallCFA OUT               start 00002
    tst.l   0(org,tos.l)
    beq     1$
    moveq.l #[eol],tos
    CallCFA emit
1$: CallCFA FlushEmit         end 00002
    move.l  rp,dsp            move the data stack away from allocated mem
    sub.l   #2048,dsp         ...like 2k below the return stk
    CallCFA ReturnStuff       give it all back
    CallCFA RetCode           get any returncode
    move.l  0(org,tos.l),d0   ...in d0
    CallCFA R0                get the original returnstack...
    move.l  0(org,tos.l),d4
    add.l   org,d4
    move.l  d4,rp
end-code


: SetSignal()  ( states mask -- prevstates )
  call Exec_lib SetSignal
;


only forth definitions   also tgt


ASM (CancelKey?) ( -- 0=no, otherwise, ascii C, D, E, or F )
    move.l    tos,-(dsp)            set stack to returning level
    move.l    dsp,-(rp)             and save it
    sub.l     #4,dsp
    clr.l     (dsp)                 read the signal bits
    moveq.l   #0,tos
    CallCFA   SetSignal()
    move.l    #12,d4
    lsr.w     d4,tos                move bits 15-12 to lo nibble
    move.b    tos,d4
    and.b     #$0f,d4               clr higher nibble
    beq       8$
    move.l    #[ascii F],tos        put an 'F' in tos
    cmp.b     #8,d4                 is the ^F bit set?
    bge       1$
    subq.l    #1,tos                char -> E
    cmp.b     #4,d4                 is the ^E bit set?
    bge       1$
    subq.l    #1,tos                char -> D
    cmp.b     #2,d4                 is the ^D bit set?
    bge       1$
    subq.l    #1,tos                char -> C
    cmp.b     #1,d4                 is the ^C bit set?
    bge       1$
8$: moveq.l   #0,tos                none set, return false
1$: tst.b     tos                   anything there?
    beq       3$
    move.l    tos,-(dsp)            yes, clear the signal bits
    clr.l     -(dsp)
    move.l    #$f000,tos
    CallCFA   SetSignal()
    move.l    (dsp)+,tos
3$: move.l    (rp)+,dsp
end-code

' (CancelKey?) is CancelKey?

: (CancelNow?)  ( -- )
  Enable_Cancel @
  IF
     CancelKey? -dup
     IF
        >newline  ascii ^ emit  emit ."  Abort"
        cr  quit
     THEN
  THEN
;

' (CancelNow?) is CancelNow?

only forth   also tgt definitions


ASM InitLibraries  ( -- , init the Exec & dos libs )
    move.l    tos,-(rp)            just save the data stack, we'll restore it
    move.l    dsp,-(rp)
    CallCFA   Exec_Lib             get the pointer to the exec_lib
    move.l    $4.w,0(org,tos.l)    ( 00001 )
    CallCFA   RetCode              give a message if we fail to allocate
    move.l    tos,-(rp)
    move.l    #1001,0(org,tos.l)
    CallCFA   DOS_Name             get ready to open DOS...
    add.l     org,tos              >abs
    move.l    tos,-(dsp)
    moveq.l   #0,tos
    FORTH{    ] call Exec_Lib OpenLibrary  [  }
    tst.l     tos                  did we succeed?
    bne.s     1$
    CallCFA   ExitJForth
1$: CallCFA   DOS_lib              guess so, install the pointer
    move.l    (dsp),0(org,tos.l)
    move.l    (rp)+,tos            adjust the return code
    sub.l     #1,0(org,tos.l)
    move.l    (rp)+,dsp            restore the stack
    move.l    (rp)+,tos
end-code


ASM InitStacks
    move.l    tos,-(rp)            save CLI arguments  ( - a1 a2 )
    move.l    (dsp),-(rp)
    CallCFA   RetCode              register some success( - a1 a2 rc )
    sub.l     #1,0(org,tos.l)
    CallCFA   StackSize            get the desired stksize ( - a1 a2 rc ss )
    move.l    0(org,tos.l),tos     00003 , removed .L from ",tos.L"
    move.l    tos,-(rp)            save it on the return stack
    move.l    #[MEMF_CLEAR],(dsp)  finish setup for allocblock ( a a mc s )
    CallCFA   XAllocBLK            ( a a adr )
    tst.l     tos                  did we succeed?
    bne.s     1$
    CallCFA   ExitJForth
1$: CallCFA   StackBlock           ( a a adr vadr )
    move.l    (dsp),0(org,tos.l)
    move.l    (dsp)+,tos           ( a a adr )
    add.l     (rp)+,tos            point to the END of the area
    sub.l     #32,tos              give a little 'overflow' room
    move.l    tos,dsp              install it
    add.l     org,dsp
    CallCFA   S0
    move.l    (dsp)+,0(org,tos.l)  put it in S0
    sub.l     #8,dsp
    move.l    (rp)+,(dsp)          recover the CLI arguments
    move.l    (rp)+,tos
    move.l    rp,d0                set R0 to original stack value
    addq.l    #8,d0                ...we're 2 levels down
    sub.l     org,d0
    CallCFA   R0
    move.l    d0,0(org,tos.l)
    move.l    (dsp)+,tos
end-code

ASM AArea   ( allocate an area of size in d0, return adr in d0 )
            ( d0 = 0 if not successful )
    move.l    tos,-(dsp)
    move.l    #[MEMF_CLEAR],tos
    move.l    tos,-(dsp)
    move.l    d0,tos
    CallCFA   XAllocBLK
    tst.l     tos
    bne       1$
    CallCFA   ExitJForth
1$: move.l    tos,d0
    move.l    (dsp)+,tos
end-code

ASM InitBlocks  ( -- )  build a dictionary area and a TIB
    move.l    tos,-(dsp)       save stack condition
    move.l    dsp,-(rp)
    \
    \ allocate the TIB
    \
    move.l    #1028,d0
    CallCFA   AArea
    CallCFA   CMDBlock
    move.l    d0,0(org,tos.l)
    addq.l    #1,d0            count will be at beginning
    CallCFA   'TIB
    move.l    d0,0(org,tos.l)
    \
    \ allocate a DOS0 Buffer
    \
    move.l    #258,d0
    CallCFA   AArea
    CallCFA   DOSBlock
    move.l    d0,0(org,tos.l)
    \
    \ leave
    \
    move.l    (rp)+,dsp        restore stack condition
    move.l    (dsp)+,tos
end-code


\ getmodule includes


ASM AddCMD   ( -- , d0=#chars  a0=from  a1=countaddr )
    clr.l     d1
    move.b    (a1),d1       get curr str len
    move.l    d1,d2         copy it
    add.b     d0,d1         increment it
    move.b    d1,(a1)+      put it there, point to text
    add.l     d2,a1         point to end of string
1$: move.b    (a0)+,(a1)+
    subq.l    #1,d0
    bne.s     1$
end-code


ASM InitCLI   ( CLIargs $cnt absCLI -- )
    move.l    dsp,d0
    addq.l    #8,d0
    move.l    d0,-(rp)                   save final stack adr-4
    lsl.l     #2,tos                     BCPL convert
    sub.l     org,tos                    >rel
    FORTH{ ]  ..@ cli_CommandName [ }
    lsl.l     #2,tos                     BCPL convert
    move.l    tos,a0                     a0=abs$1c
    move.l    (dsp)+,d4                  d4=cnt$2
    move.l    (dsp)+,d3                  d3=rel$2
    add.l     org,d3                     d3=abs$2
    CallCFA   CLICommand
    add.l     org,tos                    d7=absCMD
    move.l    tos,up                     up=absCMD
    clr.l     d0  
    move.b    (a0)+,d0                   d0=cnt$1
    CallCFA   >IN
    move.l    d0,0(org,tos.l)            point >in past the command name
    move.l    up,a1
    CallCFA   ADDCMD
    move.b    #32,(a1)                   add a blank
    add.b     #1,(up)                    inc the cnt
    move.l    d3,a0
    move.l    d4,d0
    move.l    up,a1
    CallCFA   ADDCMD
    CallCFA   WBMESSAGE                  clear these variable under CLI
    clr.l     0(org,tos.l)
    CallCFA   TOOLWINDOW
    clr.l     0(org,tos.l)
    FORTH{ ]  call dos_lib Output [ }
    move.l    tos,d4
    CallCFA   CONSOLEOUT
    move.l    d4,0(org,tos.l)
    FORTH{ ]  call dos_lib Input [ }
    move.l    tos,d4
    CallCFA   CONSOLEIN
    move.l    d4,0(org,tos.l)
    \
    CallCFA   TASKBASE                save away CLILOCK    00004
    move.l    0(org,tos.l),a0          TASKBASE is saved absolute
    move.l    [pr_CurrentDir](a0),d0
    CallCFA   CLILOCK
    move.l    d0,0(org,tos.l)
    \
    move.l    (rp)+,dsp
    move.l    (dsp)+,tos
end-code


ASM InitWorkBench   ( process -- ) tos holds process
    addq.l    #4,dsp               stack is empty, save it for restore 
    move.l    dsp,-(rp)
    FORTH{ ]  .. pr_MsgPort [ }    get address of message port
    add.l     org,tos              >abs
    move.l    tos,-(rp)            and save it
    FORTH{ ]  call Exec_lib WaitPort  [ }
    move.l    (rp)+,tos
    FORTH{ ]  call Exec_lib GetMsg  [ }   tos has Wbench message
    move.l    tos,-(rp)                   save it
    CallCFA   WBMESSAGE                   put it here
    move.l    (rp),0(org,tos.l)
    move.l    (dsp)+,tos
    sub.l     org,tos                     >rel
    move.l    tos,(rp)                    replace absolute one
    FORTH{ ]  ..@ sm_ArgList if>rel [ }
    tst.l     tos                         is there a pathname?
    beq.s     1$
    FORTH{ ]  ..@ wa_Lock [ }
    CallCFA   WBLOCK
    move.l    (dsp),0(org,tos.l)
    move.l    (dsp),tos
    FORTH{ ]  call DOS_lib CurrentDir drop [ }
1$: move.l    (rp)+,tos                   get relative startup msg
    FORTH{ ]  ..@ sm_ToolWindow  [ }
    CallCFA   TOOLWINDOW
    move.l    (dsp)+,0(org,tos.l)
    \
    CallCFA   CLILOCK      00004
    CallCFA   off
    \
    move.l    (rp)+,dsp                   empty the stack
end-code


ASM InitTIB   ( -- )
    move.l    dsp,-(rp)
    CallCFA   CLICOMMAND
    move.l    tos,d4
    CallCFA   #TIB
    clr.l     0(org,tos.l)
    move.b    0(org,d4.l),3(org,tos.l)
    CallCFA   OUT
    clr.l     0(org,tos.l)
    move.l    (rp)+,dsp
    CallCFA   InitAlloc
end-code


: HLINIT  ( ArgsAddr ArgsCnt -- )
\
\ Init the system variables...
  decimal
  ' byefree>    'byefree> !
  ' >byefree    '>byefree !
  ' byeclose>   'byeclose> !
  ' >byeclose   '>byeclose !
  ' noop dup is UserCleanUp   is ErrorCleanup
  freeatbye           off   fcloseatbye     off   >in                 off
  CMDBlock            off   ConsoleIn       off   ConsoleOUT          off
  DOSBlock            off   STackBlock      off
  clist_lib           off   graphics_lib    off   layers_lib          off
  intuition_lib       off   mathffp_lib     off   mathtrans_lib       off
  mathieeedoubbas_lib off   translator_lib  off   icon_lib            off
  diskfont_lib        off   console_lib     off   mathieeesingbas_lib off
  potgo_lib           off   timer_lib       off
\
\ for 2.0...
\
  asl_lib off
  battclock_lib off
  battmem_lib off
  commodities_lib off
  romboot_lib off
  cstrings_lib off
  misc_lib off
  rexxsyslib_lib off
  utility_lib off
  disk_lib off
  gadtools_lib off
  input_lib off
  keymap_lib off
  mathieeesingtrans_lib off
  ramdrive_lib off
  workbench_lib off  \ 00005
  expansion_lib off
  iffparse_lib off
\
  dp drop   $ 7fff,ffff   max-type !
  MODE_OLDFILE  filemode !
\
\ Init the ExecLibrary.......................
  InitLibraries   ( -- Args? cnt? )
\
\ Allocate a bigger stack & set r0...........
  InitStacks        ( -- args? cnt? )
\
\ Allocate a dos0 buffer and a TIB............
  InitBlocks
\
\ Set our task addr in TASKBASE..............
  0 call Exec_lib FindTask dup TaskBase !  >rel  ( -- args cnt task )
\
\ Are we under WorkBench?
  dup >r  ..@ pr_CLI    -dup
  IF
     \
     \ we were run from CLI, convert BCPL, make relative, get args...
       InitCLI
  ELSE
     \
     \ We were started from WorkBench, copy process message...
       2drop  r@ InitWorkBench
  THEN
  rdrop   ( drop taskbase )
  InitTIB
;


0 .IF

!!!!  IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT  !!!!

      NEVER alter the next word,  StartJForth, unless checking
     with Delta Research.  Doing so may result in unpredictable
     results from CLONEd programs.
     
.THEN

ASM StartJForth   ( ENTRY POINT ... rp is set, a0=abs args addr, d0=arg cnt )
    lea      -2(pc),org     Init the origin and +64k regs...
    move.l   org,a3
    add.l    #$10000,a3
    move.l   rp,dsp           Set dsp to (rp - 2048)
    sub.l    #2048,dsp
    sub.l    org,a0           Push relative CLI args onto data stack
    move.l   a0,-(dsp)
    move.l   d0,tos
    CallCFA  HLInit           ( -- &args $cnt ) rest of init is high-level...
    CallCFA  RetCode
    CallCFA  Off
    CallCFA  _main            fetch & call _main ...
    move.l   0(org,tos.l),tos   00003 , was (org.L,tos) , .L in wrong place
    add.l    org,tos
    move.l   tos,a0
    move.l   (dsp)+,tos
    jsr      (a0)
    CallCFA  ExitJForth       on return, cleanup
    move.l   #[version#],d6     \ do NOT remove this line!
    move.l   #[serial# @],tos   \ do NOT remove this line!
End-Code



verify-libs !   max-inline !


only forth definitions
also TGT
