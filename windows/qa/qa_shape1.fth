\ Test various shape functions.

ANEW TASK-QA_SHAPE1

hmsl-graphics off
ob.shape sh1

: REVSH  { shape -- }
    0 many: shape 1-   \ all elements
    -1   \ all dimensions
    reverse: shape
;

: TSH1.INIT
    20 3 new: sh1
    200 54 60 add: sh1
    200 58 70 add: sh1
    200 60 80 add: sh1
    400 69 90 add: sh1

    6 put.repeat: sh1
    
    print: sh1
    sh1 revsh
    
    ['] revsh put.repeat.function: sh1
;

: TSH1.PLAY
    sh1 hmsl.exec
    print: sh1
;

: TSH1.TERM
    free: sh1
;

