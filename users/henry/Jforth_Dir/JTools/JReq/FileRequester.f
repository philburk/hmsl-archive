\ File Requester using Cygnus Ed REQ.LIBRARY

include? task-req_support.f jreq:req_support.f

ANEW TASK-FileRequester.F

reqfilerequester myfreq
create freq-dir  DSIZE 2+ allot  freq-dir OFF
create freq-file FCHARS 2+ allot freq-file OFF
create freq-path DSIZE FCHARS + 2+ 2+ allot freq-path OFF

: FREQ.INIT
	req?
\ use 1+ to leave room for count byte
	freq-dir  1+  myfreq s! rfr_Dir
	freq-file 1+  myfreq s! rfr_File
	freq-path 1+  myfreq s! rfr_PathName
\
\ set colors
	1 myfreq s! rfr_filenamescolor
	3 myfreq s! rfr_dirnamescolor
;

: FREQ.TERM
    -req
;

: FIX.0STRING ( 0string -- , put count before !!! )
	0count swap 1- c!
;

: EZFILEREQ ( $messaGE -- $path true | false )
	freq.init
	count >dos
	dos0 myfreq s! rfr_title
	myfreq FileRequester()
	IF
		freq-dir 1+ fix.0string
		freq-file 1+ fix.0string
		freq-path 1+ fix.0string
		freq-path true
	ELSE
		false
	THEN
	freq.term
;

: INCL?  ( -- , include a file using the requester )
	" Select file to INCLUDE"    ezfilereq
	IF
		$include interpret
		>newline ." Compilation complete." cr
	THEN
;

." Installing INCL? on <FKEY-9>" cr

' incl? 9 fkey-vectors !

if.forgotten freq.term

: AUTO.TERM ( -- ) auto.term freq.term ;

