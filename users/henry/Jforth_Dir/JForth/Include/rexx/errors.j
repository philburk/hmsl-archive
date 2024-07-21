\ AMIGA JForth Include file.
decimal
EXISTS? REXX_ERRORS_H NOT .IF
: REXX_ERRORS_H ;
0   constant ERRC_MSG
ERRC_MSG  1 +  constant ERR10_001
ERRC_MSG  2 +  constant ERR10_002
ERRC_MSG  3 +  constant ERR10_003
ERRC_MSG  4 +  constant ERR10_004
ERRC_MSG  5 +  constant ERR10_005
ERRC_MSG  6 +  constant ERR10_006
ERRC_MSG  7 +  constant ERR10_007
ERRC_MSG  8 +  constant ERR10_008
ERRC_MSG  9 +  constant ERR10_009

ERRC_MSG  10 +  constant ERR10_010
ERRC_MSG  11 +  constant ERR10_011
ERRC_MSG  12 +  constant ERR10_012
ERRC_MSG  13 +  constant ERR10_013
ERRC_MSG  14 +  constant ERR10_014
ERRC_MSG  15 +  constant ERR10_015
ERRC_MSG  16 +  constant ERR10_016
ERRC_MSG  17 +  constant ERR10_017
ERRC_MSG  18 +  constant ERR10_018
ERRC_MSG  19 +  constant ERR10_019

ERRC_MSG  20 +  constant ERR10_020
ERRC_MSG  21 +  constant ERR10_021
ERRC_MSG  22 +  constant ERR10_022
ERRC_MSG  23 +  constant ERR10_023
ERRC_MSG  24 +  constant ERR10_024
ERRC_MSG  25 +  constant ERR10_025
ERRC_MSG  26 +  constant ERR10_026
ERRC_MSG  27 +  constant ERR10_027
ERRC_MSG  28 +  constant ERR10_028
ERRC_MSG  29 +  constant ERR10_029

ERRC_MSG  30 +  constant ERR10_030
ERRC_MSG  31 +  constant ERR10_031
ERRC_MSG  32 +  constant ERR10_032
ERRC_MSG  33 +  constant ERR10_033
ERRC_MSG  34 +  constant ERR10_034
ERRC_MSG  35 +  constant ERR10_035
ERRC_MSG  36 +  constant ERR10_036
ERRC_MSG  37 +  constant ERR10_037
ERRC_MSG  38 +  constant ERR10_038
ERRC_MSG  39 +  constant ERR10_039

ERRC_MSG  40 +  constant ERR10_040
ERRC_MSG  41 +  constant ERR10_041
ERRC_MSG  42 +  constant ERR10_042
ERRC_MSG  43 +  constant ERR10_043
ERRC_MSG  44 +  constant ERR10_044
ERRC_MSG  45 +  constant ERR10_045
ERRC_MSG  46 +  constant ERR10_046
ERRC_MSG  47 +  constant ERR10_047
ERRC_MSG  48 +  constant ERR10_048

0  constant RC_OK
5  constant RC_WARN
10  constant RC_ERROR
20  constant RC_FATAL

.THEN
