\ (c) 1987 Mike Haas ... 13-may-87 ... UPDATE and UPD
\
\  This JForth program examines the two directories, then copies everything
\  from <srcdir> to <destdir> that meet the specified criteria.
\
\  Usage:
\
\      Update  SourceDir DestDir [-date|-size -list -noask
\                                 -both -all -warn <dd-mm-yy>]
\
\     -date = SourceDir/file is later than DestDir/file (default)
\     -size = SourceDir/file is different size than DestDir/file
\     -list = Don't really copy, just list the files that WOULD.
\     -noask= Don't ask the user to verify input
\     -both = Update only those files that exist in BOTH directories
\     -all  = Update all subdirectories also
\     -off  = Turn off ansi highlighting for directory names" cr
\     -warn = Warn if both files are newer than <date> (don't copy)" cr
\
\
\  This program is a boon to those with mucho ram, even with recoverable
\  ram.  It saves constant copying of files from ram: or vd0: to disk every
\  time you edit something.
\
\  You can edit out of ram in a 'duplicate' of your permanent directory on
\  disk...then, with one command, just copy to that dir JUST WHATS DIFFERENT.
\
\
\  ------------------- SPECIAL NOTES IF USED FROM JFORTH (not CLONEd)
\
\  The first time you use UPDATE for a project, use the normal
\  UPDATE SourceDir DestDir [??]  form.  The pathnames are saved
\  in the dictionary.  Then, as long as you just want to UPDATE
\  to those directories, just type in UPD.
\
\  UPD also uses the options that were specified in the previous
\  UPDATE command.
\
\
\ 00001 27-apr-91 mdh - Added copying of source file datestamp
\                     - changed version stamp
\                     - revised output query format
\ 00002 10-mar-91 mdh - increment version # due to fix in setdate.f  (1.3)
\ ----- 10-sep-91 mdh - added '-all' recursive option (1.3+)
\ 00003 21-sep-91 mdh - added printing of directory  (1.4)
\ 00004 09-dec-91 mdh - fixed problem with cancel  (1.5)
\ 00005 15-jan-92 mdh - added -WARN <date> option  (1.6)

max-inline @   6 max-inline !

exists? getmodule
.if     getmodule includes
.then

.need Enable_Cancel
  cr ." If you want to clone UPDATE, the CLONE program must be"
  cr ." compiled FIRST.  This is not currently the case." cr
  cr ." Do you want to compile CLONE now" y/n cr
  .IF
     include cl:topfile
  .ELSE
     ." NOTE: If you later compile CLONE on top of UPDATE, the CANCEL" cr
     ."       keys (CTRL-C,D,E,F) will not work in CLONEd programs." cr cr
     variable Enable_Cancel
     : CancelKey?  0 ;
  .THEN
.then

include? LIBRARIES_DOS_H ji:libraries/dos.j
include? Lock() ju:dos-support
include? setdate ju:setdate.f   \ 00001
include? dynamicstack ju:stackutils

anew task-Update.f

\ ****************************  the program  *****************************

variable UPD_CANCELED   UPD_CANCELED off   \ 00004

variable SRCFIB   \ pointers to FileInfoBlocks
variable DESTFIB

variable SRCDIR$   40 allot   \ buffers for pathnames
variable DESTDIR$  40 allot

" wp:"   srcdir$ $move
" wp2:" destdir$ $move

variable SRCLOCK  \ storage
variable DESTLOCK
variable PREVLOCK

variable SRCFILE  \ for storing actual file pointers
variable DESTFILE

variable UPDBUFFSIZE    10 1024 * updbuffsize !
variable UPDSizeMode \ qualifies a copy operation on size or date basis
variable UPDListOnly
variable UPDNoAsk
variable UPDExists
variable UPDRecurse
variable DoANSI
variable #Nests
variable UPDWarn

128 Dynamicstack Locks
128 DynamicStack FIBs
 32 DynamicStack DirNames
 
\ create dirname 64 allot
\ variable NameShown


\ ----------------------- Interpret date string ------------------------

decimal
           60    constant TICKSperSEC
           60    constant SECperMIN
SECperMIN  60 *  constant SECperHR
SECperHR   24 *  constant SECperDAY
SECperDAY 365 *  constant SECperYR

variable day
variable month
variable year
variable totalsecs

create WarnString   16 allot

DateStamp WarnDate

: months  0" janfebmaraprmayjunjulaugsepoctnovdec"   ;


12 array numdays

31  0 numdays !     28  1 numdays !     31  2 numdays !
30  3 numdays !     31  4 numdays !     30  5 numdays !
31  6 numdays !     31  7 numdays !     30  8 numdays !
31  9 numdays !     30 10 numdays !     31 11 numdays !


: month>num  ( &3chars -- num , 1-based, 0 means not found )
  months   0   12 0
  DO
     ( -- &3chars months num )   2 pick 3  3 pick 3  match?
     IF
        drop ( the zero )   i 1+   leave
     ELSE
        swap  3 +  swap
     THEN
  LOOP
  nip nip
;


0 .if
: aBCDLeap  ( yr -- flag )
  dup  -4 ashift  10 *
  swap  $ 0f and  3 and
  +     0=
;
.then


: aLeap  ( yr -- flag )  3 and  0=   ;


variable err#

: BadArgs?   ( flag -- )
  IF
     err# @ ?dup
     IF
        >newline ." error " .
     THEN
     >newline ." Error in date string" cr decimal quit
  THEN
;

   
: SetWarnDate  ( -- , <date> )  \ QUITs if invalid format
  day   off
  month off
  year  off
  err#  off
\ 
\ /* Interpret arguments from input stream ... dd-mmm-yy ... */
\
  bl word drop  decimal
\ 
\ /* Get day... */
\ 
  0. here    convert
  ( -- lo hi adr )         dup c@  ascii - -
\ 1 err# !
  ( -- lo hi adr flag )    3 pick  1 <  OR  BadArgs?
  1+ >r  drop  day !
\
\     /* finish err check on day after month & yr is known */
\ 
\ 
\ /* Get month... */
\ 
  ( -- )
\ 2 err# !
  r@ month>num  dup 0=  r@ 3 + c@ ascii - - or  ( -- num flag )  BadArgs?
  month !
\ 
\ /* Get year... */
\ 
  0. r> 3 +   convert
  ( -- lo hi adr )         dup c@ bl -
\ 3  err# !
  ( -- lo hi adr flag )    3 pick 78 <  OR  BadArgs?
  2drop  year !
\ 
\ /* finish err check on 'days' ... */
\
  year @ aLeap   month @ 2 =  AND
  IF
\ 4 err# !
     day @ 29 >  BadArgs?
  ELSE
     day @ ( -4 ashift  10 *   day @ $ 0f and + )
\ 5 err# !
     month @ 1- numdays @  >  BadArgs?
  THEN

\ /* the digits have been loaded in...convert to Amiga 'seconds' */
\
\ /* calc #seconds to Jan 1 of this year... */
  totalsecs off
  year @  78
  DO
     SECperYR totalsecs +!
     i aleap
     IF
        SECperDAY totalsecs +!
     THEN
  LOOP
\ 
\ /* calc additional secs to begin of this month... */
  month @ 1-   0
  DO
     i numdays @  SECperDAY *  totalsecs +!
  LOOP
  month @ 2 >  year @ aLeap  and
  IF
     SECperDAY totalsecs +!
  THEN
\ 
\ /* calc tot secs at midnite ...  */
  day @ 1-  SECperDAY *  totalsecs +!
\ 
\ /* calc total secs at start of this hour... */
\ hour @  SECperHR *  totalsecs +!
\ 
\ /* calc total secs to start of this minute... */
\ min @  SECperMIN *  totalsecs +!
\ 
\ /* add in extra seconds... */
\ sec @  totalsecs +!
\
  totalsecs @  SECperDAY /mod  WarnDate ..! ds_days
  ( -- secs )  SECperMIN /mod  WarnDate ..! ds_Minute
  ( -- secs )  TICKSperSEC *   WarnDate ..! ds_Tick
  here WarnString $move
;


\ ------------------- End of Interpret date string ---------------------



.need CreateDir()
: CreateDir()  ( 0name -- lock , 0=fail )
 >abs call dos_lib CreateDir
;
.then

: ALLOCFIBS  ( -- , allocation insures long-word alignment )
  MEMF_CLEAR  sizeof() FileInfoBlock   2dup
  allocblock?    srcfib !
  allocblock?   destfib !
;


: @FREEFIB  ( var-addr -- )
  dup @ ?dup
  IF   freeblock  ( -- var-addr )  dup off
  THEN drop
;


: FREEFIBS   ( -- , give back both FileInfoBlocks )
  srcfib  @freefib
  destfib @freefib
;


: GETLOCK  ( forth-$addr -- lock OR 0 )
  ACCESS_READ  $Lock()
;


: @UNLOCK  ( var-addr -- , fetch and unlock anything there )
  dup @ ?dup
  IF   UnLock()  ( -- var-addr )   dup off
  THEN drop
;



: CLEANUP  ( -- , get rid of anything & everything )
\
\ restore any previously selected directory...
\
  prevlock dup @ ?dup
  IF    CurrentDir() drop
  THEN  off
\
\ give back everything else...
\
  LocksVAR @
  IF
     Locksbase freecell  0
     DO
        Locksbase pop Unlock()
     LOOP
     LocksVAR Freestack
  THEN
  FIBsVAR @
  IF
     FIBsbase freecell  0
     DO
        FIBsbase pop freeblock
     LOOP
     FIBsVAR Freestack
  THEN
  srclock  @unlock
  destlock @unlock
  freefibs
  DirNamesVAR @
  IF
     DirNamesBase dup freecell 2/ 0
     DO
        cell+ @ freeblock  cell+
     LOOP
     drop  DirNamesVAR freestack
  THEN
  
;



: OPENED?  ( 0name fileptr? -- 0name fileptr )
  ?dup 0=
  IF    cleanup ." Can't open " 0count type quit
  THEN  dup markfclose
;

: UPDYesOrNo  ( -- true = yes )
  ." (Y)es or (N)o? "  key ( dup emit cr \ no good from CLI )
  out off   ?terminal
  IF
     key drop
  ELSE
     dup emit cr
  THEN
  $ 20 or  ascii y =
;

: BuildDirNameAtPad  ( upto# -- )
  pad off
  DirNamesBase dup freecell 2/   ( -- #upto base #names )
  rot 1+ min  0
  DO
     cell+ dup @ count pad $append
     " /" count pad $append
     cell+
  LOOP
  drop
;

: OutPutName  ( addr cnt -- )
  DoANSI @
  IF
     inverse \ italic
  THEN
  type
  DoANSI @
  IF
     plain
  THEN
;

: PrintAllNames  ( -- )
  DirNamesBase dup freecell 2/   ( -- base #names )  0
  DO
     dup @ 0=
     IF
        ( -- &flag )  >newline  i 3 * spaces
        i BuildDirNameAtPad pad count OutputName cr   dup on
     THEN
     [ 2 cells ] literal +
  LOOP
  drop
;

: <COPYIT>  ( -- , srcfib holds name )
  PrintAllNames
\
\ Allocate a buffer for filexfer...
\
  UPDListOnly @ 0=
  IF
     MEMF_CLEAR  updbuffsize @  allocblock ?dup 0=
     IF    cleanup  ." Insufficient memory available" quit
     THEN  dup markfreeblock  >r
  THEN
\
\ Open the SRC file...
\
  #nests @ 3 * spaces
\
  srclock @ CurrentDir() drop
  srcfib @ .. fib_Filename      ( -- 0name )
  UPDListOnly @ 0=
  IF
     dup  0fopen opened?  srcfile !
     \
     \ Open the DEST file...
     \
     destlock @ CurrentDir() drop dup new 0fopen opened? destfile !
     \
     \ Announce...
     \
     ( -- 0name )   ." -- Copying "
  ELSE
     ." -- Would copy "
  THEN
  0count type  cr   ( -- )
  UPDListOnly @ 0=
  IF
     \
     \ Copy...
     \
     1  ( dummy value )
     BEGIN
           dup 0>
           IF   drop   srcfile @ ( fptr )  r@ ( addr )
                dup sizemem  FREAD dup 0>
           ELSE FALSE
           THEN
     WHILE
           destfile @    r@   rot  FWRITE  dup 0<
           IF   ." Error while writing." cr
           THEN
     REPEAT drop
     \
     \ close files, give back memory...
     \
     srcfile  @ dup unmarkfclose  fclose
     destfile @ dup unmarkfclose  fclose
     r> dup unmarkfreeblock  freeblock
     \
     \ clone protection
     \
     destlock @ CurrentDir() drop
     srcfib @ dup .. fib_Filename ( -- srcfib@ &0name )  2dup ( added 00001)
     >abs swap ..@ fib_Protection  call dos_lib SetProtection drop
     \
     \ clone date  00001
     \
     ( MUST be selected to 'destlock, done just above )
     ( -- srcfib@ &0name )  swap .. fib_Date  SetDate drop
     \
  THEN
;


variable Found>

: DateCompare  ( n1 n2 -- flag , set variables & return TRUE if = )
  -  ?dup
  IF
     Found>  swap  0<
     IF
        off
     ELSE
        on
     THEN
     false
  ELSE
     Found> off  true
  THEN
;


: DateStamp>  ( datestamp_struct1 datestamp_struct2 -- flag )
\
\ return non-zero if strct1 is later than struct2
\
  over ..@ ds_Days   over ..@ ds_Days  DateCompare
  IF
     over ..@ ds_Minute   over ..@ ds_Minute  DateCompare
     IF
        over ..@ ds_Tick   over ..@ ds_Tick  DateCompare  drop
     THEN
  THEN
  2drop  Found> @
;

variable NUMCOPIED

: COPYIT?  ( -- , SRCFIB is set to a directory )
  \
  \ Create a default TRUE flag on the ret stack...
  \
  TRUE >r
  \
  \ Does it exist in the DEST dir?
  \
  destlock @ CurrentDir() drop
  srcfib @ .. fib_Filename  ACCESS_WRITE  Lock()  -dup
  IF
     \
     \ Yes, is it not a FILE that meets the criteria? ( -- dest??Lock )
     \
     dup  destfib @  Examine()   ( -- dlock flag )
     swap UnLock()
     IF
        destfib @ ..@ fib_DirEntryType  0<   ( -- flag )
        dup 0= >r   ( true if it is a directory )
        UPDSizeMode @
        IF
           \
           \ Check size too...
           \
           destfib @ ..@ fib_Size  ( -- flag destsize )
           srcfib  @ ..@ fib_Size  =
        ELSE
           \
           \ Check if the date is later...
           \
           srcfib @ .. fib_Date  destfib @ .. fib_Date
           ( -- flag &datesrc &datedest )  DateStamp> 0=
        THEN
        AND  r> OR
        UPDWarn @
        IF
           srcfib  @ .. fib_Date  WarnDate  DateStamp>
           destfib @ .. fib_Date  WarnDate  DateStamp>   and
           IF
              PrintAllNames
              >newline ." WARNING: Both '"
              srcfib @ .. fib_Filename  0count type
              ." ' files are newer than " WarnString $type cr
              drop true
           THEN
        THEN
        \ Don't copy?
        IF
           \
           \ If here, do NOT copy, cancel the default flag...
           \ DEST object is either a dir, or doesn't qualify.
           \
           r> drop  FALSE >r
        THEN
     THEN
  ELSE
     UPDExists @
     IF
        rdrop  false >r
     THEN
  THEN r>
  IF
     <COPYIT>  1 NUMCOPIED +!
  THEN
;

.NEED .COMMAND
: .COMMAND ( -- <name> )
    >in @
    >in off
    bl word $type
    >in !
;
.THEN

: UpdateLocks  ( --, srclock+destlock set & fibs alloc'ed )
\
\ Examine the source directory (init the fib)...
\
  srclock @   srcfib @   Examine()  0=
  IF    cleanup  ." Can't examine SRCDIR!" cr quit
  THEN
\
\ make sure it is a directory...
\
  srcfib @  ..@ fib_DirEntryType 0<
  IF    cleanup  ." SOURCE must be a directory!" cr quit
  THEN
\
\ print informative message 00003
\
  \ allocate an area
  srcfib @ .. fib_Filename  0count  ( adr cnt )
  dup 2+   MEMF_CLEAR  swap allocblock  ?dup 0=
  IF
     >newline ." Insufficient available memory" cr cleanup quit
  THEN
  ( -- text cnt memblk )
  0 DirNames +stack   ( not shown yet )
  dup>r DirNames +stack  r@ off  r@ $append  r> +null
\
\ now process each file in the SRC directory...
\
  BEGIN
     CancelKey?     UPD_CANCELED @  or \ 00004
     IF
        UPD_CANCELED @ 0=   \ 00004
        IF
           >newline .command ."  canceled" cr  UPD_CANCELED on \ 00004
        THEN
        false
     ELSE
        srclock @  srcfib @  ExNext()  ( -- flag )
     THEN
  WHILE
     \
     \ Make sure it is a file and not a dir...
     \
     srcfib @ ..@ fib_DirEntryType 0<  ( neg if a file )
     IF
        copyit?
     ELSE
        \
        \ OK, we've found another dir...save locks, fibs,
        \ set new locks, alloc new fibs, recurse, then restore
        \ upon return
        \
        UPDRecurse @
        IF
           \ does the dir exist in the destdir?
           srcfib  dup @ dup>r FIBs +stack off
           destfib dup @ dup>r FIBs +stack off    AllocFIBs
           srclock @ >r
           destlock @ dup>r   CurrentDir() drop
           ( -r- SFIB DFIB SLK0 DLK0 )
           3 rpick ( SFIB ) .. fib_Filename  ACCESS_READ  Lock() ?dup 0=
           IF
              UPDExists @
              IF
                 0
              ELSE
                 UPDListOnly @
                 IF
                    PrintAllNames  >newline
                    #nests @ 1+ 3 * spaces  \ ." DIRECTORY "
                    #nests @ BuildDirNameAtPad
                    3 rpick ( SFIB ) .. fib_Filename 0count pad $append
                    " /" count pad $append  pad count OutputName
                    ."  would be created & duplicated" cr  0
                 ELSE
                    \ create the dir, return the lock
                    3 rpick ( SFIB ) .. fib_Filename CreateDir() dup 0=
                    IF
                       >newline ." Can't create subdirectory" cr
                    ELSE
                       Unlock()
                       3 rpick .. fib_Filename  ACCESS_READ  Lock()
                    THEN
                 THEN
              THEN
           THEN
           ?dup IF
              \ it exists, is it a dir?
              destlock @ Locks +stack
              dup destlock !   destfib @  Examine()   ( -- flag )
              IF
                 destfib @ ..@ fib_DirEntryType 0<  ( neg if file )
                 IF
                    >newline ." Source is directory, Destination is file: "
                    destfib @ .. fib_Filename 0count type  cr
                 ELSE
                    \
                    \ the directory exists, lock srcdir
                    srclock @ CurrentDir() drop
                    3 rpick .. fib_Filename  ACCESS_READ  Lock() ?dup
                    IF
                       dup CurrentDir() drop
                       srclock @ Locks +stack
                       srclock !   1 #nests +!
                       recurse    -1 #nests +!
                       1 rpick  CurrentDir() drop
                       srclock @ Unlock()
                       Locksbase pop drop
                    THEN
                 THEN
              THEN
              destlock @ Unlock()
              Locksbase pop drop
           THEN
           r> destlock !
           r> srclock !
           FreeFIBs  r> destfib !  r> srcfib !
           FIBsbase pop drop  FIBsbase pop drop
        THEN
     THEN
  REPEAT
  DirNamesBase pop freeblock   DirNamesBase pop drop
;

: UPD  ( -- , SRCDIR and DESTDIR should point to two directory PATHnames )
  NUMCOPIED off  UPD_CANCELED off \ 00004
  allocfibs
\
\ Get locks on both directories...
\
  srcdir$  getlock  ?dup
  IF    srclock !
  ELSE  cleanup  ." Can't find source directory" cr quit
  THEN
  destdir$ getlock  ?dup 0=
  IF
     destdir$ $type ."  doesn't exist."  UPDListOnly @
     IF
        cr cleanup quit
     ELSE
        ."  Create it? " UPDYesOrNo 0=
        IF
           cleanup quit
        THEN
        destdir$ count >dos  dos0 CreateDir() ?dup 0=
        IF
           ." Error creating " destdir$ $type cr cleanup quit
        THEN
        Unlock()  dos0  ACCESS_READ  Lock()
     THEN
  THEN
  destlock !
\
\ Set one-of-em as CURRENT directory (just to get the 'prevlock')...
\
  srclock @  CurrentDir()  prevlock !
  \
  UpdateLocks
  \
  NumCopied @ dup 0=
  IF
     ." No "
  ELSE
     dup .
  THEN
  ." file"  1-
  IF
     ascii s emit
  THEN
  UPDListOnly @
  IF
     ."  would be"
  THEN
  ."  copied." cr
\
\ that's all folks...
\
  cleanup
;

variable numspaces

: .spaces   numspaces @ spaces ;

: .HELP ( -- )
    cr
    ." Usage: " .command     out @ 16 + numspaces !
    ."  FromDir ToDir [-date|-size -list -noask -both"  cr
          .spaces   ." -all -off -warn <dd-mmm-yy>]"  cr cr
\
    ."  -date = Copy if FromDir/file is NEWER than ToDir/file (DEFAULT)" cr
    ."  -size = Copy if FromDir/file is DIFFERENT SIZE than ToDir/file" cr
    ."  -list = Do NOT COPY, just LIST files that would be copied" cr
    ."  -noask= Do NOT PROMPT for user verification" cr
    ."  -both = Update only which already exists in BOTH directories" cr
    ."  -all  = Update all subdirectories and their contents" cr
    ."  -off  = Turn off ansi highlighting for directory names" cr
    ."  -warn = Warn if both files are newer than <date> (don't copy)" cr
    ."          for example:   -warn 4-jul-91"   cr cr
\
    ."  CTRL-C, D, E or F will abort the program" cr
    ."  Any portion of an option qualifies it  (examples: -n -bo)" cr
;

: UPDhelp?  here c@ 0=  here 1+ c@ ascii - =  OR
  IF
    .help  quit
  THEN
;

: IsIT?  ( string -- flag )
  >r   here count   r> 1+ text=?
;

variable DateSpecked

: DateSizeErr  ( -- )
  >newline  ." ERROR: -DATE and -SIZE are mutually exclusive..." cr
  ."        Only one may be specified (default is -DATE)" cr  quit
;

: SetUPDMode  ( -- , parses remainder of line for options )
  UPDSizeMode off   \ default: -DATE mode
  UPDListOnly off   \ default: copy the files
  UPDNoAsk    off   \ default: let user verify
  UPDExists   off   \ default: copy all files
  UPDRecurse  off   \ default: stay at this level
  DoANSI      on    \ default: display highlight for dirnames
  UPDWarn     off
  #nests off
  BEGIN
     bl word c@
  WHILE
     " -SIZE"  IsIt?
     IF
        DateSpecked @  IF  DateSizeErr  THEN
        UPDSizeMode on
     ELSE
        " -DATE"  IsIt?
        IF
           DateSpecked on  UPDSizeMode @  IF  DateSizeErr  THEN
           UPDSizeMode off
        ELSE
           " -LIST"  IsIt?
           IF
              UPDListOnly on
           ELSE
              " -NOASK"  IsIt?
              IF
                 UPDNoAsk on
              ELSE
                 " -BOTH"  IsIt?
                 IF
                    UPDExists  on
                 ELSE
                    " -ALL" IsIt?
                    IF
                       UPDRecurse on
                    ELSE
                       " -OFF" IsIt?
                       IF
                          DoANSI off
                       ELSE
                          " -WARN" IsIt?
                          IF
                             SetWarnDate  UPDWarn on
                          ELSE
                             .help quit
                          THEN
                       THEN
                    THEN
                 THEN
              THEN
           THEN
        THEN
     THEN
  REPEAT
;

: .pathname  ( $name -- )
  ascii " emit  $type  ascii " emit
;

.NEED .COMMAND
: .COMMAND ( -- <name> )
    >in @
    >in off
    bl word $type
    >in !
;
.THEN

: UPDATE  ( <srcdir> <destdir> )
  >newline .command ."  V1.6 by Mike Haas  (written in JForth)"
  out @ dup>r cr  0 do  ascii = emit loop cr  \ 00001 00002
  fileword  UPDHelp?  dup c@ 1+  40 max   srcdir$  swap  move
  fileword  UPDHelp?  dup c@ 1+  40 max  destdir$  swap  move
  ' cleanup is errorcleanup   \ for cloned images
  SetUPDMode
  UPDNoAsk @ 0=
  IF
     \ 00001, revised messages
     \
     UPDListOnly @
     IF
        ." List files that would be copied"
     ELSE
        ." Copy files"
     THEN
     cr cr
     ."     FROM:   "  srcdir$ .pathname cr
     ."       TO:   " destdir$ .pathname cr cr
     ." IF "   UPDExists @
     IF
        ." they exist in both places AND "  cr  \ cr ." places AND "
     THEN
     UPDSizeMode @
     IF
        ." they are different in size?"
     ELSE
        ." the file in the FROM: directory is newer?"
     THEN
     cr
     UPDRecurse @
     IF
        ." (Including All Subdirectories)" cr
     THEN
     UPDYesOrNo
     IF
        r@ 0 do  ascii = emit loop cr
        UPD
     THEN
     begin ?terminal
     while key drop
     repeat
  ELSE
     UPD
  THEN
  >newline  rdrop
;


max-inline !
