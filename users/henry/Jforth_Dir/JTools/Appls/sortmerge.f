\ Sort Merge two files into a third.
\
\ This will change when two virtual
\ files can be opened together. %Q
\
\ Author: Phil Burk
\ Copyright 1988 Phil Burk
\ All Rights Reserved.

ANEW TASK-SORTMERGE

200 constant FH_MAX_CHARS
:STRUCT FILEHEAD
  long FH_FILEID
  long FH_FILEBUF
  long FH_LINESTART  ( %Q kludge to allow two virtual files )
  fh_max_chars bytes FH_LINEBUF 
;struct

\ Holders for multiple names since they would conflict
\ if left on the PAD.
\ These are made large so they can also be used
\ as pads for converting strings to uppercase.
VARIABLE FILENAME1 256 allot
VARIABLE FILENAME2 256 allot

filehead INFILEHEAD1
filehead INFILEHEAD2
variable OUTFILEID

: $FH.OPEN.VFILE  ( $name filehead -- if_ok )
    >r
    $fopen dup r@ ..! fh_fileid
    IF r@ .. fh_filebuf openfv drop ( %Q )
      true
    ELSE false
    THEN
    rdrop
;

: FH.CLOSE.VFILE  ( filehead -- )
    dup ..@ fh_fileid dup ( -- fh id id )
    IF fclose
       dup .. fh_filebuf closefvread
       0 swap ..! fh_fileid
    ELSE 2drop
    THEN
;

: FH.READ.LINE ( filehead -- #chars )
    >r
    r@ ..@ fh_fileid
    r@ .. fh_filebuf
    r@ .. fh_linebuf 1+
    fh_max_chars
    r@ ..@ fh_linestart line-start !
    readline  nip ( %Q )
    dup r@ .. fh_linebuf c!
\ ." Read: "    r@ .. fh_linebuf $type cr ?pause
    line-start @ r@ ..! fh_linestart
    rdrop
;

: FH.READ.FULL.LINE ( filehead -- #chars , skip blank lines )
    BEGIN
        dup fh.read.line ?dup
    UNTIL nip
;

: SM.WRITE.LINE ( filehead -- )
    outfileid @ 
    swap .. fh_linebuf \ dup $type cr
    count fwrite drop
    outfileid @ $ 0A femit
;

VARIABLE SM-CASE-SENSITIVE
sm-case-sensitive on

.NEED $CONVERT2UPPER
: $CONVERT2UPPER  ( $string -- , convert in place )
    count 0
    DO i over + c@ dup
       ascii a ascii z within?
       IF  ascii a - ascii A +
           i 2 pick + c!
       ELSE drop
       THEN
    LOOP drop
;
.THEN

: SM.COMPARE.1/2 ( -- true_if_1_bigger )
    infilehead1 .. fh_linebuf
    infilehead2 .. fh_linebuf
    SM-CASE-SENSITIVE @
    IF ( $line1 $line2 )
        filename2 $move
        filename1 $move
        filename1 $convert2upper
        filename2 $convert2upper
        filename1 filename2
    THEN
    $- 0>
;

: SM.LOOP.FILE ( -- file_left )
    BEGIN
        infilehead2 infilehead1
        sm.compare.1/2
        IF swap
        THEN
        dup sm.write.line
        fh.read.full.line 0< not
    WHILE
        drop
    REPEAT  ( filehead with lines left )
;

: SM.COPY.FILE ( filehead -- )
    BEGIN
        dup fh.read.full.line 0< not
    WHILE
        dup sm.write.line
    REPEAT
    drop
;

: SM.PROCESS.FILE ( -- )
    infilehead1 fh.read.full.line 0<
    IF ." FILE1 empty!" cr
    ELSE infilehead2 fh.read.full.line 0<
        IF ." FILE2 empty!" cr
        ELSE sm.loop.file
            sm.copy.file
        THEN
    THEN
;

: $SM.OPEN.FILES ( $infile1 $infile2 $outfile -- if_ok )
    new $fopen dup outfileid !
    IF  infilehead2 $fh.open.vfile
        IF  infilehead1 $fh.open.vfile
            IF true
            ELSE false
            THEN
        ELSE drop false
        THEN
    ELSE 2drop false
    THEN
;

: SM.CLOSE.FILES  ( -- , close files if open )
    infilehead1 fh.close.vfile
    infilehead2 fh.close.vfile
    outfileid @ ?dup
    IF  fclose
        0 outfileid !
    THEN
;

: SM.USAGE  ( -- , print instructions )
    cr ." SortMerge -  Written in JForth by Phil Burk" cr
    cr ." USAGE:   sortmerge infile1 infile2 outfile" cr cr
    ." The contents of infile1 and infile2 will be merged" cr
    ." to outfile in sorted order.  Infile1 and infile2" cr
    ." must be presorted!" cr
;

: $SORTMERGE ( $infile1 $infile2 $outfile -- )
    $SM.open.files
    IF SM.process.file
    ELSE sm.usage
    THEN
    SM.close.files
;

: SORTMERGE ( <infile1> <infile2> <outfile> -- )
    fileword filename1 $move filename1
    fileword filename2 $move filename2
    fileword $sortmerge
;
