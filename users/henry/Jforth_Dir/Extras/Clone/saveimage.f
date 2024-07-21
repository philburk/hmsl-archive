\ save-image <name> <file> [options]
\
\ where: <name> is the word to set as _main
\
\        <file> is the name of the executable file that
\               will be created.
\
\       options ... -s will include a Symbol Table in the executable.
\                   -m will write a Map file (same format as STATS)
\
\ .........  THIS COMMAND PARSES THE ENTIRE INPUT LINE  ...........

only forth definitions

ANEW task-saveimage.f

also TGT definitions


variable +Symbols   +symbols on
variable +Map       +Map off
variable +Icon

: AddSDU  ( InTGTindex -- , Add SYMBOL DATA UNIT )
  >r
  r@ InDictBase stack@   ( -- origpfa )  dup PacketFor ..@ ref_IsPFA
  IF
     pad 32 erase
     ( -- pfa )  >name dup c@ $ 1f and   ( -- nfa cnt )
     swap 1+  over  pad  swap move       ( -- cnt )
     cell /mod swap
     IF
        1+
     THEN
     ( -- #cells )  dup save,  pad swap 0
     DO
        ( -- addr ) dup @ save, cell+
     LOOP
     drop   r@ InTGTBase stack@ save,
  ELSE
     drop
  THEN
  rdrop
;


: AddSymbolTable  ( -- )
  $ 3f0  ( hunk_symbol )  save,
  TargetTables   \ build the 3 tables  (see STATS.F)
  InTGTBase freecell 0
  DO
     i AddSDU
  LOOP
  0 save,
;


: WriteTGTRelocs?  ( -- )
  TargetABSVAR @
  IF   \ ." writing hunk_reloc32..." cr

       hunk_reloc32   save,
       TargetABSBase Freecell  dup save,   ( --  #reloc )
       0 save,    ( hunk# to link with )   0
       DO  
          i TargetABSBASE stack@  ( relocaddr1 -- )  save,
       LOOP
       0 save,    ( no more relocs )
  THEN
;


: WRITE-IMAGE  ( fptr -- )
  tempfile !   save-error off
  \
  \ Alloc a virtual-buffer...
  \
  TempBuff openfv drop
  \
  \ Calc #bytes in image (to nearest cell)...
  \
  TargetImageBase FreeByte  cell /mod swap
  IF
     1+
  THEN   cells
  \
  \ ( -- #bytes )  Write the HUNK_HEADER...
  \
  #relocs @ >r   relocs @ >r      ( -- #codebytes )
  TargetABSVAR @
  IF
     TargetABSBASE freecell
  ELSE
     0
  THEN   #relocs !   TargetABSVAR @ relocs !
  dup  DictionarySize @ cell/ cells +   write_hunk_header
  \
  \ ( -- #bytes )  Write the HUNK_CODE...
  \
  hunk_code save, dup  DictionarySize @ +  cell/ save,
  TargetImageBase  over 0
  DO
     dup @ save,   cell+  cell
  +LOOP
  drop  DictionarySize @ cell/  0
  DO
     0 save,
  LOOP
  \
  \ ( #bytes )
  \
  drop
  \
  \ Write any Symbol Table...
  \
  +Symbols @
  IF
     AddSymbolTable
  THEN
  WriteTGTRelocs?
  \
  \ HUNK_END ...
  \
  hunk_end save,
  \
  \ empty-hunk...
  \
  write_hunk_empty
  save-error @
  IF    ." Error writing file." cr
  ELSE  +Icon @
        IF  MakeIcon
        THEN
  THEN  tempfile @  tempbuff closeFVWrite
  tempfile @  fclose
  r> relocs !   r> #relocs !
;

: writestats  ( -- )
  " .map" count here $append
  skip-word? on  logto  stats  logend
;

: SetOptions  ( -- , parses remainder of line for options )
  [compile] \
  pushtib
  here 1+  tib  here c@    dup tib + 0 swap odd!   dup #tib !    move
  >in off  tibend off
  fblk dup @ >r off
  blk  dup @ >r off
  +Symbols off  +Map off   +Icon off
  BEGIN
     bl word c@
  WHILE
     here " -S" $=
     IF
        +symbols on
     THEN
     here " -M" $=
     IF
        +map on
     THEN
     here " -ICON" $=
     IF
        +icon on
     THEN
  REPEAT
  pulltib
  r> blk !    r> fblk !
;

also Forth Definitions


: Save-Image  ( -- , <name> )  >newline
  \
  \ Is there a target word with that name?
  \
  [compile] '   ( res-pfa )  dup references stackfind   ( -- respfa ix flag )
  IF
     drop  PacketFor dup ..@ ref_resolved   ( -- pkt flag )
     IF
        \
        \ Set _main in the image...
        \
        ..@ ref_TgtAdr  ( -- tgtadr )  ' _main >TargetAdr  Target!   ( -- )
        \
        \ Set the Initial DP...
        \
        TargetHERE  ' DP  >TargetAdr  Target!
        \
        \ Create the file...
        \
        new fopen  -dup
        IF
           SetOptions
           write-image
           +Map @
           IF
             writestats
           THEN
        ELSE
            ." Can't write image file!" quit
        THEN
     ELSE
        here count type ."  is not resolved!"  quit
     THEN
  ELSE
     here count type ."  is not defined in the Target file!"  quit
  THEN
;


only forth definitions
also TGT
