\ AMIGA JForth Include file.

(  reqlibrary.h © 1988/1989/1990 reserved by Colin Fox and Bruce Dawson )

decimal

EXISTS? REQLIBRARY_H NOT .IF
: REQLIBRARY_H ;

getmodule includes

EXISTS? 	EXEC_TYPES_H NOT .IF	
include ji:exec/types.j	
.THEN

EXISTS? 	AZTEC_C NOT .IF	
EXISTS? 	DOS_DOS_H NOT .IF	
include ji:libraries/dos.j		
\ include ji:dos/dos.j	     \ original line !!!
.THEN
.THEN


2   constant REQVERSION
10   constant NUMPAIRS


:STRUCT GadgetBlock
	  STRUCT Gadget	gbl_Gadget
	  STRUCT Border	gbl_Border
	( %?)   NUMPAIRS 2 *  BYTES gbl_Pairs
	  STRUCT IntuiText	gbl_Text
;STRUCT



:STRUCT StringBlock
	STRUCT Gadget	sbl_Gadget
	  STRUCT StringInfo	sbl_Info
	  STRUCT Border	sbl_Border
	( %?)   NUMPAIRS 2 *  BYTES sbl_Pairs
;STRUCT



:STRUCT PropBlock
	  STRUCT Gadget	pbl_Gadget
	  STRUCT PropInfo	pbl_Info
	  STRUCT Image	pbl_Image
;STRUCT



:STRUCT ScrollBlock
	  STRUCT Gadget	ScrBl_ArrowUpLt
	  STRUCT Image	ScrBl_ImageUpLt
	  STRUCT Gadget	ScrBl_ArrowDnRt
	  STRUCT Image	ScrBl_ImageDnRt
	  STRUCT PropBlock	ScrBl_Prop
;STRUCT



:STRUCT TwoImageGadget
	  STRUCT Gadget	tig_Gadget
	  STRUCT Image	tig_Image1
	  STRUCT Image	tig_Image2
;STRUCT


16   constant ATTITUDEB

0  constant HORIZSLIDER
1  ATTITUDEB <<  constant VERTSLIDER

:STRUCT TRStructure
	  APTR trs_Text			
	  APTR trs_Controls		
	  APTR trs_Window
	  APTR trs_MiddleText	
	  APTR trs_PositiveText	
	  APTR trs_NegativeText	
	  APTR trs_Title			
	  SHORT trs_KeyMask					
	  SHORT trs_textcolor		
	  SHORT trs_detailcolor	
	  SHORT trs_blockcolor		
	  SHORT trs_versionnumber	
	  USHORT trs_Timeout		
	  LONG trs_AbortMask						
	  USHORT trs_rfu1
;STRUCT


:STRUCT ExtendedColorRequester
	  LONG ecr_defcolor		
	  APTR ecr_window	
	  LONG ecr_rfu1			
	  LONG ecr_rfu2			
	  LONG ecr_rfu3			
	  LONG ecr_rfu4	
	  LONG ecr_rfu5
;STRUCT





0   constant GLNODEFAULTB
							
							
							

1  GLNODEFAULTB <<  constant GLNODEFAULTM


:STRUCT GetLongStruct
	  APTR gls_titlebar
	  LONG gls_defaultval
	  LONG gls_minlimit
	  LONG gls_maxlimit
	  LONG gls_result
	  APTR gls_window
	  SHORT gls_versionnumber	
	  LONG gls_flags			
	  LONG gls_rfu2			
;STRUCT



:STRUCT GetStringStruct
	  APTR gss_titlebar
	  APTR gss_stringbuffer
	  APTR gss_window
	  SHORT gss_stringsize			
	  SHORT gss_visiblesize		
	  SHORT gss_versionnumber		
	  LONG gss_flags
	  LONG gss_rfu1
	  LONG gss_rfu2
	  LONG gss_rfu3
;STRUCT


EXISTS? DSIZE NOT .IF	
130   constant DSIZE
30   constant FCHARS
.THEN 	

30   constant WILDLENGTH

0   constant FRQSHOWINFOB
1   constant FRQEXTSELECTB
2   constant FRQCACHINGB
3   constant FRQGETFONTSB
4   constant FRQINFOGADGETB
5   constant FRQHIDEWILDSB
6   constant FRQABSOLUTEXYB
7   constant FRQCACHEPURGEB
8   constant FRQNOHALFCACHEB
9   constant FRQNOSORTB
10   constant FRQNODRAGB
11   constant FRQSAVINGB
12   constant FRQLOADINGB
							
							
							
							
							
							
13   constant FRQDIRONLYB


