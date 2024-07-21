\ Pronounce a given number in decimal
\
\ Mike Haas, 04-oct-88


include? speak ju:speak

anew task-SayNumber.f


\ ====================  the program  ========================


variable   1Billions
variable 100Millions
variable  10Millions
variable   1Millions
variable 100Thousands
variable  10Thousands
variable   1Thousands
variable 100s
variable  10s
variable   1s
variable Total
variable IsNegative

decimal

variable NString  252 allot

: DivideNumber   ( n1 -- , split into decimal component parts )
  dup 0< IsNegative ! abs
  1,000,000,000 /mod   1Billions  !
      1,000,000 /mod   1Millions  !
          1,000 /mod   1Thousands !
                       1s         !
;

: >NString  ( $adr $cnt -- )
  NString $append
;

: .Teen  ( 9<N<20 -- )
  CASE
     0  OF   " ten"         ENDOF
     1  OF   " elehven"      ENDOF
     2  OF   " twelve"      ENDOF
     3  OF   " thirteen"    ENDOF
     4  OF   " 4teen"       ENDOF
     5  OF   " fifteen"     ENDOF
     6  OF   " 6teen"       ENDOF
     7  OF   " 7teen"       ENDOF
     8  OF   " 8teen"       ENDOF
     9  OF   " 9teen"       ENDOF
  ENDCASE
  count >NString
;

: .Tens  ( 0<N<10 -- )
  CASE
     2  OF   " twentee "      ENDOF
     3  OF   " thirtee "    ENDOF
     4  OF   " 4tee "       ENDOF
     5  OF   " fiftee "     ENDOF
     6  OF   " 6tee "       ENDOF
     7  OF   " 7tee "       ENDOF
     8  OF   " 8tee "       ENDOF
     9  OF   " 9tee "       ENDOF
  ENDCASE
  count >NString
;

: .Triplet  ( 0<=N<=999 -- )
  100 /mod ?dup
  IF
     n>text >NString  "  hundred " count >NString
  THEN
  ?dup
  IF
     10 /mod dup 2 <
     IF
        1 <
        IF
           n>text >NString
        ELSE
           .Teen
        THEN
     ELSE
        .Tens  ?dup
        IF
           n>text >NString
        THEN
     THEN
  THEN
  "  " count >NString
;

   
: SayNum  ( -- , <text> )  intuition?  speak.init
  NString off
  bl word decimal number?
  IF
     drop  dup Total !
     DivideNumber
     IsNegative @
     IF
        " negative "  count >NString
     THEN
     1Billions @ ?dup
     IF
        .triplet " Billion "  count >NString
     THEN
     1Millions @ ?dup
     IF
        .triplet " Million "  count >NString
     THEN
     1Thousands @ ?dup
     IF
        .triplet " Thousand "  count >NString
     THEN
     1s @ ?dup
     IF
        .triplet
     ELSE
        Total @ 0=
        IF
           " zero"  count >NString
        THEN
     THEN
     NString speak
  ELSE
     >newline
     here $type  "  is not a decimal number"  dup $type cr
     here speak  speak
  THEN
  speak.term
;  
