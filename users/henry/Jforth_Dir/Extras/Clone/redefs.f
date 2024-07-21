\ MOD: 7/21/90 Add >NAME
\ 00002  06-aug-91  mdh  Added QUIT

\ Redefine words that behave differently when Cloned.

only forth definitions

ANEW task-redefs.f

VARIABLE RawExpectEcho

also TGT definitions

\ ----------------------------------------------------------------------

vocabulary redefs    also redefs definitions   previous

also redefs
defer find   ' false is find
previous

: ECHOTYPE       2drop      ;

: CLICOMMAND     CMDBlock @ ;

: DOSSTRING      DOSBlock @ ;

: .  (.) ;


: BYE  ( -- )    ExitJForth  ;


: (QUIT) ( -- )
  what's ErrorCleanUp \ should ONLY be called from here!
  ' noop dup is ErrorCleanUp  is UserCleanUp
  execute  ExitJForth  ;

also redefs  \ 00002 -- ErrorCleanUp is what the user should set instead of
defer QUIT  ' (quit) is quit   \  QUIT (<- for INTERPRETER use only)
previous

: (INTERPRET)  ( -- )  ;


: ?STACK  ( -- )  ;


: WORD  ( char -- adr )
  skip-word? @        ( -- char flag )
  IF
     drop
  ELSE
     parse-word       ( -- adr cnt )
     here lplace
  THEN
  here dup count +    ( -- here last+1 )
  bl swap c!          ( -- here )
  skip-word? off
;


: ?PAUSE  ( -- )  ;


: >IS  ( pfa -- dataadr )  ( do-does-size ) DEFER-SIZE +  ;


: DEFER-execute   @execute ;


: (EXPECT)
  what's emit >r   RawExpectEcho @ 0=
  IF
     ' drop is emit
  THEN
  (expect)
  r> is emit  ;

: (?terminal)   ( -- flag )
  ConsoleIn @ dup
  IF
     dup call dos_lib IsInteractive
     IF
        drop   (?terminal)
     ELSE
        dup fkey  ( -- fp key? )  EOF =
        IF
           drop 0
        ELSE
           ( -- fp )  -1 offset_current fseek drop  true
        THEN
     THEN
  THEN
;

: (KEY)
  ConsoleIn @
  IF
     flushemit
     BEGIN
        CancelNow?  (?terminal)  0=
     WHILE
        60,000 (?terminal.delay) drop
     REPEAT
     (key)
  ELSE
     false
  THEN
;

global-defer KEY        also Redefs	  ' (KEY)       is KEY        previous
global-defer ?TERMINAL  also Redefs	  ' (?TERMINAL) is ?TERMINAL  previous

: KH.EXPECT  ( addr max -- , expect for history )
    (expect)
;

\ These two are from the Floating Point code.
: SMUDGE0123 ;
: UNSMUDGE0123 ;

: OB.CHECK.BIND  2drop  ;

: OB.BAD.METHOD quit ;

: CREATE ;
: DOES> ;

global-defer :CREATE
also redefs ' noop is :create  previous

: OB.SET.NAME  2drop ;

: TRAPS ;
: NOTRAPS ;
: UNRAVEL ;

\ vocabulary workarounds...
also redefs definitions  only forth  \ lets make sure of where we are here!

: VOCDOES  drop ;
: VLATEST>VLINK ;
: VLINK>VLATEST ;
: DEFINITIONS ;
: ALSO ;
: ONLY ;
: SEAL ;
: PREVIOUS ;
: ORDER: ;
: VOC-ID. drop ;
: ORDER ;
: FIND-IN false ;
: VOC-FIND false ;
: VOCS ;
: VLIST ;
: WORDS ;
: SCAN-VOC drop ;
: SCAN-WORDS ;
: SCAN-ALL-VOCS ;
: >NAME ( cfa -- nfa )
    drop   " '>NAME inactive when Cloned!'" ;

only forth definitions

also TGT definitions



\ This vocabulary is searched IF TRACKING is false  (default)


vocabulary AllocRedefs    also AllocRedefs definitions   previous

: ALLOCBLOCK  xallocblk  ;
: FREEBLOCK   xfreeblk   ;
: ExitFreeBlocks   noop  ;
: ExitCloseFiles   noop  ;
: ExitCloseLibs    noop  ;
: BYEFREE>         drop  ;
: >BYEFREE         drop  ;
: BYECLOSE>        drop  ;
: >BYECLOSE        drop  ;
: MARKFREEBLOCK    drop  ;
: UNMARKFREEBLOCK  drop  ;
: MARKFCLOSE       drop  ;
: UNMARKFCLOSE     drop  ;

only forth definitions

also TGT definitions

vocabulary IORedefs    also IORedefs definitions   previous

global-defer EMIT		also IORedefs	' drop is EMIT		previous
global-defer KEY		also IORedefs	' EOL  is KEY		previous
global-defer ?TERMINAL	also IORedefs	' false is ?TERMINAL	previous
global-defer FLUSHEMIT	also IORedefs	' noop is FLUSHEMIT	previous

only forth definitions

: RedefsEnd ;

also TGT
