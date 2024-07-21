\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_DISPLAY_H NOT .IF
: GRAPHICS_DISPLAY_H ;
$ 8000   constant MODE_640
$ 7   constant PLNCNTMSK

12   constant PLNCNTSHFT
$ 40   constant PF2PRI
$ 0200   constant COLORON
$ 400   constant DBLPF
$ 800   constant HOLDNMODIFY
4   constant INTERLACE

$ F   constant PFA_FINE_SCROLL
4   constant PFB_FINE_SCROLL_SHIFT
$ F   constant PF_FINE_SCROLL_MASK

$ 7F   constant DIW_HORIZ_POS
$ 1FF   constant DIW_VRTCL_POS
7   constant DIW_VRTCL_POS_SHIFT

$ FF   constant DFTCH_MASK

$ 8000   constant VPOSRLOF

.THEN
