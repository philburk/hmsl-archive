\ JForth source file, ©1991, Delta Research

0 .IF

	This file defines some handy utilities for saving the actual
	contents of string areas, such as HERE and PAD.  The strings are
	saved in "stringframe"s which are only significant internally,
	but here explained for informational purposes.  Were they a real
	"structure", they would be of the form:
	
		:struct StringFrame
			long		sf_Dummy	\ to hold the TOS value '0'
			byte		sf_Count	\ for the counted string
			xx bytes	sf_Text		\ the characters
			long		sf_Padding  \ usually appended for ALIGNment
		;struct
	
	(Note the dummy 0 to go in tos.  This insures the count and string
	 are out in real memory, at (dsp), so the internal code can
	 use operators like MOVE and C@ on it.)
	 
	PUSHSTRING ( $adr -- stringframe, save a copy of the $ on the stack )
	
	PULLSTRING ( stringframe $adr -- , string to adr & drop from stack )
	
	Note that since stringframes are of variable length, it is very
	difficult to get data OVER them (like normally done with OVER,
	ROT, PICK etc.).  For this reason, it is advisable to save your
	stringframes below your other data, and uncover it when you
	want to "PULL" it.  For example, with a routine that takes
	one argument...
	
		: MYWORD  ( n1 -- )
		  >r               \ save n1 on return stack
		  here PUSHSTRING  \ save string that is at HERE
		  r>               \ get n1 back
		  <whatever>       \ do whatever changes HERE with n1
		  here PULLSTRING  \ restore the string at HERE
		;

.THEN

anew task-Strings.f

: PushString  ( $ -- stringframe )
  dup>r  c@ 2+ cell/ 2+  0
  DO
     0  \ allocate the spsce in real mem (on the data stack)
  LOOP
  r> dup c@ 2+ sp@ [ 2 cells ] literal + swap  move
;

: PullString ( stringframe adr -- )
  >r
  sp@ dup c@ 2+ r@ swap  move
  sp@ c@ 2+ cell/ 2+ 0  \ must be exact calculation used above
  DO
     drop
  LOOP
  rdrop
;


