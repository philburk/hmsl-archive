\ Play Notes various pitch bend settings.
\ Notes should match in pitch.
\
\ (C) 2006 Mobileer Inc

ANEW RINGER_SUDDEN.FTH
decimal

: MC! midi.channel! ;
: MP! midi.program ;

: SUDDEN1
	par{
		1 mc!  1 mp! staccato 1/1 c4 d e d
	}par{
		2 mc!  5 mp! staccato 1/1 e4 f g f
	}par{
		3 mc!  12 mp! staccato 1/1 g4 a b a
	}par{
		4 mc!  12 mp! staccato 1/1 a4 b c5 b4
	}par
;

: SUDDEN
	1 mc! 20 mp!
	staccato 1/1 _fff
	chord{ c4 e g a }chord
	chord{ d4 f a c5 }chord
	chord{ f4 a c5 d }chord
	chord{ d4 f a c5 }chord
	20 mp!
;

: MSMF PLAYNOW " sudden_chords.mid" $midifile1{ sudden }midifile1 ;
