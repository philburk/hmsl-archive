ANEW TASK-HELP_DOC: STARTS.WITH ( <char> -- )	[compile] ascii toupper >r	>newline	latest	BEGIN dup	WHILE		dup 1+ c@ r@ =		IF			dup ID. space			8 out @ 8 mod - spaces			out @ 60 >			IF cr			THEN		THEN		prevname		?pause	REPEAT	drop	rdrop;