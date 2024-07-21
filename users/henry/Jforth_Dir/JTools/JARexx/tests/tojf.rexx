/* Send commands to JFORTH */
/* Note that the first line of an ARexx program must be a comment! */
options results
address 'JFORTH' 
'111 222 + . CR'
'." Hello World!" CR'
'" ju:msec" $include CR'
'rx-quit on'
say "After RX-QUIT so not processed!" 
exit
