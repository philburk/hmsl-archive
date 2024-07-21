\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_PREFERENCES_H NOT .IF
TRUE   constant INTUITION_PREFERENCES_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? DEVICES_TIMER_H NOT .IF
include ji:devices/timer.j
.THEN

30   constant FILENAME_SIZE

1  16 + 1 + 2 *  constant POINTERSIZE

8   constant TOPAZ_EIGHTY
9   constant TOPAZ_SIXTY

:STRUCT Preferences
	( %M JForth prefix ) BYTE pf_FontHeight
	UBYTE pf_PrinterPort
	USHORT pf_BaudRate
	STRUCT timeval pf_KeyRptSpeed
	STRUCT timeval pf_KeyRptDelay
	STRUCT timeval pf_DoubleClick
	( %?) POINTERSIZE 2 *  BYTES pf_PointerMatrix
	BYTE pf_XOffset
	BYTE pf_YOffset
	USHORT pf_color17
	USHORT pf_color18
	USHORT pf_color19
	USHORT pf_PointerTicks
	USHORT pf_color0
	USHORT pf_color1
	USHORT pf_color2
	USHORT pf_color3
	BYTE pf_ViewXOffset
	BYTE pf_ViewYOffset
	SHORT pf_ViewInitX
	SHORT pf_ViewInitY
	SHORT pf_EnableCLI
	USHORT pf_PrinterType
	( %?) FILENAME_SIZE BYTES pf_PrinterFilename
	USHORT pf_PrintPitch
	USHORT pf_PrintQuality
	USHORT pf_PrintSpacing
	USHORT pf_PrintLeftMargin
	USHORT pf_PrintRightMargin
	USHORT pf_PrintImage
	USHORT pf_PrintAspect
	USHORT pf_PrintShade
	SHORT pf_PrintThreshold
	USHORT pf_PaperSize
	USHORT pf_PaperLength
	USHORT pf_PaperType
	UBYTE pf_SerRWBits

	UBYTE pf_SerStopBuf

	UBYTE pf_SerParShk

	UBYTE pf_LaceWB
	( %?) FILENAME_SIZE BYTES pf_WorkName
	BYTE pf_RowSizeChange
	BYTE pf_ColumnSizeChange
	USHORT pf_PrintFlags
	USHORT pf_PrintMaxWidth
	USHORT pf_PrintMaxHeight
	UBYTE pf_PrintDensity
	UBYTE pf_PrintXOffset
	USHORT pf_wb_Width
	USHORT pf_wb_Height
	UBYTE pf_wb_Depth
	UBYTE pf_ext_size

;STRUCT

1  0 <<  constant LACEWB
1   constant LW_RESERVED

1  14 <<  constant SCREEN_DRAG
1  15 <<  constant MOUSE_ACCEL

$ 00   constant PARALLEL_PRINTER
$ 01   constant SERIAL_PRINTER

$ 00   constant BAUD_110
$ 01   constant BAUD_300
$ 02   constant BAUD_1200
$ 03   constant BAUD_2400
$ 04   constant BAUD_4800
$ 05   constant BAUD_9600
$ 06   constant BAUD_19200
$ 07   constant BAUD_MIDI

$ 00   constant FANFOLD
$ 80   constant SINGLE

$ 000   constant PICA
$ 400   constant ELITE
$ 800   constant FINE

$ 000   constant DRAFT
$ 100   constant LETTER

$ 000   constant SIX_LPI
$ 200   constant EIGHT_LPI

$ 00   constant IMAGE_POSITIVE
$ 01   constant IMAGE_NEGATIVE

$ 00   constant ASPECT_HORIZ
$ 01   constant ASPECT_VERT

$ 00   constant SHADE_BW
$ 01   constant SHADE_GREYSCALE
$ 02   constant SHADE_COLOR

$ 00   constant US_LETTER
$ 10   constant US_LEGAL
$ 20   constant N_TRACTOR
$ 30   constant W_TRACTOR
$ 40   constant CUSTOM

$ 00   constant CUSTOM_NAME
$ 01   constant ALPHA_P_101
$ 02   constant BROTHER_15XL
$ 03   constant CBM_MPS1000
$ 04   constant DIAB_630
$ 05   constant DIAB_ADV_D25
$ 06   constant DIAB_C_150
$ 07   constant EPSON
$ 08   constant EPSON_JX_80
$ 09   constant OKIMATE_20
$ 0A   constant QUME_LP_20
$ 0B   constant HP_LASERJET
$ 0C   constant HP_LASERJET_PLUS

$ 00   constant SBUF_512
$ 01   constant SBUF_1024
$ 02   constant SBUF_2048
$ 03   constant SBUF_4096
$ 04   constant SBUF_8000
$ 05   constant SBUF_16000

$ F0   constant SREAD_BITS
$ 0F   constant SWRITE_BITS

$ F0   constant SSTOP_BITS
$ 0F   constant SBUFSIZE_BITS

$ F0   constant SPARITY_BITS
$ 0F   constant SHSHAKE_BITS

0   constant SPARITY_NONE
1   constant SPARITY_EVEN
2   constant SPARITY_ODD

0   constant SHSHAKE_XON
1   constant SHSHAKE_RTS
2   constant SHSHAKE_NONE

$ 0001   constant CORRECT_RED
$ 0002   constant CORRECT_GREEN
$ 0004   constant CORRECT_BLUE

$ 0008   constant CENTER_IMAGE

$ 0000   constant IGNORE_DIMENSIONS
$ 0010   constant BOUNDED_DIMENSIONS
$ 0020   constant ABSOLUTE_DIMENSIONS
$ 0040   constant PIXEL_DIMENSIONS
$ 0080   constant MULTIPLY_DIMENSIONS

$ 0100   constant INTEGER_SCALING

$ 0000   constant ORDERED_DITHERING
$ 0200   constant HALFTONE_DITHERING
$ 0400   constant FLOYD_DITHERING

$ 0800   constant ANTI_ALIAS
$ 1000   constant GREY_SCALE2

CORRECT_RED  CORRECT_GREEN | CORRECT_BLUE |  constant CORRECT_RGB_MASK
BOUNDED_DIMENSIONS  ABSOLUTE_DIMENSIONS | PIXEL_DIMENSIONS | MULTIPLY_DIMENSIONS |  constant DIMENSIONS_MASK
HALFTONE_DITHERING  FLOYD_DITHERING |  constant DITHERING_MASK

.THEN
