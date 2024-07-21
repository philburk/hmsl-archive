\ Log.f

anew task-Log.f

variable Log?

: logname  ( -- $name )
  " work:log"
;

: $Log  ( $adr -- )
  \
  \ open the log file, create if necessary...
  \
  logname $fopen dup 0=  IF
     ( -- $ 0 )  drop 
     logname new $fopen
  THEN
  \
  \ append string to file, follow with EOL...
  \
  ( -- $ file/0 )  ?dup IF
     >r
     r@ 0 OFFSET_END fseek  -1 -  ( -- $ non-zero-if-OK )
     IF
        dup count   r@ -rot  fwrite drop
        r@ eol femit
     THEN
     r> fclose
  THEN
  drop
;

: Log"  ( -- )
  compiling? 
  IF    [compile] $"  compile $Log
  ELSE  ASCII " lword $Log
  THEN
; immediate
