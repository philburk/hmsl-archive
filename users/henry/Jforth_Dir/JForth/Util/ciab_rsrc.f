
\ CIA B Resource support
\ The CIAB resource can be called like a library
\ Create a different version of this for CIA A
\
\ Author: Phil Burk
\ Copyright 1991 Phil Burk
\ ALl Rights Reserved

include? interrupt ji:exec/interrupts.j
include? INTB_VERTB ji:hardware/intbits.j
include? CIAICRB_TB ji:hardware/cia.j

ANEW TASK-CIAB_RSRC.F

variable CIARSRC_LIB   ( has to be called LIB to trick CALL )

: CIAB?  ( -- , open CIAB resource )
    0" ciab.resource" call>abs exec_lib OpenResource  ?dup
    IF  ciarsrc_lib !
    ELSE ." Couldn't open Resource!" abort
    THEN
;

$ BFD000 constant CIAB_ABS

: CIAB  ( -- rel_cia_addr )
    CIAB_abs >rel
;

\ CIA Resource Calls
: ADDICRVector() ( iCRBit interrupt -- old | 0 )
    call>abs ciarsrc_lib addICRVector if>rel
;
: REMICRVector() ( iCRBit interrupt -- )
    callvoid>abs ciarsrc_lib remICRVector
;

: ABLEICR() ( mask -- )
    callvoid ciarsrc_lib AbleICR
;

: SETICR() ( newmask -- oldmask )
    call ciarsrc_lib SetICR
;

