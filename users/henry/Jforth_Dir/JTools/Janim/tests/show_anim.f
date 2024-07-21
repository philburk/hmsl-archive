\ Animation Demo
\
\ Read an animation from a file and display it.
\
\ Author: Phil Burk
\ Copyright 1991 Delta Research

include? tolower ju:char-macros
\ include? ANIM.LOAD janim:load_anim

anew TASK-SHOW_ANIM

animation sa-anim
variable DELAY-N-FRAMES
variable SA-LOOP?
variable SA-DISK?  \ animation kept on disk?

64 constant SA_NAME_SIZE
create SA-FILENAME sa_name_size 2+ allot  \ room for big filenames

: SA.HELP ( -- , print usage information )
	." Usage: SHOW.ANIM filename {-w ticks} {-l} {-d}" cr
	."    -w n  = wait N ticks between frames" cr
	."    -l    = loop continuously" cr
	."    -d    = read ANIM off of disk while playing"
	cr
	." For example: SHOW.ANIM anim:jogger.anim -w 8 -l" cr
	." Hit <RETURN> or Closebox to stop." cr
;

: SA.PARSE.OPTION ( char -- , handle specific options )
	CASE
		ascii w   \  for "-w nnn"  WAIT
		OF
			bl word number?
			IF 
				drop 0 max 1000 min  \ limit to 1000 ticks/frame
				delay-n-frames !
			ELSE
				>newline $type ."  not a valid delay." cr
			THEN
		ENDOF
\
		ascii l   \ LOOP
		OF
			sa-loop? on
		ENDOF
\
		ascii d   \ DISK
		OF
			sa-disk? on
		ENDOF
\
\ fell CASE through so must be illegal
		dup emit ."  = invalid option!" cr
		sa.help
	ENDCASE
;

: SA.PARSE.LINE ( <command line> -- error? , get options )
\
\ read and save filename
	FILEWORD dup c@ sa_name_size >
	IF
		." Filename too long!" cr
		goto.error
	THEN
	dup c@ 0= ?goto.error
	sa-filename $move
\
	1 delay-n-frames !
	sa-loop? off
	sa-disk? off
\
	BEGIN
		bl word   \ get next word from command line
		dup c@ 0> \ not at end?
	WHILE
		dup c@ 2 =           \ Is it two characters
		over 1+ c@ ascii - = AND \ and does it start with a '-'?
		IF
			2+ c@ tolower \ convert option char to lower case
			sa.parse.option
		ELSE
			>Newline $TYPE ."  = invalid option!" cr
			drop
			goto.error
		THEN
	REPEAT
	drop
	false
	exit
ERROR:
	sa.help
	true
;

: SA.DELAY ( -- , delay N frames )
	delay-n-frames @ wait.frames
;

: SHOW.ANIM ( <filename> {-d delay} {-l} -- )
	gr.init
\
	>newline
	." SHOW.ANIM V1.0 by Phil Burk & Martin Kees, written in JForth." cr
\
	sa.parse.line ?goto.error
\
	sa-filename sa-anim
	sa-disk? @
	IF
		$anim.disk.load? ?goto.error \ reads filename from input line
	ELSE
		$anim.load? ?goto.error \ reads filename from input line
	THEN
\
	sa-anim anim.stats
\
	what's anim.delay
	' sa.delay is anim.delay  \ set delay vector to my word
	sa-loop? @ sa-anim anim.play
	is anim.delay  \ restore delay vector
\
ERROR:
	sa-anim anim.free
	gr.term
;

cr sa.help cr

