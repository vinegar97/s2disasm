; ===========================================================================
; ---------------------------------------------------------------------------
; Flags section. None of this is required, but I added it here to
; make it easier to debug built ROMs! If you would like easier
; assistance from Aurora, please keep this section intact!
; ---------------------------------------------------------------------------
	dc.b "AMPS-v2.1"		; ident str

	if safe
		dc.b "s"		; safe mode enabled

	else
		dc.b " "		; safe mode disabled
	endif

	if FEATURE_FM6
		dc.b "F6"		; FM6 enabled
	endif

	if FEATURE_SFX_MASTERVOL
		dc.b "SM"		; sfx ignore master volume
	endif

	if FEATURE_UNDERWATER
		dc.b "UW"		; underwater mode enabled
	endif

	if FEATURE_MODULATION
		dc.b "MO"		; modulation enabled
	endif

	if FEATURE_DACFMVOLENV
		dc.b "VE"		; FM & DAC volume envelope enabled
	endif

	if FEATURE_MODENV
		dc.b "ME"		; modulation envelope enabled
	endif

	if FEATURE_PORTAMENTO
		dc.b "PM"		; portamento enabled
	endif

	if FEATURE_BACKUP
		dc.b "BA"		; backup enabled
	endif

	if FEATURE_SOUNDTEST
		dc.b "ST"		; soundtest enabled
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Define music and SFX
; ---------------------------------------------------------------------------

	if safe=0
		listings off		; if in safe mode, list data section.
	endif

__mus :=	MusOff

MusicIndex:
	ptrMusic EHZ, $20, CPZ, $12, ARZ, $20, CNZ, $20, HTZ, $20, MCZ, $20
	ptrMusic OOZ, $20, MTZ, $16, SCZ, $20, WFZ, $20, DEZ, $20, HPZ, $20
	ptrMusic EHZ2P, $20, CNZ2P, $20, MCZ2P, $14
	ptrMusic SS, $00, Options, $00, Results2P, $00, Invincibility, $18
	ptrMusic SuperSonic, $06, Boss, $1D, FinalBoss, $20, Drowning, $00
	ptrMusic Title, $00, GotThroughAct, $00, Emerald, $00, ExtraLife, $00
	ptrMusic GameOver, $00, Continue, $00, Ending, $00, Credits, $00
	ptrMusic SEGA, $00

MusCount =	__mus-MusOff		; number of installed music tracks
SFXoff =	__mus			; first SFX ID
__sfx :=	SFXoff
; ---------------------------------------------------------------------------

SoundIndex:
	ptrSFX	$01, RingRight
	ptrSFX	0, RingLeft, RingLoss, Splash, Break, Jump, Roll
	ptrSFX	0, Skid, Bubble, Drown, SpikeHit, Death, Spindash
	ptrSFX	0, Dash, AirDing, Shield, BossHit, Flipper, Spring
	ptrSFX	0, Starpost, Signpost, Signpost2P, Register, Smash
	ptrSFX	0, Collapse, Switch, Explode, Zapper, LidPop, Bumper
	ptrSFX	0, Elevator, TinyBumper, LargeBumper, Stomp, Door
	ptrSFX	0, LaunchSpring, SlotMachine, GloopDrop, LavaBall
	ptrSFX	0, Flame, Fire, ArrowFire, ArrowStick, Saw, TrackLift
	ptrSFX	0, SpikeMove, SpikeSwitch, SpikeRing, PushBlock
	ptrSFX	0, Rumble, Rumble2, DrawBridgeMove, DrawBridgeDown
	ptrSFX	0, Sparkle, Transform, Helicopter, Leaves, Beep, Swap
	ptrSFX	0, Lazer, LargeLazer, LazerFloor, PlatformKnock
	ptrSFX	0, OilSlide, MechaSonic, Error, EnterSS, Continue
	ptrSFX	$80, Gloop

