\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_ALERTS_H NOT .IF
: EXEC_ALERTS_H ;

















$ 80000000   constant AT_DeadEnd
$ 00000000   constant AT_Recovery


$ 00010000   constant AG_NoMemory
$ 00020000   constant AG_MakeLib
$ 00030000   constant AG_OpenLib
$ 00040000   constant AG_OpenDev
$ 00050000   constant AG_OpenRes
$ 00060000   constant AG_IOError
$ 00070000   constant AG_NoSignal
$ 00080000   constant AG_BadParm
$ 00090000   constant AG_CloseLib
$ 000A0000   constant AG_CloseDev
$ 000B0000   constant AG_ProcCreate


$ 00008001   constant AO_ExecLib
$ 00008002   constant AO_GraphicsLib
$ 00008003   constant AO_LayersLib
$ 00008004   constant AO_Intuition
$ 00008005   constant AO_MathLib
$ 00008007   constant AO_DOSLib
$ 00008008   constant AO_RAMLib
$ 00008009   constant AO_IconLib
$ 0000800A   constant AO_ExpansionLib
$ 0000800B   constant AO_DiskfontLib
$ 0000800C   constant AO_UtilityLib

$ 00008010   constant AO_AudioDev
$ 00008011   constant AO_ConsoleDev
$ 00008012   constant AO_GamePortDev
$ 00008013   constant AO_KeyboardDev
$ 00008014   constant AO_TrackDiskDev
$ 00008015   constant AO_TimerDev

$ 00008020   constant AO_CIARsrc
$ 00008021   constant AO_DiskRsrc
$ 00008022   constant AO_MiscRsrc

$ 00008030   constant AO_BootStrap
$ 00008031   constant AO_Workbench
$ 00008032   constant AO_DiskCopy
$ 00008033   constant AO_GadTools
$ 00008035   constant AO_Unknown








$ 01000000   constant AN_ExecLib
$ 01000001   constant AN_ExcptVect
$ 01000002   constant AN_BaseChkSum
$ 01000003   constant AN_LibChkSum

$ 81000005   constant AN_MemCorrupt
$ 81000006   constant AN_IntrMem
$ 01000007   constant AN_InitAPtr
$ 01000008   constant AN_SemCorrupt
$ 01000009   constant AN_FreeTwice
$ 8100000A   constant AN_BogusExcpt
$ 0100000B   constant AN_IOUsedTwice
$ 0100000C   constant AN_MemoryInsane
$ 0100000D   constant AN_IOAfterClose
$ 0100000E   constant AN_StackProbe
$ 0100000F   constant AN_BadFreeAddr

$ 02000000   constant AN_GraphicsLib
$ 82010000   constant AN_GfxNoMem
$ 82010001   constant AN_GfxNoMemMspc
$ 82010006   constant AN_LongFrame
$ 82010007   constant AN_ShortFrame
$ 02010009   constant AN_TextTmpRas
$ 8201000A   constant AN_BltBitMap
$ 8201000B   constant AN_RegionMemory
$ 82010030   constant AN_MakeVPort
$ 0200000C   constant AN_GfxNewError
$ 0200000D   constant AN_GfxFreeError

$ 82011234   constant AN_GfxNoLCM

$ 02000401   constant AN_ObsoleteFont

$ 03000000   constant AN_LayersLib
$ 83010000   constant AN_LayersNoMem

$ 04000000   constant AN_Intuition
$ 84000001   constant AN_GadgetType
$ 04000001   constant AN_BadGadget
$ 84010002   constant AN_CreatePort
$ 04010003   constant AN_ItemAlloc
$ 04010004   constant AN_SubAlloc
$ 84010005   constant AN_PlaneAlloc
$ 84000006   constant AN_ItemBoxTop
$ 84010007   constant AN_OpenScreen
$ 84010008   constant AN_OpenScrnRast
$ 84000009   constant AN_SysScrnType
$ 8401000A   constant AN_AddSWGadget
$ 8401000B   constant AN_OpenWindow
$ 8400000C   constant AN_BadState
$ 8400000D   constant AN_BadMessage
$ 8400000E   constant AN_WeirdEcho
$ 8400000F   constant AN_NoConsole

$ 05000000   constant AN_MathLib

$ 07000000   constant AN_DOSLib
$ 07010001   constant AN_StartMem
$ 07000002   constant AN_EndTask
$ 07000003   constant AN_QPktFail
$ 07000004   constant AN_AsyncPkt
$ 07000005   constant AN_FreeVec
$ 07000006   constant AN_DiskBlkSeq
$ 07000007   constant AN_BitMap
$ 07000008   constant AN_KeyFree
$ 07000009   constant AN_BadChkSum
$ 0700000A   constant AN_DiskError
$ 0700000B   constant AN_KeyRange
$ 0700000C   constant AN_BadOverlay
$ 0700000D   constant AN_BadInitFunc
$ 0700000E   constant AN_FileReclosed

$ 08000000   constant AN_RAMLib
$ 08000001   constant AN_BadSegList

$ 09000000   constant AN_IconLib

$ 0A000000   constant AN_ExpansionLib
$ 0A000001   constant AN_BadExpansionFree

$ 0B000000   constant AN_DiskfontLib

$ 10000000   constant AN_AudioDev

$ 11000000   constant AN_ConsoleDev
$ 11000001   constant AN_NoWindow

$ 12000000   constant AN_GamePortDev

$ 13000000   constant AN_KeyboardDev

$ 14000000   constant AN_TrackDiskDev
$ 14000001   constant AN_TDCalibSeek
$ 14000002   constant AN_TDDelay

$ 15000000   constant AN_TimerDev
$ 15000001   constant AN_TMBadReq
$ 15000002   constant AN_TMBadSupply

$ 20000000   constant AN_CIARsrc

$ 21000000   constant AN_DiskRsrc
$ 21000001   constant AN_DRHasDisk
$ 21000002   constant AN_DRIntNoAct

$ 22000000   constant AN_MiscRsrc

$ 30000000   constant AN_BootStrap
$ 30000001   constant AN_BootError

$ 31000000   constant AN_Workbench
$ B1000001   constant AN_NoFonts
$ 31000001   constant AN_WBBadStartupMsg1
$ 31000002   constant AN_WBBadStartupMsg2
$ 31000003   constant AN_WBBadIOMsg

$ B1010004   constant AN_WBInitPotionAllocDrawer
$ B1010005   constant AN_WBCreateWBMenusCreateMenus1
$ B1010006   constant AN_WBCreateWBMenusCreateMenus2
$ B1010007   constant AN_WBLayoutWBMenusLayoutMenus
$ B1010008   constant AN_WBAddToolMenuItem
$ B1010009   constant AN_WBReLayoutToolMenu
$ B101000A   constant AN_WBinitTimer
$ B101000B   constant AN_WBInitLayerDemon
$ B101000C   constant AN_WBinitWbGels
$ B101000D   constant AN_WBInitScreenAndWindows1
$ B101000E   constant AN_WBInitScreenAndWindows2
$ B101000F   constant AN_WBInitScreenAndWindows3
$ B1010010   constant AN_WBMAlloc

$ 32000000   constant AN_DiskCopy

$ 33000000   constant AN_GadTools

$ 34000000   constant AN_UtilityLib

$ 35000000   constant AN_Unknown


.THEN
