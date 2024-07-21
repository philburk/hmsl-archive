\ ANIM.h: structures and constants for ANIM support
\ for JFORTH
\ Author: Martin Kees    10/13/90
\ Copyright: 1990 Martin Kees
\ Freely distributable to the JForth Community
\ MOD: MCK 11/22/90 added DPAN stuff
\ MOD: MCK 2/9/91   name change > abr for all animbrush refs
\ MOD: MCK 2/11/91  ANIM-ERROR added
\ MOD: PLB 10/25/91 Changed some longs to RPTR

\ Define special structure for manipulating IFF ANIM-5 animations.
\ Pointers are relative pointers.
:STRUCT ANIMATION
	struct picture  an_pic0
	long   an_key
	rptr   an_DELTAlist        \ pointer to list of pointers to DELTAs
	rptr   an_ytable
	short  an_cels
	short  an_atdelta
	long   an_flags
\
\ these members differ from ANIMBRUSHes
	struct picture  an_pic1
	rptr   an_displaying       \ pointer to picture current displayed
	rptr   an_hiding           \ pointer to picture current hidden
	long   an_CAMG
	rptr   an_Seeklist         \ for HD
	rptr   an_Sizelist         \ FOR HDdisk player
	rptr   an_$filename        \ FOr HDdisk player
;STRUCT


$ 67676767 CONSTANT ANIM_VALID_KEY

0 CONSTANT Anim_MEMmode
1 CONSTANT Anim_DISKmode
1 CONSTANT ANIM_LOOP
0 CONSTANT ANIM_ONETIME

\ Define special structure for manipulating DpaintIII ANIM-Brushes.
\ Pointers are relative pointers.
:STRUCT ANIMBrush
	struct picture  abr_pic0
	long   abr_key
	rptr   abr_DELTAlist        \ pointer
	rptr   abr_ytable
	short  abr_cels
	short  abr_atdelta
	long   abr_flags
\
\ These differ from ANIMATIONs
	long   abr_direction
;STRUCT

 1 CONSTANT ABR_FORWARD
-1 CONSTANT ABR_BACKWARD
 4 CONSTANT ABR_Loop
 8 CONSTANT ABR_PingPong

$ 6868686868 CONSTANT Abr_Valid_Key

CHKID ANIM 'ANIM'
CHKID ANHD 'ANHD'
CHKID DLTA 'DLTA'
CHKID DPAN 'DPAN'

:STRUCT ANHD
 ubyte ah_operation
 ubyte ah_mask
 short ah_w
 short ah_h
 short ah_x
 short ah_y
 long  ah_abstime
 long  ah_reltime
 ubyte ah_interleave
 byte  ah_pad0
 long  ah_bits
 16 bytes ah_pad16
;STRUCT

\ This is guess work by looking at DPaintIII files
:STRUCT DPAN
	ushort	dp_code     \ seems to be 3 always
	ushort	dp_frames   \ number of actual frames not counting loop deltas
	ubyte	dp_rate     \ in frames/sec?
	ubyte	dp_mode     \ 0=forward 2=pingpong 5=reverse   
	ushort	dp_dur      \ animbrush duration setting ?
;STRUCT 

variable ANIM-ERROR ANIM-ERROR OFF

: <anim.error> ( $errormsg -- )
  $type cr
  ANIM-ERROR ON
;  

DEFER anim.error
' <anim.error> is anim.error
