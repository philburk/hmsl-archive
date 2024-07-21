\ AMIGA JForth Include file.
decimal
EXISTS? DOS_STDIO_H NOT .IF
: DOS_STDIO_H ;
\ %? #define ReadChar()		FGetC(Input()): ReadChar ;
\ %? #define WriteChar(c)		FPutC(Output(),(c)): WriteChar ;
\ %? #define UnReadChar(c)		UnGetC(Input(),(c)): UnReadChar ;
\ %? #define ReadChars(buf,num)	FRead(Input(),(buf),1,(num)): ReadChars ;
\ %? #define ReadLn(buf,len)		FGets(Input(),(buf),(len)): ReadLn ;
\ %? #define WriteStr(s)		FPuts(Output(),(s)): WriteStr ;
\ %? #define VWritef(format,argv)	VFWritef(Output(),(format),(argv)): VWritef ;

0   constant BUF_LINE
1   constant BUF_FULL
2   constant BUF_NONE

.THEN
