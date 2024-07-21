\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_GELS_H NOT .IF
: GRAPHICS_GELS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

\ 00001 10/25/91 Added prefixes to ?UserExt. Thanks Nick Didkovsky.

$ 00FF   constant SUSERFLAGS
$ 0001   constant VSPRITE
$ 0002   constant SAVEBACK
$ 0004   constant OVERLAY
$ 0008   constant MUSTDRAW
$ 0100   constant BACKSAVED
$ 0200   constant BOBUPDATE
$ 0400   constant GELGONE
$ 0800   constant VSOVERFLOW

$ 00FF   constant BUSERFLAGS
$ 0001   constant SAVEBOB
$ 0002   constant BOBISCOMP
$ 0100   constant BWAITING
$ 0200   constant BDRAWN
$ 0400   constant BOBSAWAY
$ 0800   constant BOBNIX
$ 1000   constant SAVEPRESERVE
$ 2000   constant OUTSTEP

6   constant ANFRACSIZE
$ 0020   constant ANIMHALF
$ 0001   constant RINGTRIGGER

:STRUCT VSprite
	( %M JForth prefix ) APTR vs_NextVSprite
	APTR vs_PrevVSprite
	APTR vs_DrawPath
	APTR vs_ClearPath
	SHORT vs_OldY
	SHORT vs_OldX
	SHORT vs_Flags
	SHORT vs_Y
	SHORT vs_X
	SHORT vs_Height
	SHORT vs_Width
	SHORT vs_Depth
	SHORT vs_MeMask
	SHORT vs_HitMask
	APTR vs_ImageData
	APTR vs_BorderLine
	APTR vs_CollMask
	APTR vs_SprColors
	APTR vs_VSBob
	BYTE vs_PlanePick
	BYTE vs_PlaneOnOff
	LONG vs_VUserExt ( %M 00001 )
;STRUCT

:STRUCT Bob
	( %M JForth prefix ) SHORT bob_Flags
	APTR bob_SaveBuffer
	APTR bob_ImageShadow
	APTR bob_Before
	APTR bob_After
	APTR bob_BobVSprite
	APTR bob_BobComp
	APTR bob_DBuffer
	LONG bob_BUserExt ( %M 00001 )
;STRUCT

:STRUCT AnimComp
	( %M JForth prefix ) SHORT ac_Flags
	SHORT ac_Timer
	SHORT ac_TimeSet
	APTR ac_NextComp
	APTR ac_PrevComp
	APTR ac_NextSeq
	APTR ac_PrevSeq
APTR ac_AnimCRoutine ( %M )
  SHORT ac_YTrans
  SHORT ac_XTrans
	APTR ac_HeadOb
	APTR ac_AnimBob
;STRUCT

:STRUCT AnimOb
	( %M JForth prefix ) APTR ao_NextOb
		APTR ao_PrevOb
	LONG ao_Clock
	SHORT ao_AnOldY
	SHORT ao_AnOldX
	SHORT ao_AnY
	SHORT ao_AnX
	SHORT ao_YVel
	SHORT ao_XVel
	SHORT ao_YAccel
	SHORT ao_XAccel
	SHORT ao_RingYTrans
	SHORT ao_RingXTrans
APTR ac_AnimORoutine ( %M )
  APTR ao_HeadComp
LONG ao_AUserExt ( %M 00001 )
;STRUCT

:STRUCT DBufPacket
	( %M JForth prefix ) SHORT dbp_BufY
		SHORT dbp_BufX
	APTR dbp_BufPath
	APTR dbp_BufBuffer
;STRUCT

\ %? #define InitAnimate(animKey) {*(animKey) = NULL;}: InitAnimate ;
\ %? #define RemBob(b) {(b)->Flags |= BOBSAWAY;}: RemBob ;

0   constant B2NORM
1   constant B2SWAP
2   constant B2BOBBER

:STRUCT collTable
16 4 * BYTES collPtrs ( %M )
;STRUCT

.THEN
