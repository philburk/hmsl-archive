\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_ICCLASS_H NOT .IF
: INTUITION_ICCLASS_H ;
EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

$ 0401  constant ICM_Dummy
$ 0402  constant ICM_SETLOOP
$ 0403  constant ICM_CLEARLOOP
$ 0404  constant ICM_CHECKLOOP

TAG_USER  $ 40000  constant ICA_Dummy
ICA_Dummy  1 +  constant ICA_TARGET

ICA_Dummy  2 +  constant ICA_MAP

ICA_Dummy  3 +  constant ICSPECIAL_CODE


0 COMP constant ICTARGET_IDCMP ( %M )

.THEN
