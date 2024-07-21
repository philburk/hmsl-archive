\ Display an Alert from the CLI
\ This can be used to control the flow of a command file.
\
\ Author: Phil Burk
\ Copyright 1988 Delta Research

include? ezalert ju:ezalert

ANEW TASK-RUDE.F

decimal
\ This word can be cloned to create a handy but rude
\ version of ASK.  Use with IF WARN to control command-files.
: RUDE  ( <quoted_string> -- , set return code for CLI)
    fileword dup c@ 0=
    IF ." RUDE was written in JForth V2.0 by Phil Burk" cr
       ." USAGE:  RUDE "
       ascii " emit
       ." string" ascii " emit cr
       ." RUDE will set the return code to 0 or 5 like ASK" cr
       drop 0
    ELSE
       ezalert
    THEN
    5 * retcode !
;

