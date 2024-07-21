/* Tests the direct variable interface    */
/* Include JRX:VarTest.f and run it before this. */

a.1 = "Just a test."
a.2 = "Hello There!"

/* send a command to the VarTest host */
say 'Before command status='status 'a.1='a.1 'a.2='a.2
address 'VarTest' 'The first command'
say 'After  command status='status 'a.1='a.1 'a.2='a.2
say

say "Before TestMem =" storage()
call TestMem
say "After  TestMem =" storage()

/* send the 'CLOSE' command' */
address 'VarTest' close
exit

/* Test for memory usage ----------------------------- */
/* Variable are local to procedures unless exposed. */
TestMem: procedure expose a.2
do for 2
   address 'VarTest' 'Test command'
	a.1 = "Local to Testmem"   /* change after first call in proc */
   say "Inside testMem =" storage()
   end