; unused sfx
	ptrSFX	0, Chain, Bonus, BigRing, ActionBlock, Diamonds
	ptrSFX	0, QuickDoor, Electricity, Unk2B, Unk38, Unk51, Unk52

	ptrSFX  0, FireShield, BubbleShield, ElectricShield
	ptrSFX  0, InstaAttack, FireAttack, BubbleAttack, ElectricAttack, Grab
	ptrSFX  0, GlideLand, GroundSlide, Flying, FlyTired, Thok, DropDash

SFXcount =	__sfx-SFXoff		; number of intalled sound effects
SFXlast =	__sfx
; ===========================================================================
; ---------------------------------------------------------------------------
; Define samples
; ---------------------------------------------------------------------------

__samp :=	$80
SampleList:
	sample $0000, Stop, Stop		; 80 - Stop sample (DO NOT EDIT)
	sample $0100, Kick, Stop		; 81 - Kick
	sample $0100, Snare, Stop		; 82 - Snare
	sample $0100, Clap, Stop		; 83 - Clap
	sample $0100, Scratch, Stop		; 84 - Scratch

	sample $0100, Timpani, Stop, HiTimpani	; 85 - High Timpani
	sample $00EE, Timpani, Stop, MidTimpani	; 86 - Mid Timpani
	sample $00D4, Timpani, Stop		; 87 - Mid Timpani
	sample $00D0, Timpani, Stop, LowTimpani	; 88 - Low Timpani
	sample $00CC, Timpani, Stop, FloorTimpani; 89 - Floor Timpani

	sample $0180, Tom, Stop, HiTom		; 8A - High Tom
	sample $0140, Tom, Stop, MidTom		; 8B - Mid Tom
	sample $0100, Tom, Stop, LowTom		; 8C - Low Tom
	sample $00E0, Tom, Stop, FloorTom	; 8D - Floor Tom

	sample $0100, Bongo, Stop, HiBongo	; 8E - High Bongo
	sample $00D0, Bongo, Stop, MidBongo	; 8F - Mid Bongo
	sample $00A0, Bongo, Stop, LowBongo	; 90 - Low Bongo
	sample $0080, Bongo, Stop, FloorBongo	; 91 - Floor Bongo

	sample $0100, SEGA, Stop		; 92 - SEGA
	sample $0100, Thok, Stop		; 93 - Thok
	sample $0100, DropDash, Stop		; 94 - DropDash
; ===========================================================================
; ---------------------------------------------------------------------------
; Define volume envelopes and their data
; ---------------------------------------------------------------------------

vNone =		$00
__venv :=	$01

VolEnvs:
	volenv 01, 02, 03, 04, 05, 06, 07, 08
	volenv 09, 0A, 0B, 0C, 0D, 17
VolEnvs_End:
; ---------------------------------------------------------------------------

vd01:		dc.b $00, $00, $00, $08, $08, $08, $10, $10
		dc.b $10, $18, $18, $18, $20, $20, $20, $28
		dc.b $28, $28, $30, $30, $30, $38, eHold

vd02:		dc.b $00, $10, $20, $30, $40, $7F, eHold

vd03:		dc.b $00, $00, $08, $08, $10, $10, $18, $18
		dc.b $20, $20, $28, $28, $30, $30, $38, $38
		dc.b eHold

vd04:		dc.b $00, $00, $10, $18, $20, $20, $28, $28
		dc.b $28, $30, eHold

vd05:		dc.b $00, $00, $00, $00, $00, $00, $00, $00
		dc.b $00, $00, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $10, $10, $10, $10, $10, $10, $10, $10
		dc.b $18, $18, $18, $18, $18, $18, $18, $18
		dc.b $20, eHold

vd06:		dc.b $18, $18, $18, $10, $10, $10, $10, $08
		dc.b $08, $08, $00, $00, $00, $00, eHold

