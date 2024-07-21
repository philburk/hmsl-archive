\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_INPUTEVENT_H NOT .IF
: DEVICES_INPUTEVENT_H ;
EXISTS? DEVICES_TIMER_H NOT .IF
include ji:devices/timer.j
.THEN

$ 00   constant IECLASS_NULL
$ 01   constant IECLASS_RAWKEY
$ 02   constant IECLASS_RAWMOUSE
$ 03   constant IECLASS_EVENT
$ 04   constant IECLASS_POINTERPOS
$ 06   constant IECLASS_TIMER
$ 07   constant IECLASS_GADGETDOWN
$ 08   constant IECLASS_GADGETUP
$ 09   constant IECLASS_REQUESTER
$ 0A   constant IECLASS_MENULIST
$ 0B   constant IECLASS_CLOSEWINDOW
$ 0C   constant IECLASS_SIZEWINDOW
$ 0D   constant IECLASS_REFRESHWINDOW
$ 0E   constant IECLASS_NEWPREFS
$ 0F   constant IECLASS_DISKREMOVED
$ 10   constant IECLASS_DISKINSERTED
$ 11   constant IECLASS_ACTIVEWINDOW
$ 12   constant IECLASS_INACTIVEWINDOW
$ 13   constant IECLASS_NEWPOINTERPOS
$ 14   constant IECLASS_MENUHELP
$ 15   constant IECLASS_CHANGEWINDOW

$ 15   constant IECLASS_MAX

$ 00   constant IESUBCLASS_COMPATIBLE
$ 01   constant IESUBCLASS_PIXEL
$ 02   constant IESUBCLASS_TABLET

:STRUCT IEPointerPixel
	APTR iepp_Screen
	SHORT iepp_Position.X \ %M
	SHORT iepp_Position.Y \ %M
;STRUCT

:STRUCT IEPointerTablet
	USHORT iept_Range.X
	USHORT iept_Range.Y
	USHORT iept_Value.X
	USHORT iept_Value.Y
	SHORT iept_Pressure
;STRUCT

$ 80   constant IECODE_UP_PREFIX
$ 00   constant IECODE_KEY_CODE_FIRST
$ 77   constant IECODE_KEY_CODE_LAST
$ 78   constant IECODE_COMM_CODE_FIRST
$ 7F   constant IECODE_COMM_CODE_LAST

$ 00   constant IECODE_C0_FIRST
$ 1F   constant IECODE_C0_LAST
$ 20   constant IECODE_ASCII_FIRST
$ 7E   constant IECODE_ASCII_LAST
$ 7F   constant IECODE_ASCII_DEL
$ 80   constant IECODE_C1_FIRST
$ 9F   constant IECODE_C1_LAST
$ A0   constant IECODE_LATIN1_FIRST
$ FF   constant IECODE_LATIN1_LAST

$ 68   constant IECODE_LBUTTON
$ 69   constant IECODE_RBUTTON
$ 6A   constant IECODE_MBUTTON
$ FF   constant IECODE_NOBUTTON

$ 01   constant IECODE_NEWACTIVE
$ 02   constant IECODE_NEWSIZE
$ 03   constant IECODE_REFRESH

$ 01   constant IECODE_REQSET
$ 00   constant IECODE_REQCLEAR

$ 0001   constant IEQUALIFIER_LSHIFT
$ 0002   constant IEQUALIFIER_RSHIFT
$ 0004   constant IEQUALIFIER_CAPSLOCK
$ 0008   constant IEQUALIFIER_CONTROL
$ 0010   constant IEQUALIFIER_LALT
$ 0020   constant IEQUALIFIER_RALT
$ 0040   constant IEQUALIFIER_LCOMMAND
$ 0080   constant IEQUALIFIER_RCOMMAND
$ 0100   constant IEQUALIFIER_NUMERICPAD
$ 0200   constant IEQUALIFIER_REPEAT
$ 0400   constant IEQUALIFIER_INTERRUPT
$ 0800   constant IEQUALIFIER_MULTIBROADCAST
$ 1000   constant IEQUALIFIER_MIDBUTTON
$ 2000   constant IEQUALIFIER_RBUTTON
$ 4000   constant IEQUALIFIER_LEFTBUTTON
$ 8000   constant IEQUALIFIER_RELATIVEMOUSE

0   constant IEQUALIFIERB_LSHIFT
1   constant IEQUALIFIERB_RSHIFT
2   constant IEQUALIFIERB_CAPSLOCK
3   constant IEQUALIFIERB_CONTROL
4   constant IEQUALIFIERB_LALT
5   constant IEQUALIFIERB_RALT
6   constant IEQUALIFIERB_LCOMMAND
7   constant IEQUALIFIERB_RCOMMAND
8   constant IEQUALIFIERB_NUMERICPAD
9   constant IEQUALIFIERB_REPEAT
10   constant IEQUALIFIERB_INTERRUPT
11   constant IEQUALIFIERB_MULTIBROADCAST
12   constant IEQUALIFIERB_MIDBUTTON
13   constant IEQUALIFIERB_RBUTTON
14   constant IEQUALIFIERB_LEFTBUTTON
15   constant IEQUALIFIERB_RELATIVEMOUSE

:STRUCT InputEvent
	APTR ie_NextEvent
	UBYTE ie_Class
	UBYTE ie_SubClass
	USHORT ie_Code
	USHORT ie_Qualifier
	UNION{
		SHORT ie_X
		SHORT ie_Y
	}UNION{
		APTR ie_addr
	}union{
		UBYTE ie_prev1DownCode
		UBYTE ie_prev1DownQual
		UBYTE ie_prev2DownCode
		UBYTE ie_prev2DownQual
	}union
		STRUCT timeval ie_TimeStamp
;STRUCT

\ %? #define	ie_X			ie_position.ie_xy.ie_x
\ %? #define	ie_Y			ie_position.ie_xy.ie_y
\ %? #define	ie_EventAddress		ie_position.ie_addr
\ %? #define	ie_Prev1DownCode	ie_position.ie_dead.ie_prev1DownCode
\ %? #define	ie_Prev1DownQual	ie_position.ie_dead.ie_prev1DownQual
\ %? #define	ie_Prev2DownCode	ie_position.ie_dead.ie_prev2DownCode
\ %? #define	ie_Prev2DownQual	ie_position.ie_dead.ie_prev2DownQual

.THEN
