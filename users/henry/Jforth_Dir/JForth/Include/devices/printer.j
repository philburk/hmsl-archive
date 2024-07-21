\ AMIGA JForth Include file.
decimal
EXISTS?     DEVICES_PRINTER_H NOT .IF
: DEVICES_PRINTER_H ;
EXISTS?  EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS?  EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS?  EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS?  EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

include? CMD_NONSTD ji:exec/io.j ( %M)

CMD_NONSTD  0 +  constant PRD_RAWWRITE
CMD_NONSTD  1 +  constant PRD_PRTCOMMAND
CMD_NONSTD  2 +  constant PRD_DUMPRPORT
CMD_NONSTD  3 +  constant PRD_QUERY

0   constant aRIS
1   constant aRIN
2   constant aIND
3   constant aNEL
4   constant aRI

5   constant aSGR0
6   constant aSGR3
7   constant aSGR23
8   constant aSGR4
9   constant aSGR24
10   constant aSGR1
11   constant aSGR22
12   constant aSFC
13   constant aSBC

14   constant aSHORP0
15   constant aSHORP2
16   constant aSHORP1
17   constant aSHORP4
18   constant aSHORP3
19   constant aSHORP6
20   constant aSHORP5

21   constant aDEN6
22   constant aDEN5
23   constant aDEN4
24   constant aDEN3
25   constant aDEN2
26   constant aDEN1

27   constant aSUS2
28   constant aSUS1
29   constant aSUS4
30   constant aSUS3
31   constant aSUS0
32   constant aPLU
33   constant aPLD

34   constant aFNT0
35   constant aFNT1
36   constant aFNT2
37   constant aFNT3
38   constant aFNT4
39   constant aFNT5
40   constant aFNT6
41   constant aFNT7
42   constant aFNT8
43   constant aFNT9
44   constant aFNT10

45   constant aPROP2
46   constant aPROP1
47   constant aPROP0
48   constant aTSS
49   constant aJFY5
50   constant aJFY7
51   constant aJFY6
52   constant aJFY0
53   constant aJFY3
54   constant aJFY1

55   constant aVERP0
56   constant aVERP1
57   constant aSLPP
58   constant aPERF
59   constant aPERF0

60   constant aLMS
61   constant aRMS
62   constant aTMS
63   constant aBMS
64   constant aSTBM
65   constant aSLRM
66   constant aCAM

67   constant aHTS
68   constant aVTS
69   constant aTBC0
70   constant aTBC3
71   constant aTBC1
72   constant aTBC4
73   constant aTBCALL
74   constant aTBSALL
75   constant aEXTEND

76   constant aRAW

:STRUCT IOPrtCmdReq
	( %M JForth prefix ) STRUCT Message prt_io_Message
	APTR prt_io_Device
	APTR prt_io_Unit
	USHORT prt_io_Command
	UBYTE prt_io_Flags
	BYTE prt_io_Error
	USHORT prt_io_PrtCommand
	UBYTE prt_io_Parm0
	UBYTE prt_io_Parm1
	UBYTE prt_io_Parm2
	UBYTE prt_io_Parm3
;STRUCT

:STRUCT IODRPReq
	( %M JForth prefix ) STRUCT Message drp_io_Message
	APTR drp_io_Device
	APTR drp_io_Unit
	USHORT drp_io_Command
	UBYTE drp_io_Flags
	BYTE drp_io_Error
	APTR drp_io_RastPort
	APTR drp_io_ColorMap
	ULONG drp_io_Modes
	USHORT drp_io_SrcX
	USHORT drp_io_SrcY
	USHORT drp_io_SrcWidth
	USHORT drp_io_SrcHeight
	LONG drp_io_DestCols
	LONG drp_io_DestRows
	USHORT drp_io_Special
;STRUCT

$ 0001   constant SPECIAL_MILCOLS
$ 0002   constant SPECIAL_MILROWS
$ 0004   constant SPECIAL_FULLCOLS
$ 0008   constant SPECIAL_FULLROWS
$ 0010   constant SPECIAL_FRACCOLS
$ 0020   constant SPECIAL_FRACROWS
$ 0040   constant SPECIAL_CENTER
$ 0080   constant SPECIAL_ASPECT
$ 0100   constant SPECIAL_DENSITY1
$ 0200   constant SPECIAL_DENSITY2
$ 0300   constant SPECIAL_DENSITY3
$ 0400   constant SPECIAL_DENSITY4
$ 0500   constant SPECIAL_DENSITY5
$ 0600   constant SPECIAL_DENSITY6
$ 0700   constant SPECIAL_DENSITY7
$ 0800   constant SPECIAL_NOFORMFEED
$ 1000   constant SPECIAL_TRUSTME
$ 2000   constant SPECIAL_NOPRINT

0   constant PDERR_NOERR
1   constant PDERR_CANCEL
2   constant PDERR_NOTGRAPHICS
3   constant PDERR_INVERTHAM
4   constant PDERR_BADDIMENSION
5   constant PDERR_DIMENSIONOVFLOW
6   constant PDERR_INTERNALMEMORY
7   constant PDERR_BUFFERMEMORY
8   constant PDERR_TOOKCONTROL

$ 0700   constant SPECIAL_DENSITYMASK
\ %? #define SPECIAL_DIMENSIONSMASK \
\ %? 	(SPECIAL_MILCOLS|SPECIAL_MILROWS|SPECIAL_FULLCOLS|SPECIAL_FULLROWS\
\ %? 	|SPECIAL_FRACCOLS|SPECIAL_FRACROWS|SPECIAL_ASPECT)
.THEN