vd07:		dc.b $00, $00, $00, $00, $00, $00, $08, $08
		dc.b $08, $08, $08, $10, $10, $10, $10, $10
		dc.b $18, $18, $18, $20, $20, $20, $28, $28
		dc.b $28, $30, $38, eHold

vd08:		dc.b $00, $00, $00, $00, $00, $08, $08, $08
		dc.b $08, $08, $10, $10, $10, $10, $10, $10
		dc.b $18, $18, $18, $18, $18, $20, $20, $20
		dc.b $20, $20, $28, $28, $28, $28, $28, $30
		dc.b $30, $30, $30, $30, $38, $38, $38, eHold

vd09:		dc.b $00, $08, $10, $18, $20, $28, $30, $38
		dc.b $40, $48, $50, $58, $60, $68, $70, $78
		dc.b eHold

vd0A:		dc.b $00, $00, $00, $00, $00, $00, $00, $00
		dc.b $00, $00, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $10, $10, $10, $10, $10, $10, $10, $10
		dc.b $10, $10, $18, $18, $18, $18, $18, $18
		dc.b $18, $18, $18, $18, $20, eHold

vd0B:		dc.b $20, $20, $20, $18, $18, $18, $10, $10
		dc.b $10, $08, $08, $08, $08, $08, $08, $08
		dc.b $10, $10, $10, $10, $10, $18, $18, $18
		dc.b $18, $18, $20, eHold

vd0C:		dc.b $20, $20, $18, $18, $10, $10, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $10, $10, $10, $10, $10, $10
		dc.b $10, $10, $10, $10, $10, $10, $10, $10
		dc.b $10, $10, $10, $10, $10, $10, $18, $18
		dc.b $18, $18, $18, $18, $18, $18, $18, $18
		dc.b $18, $18, $18, $18, $18, $18, $18, $18
		dc.b $18, $18, $20, $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20, $20, $28, $28
		dc.b $28, $28, $28, $28, $28, $28, $28, $28
		dc.b $28, $28, $28, $28, $28, $28, $28, $28
		dc.b $28, $28, $30, $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $38, eHold

vd0D:		dc.b $70, $68, $60, $58, $50, $48, $40, $38
		dc.b $30, $28, $20, $18, $10, $08, $00, eHold


vd17:	dc.b $01, $00, $00, $00, $00, $01, $01, $01
		dc.b $02, $02, $02, $03, $03, $03, $03, $04
		dc.b $04, $04, $05, $05, eHold
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; Define volume envelopes and their data
; ---------------------------------------------------------------------------

mNone =		$00
__menv :=	$01

ModEnvs:
ModEnvs_End:
; ---------------------------------------------------------------------------

	if FEATURE_MODENV

		even
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Include music, sound effects and voice bank
; ---------------------------------------------------------------------------

	include "AMPS/Voices.s2a"	; include universal voice bank
; ---------------------------------------------------------------------------

; include SFX and music
sfxaddr:	incSFX
musaddr:	incMus
musend:
; ===========================================================================
; ---------------------------------------------------------------------------
; Include samples and filters
; ---------------------------------------------------------------------------

		align	$8000		; must be aligned to bank. By the way, these are also set in Z80.asm. Be sure to check it out
fLog:		binclude "AMPS/filters/Logarithmic.dat"	; logarithmic filter (no filter)
;fLinear:	binclude "AMPS/filters/Linear.dat"	; linear filter (no filter)

dacaddr:	asdata Z80E_Read*(MaxPitch/$100), $00
SWF_Stop:	asdata $8000-(2*Z80E_Read*(MaxPitch/$100)), $80
SWFR_Stop:	asdata Z80E_Read*(MaxPitch/$100), $00
; ---------------------------------------------------------------------------

	incSWF	Kick, Snare, Clap, Tom, Timpani, Bongo
	incSWF	Scratch, SEGA, Thok, DropDash
	even

	listing on			; continue source listing
; ---------------------------------------------------------------------------
