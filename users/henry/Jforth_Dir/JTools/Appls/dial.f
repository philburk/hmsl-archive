\ Fast Dial Telephone Utility
\ Uses a Hayes Modem connected to the serial port.
\
\ This program reads a file containing names and numbers
\ looking for a match. If it matches then it dials the number.
\
\ Author: Phil Burk
\ Copyright 1991 Phil Burk
\ All Rights Reserved.

include? dolines ju:dolines

ANEW TASK-DIAL.F

create PERSON-NAME 32 allot    \ place to hold name
create &0D $ 0D c, 0 c,  \ fwrite requires a string in memory

variable DIAL-DONE
variable SER-FILEID

: DELAY() ( ticks -- , wait )
	callvoid dos_lib delay
;

: DIAL.HELP  ( -- )
	cr
	." Usage:" cr
	."   to dial by name:    DIAL name {filename}" cr
	."   to dial by number:  DIAL ###-####" cr
	."   to add name:        DIAL ADD name ###-#### {filename}" cr
	cr
	." Default filename is S:PHONELIST" cr
	." File should contain lines with:   name ###-####" cr
	." Use Hayes compatible modem." cr
	." Set Serial Preferences appropriately." cr
	." For optional filenames make an alias for speed:" cr
	."     ALIAS DL DIAL [] DH0:PHONELIST" cr
;

: SER.TYPE ( addr count -- , echo string and send it to modem )
	2dup type
	ser-fileid @ -rot fwrite drop \ no error check!
;

: SER.CR ( -- , carriage return )
	cr
	&0d 1 ser.type
;

: (DIAL.STRING)  ( addr count -- , dial number in string )
	ser.cr
	20 delay()
	" AT DT " count ser.type  ( dial using touch tone )
	ser.type
	" ;" count ser.type  \ ';' so modem returns to command mode
	ser.cr
	f:3 ." Pick up phone!" cr f:1
	8 60 * delay()  \ delay a few seconds , may need to be extended
	" AT H" count ser.type ser.cr  ( hang up modem so phone is not stuck )
	." Modem disconnected." cr
;

: DIAL.STRING  ( addr count -- , dial number in string )
	" SER:" $fopen ?dup  ( open serial port as file )
	IF
		ser-fileid !
		(dial.string)
		ser-fileid @ fclose
	ELSE ." Serial port could not be opened!" cr 2drop
	THEN
;
    	
: DIAL.LINE?  ( $line -- , phone if match at beginning of line )
	dup c@
	person-name c@ >  ( line longer then name )
	IF
		dup 1+ person-name count swap text=?  ( does it match )
		IF
			dial-done @  ( have we already dialed )
			IF
				." Duplicate entries!" cr
			ELSE
				( skip over name to number )
				dup count bl skip bl scan
				dial.string  dial-done on
			THEN
		THEN
	THEN
	drop
;

: CHECK.NUMBER  ( $string -- flag , OK if all digits or - or (  or )
	spare on
	count 0
	DO
		dup i + c@ ( get char )
		dup ascii 0 ascii 9 within? not
		IF
			dup ascii ( = not
			IF
				dup ascii ) = not
				IF
					dup ascii - = not
					IF
						drop spare off LEAVE
					THEN
				THEN
			THEN
		THEN
		drop
	LOOP
	drop
	spare @
;

: GET.FILENAME  ( {filename} -- )
	fileword dup c@ 0=
	IF drop " S:PHONELIST"
	THEN
;

: (DIAL)  ( <filename> -- , dial name in person-name )
	' noop is doline.error
	' dial.line? is doline
	dial-done off
	get.filename $dolines
	dial-done @ 0=
	IF
		f:3 cr ." Could not find "
		person-name $type
		."  in phone number file." cr f:1
		." For help, enter: DIAL ?" cr
	THEN
;

: FAPPEND  ( fileid addr count -- count' , append to end of file )
	2 pick 0 offset_end fseek drop
	fwrite
;
	
: ADD.NAME&NUMBER ( <name> <number> <filename> -- )
\ add person-name and number to file
\ concatenate name and number
	bl lword pad $move
	"   " count pad $append
	bl word count pad $append
\
\ APPEND to file
	get.filename dup $fopen dup 0=
	IF	( -- $name 0 )
		drop NEW dup $fopen dup 0=  ( start a new file )
		IF	( -- $name 0 )
			2drop
			f:3 ." Could not open file!" f:1 cr
			." For help, enter: DIAL ?" cr
			RETURN
		THEN
		f:3 cr ." New file started called: " over $type cr f:1
	THEN
	( -- $name fid )
	dup pad count fappend drop
	dup EOL femit
	fclose
	cr pad $type ."           added to " $type cr
;

: DIAL ( <person> <filename> -- , phone person )
	>newline
	." Dial - Copyright Phil Burk 1991, written using JForth" cr
	." Dial may be freely redistributed for non-commercial use." cr
	." Dial is SHAREWARE! If you like it, please send $10.00 to:" cr
	."   Phil Burk, PO Box 151051, San Rafael, CA, 94915-1051" cr
	bl word  ( get person's name )
	dup c@ 0=
	IF
		dial.help
	ELSE
		person-name $move
		person-name check.number
		IF
			person-name count dial.string
		ELSE
			person-name dup c@ 1+ " ADD" text=?
			IF
				add.name&number
			ELSE
				person-name dup c@ 1+ " ?" text=?
				IF
					dial.help
				ELSE
					(dial)
				THEN
			THEN
		THEN
	THEN
;

