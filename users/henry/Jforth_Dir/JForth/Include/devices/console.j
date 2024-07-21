\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_CONSOLE_H NOT .IF
: DEVICES_CONSOLE_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN

CMD_NONSTD  0 +  constant CD_ASKKEYMAP
CMD_NONSTD  1 +  constant CD_SETKEYMAP
CMD_NONSTD  2 +  constant CD_ASKDEFAULTKEYMAP
CMD_NONSTD  3 +  constant CD_SETDEFAULTKEYMAP

0   constant SGR_PRIMARY
1   constant SGR_BOLD
3   constant SGR_ITALIC
4   constant SGR_UNDERSCORE
7   constant SGR_NEGATIVE

22   constant SGR_NORMAL
23   constant SGR_NOTITALIC
24   constant SGR_NOTUNDERSCORE
27   constant SGR_POSITIVE

30   constant SGR_BLACK
31   constant SGR_RED
32   constant SGR_GREEN
33   constant SGR_YELLOW
34   constant SGR_BLUE
35   constant SGR_MAGENTA
36   constant SGR_CYAN
37   constant SGR_WHITE
39   constant SGR_DEFAULT

40   constant SGR_BLACKBG
41   constant SGR_REDBG
42   constant SGR_GREENBG
43   constant SGR_YELLOWBG
44   constant SGR_BLUEBG
45   constant SGR_MAGENTABG
46   constant SGR_CYANBG
47   constant SGR_WHITEBG
49   constant SGR_DEFAULTBG

30   constant SGR_CLR0
31   constant SGR_CLR1
32   constant SGR_CLR2
33   constant SGR_CLR3
34   constant SGR_CLR4
35   constant SGR_CLR5
36   constant SGR_CLR6
37   constant SGR_CLR7

40   constant SGR_CLR0BG
41   constant SGR_CLR1BG
42   constant SGR_CLR2BG
43   constant SGR_CLR3BG
44   constant SGR_CLR4BG
45   constant SGR_CLR5BG
46   constant SGR_CLR6BG
47   constant SGR_CLR7BG

6   constant DSR_CPR

0   constant CTC_HSETTAB
2   constant CTC_HCLRTAB
5   constant CTC_HCLRTABSALL

0   constant TBC_HCLRTAB
3   constant TBC_HCLRTABSALL

20   constant M_LNM
0" >1" 0string M_ASM ( %M )
0" ?7" 0string M_AWM ( %M )

.THEN
