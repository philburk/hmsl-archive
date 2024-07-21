\ Convert Brush to Image Source Code
\
\ Author Phil Burk
\ Copyright 1990 Phil Burk
\
\ MOD: PLB/MDH 2/6/91 Make dataname from filename, add GET.NAME

include? $iff>bitmap jiff:show_iff
decimal
anew TASK-DumpBrush

: .WORD  ( n -- , print hex word with leading zeros )
	s->d <# # # # # #> type
;

: NEWLINE  ( -- , emit EOL for new line )
	?pause EOL emit
;

: GET.NAME ( -- addr count , name of file )
	pad count strip-pathname  \ from fileword
;

: .NAME ( -- )
	get.name type
;

: .NAMEI .name ." -image" ;

: PRINT.BITMAP  { bmap | width height #planes plane -- }
\ get info from bitmap
	bmap bitmap>wh -> height -> width
	bmap ..@ bm_depth -> #planes
\
\ print source code for image
	." image " .namei newline
	width . .namei   ."  s! ig_width" newline
	height . .namei  ."  s! ig_height" newline
	#planes . .namei ."  s! ig_depth" newline
\ check for not word aligned brush
	width 15 and 0>
	IF ." Warning - width not even number of bytes!" newline
	THEN
\
\ Print source code for bit planes
	hex
	." create "	.name ." -planes   here HEX" newline
	#planes 0
	DO  ." \ Plane " i . newline
		i bmap bmplane[] @ >rel -> plane
		height 0
		DO	\ for each word in row
			3 spaces
			width 16 / 0
			DO	space plane dup w@ .word ."  w,"
				2+ -> plane
			LOOP newline
		LOOP
		newline
	LOOP
	." here swap - constant "
	.name ." _size   DECIMAL" newline
	." \ Copy image data to CHIP RAM before using!" newline
	decimal
;

: $DumpBrush  ( $filename -- )
	$iff>bitmap ?dup
	IF
		dup>r print.bitmap
		r> free.bitmap
	ELSE ." Couldn't read brush!" newline
	THEN
;

: DumpBrush  ( <filename> -- )
	." \ DumpBrush by Phil Burk 1990" newline
	." \ Written using JForth Professional" newline
	." \ Public Domain" newline
	." \      DUMPBRUSH >outfile brushfilename" newline
	fileword   here pad $move
	$dumpbrush
;

>newline
." Use LOGTO or Clone this and enter:" cr
."    DUMPBRUSH >outfile brushfilename" cr

