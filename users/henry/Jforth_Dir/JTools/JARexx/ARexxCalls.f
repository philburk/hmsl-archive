\ JForth V2.x interface for ARexx Library.  Mike Haas.  All Rights Reserved.
\
\ This file defines all the ARexx library functions, accepting
\ and returning all arguments on the data stack (as you would
\ expect).  Just watch the order of the returned values.
\
\ Addresses returned by ARexx will be converted to relative
\ before being pushed on the stack.  ALL ADDRESSES (pointers),
\ IN AND OUT OF THESE 'GLUE' ROUTINES, ARE IN JFORTH-RELATIVE FORM!
\
\ Some ARexx functions do wierd things like return multiple
\ arguments in registers other than D0 and D1, so just the
\ normal CALL & DCALL primitives don't suffice.
\
\ This source is highly JForth dependant, and not likely to
\ be useful to a user of any other brand of Forth.


anew Task-ARexxCalls.f


\ IS THE AREXX LIBRARY DEFINED?...

.NEED RexxSysLib_lib

  :Library RexxSysLib
  
  : RexxSysLib?  RexxSysLib_name  RexxSysLib_lib  lib?   ;
  
  : -RexxSysLib  RexxSysLib_lib -lib  ;
  
.THEN


\ SUPPORT FOR PUSHING THOSE MULTIPLE REGISTERS...

: TuckA0  ( -- , gen code to >REL on adr in A0, then push below TOS )
  $ 91cc w,   \ suba.l  org,a0
  $ 2d08 w,   \ move.l  a0,-(dsp)
;
immediate

: TuckA1  ( -- , gen code to >REL on adr in A1, then push below TOS )
  $ 93cc w,   \ suba.l  org,a1
  $ 2d09 w,   \ move.l  a1,-(dsp)
;
immediate

: TuckD1  ( -- , compile code to push value in d1 under TOS )
  $ 2d01 w,   \ move.l  d1,-(dsp)
;
immediate


\ THE ACTUAL AREXX CALLS...

: ErrorMsg()  ( code -- StringStructure flag , 0=invalid code ) 
  call RexxSysLib_lib ErrorMsg  TuckA0
;

: IsSymbol()  ( string -- length code , code=0 if not a symbol )
  >abs dcall RexxSysLib_lib IsSymbol swap
;

: CurrentEnv()  ( RexxTaskPtr -- EnvPtr )
  call>abs RexxSysLib_lib CurrentEnv if>rel
;

: GetSpace()  ( EnvPtr len -- ARexxMemBlk )
  call>abs RexxSysLib_lib GetSpace if>rel
;

: FreeSpace()  ( EnvPtr ARexxMemBlk length -- )
  call>abs RexxSysLib_lib FreeSpace drop
;

: CreateArgstring()  ( string len -- argstring )
  call>abs RexxSysLib_lib CreateArgstring if>rel
;

: DeleteArgstring()  ( argstring -- )
  >abs callvoid RexxSysLib_lib DeleteArgstring
;

: LengthArgstring()  ( argstring -- length )
  call>abs RexxSysLib_lib LengthArgstring
;

: CreateRexxMsg()  ( replyport extensionPtr hostPtr -- msgPtr )
  >abs call>abs RexxSysLib_lib CreateRexxMsg if>rel
;

: DeleteRexxMsg()  ( msgPtr -- )
  call>abs RexxSysLib_lib DeleteRexxMsg drop
;

: ClearRexxMsg()  ( msgPtr numStrings -- )
  call>abs RexxSysLib_lib ClearRexxMsg drop
;

: FillRexxMsg()  ( msgPtr count mask -- flag , 0=notsuccessful )
  call>abs RexxSysLib_lib FillRexxMsg
;

: IsRexxMsg()  ( msgPtr -- flag )
  call>abs RexxSysLib_lib IsRexxMsg
;

: AddRsrcNode()  ( list name len -- node-or-0 )
  call>abs RexxSysLib_lib AddRsrcNode  if>rel
;

: FindRsrcNode()  ( list name len -- node-or-0 )
  call>abs RexxSysLib_lib FindRsrcNode  if>rel
;

: RemRsrcList()  ( list -- )
  >abs callvoid RexxSysLib_lib RemRsrcList
;

: RemRsrcNode()  ( node -- )
  >abs callvoid RexxSysLib_lib RemRsrcNode
;

: OpenPublicPort()  ( list name -- node )
  call>abs RexxSysLib_lib OpenPublicPort  if>rel
;

: ClosePublicPort()  ( node -- )
  >abs callvoid RexxSysLib_lib ClosePublicPort
;

: ListNames()  ( list separator -- argstring )
  call>abs RexxSysLib_lib ListNames if>rel
;

: ClearMem()  ( adr len -- )
  call>abs RexxSysLib_lib ClearMem  drop
