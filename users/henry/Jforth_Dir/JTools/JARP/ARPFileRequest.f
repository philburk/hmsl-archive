\ Access ARP File Requester
\ By Henry Lowengard, Nick Didkovsky, Phil Burk
\ -------------------------------------------------
\ Nick Didkovsky
\ File requester for Script Supervisor Spreadsheet
\ This code was pruned from Henry Lowengard's code.
\ It calls the ARP file requester quickly and easily from JForth Pro v2.0
\ Let me go on the record to say this file requester is great and I love it. 
\ -------------------------------------------------
\ Phil Burk
\ Modified for JForth Pro 2.1, 1/25/91

getmodule includes
\ include? LIBRARIES_ARPBASE_H jarp:ARP.j

anew task-arpfilerequester 

.NEED FileRequester    \ only load small part of ARP.J
( ************************* File Requester ***************************)
( **************** Submit the following to FileRequest[] *************)
( ********************************************************************)

32  constant FCHARS (  Filename size )
33  constant DSIZE (  Directory name size )

:STRUCT FileRequester
	APTR  fr_Hail		(  Hailing text			)
	APTR  fr_File		(  Filename array [FCHARS * N]	)
	APTR  fr_Dir		(  Directory array [DSIZE + 1]	)
	APTR  fr_Window	(  Window requesting files or NULL)
	BYTE  fr_FuncFlags		(  Set bitdef's below		)
	BYTE  fr_reserved1		(  Set to NULL			)
\ %? 	VOID	(*fr_Function)();	/* Your function, see bitdef's	*/	
	LONG  fr_Function		(  RESERVED			)
	LONG  fr_reserved2		(  RESERVED			)
;STRUCT 

.NEED ARP?
\ classic library stuff
:Library ARP
: Arp? ARP_NAME ARP_LIB LIB? ;
: -Arp ARP_LIB -LIB ;
arp?
if.forgotten -arp
.THEN

.NEED 0MOVE
: 0MOVE  ( 0string1 addr -- , move NUL terminated string to addr )
	>r 0count r> swap 1+ move
;
.THEN

FileRequester MyFileReq
create Chail 64 allot
create arp-filename FCHARS allot
create arp-dir	DSIZE Allot

\ Your end-users will love you if you remember the last path/file used by
\ this requester. ND
variable arp-def-dir DSIZE Allot
variable arp-def-file FCHARS allot

\ This is a JForth string,leading count byte, with path appended to filename
CREATE full-arp-filename FCHARS Dsize + Allot

\ This appends the two null-terminated strings for Dir and Filename
\ into one JForth-style string (leading count byte). 
\ Takes care of dirs within dirs within dirs, etc

: BUILD.FULL.NAME ( -- , concatenate directory and filename )
	full-arp-filename off
	arp-dir 0count ?dup
	IF
		full-arp-filename $append
\ add a '/' if no ':' at end
		full-arp-filename count + 1- c@ ascii : = not
		IF " /" count full-arp-filename $append
		THEN
	ELSE drop
	THEN
	arp-filename 0count full-arp-filename $append
;

: FileRequest() ( filereq -- flag )
	>Abs call arp_lib FileRequest
;

\ Loads selected directory name into string called arp-dir
\ Loads selected filename into string called arp-filename
\ Leaves a flag on the stack, if 0, then 'cancel' was hit by user.
\ Stores most recent dir in default dir, so you don't have to override
\ defaults more than once per session.	ND

: FileRequest ( 0prompt window|0 -- $file true | false )
	swap >abs MyFileReq ..! fr_Hail
\
\ set starting file
	arp-def-file arp-filename 0move
	arp-filename >abs MyFileReq ..! fr_File
\
\ set default directory
	arp-def-dir arp-dir 0move
	arp-dir >Abs MyFileReq ..! fr_dir
\
	if>abs MyFileReq ..! fr_Window	
	0 MyFileReq ..! fr_FuncFlags
	0 MyFileReq ..! fr_reserved1
	0 MyFileReq ..! fr_Function
	0 MyFileReq ..! fr_reserved2

\ This call leaves 0 on stack if cancel was hit. ND
	arp_lib @ 0=
	IF	arp?
		arp_lib @ 0=
		IF ." ARP Library not available!" cr false
		ELSE	MyFileReq fileRequest()
			-arp
		THEN
	ELSE	MyFileReq fileRequest()
	THEN
	
	IF
\ Update default dir and file names for the next time filerequest is used. ND
		arp-dir arp-def-dir 0move
		arp-filename arp-def-file 0move
\
\ appends dir and filename into one JForth string. ND
		build.full.name
		full-arp-filename c@ 0>
		IF full-arp-filename true
		ELSE false
		THEN
	ELSE
		false
	THEN
;

: GET.FILE ( -- $filename true | false )
	0" Load file..." 0 FileRequest
;

: PUT.FILE ( -- $filename true | false )
	0" Save file..." 0 FileRequest
;


