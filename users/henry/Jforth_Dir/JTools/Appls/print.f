\ Print a Source Code file with Header
\ Convert TABS to spaces.
\ Output text to optional file if specified.
\ Print Linenumbers unless '-n' option selected.
\
\ Author: Phil Burk
\ Copyright 1988 Phil Burk
\
\ MOD: PLB 9/19/89 Close PRT: if error with input file.

exists? includes
.IF getmodule includes
.ELSE include? preferences ji:intuition/preferences.j
.THEN

include? dolines ju:dolines

decimal

ANEW TASK-PRINT.F

: GetPrefs() ( pref size -- , read preferences info )
    intuition?
    callvoid>abs intuition_lib getprefs
;

\ Printer characteristics.
preferences MY-PREF
variable PR-LEFT
variable PR-RIGHT
variable PR-LINES/PAGE
variable PR-CHARS/LINE

128 constant PR_MAX_CHARS

\ Header to hold filename and page count.
variable PR-HEADER pr_max_chars 2+ allot
variable PR-NUM-BUFFER 16 allot ( hold line numbers )
variable PR-LINE-BUFFER pr_max_chars 2+ allot
variable PR-INFILE-NAME filename_size allot 
variable PR-OUTFILE-NAME filename_size allot 

variable PR-LINE-OUT  \ num chars in line so far
variable PR-IF-NUMBER
variable PR-OFFSET
variable PR-PAGE-NUMBER
variable PR-LINE-NUMBER
variable PR-LINES-SOFAR
variable PR-PRT-FILEID
variable PR-ERROR
variable PR-TAB-WIDTH

70 pr-chars/line !
8 pr-tab-width !

: GET.PREFS ( -- )
    my-pref
    sizeof() preferences
    getprefs()
;

: GET.PAGE.INFO ( -- , extract relevant information )
    get.prefs
    my-pref ..@ pf_printleftmargin pr-left !
    my-pref ..@ pf_printrightmargin pr-right !
    pr-right @ pr-left @ - 1+ pr-chars/line !
    my-pref ..@ pf_paperlength 8 - pr-lines/page !
;

: GET.DATE.STRING ( -- addr count , get date from DOS )
    " DATE >RAM:ZZZZ_DATE" $dos
    " RAM:ZZZZ_DATE" $fopen ?dup
    IF  dup pad 40 fread 1- 0 max pad swap
        rot fclose
    ELSE pad 0
    THEN
;

: PR.BUILD.HEADER ( -- , assemble date and name )
    pr-header pr_max_chars BL fill  ( fill with blanks )
\
\ Put filename against right margin
    pr-infile-name count  32 min 
    pr-header pr-chars/line @ + over -
    swap cmove
\
\ Put date against left margin
    get.date.string dup
    IF  bl scan ( skip past day )
        pr-header swap cmove
    ELSE 2drop
    THEN
;

: PR.ADD.NUMBER ( -- , add page number to header )
    pr-page-number @ n>text
    pr-chars/line @ over - 2/
    pr-header +
    swap cmove
;

: PR.CR ( -- , send CR to printer )
    pr-prt-fileid @ eol femit
    1 pr-lines-sofar +!
;

: PR.TYPE ( addr count -- , output a string to printer )
    dup
    IF  pr-prt-fileid @ -rot dup>r fwrite
        r> - dup pr-error !  ( set error if not written )
        IF ." Write failed!" cr
        THEN
    ELSE 2drop
    THEN
;

: PR.LINEOUT ( addr count -- , output a line to printer )
    pr.type pr.cr
;

: PR.DO.HEADER ( -- , print header with page number )
    1 pr-page-number +!
    pr.add.number
    pr-header pr-chars/line @ pr.lineout
    pr.cr
;

: PR.NEW.PAGE ( -- , skip to new page )
    pr-lines-sofar @
    IF  pr-prt-fileid @ 12 femit
        0 pr-lines-sofar !
    THEN
;

: PR.LINE.DUMP ( -- , dump current line to printer )
    pr-line-buffer
    pr-line-out @ pr-chars/line @ pr-offset @ - min
    pr.lineout 
;

: PR.EMIT ( char -- , add char to line buffer )
    pr-line-out @ dup 1+ pr-line-out !
    pr-line-buffer + c!
;

: PR.TAB ( -- , simulate tab )
    pr-tab-width @
    pr-line-out @ pr-tab-width @ mod
    - 0
    DO bl pr.emit
    LOOP
;

9 constant TAB_CHAR

: PR.LINE.FULL? ( -- if_full )
    pr-chars/line @
    pr-offset @ - ( max allowed )
    pr-line-out @ <=
;

: PR.SCAN.CHARS ( addr numc -- addr' numc' , add characters to buf )
\ Convert tabs to spaces.
    0 pr-line-out !
    BEGIN ( -- addr numc )
        dup 0>
        pr.line.full? not and
    WHILE
        over c@ dup tab_char =
        IF drop pr.tab
        ELSE pr.emit
        THEN
        1- swap 1+ swap  ( adjust addr and count )
    REPEAT
