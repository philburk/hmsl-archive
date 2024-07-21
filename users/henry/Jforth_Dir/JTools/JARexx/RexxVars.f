\ RVI for JForth
\ translated by Martin Kees
\ 5/30/91
\  SetValue	equ	-$54
\  StrcpyN	equ	-$10E
\  CurrentEnv	equ	-$6C
\  Strlen	equ	-$120
\  CloseLibrary	equ	-$19E
\  FreeSpace	equ	-$78
\  GetSpace	equ	-$72
\  OpenLibrary	equ	-$228
\  IsRexxMsg	equ	-$A8
\  FetchValue	equ	-$48
\  IsSymbol	equ	-$66
\  EnterSymbol	equ	-$42

\ 00001 PLB 1/24/92 Changed PC relative reference to REXSYS_NAME for Clone
\ 00002 PLB 1/25/92 Fixed wierd 78(PC) error recovery in <SETREXXVAR>

anew task-rexxvars.f

\ internal stubs used by RexxVar interface
ASM Stubb1D2
	move.l	a1,d1
	beq.s	1$
	moveq	#1,d0
	and.b	6(a1),d0
	bne.s	1$
	move.w	4(a1),d0
	addq.l	#8,d0
	addq.l	#1,d0
	jsr	$-78(a6)	 \ freespace
1$:	rts
end-code

ASM Stubb19E
	movem.l	d0/a1,-(rp)
	addq.l	#8,d0
	addq.l	#1,d0
	jsr	$-72(a6)	
	movem.l	(rp)+,d0/a1
	beq.s	1$
	move.l	a0,-(rp)
	clr.l	(a0)
	move.w	d0,4(a0)
	move.b	#2,6(a0)
	clr.b	8(a0,d0.l)
	addq.w	#8,a0
	jsr	$-10E(a6)	
	move.l	(rp)+,a0
	move.b	d0,7(a0)
1$:	move.l	a0,d0
end-code

ASM Stubb134
	movem.l	d2/d3/a2/a3,-(rp)
	moveq	#0,d2
	moveq	#0,d3
	jsr	$-120(a6)	
	move.l	a0,a1
	move.l	a4,a0
	bsr	Stubb19E
	move.l	d0,a2
	beq.s	180$
	lea	8(a2),a1
	move.w	4(a2),d0
	move.l	a1,d1
154$:	cmp.b	#$2E,(a1)+
	dbeq.w	d0,154$
	bne.s	16$
	exg	d1,a1
	sub.l	a1,d1
	move.l	a2,d3
	move.l	a4,a0
	move.l	d1,d0
	bsr	Stubb19E
	move.l	d0,a2
	beq.s	180$
16$:	lea	8(a2),a0
	jsr	$-66(a6)	
	cmp.w	4(a2),d1
	beq.s	182$
	moveq	#$28,d2
	bra.s	182$
180$:	moveq	#3,d2
182$:	tst.l	d2
	beq.s	192$
	move.l	a4,a0
	move.l	a2,a1
	bsr	Stubb1D2
	move.l	a4,a0
	move.l	d3,a1
	bsr	Stubb1D2
192$:	move.l	a2,a1
	move.l	d3,d1
	move.l	d2,d0
	movem.l	(rp)+,d2/d3/a2/a3
end-code



ASM Stubb1EC
	move.l	a3,-(rp)
	move.l	$14(a2),a3
	move.l	a2,(a1)
	movem.l	$FC(a3),d0/d1
	movem.l	a0/a1,$FC(a3)
	movem.l	d0/d1,4(a1)
	move.l	(rp)+,a3
end-code

ASM Stubb20A
        move.l	(a0),a1
	move.l	$14(a1),a1
	movem.l	4(a0),d0/d1
	movem.l	d0/d1,$FC(a1)
end-code

\ Use this instead of string past RTS for Clone
create RXSLIB_NAME ," rexxsyslib.library"  RXSLIB_NAME $>0

ASM <CheckRexxMsg>  (  --- )
	movem.l	d2/a2/a6,-(rp)
	move.l	a0,a2
	move.l	4,a6
	lea	[RXSLIB_NAME HERE - 2-](pc),a1    \ point to 0" rexxsyslib.library"
	moveq	#0,d0
	jsr	$-228(a6)	
	move.l	d0,d2
	beq.s	48$
	move.l	d2,a1
	jsr	$-19E(a6)	
	moveq	#0,d0
	cmp.l	$18(a2),d2
	bne.s	48$
	move.l	$14(a2),d1
	beq.s	48$
	move.l	a2,a0
	move.l	d2,a6
	jsr	$-A8(a6)	
