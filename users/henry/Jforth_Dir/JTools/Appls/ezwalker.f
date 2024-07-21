\ Demonstrate the use of JForth's EZMenu system.
\ Use pull down menus in a simple graphics application.
\
\ Author: Phil Burk
\ Delta Research, Box 1051, San Rafael, CA, 94915
\ (415) 485-6867
\ July 8, 1988
\
\ This code is hereby placed in the Public Domain
\ and may be freely distributed.

\ (1) Conditionally compile support code not already loaded
include? newwindow.setup ju:amiga_graph
include? ev.getclass     ju:amiga_events
include? ezmenu ju:amiga_menus
include? choose ju:random

\ Forget this code if already loaded.
ANEW TASK-EZWALKER.F

\ (2) Declare an EZMenu structure.
EZMENU MY-MENU

\ (3) -----------------------------------------
\ Variables used to control application.
variable DRAW-MODE   ( lines or boxes )
0 constant USE_LINES
1 constant USE_BOXES

variable QUIT-NOW    ( time to stop? )
variable LAST-X
variable LAST-Y

\ Define words (functions) to call when menu item picked.
: USE.LINES  ( -- , set application drawing mode to lines)
    use_lines draw-mode !
    last-x @ last-y @ gr.move
;

: USE.BOXES  ( -- , now draw boxes )
    use_boxes draw-mode !
;

\ (4) Call any Amiga Library routine by name
\ using the JForth CALL facility.
: CLEAR.WINDOW ( -- , set rastport to color 0 )
    gr-currport @ ( get absolute addr of window rastport)
    0     ( background color )
    call graphics_lib SetRast   ( call Amiga routine )
    drop  ( don't need return value )
;

: QUIT.DRAWING  ( -- , set termination flag )
    quit-now on
;

\ (5) --------------------------------------------
\ Set up Menu and Menu items using EZMENU system.
: MY-MENU.INIT  ( -- , initialize menu )
    110 menuitem-defwidth !  ( set default item width )
\ Allocate space for 4 menu items with intuitext structures
    4 my-menu ezmenu.alloc
\
\ Set name of menu and position in list.
    0" Choose" 0 my-menu ezmenu.setup
\
\ Define the text for each menu item.
    0" Lines" 0 my-menu ezmenu.text!
    0" Boxes" 1 my-menu ezmenu.text!
    0" Clear" 2 my-menu ezmenu.text!
    0" Quit"  3 my-menu ezmenu.text!
\
\ Set the function to call for each menu item.
\ Pull off stack in reverse order.
    ' quit.drawing    ' clear.window
    ' use.boxes       ' use.lines
    4 0 DO  i my-menu ezmenu.cfa[] !  LOOP
\
\ (6) Set lines and boxes item to have exclusive checkmarks
    [ BINARY ] ( Use base 2 to express exclusion pattern.)
    0010 0 my-menu ezmenu.exclude!
    0001 1 my-menu ezmenu.exclude!
    CHECKED 0 my-menu ezmenu.set.flag
    [ DECIMAL ]
\
\ (7) Set Command Sequence keys for Clear and Quit.
    ascii C 2 my-menu ezmenu.commseq!
    ascii Q 3 my-menu ezmenu.commseq!
;

\ (8) ----------------------------------------------
\ Code for drawing lines and boxes.
: SAFE.RECT ( x1 y1 x2 y2 - , sort corners and draw )
    >r swap >r 2sort  ( sort X values )
    r> r> -2sort      ( sort Y values )
    -rot     ( -- x y x y )
    gr.rect
;

: DRAW.NEW.XY ( x y -- , draw either a line or a box )
    draw-mode @
    use_lines =
    IF  2dup gr.draw
    ELSE
        2dup last-x @ last-y @ safe.rect
    THEN
    last-y ! last-x !
;

: NEXT.COLOR ( -- , Cycle through colors 1,2,3 )
    gr.color@ 1+ dup 3 >
    IF drop 1
    THEN  gr.color!
;

\ Select random distances for random walk.
: CALC.DELTA.X ( -- dx )
    41 choose 20 -
;
: CALC.DELTA.Y ( -- dy )
    21 choose 10 -
;

: WANDER.XY ( -- , random walk )
\ Add a number between -20 and +20
    last-x @ calc.delta.x +
\ Clip to 0 and current window size.
\ Note reference to window structure.
    0 max gr-curwindow @ ..@ wd_gzzwidth min
\
    last-y @ calc.delta.y +
    0 max gr-curwindow @ ..@ wd_gzzheight min
    draw.new.xy
;

\ (9) --------------------------------------
\ Process IDCMP events. 
: HANDLE.EVENT ( event_class -- )
    CASE
\ Call functions set using EXMENU.CFA[] !
        MENUPICK
        OF  ev-last-code @ my-menu ezmenu.exec
        ENDOF
\
\ Set quit flag if CLOSEBOX hit.
        CLOSEWINDOW
        OF quit-now on
        ENDOF
\
        ." Unrecognized event!" cr
    ENDCASE
;

\ Draw lines or boxes until told to quit.
: LOOP.DRAW ( -- )
    quit-now off
    BEGIN
        wander.xy  ( do graphics )
        next.color
\
        gr-curwindow @ ev.getclass ?dup
        IF handle.event
        THEN
        quit-now @
    UNTIL
;

\ Declare new window structure.
NewWindow MY-WINDOW

: EZWALKER.INIT ( -- , set everything up )
    gr.init  ( initialize graphics system )
    my-window newwindow.setup  ( set defaults )
\
\ Change window title using structure access word ..!
    0" EZWAlker  in JForth  by Phil Burk" >abs
    my-window ..! nw_Title
\
\ Set flags for window to allow menus.
    CLOSEWINDOW MENUPICK |
    my-window ..! nw_IDCMPFlags
\ Make window automatically active.
    MY-WINDOW ..@ nw_Flags   ACTIVATE |
    MY-WINDOW ..! nw_Flags
\
\ Open window based on NewWindow template
    my-window gr.openwindow gr.set.curwindow
\
\ Initialize menu and attach to window.
    my-menu.init
    gr-curwindow @ my-menu SetMenuStrip()
\
\ Start in middle of window
    gr_xmax 2/ last-x !
    gr_ymax 2/ last-y !
    use.lines
;

: EZWALKER.TERM ( -- , clean up menus and close window. )
    gr-curwindow @ ClearMenuStrip()
    gr.closecurw
    my-menu ezmenu.free
;

: EZWALKER ( -- , do it all)
    EZWALKER.init
    loop.draw
    EZWALKER.term
;
    
cr ." Enter:    EZWALKER    to see demo." cr
