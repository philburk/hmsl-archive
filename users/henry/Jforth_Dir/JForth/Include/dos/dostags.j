\ AMIGA JForth Include file.
decimal
EXISTS? DOS_DOSTAGS_H NOT .IF
: DOS_DOSTAGS_H ;
EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

TAG_USER  32 +  constant SYS_Dummy
SYS_Dummy  1 +  constant SYS_Input

SYS_Dummy  2 +  constant SYS_Output

SYS_Dummy  3 +  constant SYS_Asynch

SYS_Dummy  4 +  constant SYS_UserShell

SYS_Dummy  5 +  constant SYS_CustomShell

TAG_USER  1000 +  constant NP_Dummy
NP_Dummy  1 +  constant NP_Seglist

NP_Dummy  2 +  constant NP_FreeSeglist


NP_Dummy  3 +  constant NP_Entry


NP_Dummy  4 +  constant NP_Input

NP_Dummy  5 +  constant NP_Output

NP_Dummy  6 +  constant NP_CloseInput


NP_Dummy  7 +  constant NP_CloseOutput


NP_Dummy  8 +  constant NP_Error

NP_Dummy  9 +  constant NP_CloseError


NP_Dummy  10 +  constant NP_CurrentDir

NP_Dummy  11 +  constant NP_StackSize

NP_Dummy  12 +  constant NP_Name

NP_Dummy  13 +  constant NP_Priority

NP_Dummy  14 +  constant NP_ConsoleTask

NP_Dummy  15 +  constant NP_WindowPtr

NP_Dummy  16 +  constant NP_HomeDir

NP_Dummy  17 +  constant NP_CopyVars

NP_Dummy  18 +  constant NP_Cli

NP_Dummy  19 +  constant NP_Path


NP_Dummy  20 +  constant NP_CommandName

NP_Dummy  21 +  constant NP_Arguments







NP_Dummy  22 +  constant NP_NotifyOnDeath


NP_Dummy  23 +  constant NP_Synchronous



NP_Dummy  24 +  constant NP_ExitCode

NP_Dummy  25 +  constant NP_ExitData



TAG_USER  2000 +  constant ADO_Dummy
ADO_Dummy  1 +  constant ADO_FH_Mode









ADO_Dummy  2 +  constant ADO_DirLen

ADO_Dummy  3 +  constant ADO_CommNameLen

ADO_Dummy  4 +  constant ADO_CommFileLen

ADO_Dummy  5 +  constant ADO_PromptLen


.THEN
