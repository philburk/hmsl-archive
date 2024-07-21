\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? GRAPHICS_COPPER_H NOT .IF
: GRAPHICS_COPPER_H ;
0   constant COPPER_MOVE
1   constant COPPER_WAIT
2   constant CPRNXTBUF
$ 8000   constant CPR_NT_LOF
$ 4000   constant CPR_NT_SHT
$ 2000   constant CPR_NT_SYS

:STRUCT CopIns
	SHORT ci_OpCode
	UNION{
		APTR ci_nxtlist
	}UNION{
		UNION{
			SHORT ci_VWaitPos
			SHORT ci_HWaitPos
		}UNION{
			SHORT ci_DestAddr
		SHORT ci_DestData
		}UNION
	}UNION
;STRUCT
\ You can reference any of these members like normal, ie.
\    COPINS MYCOPINS
\       20 MYCOPINS ..! CI_VWAITPOS


:STRUCT cprlist
	APTR crl_Next
	APTR crl_start
	SHORT crl_MaxCount
;STRUCT


:STRUCT CopList
	APTR cl_Next
	APTR cl__CopList
	APTR cl__ViewPort
	APTR cl_CopIns
	APTR cl_CopPtr
	APTR cl_CopLStart
	APTR cl_CopSStart
	SHORT cl_Count
	SHORT cl_MaxCount
	SHORT cl_DyOffset
;STRUCT


:STRUCT UCopList
	APTR ucl_Next
	APTR ucl_FirstCopList
	APTR ucl_CopList
;STRUCT


:STRUCT copinit
( %?)   4 2 *  BYTES copinit_diagstrt
2 8 * 2 *   2 +  2 2 * + 2 +   2 * BYTES copinit_sprstrtup
( %?)   2 2 *  BYTES copinit_sprstop
;STRUCT

.THEN