48$:	tst.l	d0
	movem.l	(rp)+,d2/a2/a6
end-code

ASM <GetRexxVar> ( -- )
	movem.l	a2-a4/a6,-(rp)
	move.l	a0,a2
	move.l	a1,a3
	bsr	<CheckRexxMsg>
	beq.s	9$
	move.l	$18(a2),a6
	move.l	$14(a2),a0
	jsr	$-6C(a6)	
	move.l	a0,a4
	move.l	a3,a0
	bsr	Stubb134
	bne.s	8$
	move.l	a4,a0
	move.l	d1,d0
	moveq	#0,d1
	jsr	$-48(a6)
	addq.w	#8,a1
	moveq	#0,d0
	tst.l	d1
	beq.s	8$
	sub.l	a1,a1
	bra.s	8$
9$:	moveq	#10,d0
8$:	tst.l	d0
	movem.l	(rp)+,a2-a4/a6
end-code

\ This next routine is only for error returns from <SETREXXVAR>
\ in case of low memory.  It is a wierd kludge for Clone needed
\ because of some wierd error handling in ARexx.  It is copied
\ from the rear of <SETREXXVAR>
ASM <SRV.NOMEM>  ( -- , DO NOT CALL THIS )
		moveq	#3,d0
		move.l	rp,a0
		move.l	d0,-(rp)
		bsr	Stubb20A
		move.l	(rp)+,d0
		lea	12(rp),rp
		movem.l	(rp)+,d2-d7/a2-a6
END-CODE	

ASM <SetRexxVar> ( -- )
	movem.l	d2-d7/a2-a6,-(rp)
	lea	-12(rp),rp
	move.l	a0,a2    \ rexxmsg
	move.l	a1,a3    \ rexxvar
	move.l	d0,a5
	move.l	d1,d3
	bsr	<CheckRexxMsg>
	beq.s	116$
	move.l	$18(a2),a6
	lea	[' <SRV.NOMEM> HERE - 2-](pc),a0   \ set error jump
	move.l	rp,a1
	bsr	Stubb1EC
	cmp.l	#$FFFF,d3
	bgt.s	11$
	move.l	$14(a2),a0
	jsr	$-6C(a6)	
	move.l	a0,a4
	move.l	a3,a0
	bsr	Stubb134
	bne.s	120$
	move.l	a1,a2
	move.l	d1,d2
	move.l	a4,a0
	move.l	d2,d0
	jsr	$-42(a6)	
	move.l	d0,d4
	move.l	a4,a0
	move.l	a5,a1
	move.l	d3,d0
	bsr	Stubb19E
	beq.s	1110$
	move.l	a4,a0
	move.l	d0,a1
	move.l	d4,d0
	jsr	$-54(a6)	
	moveq	#0,d0
	bra.s	120$
\
116$:	moveq	#10,d0
	bra.s	12$
\
1110$:  moveq	#3,d0
	bra.s	120$
\
11$:	moveq	#9,d0
120$:	move.l	rp,a0
	move.l	d0,-(rp)
	bsr	Stubb20A
	move.l	(rp)+,d0
12$:	lea	12(rp),rp
	movem.l	(rp)+,d2-d7/a2-a6
end-code	

\ All of the following use standard JForth relative addresses
ASM CheckRexxMsg ( rxmsg --- Flag )
    move.l tos,a0
    adda.l org,a0
    bsr    <CheckRexxMsg>
    move.l d0,tos
end-code    

ASM GetRexxVar ( rxmsg 0$variable -- 0$value error )
    move.l tos,a1
    adda.l org,a1
    move.l (dsp),a0
    adda.l org,a0
    bsr    <GetRexxVar>
    move.l d0,tos
    sub.l  org,a1
    move.l a1,(dsp)
end-code    

ASM SetRexxVar ( rxmsg 0$var 0$val length -- error )
    move.l tos,d1
    move.l (dsp)+,d0
    add.l  org,d0
    move.l (dsp)+,a1
    adda.l org,a1
    move.l (dsp)+,a0
    adda.l org,a0
    bsr    <SetRexxVar>
    move.l d0,tos
end-code    