;

: InitList()  ( list -- )
  >abs callvoid RexxSysLib_lib InitList
;

: InitPort()  ( port name -- port signal )
  call>abs RexxSysLib_lib InitPort  TuckA1
;

: FreePort()  ( port -- )
  >abs callvoid RexxSysLib_lib FreePort
;

: CmpString()  ( StringStructure1 StringStructure2 -- flag )
  call>abs RexxSysLib_lib CmpString
;

: StcToken()  ( string -- token scan length quote )
  call>abs RexxSysLib_lib StcToken  TuckA1 TuckA0 TuckD1
;

: StrcmpN()  ( string1 string2 len -- result )
  call>abs RexxSysLib_lib StrcmpN
;

: StrcmpU()  ( string1 string2 len -- result )
  call>abs RexxSysLib_lib StrcmpU
;

: StrcpyA()  ( dest source len -- hash )
  call>abs RexxSysLib_lib StrcpyA
;

: StrcpyN()  ( dest source len -- hash )
  call>abs RexxSysLib_lib StrcpyN
;

: StrcpyU()  ( dest source len -- hash )
  call>abs RexxSysLib_lib StrcpyU
;

: StrFlipN()  ( string len -- )
  call>abs RexxSysLib_lib StrFlipN drop
;

: Strlen()  ( string -- len )
  call>abs RexxSysLib_lib Strlen
;

: ToUpper()  ( char -- char' )
  call RexxSysLib_lib ToUpper
;

: CVa2i()  ( buffer -- value numDigits )
  call>abs RexxSysLib_lib CVa2i  TuckD1
;

: CVi2a()  ( buffer value maxNumDigits -- buffer' numDigits )
  call>abs RexxSysLib_lib CVi2a  TuckA0
;

: CVi2arg()  ( value -- argstring-or-0 )
  call RexxSysLib_lib CVi2arg if>rel
;

: CVi2az()  ( buffer value numDigits<w/leadzeros> -- buffer' numDigits )
  call>abs RexxSysLib_lib CVi2az  TuckA0
;

: CVc2x()  ( outbuff string len mode -- error )
  call>abs RexxSysLib_lib CVc2x
;

: CVx2c()  ( outbuff string len mode -- error )
  call>abs RexxSysLib_lib CVx2c
;

: OpenF()  ( list filename mode logical -- IoBuff )
  3 x>r  >abs   r> >abs  r> r> if>abs  call RexxSysLib_lib OpenF if>rel
;

: CloseF()  ( IoBuff -- flag )
  call>abs RexxSysLib_lib CloseF
;

: ReadStr()  ( IoBuff buffer len -- adr count , count=-1 if err )
  call>abs RexxSysLib_lib ReadStr  TuckA1
;

: ReadF()  ( IoBuff buffer len -- count , count=-1 if err )
  call>abs RexxSysLib_lib ReadF
;

: WriteF()  ( IoBuff buffer len -- count , count=-1 if err )
  call>abs RexxSysLib_lib WriteF
;

: SeekF()  ( IoBuff offset anchor -- position )
  call>abs RexxSysLib_lib SeekF
;

: QueueF()  ( IoBuff buffer len -- count , count=-1 if err )
  call>abs RexxSysLib_lib QueueF
;

: StackF()  ( IoBuff buffer len -- count , count=-1 if err )
  call>abs RexxSysLib_lib StackF
;

: ExistF()  ( filename -- flag )
  call>abs RexxSysLib_lib ExistF
;

: DOSCommand()  ( string filehandle -- code )
  call>abs RexxSysLib_lib DOSCommand
;

: DOSRead()  ( filehandle buffer len -- count , count=-1 if err )
  call>abs RexxSysLib_lib DOSRead
;

: DOSWrite()  ( filehandle buffer len -- count , count=-1 if err )
  call>abs RexxSysLib_lib DOSWrite
;

: CreateDOSPkt()  ( -- message )
  call RexxSysLib_lib CreateDOSPkt  if>rel
;

: DeleteDOSPkt()  ( message -- )
  >abs callvoid RexxSysLib_lib DeleteDOSPkt
;

: FindDevice()  ( devicename type -- device/0 )
  call>abs RexxSysLib_lib FindDevice  if>rel
;

: AddClipNode()  ( list name len value -- node/0 )
  3 x>r  >abs  r> >abs  r> r> >abs call RexxSysLib_lib AddClipNode if>rel
;

: RemClipNode()  ( mode -- )
  >abs callvoid RexxSysLib_lib RemClipNode
;

: LockRexxBase()  ( resource -- )
  callvoid RexxSysLib_lib LockRexxBase
;

: UnlockRexxBase()  ( resource -- )
  callvoid RexxSysLib_lib UnlockRexxBase
;
