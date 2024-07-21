\ Support for the Cygnus Ed Requester Library
\ REQ.LIBRARY is a library that can be used in your applications
\ without royalties.  The only requirement is that you include
\ proper credit and the documentation with the library.
\ The complete system is available on Fred Fish disk #419
\
\ This JForth interface was developed by:
\	John Gangell, Martin Kees, and Phil Burk

getmodule includes
include? findtask() ju:exec_support
include? ReqFileRequester  JREQ:ReqBase.j

ANEW TASK-REQ_SUPPORT.f

\ Declare the Library control words
:LIBRARY REQ

: REQ? req_name req_lib lib?
;

: -REQ req_lib -lib
;
\ ----------------------------------------------

\ Support for setting and restoring the pr_windowptr
variable old-windowptr

: SET.WINDOWPTR  ( window -- oldwindowptr )
	0 findtask() dup s@ pr_windowptr >r
	s! pr_windowptr
	r>
;

: ColorRequester()  ( color -- result )
  call req_lib ColorRequester w->s
;

: GetString() ( buf title wind visible maxc --- flag )
  >r >r >r >r
  >abs 
  r> >abs r> if>abs r> r> call req_lib getstring
;

: FileRequester() ( frstruct -- success)
  call>abs req_lib FileRequester
;

: TextRequest()	( add of TRstructure -- 1|2|0 )	\ Tested Aok
	call>abs req_lib textrequest
;

