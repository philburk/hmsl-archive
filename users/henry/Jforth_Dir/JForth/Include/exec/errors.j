\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_ERRORS_H NOT .IF
: EXEC_ERRORS_H ;
-1   constant IOERR_OPENFAIL
-2   constant IOERR_ABORTED
-3   constant IOERR_NOCMD
-4   constant IOERR_BADLENGTH
-5   constant IOERR_BADADDRESS
-6   constant IOERR_UNITBUSY
-7   constant IOERR_SELFTEST

.THEN
