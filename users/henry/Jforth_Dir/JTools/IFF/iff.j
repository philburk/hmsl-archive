\ Includes for IFF support.
\ There are other types of IFF structure not defined here.

: CHKID ( <chkid> <name> -- , define chkid )
	"      " here $move
	32 word count drop odd@ constant
;

chkid FORM 'FORM'
chkid LIST 'LIST'
chkid CAT  'CAT'
chkid PROP 'PROP'

chkid ILBM 'ILBM'
chkid BMHD 'BMHD'
chkid CMAP 'CMAP'
chkid CRNG 'CRNG'
chkid BODY 'BODY'
chkid GRAB 'GRAB'
chkid TRAK 'TRAK'
chkid SMUS 'SMUS'
chkid CAMG 'CAMG'
chkid INS1 'INS1'
chkid SHDR 'SHDR'
chkid 8SVX '8SVX'
chkid VHDR 'VHDR'
chkid ATAK 'ATAK'
chkid NAME 'NAME'
chkid AUTH 'AUTH'
chkid (C)  '(C)'

\ Used in 8SVX files
:STRUCT Voice8Header
    ULONG v8h_OneShotHiSamples
    ULONG v8h_RepeatHiSamples
    ULONG v8h_SamplesPerHiCycle
    USHORT v8h_SamplesPerSec
    UBYTE v8h_ctOctave
    UBYTE v8h_sCompression
    LONG  v8h_volume
;STRUCT

\ Structure used by IFF ILBM
:STRUCT BitMapHeader
	ushort bmh_w
	ushort bmh_h
	short  bmh_x
	short  bmh_y
	ubyte  bmh_nPlanes
	ubyte  bmh_masking
	ubyte  bmh_compression
	ubyte  bmh_pad1
	ushort bmh_transparentColor
	ubyte  bmh_xAspect
	ubyte  bmh_yAspect
	short  bmh_pagewidth
	short  bmh_pageheight
;STRUCT

0 constant cmpNone
1 constant cmpByteRun1

