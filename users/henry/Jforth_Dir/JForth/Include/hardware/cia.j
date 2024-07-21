\ AMIGA JForth Include file.
decimal
EXISTS? HARDWARE_CIA_H NOT .IF
: HARDWARE_CIA_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT CIA
	UBYTE ciapra
	( %M) $ FF BYTES pad0
	UBYTE ciaprb
	( %M) $ FF BYTES pad1
	UBYTE ciaddra
	( %M) $ FF BYTES pad2
	UBYTE ciaddrb
	( %M) $ FF BYTES pad3
	UBYTE ciatalo
	( %M) $ FF BYTES pad4
	UBYTE ciatahi
	( %M) $ FF BYTES pad5
	UBYTE ciatblo
	( %M) $ FF BYTES pad6
	UBYTE ciatbhi
	( %M) $ FF BYTES pad7
	UBYTE ciatodlow
	( %M) $ FF BYTES pad8
	UBYTE ciatodmid
	( %M) $ FF BYTES pad9
	UBYTE ciatodhi
	( %M) $ FF BYTES pad10
	UBYTE unusedreg
	( %M) $ FF BYTES pad11
	UBYTE ciasdr
	( %M) $ FF BYTES pad12
	UBYTE ciaicr
	( %M) $ FF BYTES pad13
	UBYTE ciacra
	( %M) $ FF BYTES pad14
	UBYTE ciacrb
;STRUCT

0   constant CIAICRB_TA
1   constant CIAICRB_TB
2   constant CIAICRB_ALRM
3   constant CIAICRB_SP
4   constant CIAICRB_FLG
7   constant CIAICRB_IR
7   constant CIAICRB_SETCLR

0   constant CIACRAB_START
1   constant CIACRAB_PBON
2   constant CIACRAB_OUTMODE
3   constant CIACRAB_RUNMODE
4   constant CIACRAB_LOAD
5   constant CIACRAB_INMODE
6   constant CIACRAB_SPMODE
7   constant CIACRAB_TODIN

0   constant CIACRBB_START
1   constant CIACRBB_PBON
2   constant CIACRBB_OUTMODE
3   constant CIACRBB_RUNMODE
4   constant CIACRBB_LOAD
5   constant CIACRBB_INMODE0
6   constant CIACRBB_INMODE1
7   constant CIACRBB_ALARM

1  CIAICRB_TA <<  constant CIAICRF_TA
1  CIAICRB_TB <<  constant CIAICRF_TB
1  CIAICRB_ALRM <<  constant CIAICRF_ALRM
1  CIAICRB_SP <<  constant CIAICRF_SP
1  CIAICRB_FLG <<  constant CIAICRF_FLG
1  CIAICRB_IR <<  constant CIAICRF_IR
1  CIAICRB_SETCLR <<  constant CIAICRF_SETCLR

1  CIACRAB_START <<  constant CIACRAF_START
1  CIACRAB_PBON <<  constant CIACRAF_PBON
1  CIACRAB_OUTMODE <<  constant CIACRAF_OUTMODE
1  CIACRAB_RUNMODE <<  constant CIACRAF_RUNMODE
1  CIACRAB_LOAD <<  constant CIACRAF_LOAD
1  CIACRAB_INMODE <<  constant CIACRAF_INMODE
1  CIACRAB_SPMODE <<  constant CIACRAF_SPMODE
1  CIACRAB_TODIN <<  constant CIACRAF_TODIN

1  CIACRBB_START <<  constant CIACRBF_START
1  CIACRBB_PBON <<  constant CIACRBF_PBON
1  CIACRBB_OUTMODE <<  constant CIACRBF_OUTMODE
1  CIACRBB_RUNMODE <<  constant CIACRBF_RUNMODE
1  CIACRBB_LOAD <<  constant CIACRBF_LOAD
1  CIACRBB_INMODE0 <<  constant CIACRBF_INMODE0
1  CIACRBB_INMODE1 <<  constant CIACRBF_INMODE1
1  CIACRBB_ALARM <<  constant CIACRBF_ALARM

0   constant CIACRBF_IN_PHI2
CIACRBF_INMODE0   constant CIACRBF_IN_CNT
CIACRBF_INMODE1   constant CIACRBF_IN_TA
CIACRBF_INMODE0  CIACRBF_INMODE1 |  constant CIACRBF_IN_CNT_TA

7   constant CIAB_GAMEPORT1
6   constant CIAB_GAMEPORT0
5   constant CIAB_DSKRDY
4   constant CIAB_DSKTRACK0
3   constant CIAB_DSKPROT
2   constant CIAB_DSKCHANGE
1   constant CIAB_LED
0   constant CIAB_OVERLAY

7   constant CIAB_COMDTR
6   constant CIAB_COMRTS
5   constant CIAB_COMCD
4   constant CIAB_COMCTS
3   constant CIAB_COMDSR
2   constant CIAB_PRTRSEL
1   constant CIAB_PRTRPOUT
0   constant CIAB_PRTRBUSY

7   constant CIAB_DSKMOTOR
6   constant CIAB_DSKSEL3
5   constant CIAB_DSKSEL2
4   constant CIAB_DSKSEL1
3   constant CIAB_DSKSEL0
2   constant CIAB_DSKSIDE
1   constant CIAB_DSKDIREC
0   constant CIAB_DSKSTEP

1  7 <<  constant CIAF_GAMEPORT1
1  6 <<  constant CIAF_GAMEPORT0
1  5 <<  constant CIAF_DSKRDY
1  4 <<  constant CIAF_DSKTRACK0
1  3 <<  constant CIAF_DSKPROT
1  2 <<  constant CIAF_DSKCHANGE
1  1 <<  constant CIAF_LED
1  0 <<  constant CIAF_OVERLAY

1  7 <<  constant CIAF_COMDTR
1  6 <<  constant CIAF_COMRTS
1  5 <<  constant CIAF_COMCD
1  4 <<  constant CIAF_COMCTS
1  3 <<  constant CIAF_COMDSR
1  2 <<  constant CIAF_PRTRSEL
1  1 <<  constant CIAF_PRTRPOUT
1  0 <<  constant CIAF_PRTRBUSY

1  7 <<  constant CIAF_DSKMOTOR
1  6 <<  constant CIAF_DSKSEL3
1  5 <<  constant CIAF_DSKSEL2
1  4 <<  constant CIAF_DSKSEL1
1  3 <<  constant CIAF_DSKSEL0
1  2 <<  constant CIAF_DSKSIDE
1  1 <<  constant CIAF_DSKDIREC
1  0 <<  constant CIAF_DSKSTEP

.THEN
