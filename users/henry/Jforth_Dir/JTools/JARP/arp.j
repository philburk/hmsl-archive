\ AMIGA JForth Include file.
\


include? :struct ju:c_struct
anew task-arp_j

EXISTS? LIBRARIES_ARPBASE_H NOT .IF 
: LIBRARIES_ARPBASE_H ;

( *********************************************************************)
(  *)
(  *	AmigaDOS Replacement Project [ARP] -- Library Include File 'C')
(  *)
(  **********************************************************************)
(  *)
(  *	History:)
(  *)
(  *	Version:	arpbase.h,v 34.00 02/27/88)
(  *)
(  *	Created by:	SDB)
(  *	Revised:	SDB -- Just bag earlier versions, since didn't have)
(  *			       time to maintain C header during 'the last days'.)
(  *			       Created this file mainly from arpbase.i.)
(  *)
(  *	Revised:	SDB -- Added stuff for version 32, ASyncRun[])
(  *			       returns and data structures.)
(  *			SDB -- Added ERROR_NO_CLI)
(  *			SDB -- Added final resident data structures,)
(  *			       final ASyncRun[] data structures, and)
(  *			       date. Final edits for V33.4 release.)
(  **********************************************************************)
(  *)
(  *)
(  *	Originally: Copyright [c] 1987, by Scott Ballantyne)
(  *)
(  *	The arp.library, and related code and files may be freely used)
(  *	by supporters of ARP.  Modules in the arp.library may not be)
(  *	extracted for us in independent code, but you are welcome to provide)
(  *	the arp.library with your work and call on it freely.)
(  *)
(  *	You are equally welcome to contribute new functions, improve the)
(  *	ones within, or suggest additions.)
(  *)
(  *	BCPL programs are not welcome to call on the arp.library.)
(  *	The welcome mat is out to all others.)
(  *)
(  ********************************************************************)

\  .THEN   \ %? Forced .THEN to prevent nesting!!!
\  EXISTS? EXEC_TYPES_H NOT .IF 
include? EXEC_TYPES_H ji:exec/types.j 
\  .THEN  

\ EXISTS? EXEC_LIBRARIES_H NOT .IF 
include? EXEC_LIBRARIES_H ji:exec/libraries.j 
\ .THEN  

\ EXISTS? EXEC_LISTS_H NOT .IF 
include? EXEC_LISTS_H ji:exec/lists.j 
\ .THEN  

\ EXISTS? EXEC_SEMAPHORES_H NOT .IF 
include? EXEC_SEMAPHORES_H ji:exec/semaphores.j 
\ .THEN  

\ EXISTS? LIBRARIES_DOS_H NOT .IF 
include? LIBRARIES_DOS_H ji:libraries/dos.j 
\ .THEN  

(  arp.library's node structure, not too hefty even now. )

:STRUCT ArpBase
	STRUCT Library	LibNode	(  Standard library node	)
	LONG SegList	(  Pointer to loaded libcode	)
	BYTE Flags		(  Not used, yet!		)
	BYTE ESCChar	(  Character used for escaping	)
	LONG ArpReserved1	(  ArpLib's use only!		)
	APTR EnvBase	(  Dummy library for MANX compatibility )
	APTR DosBase	(  Dos library pointer		)
	APTR GfxBase	(  Graphics lib pointer		)
	APTR IntuiBase	(  Intuition lib pointer	)
	STRUCT MinList	ResLists	(  Resource trackers		)
	APTR ResidentPrgList (  Installed programs )
	STRUCT SignalSemaphore ResPrgProtection (  Protection for above )
;STRUCT 

(  Following is here *only* for information and for compatibility)
(  * with MANX, don't use in new code!)
(  )

:STRUCT EnvBase
	STRUCT Library	LibNode	(  Standard library node for linkage )
	APTR EnvSpace	(  Access only when Forbidden! )
	LONG EnvSize	(  Total allocated mem for EnvSpace )
	APTR ArpBase	(  Added in V32 for Resource Tracking )
;STRUCT 

(  These are used in release 33.4, but not by the library code. Instead,)
(  * individual programs check for these flags. Not ideal, but such is life.)
(  *)
(  )

0 CONSTANT ARPB_WILD_WORLD
1 CONSTANT ARPB_WILD_BCPL

1 0 << constant ARPF_WILD_WORLD
1 1 << constant ARPF_WILD_BCPL

( ************** C SPECIFIC STUFF ************************************)
(  There are a few things in arp.library that are only directly acessable)
(  * from assembler.  The glue routines provided by us for all 'C' compilers)
(  * use the following conventions to make these available to C programs.)
(  * The glue for other language's should use as similar a mechanism as)
(  * possible, so that no matter what language or compiler we speak, when)
(  * talk about arp, we will know what the other guy is saying.)
(  *)
(  * Here are the cases:)
(  *	Atol[] - if a bad digit is encountered, will store a ERRBADINT in)
(  *		 Errno, the return from Atol[] will be the bad character)
(  *		 encountered.  Note: Atol[] will not clear Errno if return)
(  *		 is successful.)
(  *	Trackers: All tracking calls return the Tracker pointer in A1 as a)
(  *		  secondary result, you can obtain this from the global)
(  *		  variable LastTracker immediately after the call.)
(  * Finally, GetTracker[] syntax is differnt for C and assembler, for 'C')
(  * the Syntax is GetTraker[ ID ], the binding routine will store the ID)
(  * into the tracker on return.)
(  *)
(  * In cases where you have allocated a tracker before you have obtained a)
(  * resource [usually the most efficient method], and the resource has not)
(  * been obtained, you will need to clear the tracker id.  The macro CLEAR_ID[])
(  * has been provided for that purpose.  It expects a pointer to a DefaultTracker)
(  * sort of struct.)
(  *)
(  )

\ %? extern LONG Errno;	/* Error returns not reportable by functions */ 
\ %? extern struct DefaultTracker *LastTracker;	/* Look here after a tracking call */ 
1  constant ERRBADINT (  Atol[] could not convert string to number )

\ %? #define CLEAR_ID( t )	((SHORT *) t)[-1] = NULL: CLEAR_ID ;

( )
(  * Non controversial, normal library style stuff)
(  )

\ %? #define ArpName		"arp.library"		/* Name to use when opening */
34  constant ArpVersion (  Current version of arplib )


( )
(  * The alert object is what you use if you really must return an )
(  * alert to the user. You would normally OR this with another alert number)
(  * from the alerts.h file, generally, these should be NON deadend alerts.)
(  *)
(  * For example, if you can't open ArpLibrary:)
(  *	Alert[ [AG_OpenLib|AO_ArpLib], 0L];)
(  *)
(  )
$ 00008036  constant AO_ArpLib (  Alert object )

( )
(  * Alerts that arp.library can return.)
(  )

$ 03600000  constant AN_ArpLib (  Alert number			)
$ 03610000  constant AN_ArpNoMem (  No more memory		)
$ 03610002  constant AN_ArpInputMem (  No memory for input buffer	)
$ 83610003  constant AN_ArpNoMakeEnv (  No memory to make EnvLib	)

$ 83630001  constant AN_ArpNoDOS (  Can't open DOS		)
$ 83630002  constant AN_ArpNoGfx (  Can't open graphics.library	)
$ 83630003  constant AN_ArpNoIntuit (  Can't open intuition		)
$ 83640000  constant AN_BadPackBlues (  Bad packet returned to SendPacket[]	)
$ 83600003  constant AN_Zombie (  Zombie roaming around system )

$ 83600002  constant AN_ArpScattered (  Scatter loading not allowed for arp )

(  Return codes you can get from calling arp.library's Assign[] function )

0  constant ASSIGN_OK (  Everything is cool and groovey )
1  constant ASSIGN_NODEV (  "Physical" is not valid for assignment )
2  constant ASSIGN_FATAL (  Something really icky happened )
3  constant ASSIGN_CANCEL (  Tried to cancel something but it won't cancel )

(  Size of buffer you need if you are going to call ReadLine[] )

256  constant MaxInputBuf

( ************************* File Requester ***************************)
( **************** Submit the following to FileRequest[] *************)
( ********************************************************************)

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

(  The following are the defines for fr_FuncFlags.  These bits tell)
(  * FileRequest[] what your fr_UserFunc is expecting, and what FileRequest[])
(  * should call it for.)
(  *)
(  * You are called like so:)
(  * fr_Function[Mask, Object])
(  * ULONG	Mask;)
(  * CPTR		*Object;)
(  *)
(  * The Mask is a copy of the flag value that caused FileRequest[] to call)
(  * your function. You can use this to determine what action you need to)
(  * perform, and exactly what Object is, so you know what to do and)
(  * what to return.)
(  )

7  constant FRB_DoWildFunc (  Call me with a FIB and a name, ZERO return accepts. )
6  constant FRB_DoMsgFunc (  You get all IDCMP messages not for FileRequest[] )
5  constant FRB_DoColor (  Set this bit for that new and different look )
4  constant FRB_NewIDCMP (  Force a new IDCMP [only if fr_Window != NULL] )
3  constant FRB_NewWindFunc (  You get to modify the newwindow structure. )
2  constant FRB_AddGadFunc (  You get to add gadgets. )
1  constant FRB_GEventFunc (  Function to call if one of your gadgets is selected. )
0  constant FRB_ListFunc (  Not implemented yet. )

1 7 << constant FRF_DoWildFunc
1 6 << constant FRF_DoMsgFunc
1 5 << constant FRF_DoColor
1 4 << constant FRF_NewIDCMP
1 3 << constant FRF_NewWindFunc
1 2 << constant FRF_AddGadFunc
1 1 << constant FRF_GEventFunc
1 0 << constant FRF_ListFunc

32  constant FCHARS (  Filename size )
33  constant DSIZE (  Directory name size )

$ 7680  constant FR_FIRST_GADGET (  User gadgetID's must be less than this value )

( ***********************************************************************)
( ********************* PATTERN MATCHING ********************************)
( ***********************************************************************)

(  Structure expected by FindFirst[], FindNext[] )
( )
(  * You need to allocate this structure and initialize it as follows:)
(  *)
(  * Set ap_BreakBits to the signal bits [CDEF] that you want to take a)
(  * break on, or NULL, if you don't want to convenience the user.)
(  *)
(  * if you want to have the FULL PATH NAME of the files you found, allocate)
(  * a buffer at the END of this structure, and put the size of it into)
(  * ap_Length.  If you don't want the full path name, make sure you set)
(  * ap_Length to zero.  In this case, the name of the file, and stats are)
(  * available in the ap_Info, as per usual.)
(  *)
(  * Then call FindFirst[] and then afterwards, FindNext[] with this structure.)
(  * You should check the return value each time [see below] and take the)
(  * appropriate action, ultimately calling FreeAnchorChain[] when there)
(  * are no more files and you are done.  You can tell when you are done by)
(  * checking for the normal AmigaDOS return code ERROR_NO_MORE_ENTRIES.)
(  *)
(  * You will also have to check the DirEntryType variable in the ap_Info)
(  * structure to determine what exactly you have received.)
(  )

:STRUCT AnchorPath
	APTR ap_Base	(  Pointer to first anchor )
	APTR ap_Last	(  Pointer to last anchor )
	LONG ap_BreakBits	(  Bits to break on )
	LONG ap_FoundBreak	(  Bits we broke on. Also returns ERROR_BREAK )
	LONG ap_Length	(  Actual size of ap_Buf, set to 0 if no ap_Buf )
	STRUCT FileInfoBlock	ap_Info
        BYTE ap_Buf
;STRUCT 
( )
(  * structure used by the pattern matching functions, no need to obtain, diddle)
(  * or allocate this yourself.)
(  )

:STRUCT Anchor
	APTR an_Next
	APTR an_Pred
	APTR an_Lock
	APTR an_Info
	LONG an_Status		(  Type of this anchor node )
\ %? 	union { 
		SHORT an_Text	(  Actual instance of a BSTRing )
		( %?) 2 BYTES an_Actual	(  more memory allocated as required )
\ %? 	} an_BSTR; 
;STRUCT 
(  This structure takes a pointer, and returns FALSE if wildcard was not)
(  * found by FindFirst[])
(  )
\ %? #define IsWild( ptr )		( *((LONG *)(ptr)) ): IsWild ;

(  Constants used by wildcard routines )
(  These are the pre-parsed tokens referred to by pattern match.  It is not)
(  * necessary for you to do anything about these, FindFirst[] FindNext[])
(  * handle all these for you.)
(  )

$ 80  constant P_ANY (  Token for '*' or '#?' )
$ 81  constant P_SINGLE (  Token for '?' )
$ 82  constant P_ORSTART (  Token for '[' )
$ 83  constant P_ORNEXT (  Token for '|' )
$ 84  constant P_OREND (  Token for ']' )
$ 85  constant P_TAG (  Token for '{' )
$ 86  constant P_TAGEND (  Token for '}' )
$ 87  constant P_NOTCLASS (  Token for '^' )
$ 88  constant P_CLASS (  Token for '[]' )
$ 89  constant P_REPBEG (  Token for '[' )
$ 8A  constant P_REPEND (  Token for ']' )

(  Values for an_Status, NOTE: these are the actual bit numbers. )
1  constant COMPLEX_BIT (  Parsing complex pattern )
2  constant EXAMINE_BIT (  Searching directory )

(  Returns from FindFirst[] FindNext[] )
(  Note that you can also get return codes as defined in dos.h,)
(  * particularly you can get ERROR_NO_MORE_ENTRIES.)
(  )

303  constant ERROR_BUFFER_OVERFLOW (  User or internal buffer overflow )
304  constant ERROR_BREAK (  A break character was received )

(  Structure used by AddDANode[], AddDADevs[], FreeDAList[].)
(  *)
(  * This structure is used to create lists of names, which normally)
(  * are devices, assigns, volumes, files, or directories.)
(  )

:STRUCT DirectoryEntry
	APTR  de_Next	(  Next in list )
	BYTE  de_Type			(  DLX_mumble )
	BYTE  de_Flags		(  For future expansion, DO NOT USE! )
        BYTE de_Name
;STRUCT 

(  Defines you use to get a list of the devices you want to look at.)
(  * For example, to get a list of all directories and volumes, do:)
(  *)
(  *	AddDADevs[ mydalist, [DLF_DIRS | DLF_VOLUMES] ])
(  *)
(  * After this, you can examine the de_type field of the elements added to)
(  * your list [if any] to discover specifics about the objects added.)
(  *)
(  * Note that if you want only devices which are also disks, you must request)
(  * [DLF_DEVICES | DLF_DISKONLY].)
(  )

0  constant DLB_DEVICES (  Return devices )
1  constant DLB_DISKONLY (  Modifier for above: Return disk devices only )
2  constant DLB_VOLUMES (  Return volumes only )
3  constant DLB_DIRS (  Return assigned devices only )

1 0 << constant DLF_DEVICES
1 1 << constant DLF_DISKONLY
1 2 << constant DLF_VOLUMES
1 3 << constant DLF_DIRS

(  Legal de_Type values, check for these after a call to AddDADevs[], or use)
(  * on your own as the ID values in AddDANode[].)
(  )

0  constant DLX_FILE (  AddDADevs[] can't determine this )
8  constant DLX_DIR (  AddDADevs[] can't determine this )
16  constant DLX_DEVICE (  It's a resident device )

24  constant DLX_VOLUME (  Device is a volume )
32  constant DLX_UNMOUNTED (  Device is not resident )

40  constant DLX_ASSIGN (  Device is a logical assignment )

( *******************************************************************)
( ********************* RESOURCE TRACKING ***************************)
( *******************************************************************)

(  Note: ResList MUST be a DosAllocMem'ed list!, this is done for)
(  * you when you call CreateTaskResList[], typically, you won't need)
(  * to access/allocate this structure.)
(  )

:STRUCT ResList
	STRUCT MinNode	 rl_Node	(  Used by arplib to link reslist's )
	APTR  rl_TaskID	(  Owner of this list )
	STRUCT MinList	 rl_FirstItem	(  List of TrackedResource's )
	APTR  rl_Link	(  SyncRun's use - hide list here )
;STRUCT 
( )
(  * The rl_FirstItem list [above] is a list of TrackedResource [below].)
(  * It is very important that nothing in this list depend on the task)
(  * existing at resource freeing time [i.e., RemTask[0L] type stuff,)
(  * DeletePort[] and the rest].)
(  *)
(  * The tracking functions return a struct Tracker *Tracker to you, this)
(  * is a pointer to whatever follows the tr_ID variable.)
(  * The default case is reflected below, and you get it if you call)
(  * GetTracker[] [ see DefaultTracker below].)
(  *)
(  * NOTE: The two user variables mentioned in an earlier version don't)
(  * exist, and never did. Sorry about that [SDB].)
(  *)
(  * However, you can still use ArpAlloc[] to allocate your own tracking nodes)
(  * and they can be any size or shape you like, as long as the base structure)
(  * is preserved. They will be freed automagically just like the default trackers.)
(  )

:STRUCT TrackedResource
	STRUCT MinNode	tr_Node	(  Double linked pointer )
	BYTE tr_Flags	(  Don't touch )
	BYTE tr_Lock	(  Don't touch, for Get/FreeAccess[] )
	SHORT tr_ID		(  Item's ID )
	( )
( 	 * The struct DefaultTracker *Tracker portion of the structure.)
( 	 * The stuff below this point can conceivably vary, depending)
( 	 * on user needs, etc.  This reflects the default.)
( 	 )
	union{ 
                LONG  tr_Resource
                LONG tg_Verify	(  For use during TRAK_GENERIC )
	}UNION{
\ %? 	} tr_Object;			/* The thing being tracked */ 
\ %? 	union { 
\ %? 		VOID	(*tg_Function)(); /* Function to call for TRAK_GENERIC */	
		LONG tg_Function  ( Function to call for TRAK_GENERIC )	
		APTR tr_Window2	(  For TRAK_WINDOW )
\ %? 	} tr_Extra;				/* Only needed sometimes */ 
	}UNION
;STRUCT 

tg_Verify  constant tg_Value (  Ancient compatibility )

(  You get a pointer to a struct of the following type when you call)
(  * GetTracker[].  You can change this, and use ArpAlloc[] instead of)
(  * GetTracker[] to do tracking. Of course, you have to take a wee bit)
(  * more responsibility if you do, as well as if you use TRAK_GENERIC)
(  * stuff.)
(  *)
(  * TRAK_GENERIC folks need to set up a task function to be called when an)
(  * item is freed.  Some care is required to set this up properly.)
(  *)
(  * Some special cases are indicated by the unions below, for TRAK_WINDOW,)
(  * if you have more than one window opened, and don't want the IDCMP closed)
(  * particularly, you need to set a ptr to the other window in dt_Window2.)
(  * See CloseWindowSafely[] for more info.  If only one window, set this to NULL.)
(  *)
(  )

:STRUCT DefaultTracker
\ %? 	union { 
 	union{ 
               LONG dt_Resource
		LONG tg_Verify	(  For use during TRAK_GENERIC )
\ %? 	} dt_Object;			/* The object being tracked */ 
\ %? 	union {
	}UNION{ 
\ %? 		VOID	(*tg_Function)();  /* Function to call for TRAK_GENERIC */	
 		LONG tg_Function  ( Function to call for TRAK_GENERIC )	
		APTR dt_Window2	(  For TRAK_WINDOW )
\ %? 	} dt_Extra; 
	}Union
;STRUCT 

(  Items the tracker knows what to do about )

0  constant TRAK_AAMEM (  Default [ArpAlloc] element )
1  constant TRAK_LOCK (  File lock )
2  constant TRAK_FILE (  Opened file )
3  constant TRAK_WINDOW (  Window -- see docs )
4  constant TRAK_SCREEN (  Screen )
5  constant TRAK_LIBRARY (  Opened library )
6  constant TRAK_DAMEM (  Pointer to DosAllocMem block )
7  constant TRAK_MEMNODE (  AllocEntry[] node )
8  constant TRAK_SEGLIST (  Program segment )
9  constant TRAK_RESLIST (  ARP [nested] ResList )
10  constant TRAK_MEM (  Memory ptr/length )
11  constant TRAK_GENERIC (  Generic Element, your choice )
12  constant TRAK_DALIST (  DAlist [ aka file request ] )
13  constant TRAK_ANCHOR (  Anchor chain [pattern matching] )
13  constant TRAK_MAX (  Poof, anything higher is tossed )   

7  constant TRB_UNLINK (  Free node bit )
6  constant TRB_RELOC (  This may be relocated [not used yet] )
5  constant TRB_MOVED (  Item moved )

1 7 << constant TRF_UNLINK
1 6 << constant TRF_RELOC
1 5 << constant TRF_MOVED

(  Returns from CompareLock[] )
0  constant LCK_EQUAL (  The two locks refer to the same object )
1  constant LCK_VOLUME (  Locks are on the same volume )
2  constant LCK_DIFVOL1 (  Locks are on different volumes )
3  constant LCK_DIFVOL2 (  Locks are on different volumes )

( ***************************** ASyncRun[] **************************)
( )
(  * Message sent back on your request by an exiting process.)
(  * You request this by putting the address of your message in pcb_LastGasp,)
(  * and initializing the ReplyPort variable of your ZombieMsg to the)
(  * port you wish the message posted to.)
(  )

:STRUCT ZombieMsg
	STRUCT Message	zm_ExecMessage
	LONG zm_TaskNum		(  Task ID )
	LONG zm_ReturnCode		(  Process's return code )
	LONG zm_Result2		(  System return code )
	STRUCT DateStamp zm_ExitTime	(  Date stamp at time of exit )
	LONG zm_UserInfo		(  For whatever you wish. )
;STRUCT 

(  Structure required by ASyncRun[] -- see docs for more info. )

:STRUCT ProcessControlBlock
	LONG pcb_StackSize		(  Stacksize for new process )
	BYTE pcb_Pri		(  Priority of new task )
	BYTE pcb_Control		(  Control bits, see defines below )
	APTR pcb_TrapCode		(  Optional Trap Code )
	LONG pcb_Input
LONG p_Output	(  Optional stdin, stdout )
\ %? 	union { 
		LONG pcb_SplatFile	(  File to use for Open["*"] )
		APTR pcb_ConName	(  CON: filename )
\ %? 	} pcb_Console; 
	LONG pcb_SplatFile		(  File to use for Open["*"] )
        LONG pcb_LoadedCode
	APTR pcb_LastGasp	 (  ReplyMsg[] to be filled in by exit )
	APTR pcb_WBProcess	(  Valid only when PRB_NOCLI )
;STRUCT 

(  Some programs appear to have bugs in the startup code that does not handle)
(  * well a zero length command line [lattice startup has this, but is probably)
(  * not unique].  Use this macro to pass a null cmd line to a process using)
(  * either ASyncRun[] or SyncRun[])
(  )

\ %? #define NOCMD	"\n"

(  The following control bits determine what ASyncRun[] does on Abnormal Exits)
(  * and on background process termination. )
(  )

0  constant PRB_SAVEIO (  Don't free/check file handles on exit )
1  constant PRB_CLOSESPLAT (  Close Splat file, must request explicitly )
2  constant PRB_NOCLI (  Don't create a CLI process )
3  constant PRB_INTERACTIVE (  This should be interactive )
4  constant PRB_CODE (  Dangerous yet enticing )
5  constant PRB_STDIO (  Do the stdio thing, splat = CON:Filename )

1 0 << constant PRF_SAVEIO
1 1 << constant PRF_CLOSESPLAT
1 2 << constant PRF_NOCLI
1 3 << constant PRF_INTERACTIVE
1 4 << constant PRF_CODE
1 5 << constant PRF_STDIO

(  Error returns from SyncRun[] and ASyncRun[] )
-1  constant PR_NOFILE (  Could not LoadSeg[] the file )
-2  constant PR_NOMEM (  No memory for something )
-3  constant PR_NOCLI (  Only SyncRun[] will fail if call not cli )
-4  constant PR_NOSLOT (  No room in TaskArray )
-5  constant PR_NOINPUT (  Could not open input file )
-6  constant PR_NOOUTPUT (  Could not get output file )
-7  constant PR_NOLOCK (  Could not get a lock )
-8  constant PR_ARGERR (  Bad argument to ASyncRun[] )
-9  constant PR_NOBCPL (  Bad program passed to ASyncRun[] )
-10  constant PR_BADLIB (  Bad library version )
-11  constant PR_NOSTDIO (  Couldn't get stdio handles )

(  Programs should return this as result2 if need a cli and don't have one. )

400  constant ERROR_NOT_CLI (  Program/function neeeds to be cli )

( ******************* Resident Program Support ****************************)
( )
(  * This is the kind of node allocated for you when yhou AddResidentPrg[] a code)
(  * segment.  They are stored as a single linked list with the root in)
(  * ArpBase.  If you absolutely *must* wander through this list instead of)
(  * using the supplied functions, then you must first obtain the semaphore)
(  * which protects this list, and then release it afterwards.)
(  * Do not use Forbid[] and Permit[] to gain exclusive access!)
(  * Note that the supplied functions handle this locking protocol for you.)
(  )

:STRUCT ResidentPrgNode
	APTR  rpn_Next	(  next or NULL )
	LONG  rpn_Usage	(  Number of current users )
	LONG  rpn_CheckSum	(  Checksum of code )
	LONG  rpn_Segment	(  Actual segment )
       byte rpn_Name
;STRUCT 


(  If your program starts with this structure, ASyncRun[] and SyncRun[] will)
(  * override a users stack request with the value in rpt_StackSize.)
(  * Furthermore, if you are actually attached to the resident list, a memory)
(  * block of size rpt_DataSize will be allocated for you, and)
(  * a pointer to this data passed to you in register A4.  You may use this)
(  * block to clone the data segment of programs, thus resulting in one)
(  * copy of text, but multiple copies of data/bss for each process)
(  * invocation.  If you are resident, your program will start at)
(  * rpt_Instruction, otherwise, it will be launched from the initial branch.)
(  )

:STRUCT ResidentProgramTag
	LONG rpt_NextSeg	(  Provided by DOS at LoadSeg time. )
	SHORT rpt_BRA	(  Short branch to executable )
	SHORT rpt_Magic	(  Resident majik value )
	LONG rpt_StackSize	(  min stack for this process )
	LONG rpt_DataSize	(  Data size to allocate if resident )
	(  	rpt_Instruction; /* Start here if resident )
;STRUCT 
( )
(  * The form of the ARP allocated node in your tasks memlist when launched)
(  * as a resident program. Note that the data portion of the node will only)
(  * exist if you have specified a nonzero value for rpt_DataSize. Note also)
(  * that this structure is READ ONLY, modify values in this at your own)
(  * risk.  The stack stuff is for tracking, if you need actual addresses)
(  * or stack size, check the normal places for it in your process/task struct.)
(  )
:STRUCT ProcessMemory
	STRUCT Node	pm_Node
	SHORT pm_Num		(  This is 1 if no data, two if data )
        LONG pm_Stack
	LONG pm_StackSize
        LONG pm_Data
	LONG pm_DataSize
;STRUCT 

(  To find the above on your memlist, search for the following name.)
(  * We guarantee this will be the only arp.library allocated node on)
(  * your memlist with this name, i.e. FindName[task->tcb_MemEntry, PMEM_NAME];)
(  )
\ %? #define PMEM_NAME	"ARP_MEM"

$ 4AFC  constant RESIDENT_MAGIC (  same as RTC_MATCHWORD [trapf] )

(  The initial branch destination and rpt_Instruction do not have to be the same.)
(  * This allows different actions to be taken if you are diskloaded or)
(  * resident. DataSize memory will be allocated only if you are resident,)
(  * but StackSize will override all user stack requests.)
(  )

( ********************** String/Data structures ************************)

:STRUCT DateTime
	STRUCT DateStamp dat_Stamp	(  DOS Datestamp )
	BYTE dat_Format	(  controls appearance ot dat_StrDate )
	BYTE dat_Flags	(  See BITDEF's below )
	APTR dat_StrDay	(  day of the week string )
	APTR dat_StrDate	(  date string )
	APTR dat_StrTime	(  time string )
;STRUCT 

(  Size of buffer you need for each DateTime strings: )
10  constant LEN_DATSTRING

(  For dat_Flags )

0  constant DTB_SUBST (  Substitute "Today" "Tomorrow" where appropriate )
1  constant DTB_FUTURE (  Day of the week is in future )

1 0 << constant DTF_SUBST
1 1 << constant DTF_FUTURE

(  For dat_Format )
0  constant FORMAT_DOS (  dd-mmm-yy AmigaDOS's own, unique style )
1  constant FORMAT_INT (  yy-mm-dd International format )
2  constant FORMAT_USA (  mm-dd-yy The good'ol'USA.	)
3  constant FORMAT_CDN (  dd-mm-yy Our brothers and sisters to the north )
FORMAT_CDN  constant FORMAT_MAX (  Larger than this? Defaults to AmigaDOS )
.THEN