1  FRQSHOWINFOB <<  constant FRQSHOWINFOM
1  FRQEXTSELECTB <<  constant FRQEXTSELECTM
1  FRQCACHINGB <<  constant FRQCACHINGM
1  FRQGETFONTSB <<  constant FRQGETFONTSM
1  FRQINFOGADGETB <<  constant FRQINFOGADGETM
1  FRQHIDEWILDSB <<  constant FRQHIDEWILDSM
1  FRQABSOLUTEXYB <<  constant FRQABSOLUTEXYM
1  FRQCACHEPURGEB <<  constant FRQCACHEPURGEM
1  FRQNOHALFCACHEB <<  constant FRQNOHALFCACHEM
1  FRQNOSORTB <<  constant FRQNOSORTM
1  FRQNODRAGB <<  constant FRQNODRAGM
1  FRQSAVINGB <<  constant FRQSAVINGM
1  FRQLOADINGB <<  constant FRQLOADINGM
1  FRQDIRONLYB <<  constant FRQDIRONLYM


:STRUCT ESStructure
	  APTR ess_NextFile
	  SHORT ess_NameLength			
	  SHORT ess_Pad
	  APTR ess_Node				
	( %?)   1 BYTES ess_thefilename		
;STRUCT

:STRUCT ReqFileRequester
	  USHORT rfr_VersionNumber				
	  APTR rfr_Title						
	  APTR rfr_Dir						
	  APTR rfr_File						
	  APTR rfr_PathName					
	  APTR rfr_Window			
	  USHORT rfr_MaxExtendedSelect			
	  USHORT rfr_numlines					
	  USHORT rfr_numcolumns					
	  USHORT rfr_devcolumns
	  ULONG rfr_Flags						
	  USHORT rfr_dirnamescolor			
	  USHORT rfr_filenamescolor			
	  USHORT rfr_devicenamescolor		
	  USHORT rfr_fontnamescolor			
	  USHORT rfr_fontsizescolor								
	  USHORT rfr_detailcolor			
	  USHORT rfr_blockcolor				
	  USHORT rfr_gadgettextcolor		
	  USHORT rfr_textmessagecolor		
	  USHORT rfr_stringnamecolor		
	  USHORT rfr_stringgadgetcolor							
	  USHORT rfr_boxbordercolor			
	  USHORT rfr_gadgetboxcolor			
	( %?)   18 2 *  BYTES rfr_FRU_Stuff											
	  STRUCT DateStamp	rfr_DirDateStamp								
	  USHORT rfr_WindowLeftEdge			
	  USHORT rfr_WindowTopEdge									
	  USHORT rfr_FontYSize				
	  USHORT rfr_FontStyle									
	  APTR rfr_ExtendedSelect
wildlength 2+ bytes rfr_hide
wildlength 2+ bytes rfr_show
	  SHORT rfr_FileBufferPos			
	  SHORT rfr_FileDispPos			
	  SHORT rfr_DirBufferPos			
	  SHORT rfr_DirDispPos				
	  SHORT rfr_HideBufferPos
	  SHORT rfr_HideDispPos
	  SHORT rfr_ShowBufferPos
	  SHORT rfr_ShowDispPos
	  APTR rfr_Memory
	  APTR rfr_Memory2					
	  APTR rfr_Lock
DSIZE 2+ BYTES rfr_PrivateDirBuffer								
	  APTR rfr_FileInfoBlock
	  SHORT rfr_NumEntries
	  SHORT rfr_NumHiddenEntries
	  SHORT rfr_filestartnumber
	  SHORT rfr_devicestartnumber
;STRUCT

:STRUCT ReqScrollStruct
	  ULONG rss_TopEntryNumber								
	  ULONG rss_NumEntries					
	  USHORT rss_LineSpacing			
	  ULONG rss_NumLines				
	  APTR rss_PropGadget	
APTR rss_redrawAll()						
APTR rss_readMore()							
APTR rss_ScrollAndDraw()
	  SHORT rss_versionnumber			
	  LONG rss_rfu1					
	  LONG rss_rfu2					
;STRUCT


:STRUCT chipstuff
20 bytes chs_ArrowUp
	( %?)   20 BYTES chs_ArrowDown		
	( %?)   18 BYTES chs_ArrowLeft		
	( %?)   18 BYTES chs_ArrowRight		
	( %?)   20 BYTES chs_Letter_R		
	( %?)   20 BYTES chs_Letter_G		
	( %?)   20 BYTES chs_Letter_B		
	( %?)   20 BYTES chs_Letter_H		
	( %?)   20 BYTES chs_Letter_S		
	( %?)   20 BYTES chs_Letter_V		
	;STRUCT

:STRUCT ReqLib
	  STRUCT Library rqlb_RLib
	  APTR rqlb_SysLib
	  APTR rqlb_DosLib
	  APTR rqlb_IntuiLib
	  APTR rqlb_GfxLib
	  APTR rqlb_SegList
	  APTR rqlb_Images
	  BYTE rqlb_Flags
	  BYTE rqlb_Pad
	  APTR rqlb_ConsoleDev
	  APTR rqlb_ConsoleHandle
	  APTR rqlb_RexxSysBase
;STRUCT

.THEN
