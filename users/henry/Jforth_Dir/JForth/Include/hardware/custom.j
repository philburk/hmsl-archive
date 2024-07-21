\ AMIGA JForth Include file.
decimal
EXISTS? HARDWARE_CUSTOM_H NOT .IF
: HARDWARE_CUSTOM_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

\ These two structure definitions added here.
:STRUCT	AudChannel
	APTR ac_ptr
	USHORT ac_len
	USHORT ac_per
	USHORT ac_vol
	USHORT ac_dat
( %?)   2 2 *  BYTES ac_pad
;STRUCT

:STRUCT	SpriteDef
	USHORT  sd_pos
	USHORT sd_ctl
	USHORT sd_dataa
	USHORT sd_datab
;STRUCT

:STRUCT Custom
	USHORT bltddat
	USHORT dmaconr
	USHORT vposr
	USHORT vhposr
	USHORT dskdatr
	USHORT joy0dat
	USHORT joy1dat
	USHORT clxdat
	USHORT adkconr
	USHORT pot0dat
	USHORT pot1dat
	USHORT potinp
	USHORT serdatr
	USHORT dskbytr
	USHORT intenar
	USHORT intreqr
	APTR dskpt
	USHORT dsklen
	USHORT dskdat
	USHORT refptr
	USHORT vposw
	USHORT vhposw
	USHORT copcon
	USHORT serdat
	USHORT serper
	USHORT potgo
	USHORT joytest
	USHORT strequ
	USHORT strvbl
	USHORT strhor
	USHORT strlong
	USHORT bltcon0
	USHORT bltcon1
	USHORT bltafwm
	USHORT bltalwm
	APTR bltcpt
	APTR bltbpt
	APTR bltapt
	APTR bltdpt
	USHORT bltsize
	UBYTE pad2d
	UBYTE bltcon0l
	USHORT bltsizv
	USHORT bltsizh
	USHORT bltcmod
	USHORT bltbmod
	USHORT bltamod
	USHORT bltdmod
	( %?) 4 2 *  BYTES pad34
	USHORT bltcdat
	USHORT bltbdat
	USHORT bltadat
	( %?) 3 2 *  BYTES pad3b
	USHORT deniseid
	USHORT dsksync
	ULONG cop1lc
	ULONG cop2lc
	USHORT copjmp1
	USHORT copjmp2
	USHORT copins
	USHORT diwstrt
	USHORT diwstop
	USHORT ddfstrt
	USHORT ddfstop
	USHORT dmacon
	USHORT clxcon
	USHORT intena
	USHORT intreq
	USHORT adkcon
	struct AudChannel aud[0]
	struct AudChannel aud[1]
	struct AudChannel aud[2]
	struct AudChannel aud[3]
		( %?) 8 4 *  BYTES bplpt
		USHORT bplcon0
		USHORT bplcon1
		USHORT bplcon2
		USHORT bplcon3
		USHORT bpl1mod
		USHORT bpl2mod
		USHORT bplhmod
		( %?) 1 2 *  BYTES pad86
		( %?) 8 2 *  BYTES bpldat
		( %?) 8 4 *  BYTES sprpt
	sizeof() SpriteDef 8 * BYTES spr
		( %?) 32 2 *  BYTES color
		USHORT htotal \ new to AmigaDOS 2.0
		USHORT hsstop
		USHORT hbstrt
		USHORT hbstop
		USHORT vtotal
		USHORT vsstop
		USHORT vbstrt
		USHORT vbstop
		USHORT sprhstrt
		USHORT sprhstop
		USHORT bplhstrt
		USHORT bplhstop
		USHORT hhposw
		USHORT hhposr
		USHORT beamcon0
		USHORT hsstrt
		USHORT vsstrt
		USHORT hcenter
		USHORT diwhigh
;STRUCT

EXISTS? ECS_SPECIFIC .IF

$ 1000   constant VARVBLANK
$ 0800   constant LOLDIS
$ 0400   constant CSCBLANKEN
$ 0200   constant VARVSYNC
$ 0100   constant VARHSYNC
$ 0080   constant VARBEAM
$ 0040   constant DISPLAYDUAL
$ 0020   constant DISPLAYPAL
$ 0010   constant VARCSYNC
$ 0008   constant CSBLANK
$ 0004   constant CSYNCTRUE
$ 0002   constant VSYNCTRUE
$ 0001   constant HSYNCTRUE

1   constant USE_BPLCON3

1  10 <<  constant BPLCON2_ZDCTEN
1  11 <<  constant BPLCON2_ZDBPEN
1  12 <<  constant BPLCON2_ZDBPSEL0
1  13 <<  constant BPLCON2_ZDBPSEL1
1  14 <<  constant BPLCON2_ZDBPSEL2

1  0 <<  constant BPLCON3_EXTBLNKEN
1  1 <<  constant BPLCON3_EXTBLKZD
1  2 <<  constant BPLCON3_ZDCLKEN
1  4 <<  constant BPLCON3_BRDNTRAN
1  5 <<  constant BPLCON3_BRDNBLNK

.THEN

.THEN
