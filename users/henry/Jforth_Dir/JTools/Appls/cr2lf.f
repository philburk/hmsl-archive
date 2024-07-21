\ Convert CR characters in input file to LF chars in output file.
\
\ This is useful for converting Macintosh text files
\ downloaded from bulletin boards.
\
\ Author: Phil Burk
\ Copyright 1988 Phil Burk
decimal
ANEW TASK-CR2LF

VARIABLE IN-FILEID
VARIABLE OUT-FILEID

64 constant C2L_MAX_CHARS
VARIABLE CHAR-BUFFER C2L_MAX_CHARS ALLOT
VARIABLE C2L-COUNT-CHARS
VARIABLE C2L-COUNT-CR

10 constant LF_CHAR
13 constant CR_CHAR

: C2L.HELP  ( -- , print documentation )
    cr ." Syntax:   CR2LF  infile outfile" cr cr
    ." For example, to convert all carriage returns in" cr
    ." a file called 'MacText' to line feeds and save the" cr
    ." result in a file call 'AmigaText', enter:" cr cr
    ."     CR2LF MacText AmigaText" cr
    cr
;

: C2L.OPEN.FILES ( <infile> <outfile> -- error_flag )
    fopen dup in-fileid !
    IF  new fopen  dup out-fileid !
        IF false
        ELSE in-fileid @ fclose
            cr ." Couldn't open OUTPUT file!" cr
            true
        THEN
    ELSE cr ." Couldn't open INPUT file!" cr true
    THEN
;

: C2L.CLOSE.FILES ( -- )
    in-fileid @ fclose
    out-fileid @ fclose
;

: C2L.CONVERT.TEXT ( addr count -- , convert text string CR>LF )
    0 DO
        i over + c@ cr_char =
        IF i over +  lf_char swap c!
            1 c2l-count-cr +!
        THEN
    LOOP drop
;

: C2L.PROCESS.FILE  ( -- , convert entire file )
    0 c2l-count-chars !
    0 c2l-count-cr !
    BEGIN
        in-fileid @ char-buffer c2l_max_chars fread
        dup 0>
        ?terminal not AND
    WHILE
        dup c2l-count-chars +!
        dup char-buffer swap c2l.convert.text
        >r out-fileid @ char-buffer r> fwrite
        0= abort" File write failed!"
    REPEAT drop
    c2l-count-cr @ . ."  CRs converted to LF, "
    c2l-count-chars @ . ."  characters in file." cr
;

: CR2LF  ( <infile> <outfile> -- )
    cr ." CR2LF - Convert CR to LF in files." cr
    ." Written by Phil Burk using JForth V1.3 from" cr
    ." Delta Research, P.O. Box 1051, San Rafael, CA 94901" cr
    ." Hit <CR> to abort." cr
    c2l.open.files 0=
    IF  c2l.process.file
        c2l.close.files
    ELSE c2l.help
    THEN

;
