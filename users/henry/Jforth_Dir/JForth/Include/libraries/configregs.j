\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_CONFIGREGS_H NOT .IF
: LIBRARIES_CONFIGREGS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT ExpansionRom
	UBYTE er_Type
	UBYTE er_Product
	UBYTE er_Flags
	UBYTE er_Reserved03
	USHORT er_Manufacturer
	ULONG er_SerialNumber
	USHORT er_InitDiagVec
	UBYTE er_Reserved0c
	UBYTE er_Reserved0d
	UBYTE er_Reserved0e
	UBYTE er_Reserved0f
;STRUCT

:STRUCT ExpansionControl
	UBYTE ec_Interrupt
	UBYTE ec_Z3_HighBase
	UBYTE ec_BaseAddress
	UBYTE ec_Shutup
	UBYTE ec_Reserved14
	UBYTE ec_Reserved15
	UBYTE ec_Reserved16
	UBYTE ec_Reserved17
	UBYTE ec_Reserved18
	UBYTE ec_Reserved19
	UBYTE ec_Reserved1a
	UBYTE ec_Reserved1b
	UBYTE ec_Reserved1c
	UBYTE ec_Reserved1d
	UBYTE ec_Reserved1e
	UBYTE ec_Reserved1f
;STRUCT

$ 10000   constant E_SLOTSIZE
$ ffff   constant E_SLOTMASK
16   constant E_SLOTSHIFT

$ 00e80000   constant E_EXPANSIONBASE
$ ff000000   constant EZ3_EXPANSIONBASE

$ 00080000   constant E_EXPANSIONSIZE
8   constant E_EXPANSIONSLOTS

$ 00200000   constant E_MEMORYBASE
$ 00800000   constant E_MEMORYSIZE
128   constant E_MEMORYSLOTS

$ 40000000   constant EZ3_CONFIGAREA
$ 7FFFFFFF   constant EZ3_CONFIGAREAEND
$ 00080000   constant EZ3_SIZEGRANULARITY

$ C0 constant ERT_TYPEMASK ( %M )
6   constant ERT_TYPEBIT
2   constant ERT_TYPESIZE
$ c0   constant ERT_NEWBOARD
ERT_NEWBOARD   constant ERT_ZORROII
$ 80   constant ERT_ZORROIII

5   constant ERTB_MEMLIST
4   constant ERTB_DIAGVALID
3   constant ERTB_CHAINEDCONFIG

1  5 <<  constant ERTF_MEMLIST
1  4 <<  constant ERTF_DIAGVALID
1  3 <<  constant ERTF_CHAINEDCONFIG

$ 07 constant ERT_MEMMASK ( %M )
0   constant ERT_MEMBIT
3   constant ERT_MEMSIZE

1  7 <<  constant ERFF_MEMSPACE
7   constant ERFB_MEMSPACE

1  6 <<  constant ERFF_NOSHUTUP
6   constant ERFB_NOSHUTUP

1  5 <<  constant ERFF_EXTENDED
5   constant ERFB_EXTENDED


1  4 <<  constant ERFF_ZORRO_III
4   constant ERFB_ZORRO_III

$ 0F   constant ERT_Z3_SSMASK
0   constant ERT_Z3_SSBIT
4   constant ERT_Z3_SSSIZE


1   constant ECIB_INTENA
3   constant ECIB_RESET
4   constant ECIB_INT2PEND
5   constant ECIB_INT6PEND
6   constant ECIB_INT7PEND
7   constant ECIB_INTERRUPTING

1  1 <<  constant ECIF_INTENA
1  3 <<  constant ECIF_RESET
1  4 <<  constant ECIF_INT2PEND
1  5 <<  constant ECIF_INT6PEND
1  6 <<  constant ECIF_INT7PEND
1  7 <<  constant ECIF_INTERRUPTING

\ %? #define ERT_MEMNEEDED(t)	\: ERT_MEMNEEDED ;
\ %? 	(((t)&ERT_MEMMASK)? 0x10000 << (((t)&ERT_MEMMASK) -1) : 0x800000 )

\ %? #define ERT_SLOTSNEEDED(t)	\: ERT_SLOTSNEEDED ;
\ %? 	(((t)&ERT_MEMMASK)? 1 << (((t)&ERT_MEMMASK)-1) : 0x80 )

\ %? #define EC_MEMADDR(slot)		((slot) << (E_SLOTSHIFT) ): EC_MEMADDR ;

\ %? #define EROFFSET(er)	((int)&((struct ExpansionRom *)0)->er): EROFFSET ;
\ %? #define ECOFFSET(ec)	\: ECOFFSET ;
\ %?  (sizeof(struct ExpansionRom)+((int)&((struct ExpansionControl *)0)->ec))

:STRUCT DiagArea
	UBYTE da_Config
	UBYTE da_Flags
	USHORT da_Size
	USHORT da_DiagPoint
	USHORT da_BootPoint
	USHORT da_Name
	USHORT da_Reserved01
	USHORT da_Reserved02
;STRUCT

$ C0   constant DAC_BUSWIDTH
$ 00   constant DAC_NIBBLEWIDE
$ 40   constant DAC_BYTEWIDE
$ 80   constant DAC_WORDWIDE

$ 30   constant DAC_BOOTTIME
$ 00   constant DAC_NEVER
$ 10   constant DAC_CONFIGTIME

$ 20   constant DAC_BINDTIME

.THEN
