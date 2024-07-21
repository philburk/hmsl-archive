
anew task-datatypes



: AVariable? ( cfa ? -- cfa ?' , if 0, check type & leave datasize if is )
  dup 0=
  IF
     over cell- @ $ f,0000 and  VARIABLE_ID =
     IF
        drop cell
     THEN
  THEN
\   DUP 0=
\   IF
\      OVER CELL-  [ ' CLICOMMAND CELL- ] LITERAL   ( -- CFA 0 SFA CLISFA )
\      8 COMPARE 0=  ( -- CFA 0 FLAG )
\      IF
\         OVER CELL+ @ >R
\         OVER  [ CLICOMMAND  ' CLICOMMAND - ] LITERAL +  R> =
\         IF
\            DROP CELL
\         THEN
\      THEN
\   THEN
;


: AUser?   ( cfa ? -- cfa ?' , if 0, check type & leave datasize if is )
  dup 0=
  IF
     over cell- @ $ f,0000 and  USER_ID =
     IF
        drop cell
     THEN
  THEN
\   dup 0=
\   IF
\      over IsUser?
\      IF
\         drop cell
\      THEN
\   THEN
;


: ADefUser?   ( cfa ? -- cfa ?' , if 0, check type & leave datasize if is )
  dup 0=
  IF
     over cell- @ $ f,0000 and  USERDEF_ID =
     IF
        drop cell
     THEN
  THEN
\   IF
\      over IsDefUser?
\      IF
\         drop cell
\      THEN
\   THEN
;
