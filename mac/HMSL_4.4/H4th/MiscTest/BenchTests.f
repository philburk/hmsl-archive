\ bench tests to compare with JForth...decimalanew task-benchtests1000000 constant 1megvariable HowMany1meg howmany !: test1           HowMany @ 0      DO                   LOOP            ;: test2  23 45    HowMany @ 0      DO  swap             LOOP 2drop      ;: test3  23       HowMany @ 0      DO  dup drop         LOOP drop       ;: test4  23 45    HowMany @ 0      DO  over drop        LOOP 2drop      ;: test5           HowMany @ 0      DO  23 45 + drop     LOOP            ;: test6  23       HowMany @ 0      DO  >r r>            LOOP drop       ;: test7  23 45 67 HowMany @ 0      DO  rot              LOOP 2drop drop ;: test8           HowMany @ 0      DO  23 2* drop       LOOP            ;: test9           HowMany @ 10 / 0 DO  23 5 /mod 2drop  LOOP            ;