;

: PR.ONE.LINE ( addr count -- addr' count' )
\ Print header every time lines/page hit.
    pr-lines-sofar @ pr-lines/page @ mod 0=
    IF  pr.do.header
    THEN
\
\ Print line numbers or whatever.
    pr-num-buffer pr-offset @ pr.type
\
\ Print text.
    pr.scan.chars
    pr.line.dump
\
\ Form Feed if at end of page.
    pr-lines-sofar @ pr-lines/page @ =
    IF pr.new.page
    THEN
;

: PR.CLEAR.NUMBER ( -- )
    pr-num-buffer 16 bl fill
;

: PR.NUMBER.LINE ( -- , put line number in buffer )
    pr.clear.number
    pr-line-number @ n>text
    dup 3 max dup 1+ pr-offset ! ( addr count width )
    pr-num-buffer + over - swap cmove
;

: PR.LINE  ( $line -- , process line from DOLINES )
    1 pr-line-number +!
    pr-if-number @
    IF  pr.number.line
    THEN
    count
    BEGIN
        pr.one.line
        pr.clear.number
        dup 0> not
        pr-error @ 0= 0= OR
    UNTIL
    2drop
;

: FORCEUPPER ( char -- char' )
    dup ascii a ascii z within?
    IF ascii a - ascii A +
    THEN
;

: PR.OPTION? ( $word -- if_option , parse if option )
  dup c@ 2 <
  IF drop false
  ELSE
    dup 1+ c@   ascii -   =
    IF  dup 2+ c@
        forceupper
        CASE
        ascii N
            OF pr-if-number off true
            ENDOF ( -- a f )
        ascii T
            OF
            dup count 2- swap 1+ ( -- c-2 a+2 )
            tuck c!
            number?
            IF drop 16 min pr-tab-width !
            THEN
            true 
            ENDOF
            ." Unrecognized option! = " over $type cr
            pr-error on
        false swap
        ENDCASE nip
    ELSE drop false
    THEN
  THEN
;

: PR.PARSE.INPUT (  <infile> <outfile> <-n> <-t6> -- )
    " PRT:" pr-outfile-name $move
    0 pr-infile-name !
    makeucase @
    makeucase off
    BEGIN
        fileword
        dup c@
    WHILE
        dup pr.option? not
        IF  pr-infile-name @
            IF pr-outfile-name $move
            ELSE pr-infile-name $move
            THEN
        ELSE drop
        THEN
    REPEAT drop
    pr-infile-name @ 0=
    IF pr-error on
    THEN
    makeucase !
;

: .COMMAND ( -- <name> )
    >in @
    >in off
    bl word $type
    >in !
;

: PR.USAGE ( -- , print Instructions )
    cr .command ."  V1.1 by Phil Burk (Written using JForth)" cr cr
    ." Usage:  print infile {outfile} {-n} {-t8}" cr cr
    ." Prints text from infile to outfile, printing headers" cr
    ." and line numbers on each page. Default outfile = PRT:" cr
    ."    -n = turns off line numbering" cr
    ."    -ti = set tab width to i, eg. -t4" cr
;

: PR.REPORT ( --, report progress )
    cr pr-infile-name $type ."  printed to "
    pr-outfile-name $type cr
    pr-line-number ? ."  lines." cr
;

: PR.TERM ( -- , clean up )
    pr-prt-fileid @ ?dup
    IF  pr-error @ not
        IF  pr.new.page
        THEN fclose
        pr-prt-fileid off
    THEN
    pr-error @
    IF pr.usage
       10 retcode !  ( set DOS return code )
    ELSE pr.report
    THEN
;

: PR.ABORT  ( -- )
    pr-error on
    pr.term
    abort
;

: PR.INIT ( <infile> <outfile> <-n> <-t6> -- error? , setup print system )
    pr-error off
    get.page.info
\
    ' pr.line is doline
    ' pr.abort is doline.error  ( added 9/19/89 )
    0 pr-page-number !
    0 pr-line-number !
    0 pr-lines-sofar !
    0 pr-offset !
    0 pr-prt-fileid !
    8 pr-tab-width !
    pr-if-number on
\
    pr.parse.input
    pr.build.header
    pr-error @ not
    IF  pr-outfile-name new $fopen
        dup pr-prt-fileid ! 0=
        IF  pr-outfile-name $type
            ."  could not be opened!" cr
            pr-error on
        THEN
    THEN
    pr-error @
;

: PRINT ( <infile> <outfile> <-n> <-t6> -- )
    pr.init 0=
    IF  pr-infile-name $dolines
    THEN
    pr-line-number @ 0= pr-error !
    pr.term
;

cr ." Enter:  PRINT filename" cr
." to print a file to printer" cr
