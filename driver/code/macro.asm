; ===========================================================================
; ---------------------------------------------------------------------------
; Various assembly flags
; ---------------------------------------------------------------------------

FEATURE_SFX_MASTERVOL =	0	; set to 1 to make SFX use master volumes
FEATURE_MODULATION =	1	; set to 1 to enable software modulation effect
FEATURE_PORTAMENTO =	0	; set to 1 to enable portamento flag
FEATURE_MODENV =	0	; set to 1 to enable modulation envelopes
FEATURE_DACFMVOLENV =	0	; set to 1 to enable volume envelopes for FM & DAC channels.
FEATURE_UNDERWATER =	1	; set to 1 to enable underwater mode
FEATURE_BACKUP =	1	; set to 1 to enable back-up channels. Used for the 1-up SFX in Sonic 1, 2 and 3K...
FEATURE_BACKUPNOSFX =	1	; set to 1 to disable SFX while a song is backed up. Used for the 1-up SFX.
FEATURE_FM6 =		1	; set to 1 to enable FM6 to be used in music

; if safe mode is enabled (1), then the driver will attempt to find any issues.
; if Vladik's error debugger is installed, then the error will be displayed.
; else, the CPU is trapped.

safe =	1

; Select the tempo algorith.
; 0 = Overflow method.
; 1 = Counter method.

tempo =	0
; ===========================================================================
; ---------------------------------------------------------------------------
; Channel configuration
; ---------------------------------------------------------------------------

	phase 0
cFlags		ds.b 1		; various channel flags, see below
cType		ds.b 1		; hardware type for the channel
cData		ds.l 1		; 68k tracker address for the channel
	if FEATURE_DACFMVOLENV=0
cEnvPos =	*		; volume envelope position. PSG only
	endif
cPanning	ds.b 1		; channel panning and LFO. FM and DAC only
cDetune		ds.b 1		; frequency detune (offset)
cPitch		ds.b 1		; pitch (transposition) offset
cVolume		ds.b 1		; channel volume
cTick		ds.b 1		; channel tick multiplier
	if FEATURE_DACFMVOLENV=0
cVolEnv =	*		; volume envelope ID. PSG only
	endif
cSample =	*		; channel sample ID, DAC only
cVoice		ds.b 1		; YM2612 voice ID. FM only
cDuration	ds.b 1		; current note duration
cLastDur	ds.b 1		; last note duration
cFreq		ds.w 1		; channel base frequency

	if FEATURE_MODULATION
cModDelay =	*		; delay before modulation starts
cMod		ds.l 1		; modulation data address
cModFreq	ds.w 1		; modulation frequency offset
cModSpeed	ds.b 1		; number of frames til next modulation step
cModStep	ds.b 1		; modulation frequency offset per step
cModCount	ds.b 1		; number of modulation steps until reversal
	endif

	if FEATURE_PORTAMENTO
cPortaSpeed	ds.b 1		; number of frames for each portamento to complete. 0 means it is disabled.
cPortaFreq	ds.w 1		; frequency offset for portamento.
cPortaDisp	ds.w 1		; frequency displacement per frame for portamento.
	endif

	if FEATURE_DACFMVOLENV
cVolEnv		ds.b 1		; volume envelope ID
cEnvPos		ds.b 1		; volume envelope position
	endif

	if FEATURE_MODENV
cModEnv		ds.b 1		; modulation envelope ID
cModEnvPos	ds.b 1		; modulation envelope position
cModEnvSens	ds.b 1		; sensitivity of modulation envelope
	endif

cLoop		ds.b 3		; loop counter values
		even
cSizeSFX =	*		; size of each SFX track (this also sneakily makes sure the memory is aligned to word always. Additional loop counter may be added if last byte is odd byte)
cPrio =		*-1		; sound effect channel priority. SFX only

	if FEATURE_DACFMVOLENV
cStatPSG4 =	cPanning	; PSG4 type value. PSG3 only
	else
cStatPSG4 =	*-2		; PSG4 type value. PSG3 only
	endif

cNoteTimeCur	ds.b 1		; frame counter to note off. Music only
cNoteTimeMain	ds.b 1		; copy of frame counter to note off. Music only
cStack		ds.b 1		; channel stack pointer. Music only
		ds.b 1		; unused. Music only
		ds.l 3		; channel stack data. Music only
		even
cSize =		*		; size of each music track
; ===========================================================================
; ---------------------------------------------------------------------------
; Bits for cFlags
; ---------------------------------------------------------------------------

	phase 0
cfbMode =	*		; set if in pitch mode, clear if in sample mode. DAC only
cfbRest		ds.b 1		; set if channel is resting. FM and PSG only
cfbInt		ds.b 1		; set if interrupted by SFX. Music only
cfbHold		ds.b 1		; set if playing notes does not trigger note-on's
cfbMod		ds.b 1		; set if modulation is enabled
cfbCond		ds.b 1		; set if ignoring most tracker commands
cfbVol		ds.b 1		; set if channel should update volume
cfbRun =	$07		; set if channel is running a tracker
; ===========================================================================
; ---------------------------------------------------------------------------
; Misc variables for channel modes
; ---------------------------------------------------------------------------

ctbPt2 =	$02		; bit part 2 - FM 4-6
ctFM1 =		$00		; FM 1
ctFM2 =		$01		; FM 2
ctFM3 =		$02		; FM 3	- Valid for SFX
ctFM4 =		$04		; FM 4	- Valid for SFX
ctFM5 =		$05		; FM 5	- Valid for SFX
	if FEATURE_FM6
ctFM6 =		$06		; FM 6
	endif

ctbDAC =	$03		; DAC bit
ctDAC1 =	(1<<ctbDAC)|$03	; DAC 1	- Valid for SFX
ctDAC2 =	(1<<ctbDAC)|$06	; DAC 2

ctPSG1 =	$80		; PSG 1	- Valid for SFX
ctPSG2 =	$A0		; PSG 2	- Valid for SFX
ctPSG3 =	$C0		; PSG 3	- Valid for SFX
ctPSG4 =	$E0		; PSG 4
; ===========================================================================
; ---------------------------------------------------------------------------
; Misc flags
; ---------------------------------------------------------------------------

Mus_DAC =	2		; number of DAC channels
Mus_FM =	5+(FEATURE_FM6<>0); number of FM channels (5 or 6)
Mus_PSG =	3		; number of PSG channels
Mus_Ch =	Mus_DAC+Mus_FM+Mus_PSG; total number of music channels
SFX_DAC =	1		; number of DAC SFX channels
SFX_FM =	3		; number of FM SFX channels
SFX_PSG =	3		; number of PSG SFX channels
SFX_Ch =	SFX_DAC+SFX_FM+SFX_PSG; total number of SFX channels

VoiceRegs =	29		; total number of registers inside of a voice
VoiceTL =	VoiceRegs-4	; location of voice TL levels

MaxPitch =	$1000		; this is the maximum pitch Dual PCM is capable of processing
Z80E_Read =	$00018		; this is used by Dual PCM internally but we need this for macros

; NOTE: There is no magic trick to making Dual PCM play samples at higher rates.
; These values are only here to allow you to give lower pitch samples higher
; quality, and playing samples at higher rates than Dual PCM can process them
; may decrease the perceived quality by the end user. Use these equates only
; if you know what you are doing.

sr17 =		$0140		; 5 Quarter sample rate	17500 Hz
sr15 =		$0120		; 9 Eights sample rate	15750 Hz
sr14 =		$0100		; Default sample rate	14000 Hz
sr12 =		$00E0		; 7 Eights sample rate	12250 Hz
sr10 =		$00C0		; 3 Quarter sample rate	10500 Hz
sr8 =		$00A0		; 5 Eights sample rate	8750 Hz
sr7 =		$0080		; Half sample rate	7000 HZ
sr5 =		$0060		; 3 Eights sample rate	5250 Hz
sr3 =		$0040		; 1 Quarter sample rate	3500 Hz
; ===========================================================================
; ---------------------------------------------------------------------------
; Sound driver RAM configuration
; ---------------------------------------------------------------------------

dZ80 =		$A00000		; quick reference to Z80 RAM
dPSG =		$C00011		; quick reference to PSG port

	phase Drvmem		; Insert your RAM definition here!
mFlags		ds.b 1		; various driver flags, see below
mCtrPal		ds.b 1		; frame counter fo 50hz fix
mComm		ds.b 8		; communications bytes
mMasterVolFM =	*		; master volume for FM channels
mFadeAddr	ds.l 1		; fading program address
mTempoMain	ds.b 1		; music normal tempo
mTempoSpeed	ds.b 1		; music speed shoes tempo
mTempo		ds.b 1		; current tempo we are using right now
mTempoCur	ds.b 1		; tempo counter/accumulator
mQueue		ds.b 3		; sound queue
mMasterVolPSG	ds.b 1		; master volume for PSG channels
mVctMus		ds.l 1		; address of voice table for music
mMasterVolDAC	ds.b 1		; master volume for DAC channels
mSpindash	ds.b 1		; spindash rev counter
mContCtr	ds.b 1		; continous sfx loop counter
mContLast	ds.b 1		; last continous sfx played
mLastCue	ds.b 1		; last YM Cue the sound driver was accessing
	if 1&(*)
		ds.b 1		; even's are broke in 64-bit values?
	endif			; align channel data

mDAC1		ds.b cSize	; DAC 1 data
mDAC2		ds.b cSize	; DAC 2 data
mFM1		ds.b cSize	; FM 1 data
mFM2		ds.b cSize	; FM 2 data
mFM3		ds.b cSize	; FM 3 data
mFM4		ds.b cSize	; FM 4 data
mFM5		ds.b cSize	; FM 5 data
	if FEATURE_FM6
mFM6		ds.b cSize	; FM 6 data
	endif
mPSG1		ds.b cSize	; PSG 1 data
mPSG2		ds.b cSize	; PSG 2 data
mPSG3		ds.b cSize	; PSG 3 data
mSFXDAC1	ds.b cSizeSFX	; SFX DAC 1 data
mSFXFM3		ds.b cSizeSFX	; SFX FM 3 data
mSFXFM4		ds.b cSizeSFX	; SFX FM 4 data
mSFXFM5		ds.b cSizeSFX	; SFX FM 5 data
mSFXPSG1	ds.b cSizeSFX	; SFX PSG 1 data
mSFXPSG2	ds.b cSizeSFX	; SFX PSG 2 data
mSFXPSG3	ds.b cSizeSFX	; SFX PSG 3 data
mChannelEnd =	*		; used to determine where channel RAM ends

	if FEATURE_BACKUP
mBackDAC1	ds.b cSize	; back-up DAC 1 data
mBackDAC2	ds.b cSize	; back-up DAC 2 data
mBackFM1	ds.b cSize	; back-up FM 1 data
mBackFM2	ds.b cSize	; back-up FM 2 data
mBackFM3	ds.b cSize	; back-up FM 3 data
mBackFM4	ds.b cSize	; back-up FM 4 data
mBackFM5	ds.b cSize	; back-up FM 5 data
	if FEATURE_FM6
mBackFM6	ds.b cSize	; back-up FM 6 data
	endif
mBackPSG1	ds.b cSize	; back-up PSG 1 data
mBackPSG2	ds.b cSize	; back-up PSG 2 data
mBackPSG3	ds.b cSize	; back-up PSG 3 data

mBackTempoMain	ds.b 1		; back-up music normal tempo
mBackTempoSpeed	ds.b 1		; back-up music speed shoes tempo
mBackTempo	ds.b 1		; back-up current tempo we are using right now
mBackTempoCur	ds.b 1		; back-up tempo counter/accumulator
mBackVctMus	ds.l 1		; back-up address of voice table for music
	endif

	if safe=1
msChktracker	ds.b 1		; safe mode only: If set, bring up debugger
	endif

	if 1&(*)
		ds.b 1		; even's are broke in 64-bit values?
	endif			; align channel data
mSize =		*		; end of the driver RAM
; ===========================================================================
; ---------------------------------------------------------------------------
; Bits for mFlags
; ---------------------------------------------------------------------------

	phase 0
mfbRing		ds.b 1		; if set, change speaker (play different sfx)
mfbSpeed	ds.b 1		; if set, speed shoes are active
mfbWater	ds.b 1		; if set, underwater mode is active
mfbNoPAL	ds.b 1		; if set, play songs slowly in PAL region
mfbBacked	ds.b 1		; if set, a song has been backed up already
mfbPaused =	$07		; if set, sound driver is paused
; ===========================================================================
; ---------------------------------------------------------------------------
; Sound ID equates
; ---------------------------------------------------------------------------

	phase 1
Mus_Reset	ds.b 1		; reset underwater and speed shoes flags, update volume
Mus_FadeOut	ds.b 1		; initialize a music fade out
Mus_Stop	ds.b 1		; stop all music
Mus_ShoesOn	ds.b 1		; enable speed shoes mode
Mus_ShoesOff	ds.b 1		; disable speed shoes mode
Mus_ToWater	ds.b 1		; enable underwater mode
Mus_OutWater	ds.b 1		; disable underwater mode
Mus_Pause	ds.b 1		; pause the music
Mus_Unpause	ds.b 1		; unpause the music
MusOff =	*		; first music ID
; ===========================================================================
; ---------------------------------------------------------------------------
; Condition modes
; ---------------------------------------------------------------------------

	phase 0
dcoT		ds.b 1		; condition T	; True
dcoF		ds.b 1		; condition F	; False
dcoHI		ds.b 1		; condition HI	; HIgher (unsigned)
dcoLS		ds.b 1		; condition LS	; Less or Same (unsigned)
dcoHS =		*		; condition HS	; Higher or Sane (unsigned)
dcoCC		ds.b 1		; condition CC	; Carry Clear (unsigned)
dcoLO =		*		; condition LO	; LOwer (unsigned)
dcoCS		ds.b 1		; condition CS	; Carry Set (unsigned)
dcoNE		ds.b 1		; condition NE	; Not Equal
dcoEQ		ds.b 1		; condition EQ	; EQual
dcoVC		ds.b 1		; condition VC	; oVerflow Clear (signed)
dcoVS		ds.b 1		; condition VS	; oVerflow Set (signed)
dcoPL		ds.b 1		; condition PL	; Positive (PLus)
dcoMI		ds.b 1		; condition MI	; Negamite (MInus)
dcoGE		ds.b 1		; condition GE	; Greater or Equal (signed)
dcoLT		ds.b 1		; condition LT	; Less Than (signed)
dcoGT		ds.b 1		; condition GT	; GreaTer (signed)
dcoLE		ds.b 1		; condition LE	; Less or Equal (signed)
; ===========================================================================
; ---------------------------------------------------------------------------
; Envelope commands equates
; ---------------------------------------------------------------------------

	phase $80
eReset		ds.w 1		; 80 - Restart from position 0
eHold		ds.w 1		; 82 - Hold volume at current level
eLoop		ds.w 1		; 84 - Jump back/forwards according to next byte
eStop		ds.w 1		; 86 - Stop current note and envelope

; these next ones are only valid for modulation envelopes. These are ignored for volume envelopes.
esSens		ds.w 1		; 88 - Set the sensitivity of the modulation envelope
eaSens		ds.w 1		; 8A - Add to the sensitivity of the modulation envelope
eLast =		*		; safe mode equate
; ===========================================================================
; ---------------------------------------------------------------------------
; Fade out end commands
; ---------------------------------------------------------------------------

	phase $80
fEnd		ds.l 1		; 80 - Do nothing
fStop		ds.l 1		; 84 - Stop all music
fResVol		ds.l 1		; 88 - Reset volume and update
fReset		ds.l 1		; 8C - Stop music playing and reset volume
fLast		ds.l 0		; safe mode equate
; ===========================================================================
; ---------------------------------------------------------------------------
; Quickly clear some memory in certain block sizes
; ---------------------------------------------------------------------------

dCLEAR_MEM	macro len, block
		move.w	#((len)/(block))-1,d1; load repeat count to d7
-
	rept (block)/4
		clr.l	(a1)+		; clear driver and music channel memory
	endm
		dbf	d1, -		; loop for each longword to clear it...

	rept ((len)#(block))/4
		clr.l	(a1)+		; clear extra longs of memory
	endm

	if (len)&2
		clr.w	(a1)+		; if there is an extra word, clear it too
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Quickly read a word from odd address. 28 cycles
; ---------------------------------------------------------------------------

dREAD_WORD	macro areg, dreg
	move.b	(areg)+,(sp)		; read the next byte into stack
	move.w	(sp),dreg		; get word back from stack (shift byte by 8 bits)
	move.b	(areg),dreg		; get the next byte into register
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; used to calculate the address of the right FM voice
; ---------------------------------------------------------------------------

dCALC_VOICE	macro off
	lsl.w	#5,d0			; multiply voice ID by $20
	if "off"<>""
		add.w	#off,d0		; if have had extra argument, add it to offset
	endif

	add.w	d0,a1			; add offset to voice table address
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Tells the Z80 to stop, and waits for it to finish stopping (acquire bus)
; ---------------------------------------------------------------------------

stopZ80 	macro
	move.w	#$100,$A11100		; stop the Z80
.loop
	btst	#0,$A11100
	bne.s	.loop			; loop until it says it's stopped
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Tells the Z80 to start again
; ---------------------------------------------------------------------------

startZ80 	macro
	move.w	#0,$A11100		; start the Z80
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Initializes YM writes
; ---------------------------------------------------------------------------

InitChYM	macro
	move.b	cType(a5),d2		; get channel type to d2
	move.b	d2,d1			; copy to d1
	and.b	#3,d1			; get only the important part
	lsr.b	#1,d2			; halve part value
	and.b	#2,d2			; clear extra bits away
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Write data to channel-specific YM part
; ---------------------------------------------------------------------------

WriteChYM	macro reg, value
	move.b	d2,(a0)+		; write part
	move.b	value,(a0)+		; write register value to cue
	move.b	d1,d0			; get the channel offset into d0
	or.b	reg,d0			; or the actual register value
	move.b	d0,(a0)+		; write register to cue
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Write data to YM part 1
; ---------------------------------------------------------------------------

WriteYM1	macro reg, value
	clr.b	(a0)+			; write to part 1
	move.b	value,(a0)+		; write value to cue
	move.b	reg,(a0)+		; write register to cue
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Write data to YM part 2
; ---------------------------------------------------------------------------

WriteYM2	macro reg, value
	move.b	#2,(a0)+		; write to part 2
	move.b	value,(a0)+		; write value to cue
	move.b	reg,(a0)+		; write register to cue
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Macro to check cue address
; ---------------------------------------------------------------------------

CheckCue	macro
	if safe=1
		AMPS_Debug_CuePtr Gen		; check if cue pointer is valid
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for pausing music
; ---------------------------------------------------------------------------

AMPS_MUSPAUSE	macro	; enable request pause and paused flags
	move.b	#Mus_Pause,mQueue+2.w
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for unpausing music
; ---------------------------------------------------------------------------

AMPS_MUSUNPAUSE	macro	; enable request unpause flag
	move.b	#Mus_Unpause,mQueue+2.w
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Create volume envelope table, and SMPS2ASM equates
; ---------------------------------------------------------------------------

volenv		macro name
	if "name"<>""
v{"name"} =	__venv			; create SMPS2ASM equate
		dc.l vd{"name"}		; create pointer
__venv :=	__venv+1		; increase ID
		shift			; shift next argument into view
		volenv ALLARGS		; process next item
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Create modulation envelope table, and SMPS2ASM equates
; ---------------------------------------------------------------------------

modenv		macro name
	if "name"<>""			; repeate for all arguments
m{"name"} =	__menv			; create SMPS2ASM equate

		if FEATURE_MODENV
			dc.l md{"name"}	; create pointer
		endif

__menv :=	__menv+1		; increase ID
		shift			; shift next argument into view
		modenv ALLARGS		; process next item
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Fixing some weird-ass AS bugs here :(
; ---------------------------------------------------------------------------

fuckingincludeit macro {INTLABEL}, file
__LABEL__	label *
		include file
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Include PCM data
; ---------------------------------------------------------------------------

incSWF		macro file
	if "file"<>""			; repeate for all arguments
SWF_file	equ *
		binclude "driver/DAC/incswf/file.swf"; include PCM data
SWFR_file	equ *
	 	asdata Z80E_Read*(MaxPitch/$100), $00; add end markers (for Dual PCM)

		shift			; shift next argument into view
		incSWF ALLARGS		; process next item
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Create data for a sample
; ---------------------------------------------------------------------------

sample		macro freq, start, loop, name
	if "name"<>""		; if we have 4 arguments, we'd like a custom name
d{"name"} =	__samp		; use the extra argument to create SMPS2ASM equate
	else
d{"start"} =	__samp		; else, use the first one!
	endif

__samp :=	__samp+1	; increase sample ID

; create offsets for the sample normal, reverse, loop normal, loop reverse.
	if ("start"="Stop")|("start"="STOP")|("start"="stop")
		dc.b [6] 0
	else
		dc.b SWF_start&$FF,((SWF_start>>$08)&$7F)|$80,(SWF_start>>$0F)&$FF
		dc.b (SWFR_start-1)&$FF,(((SWFR_start-1)>>$08)&$7F)|$80,((SWFR_start-1)>>$0F)&$FF
	endif

	if ("loop"="Stop")|("loop"="STOP")|("loop"="stop")
		dc.b [6] 0
	else
		dc.b SWF_loop&$FF,((SWF_loop>>$08)&$7F)|$80, (SWF_loop>>$0F)&$FF
		dc.b (SWFR_loop-1)&$FF,(((SWFR_loop-1)>>$08)&$7F)|$80,((SWFR_loop-1)>>$0F)&$FF
	endif

	dc.w freq-$100		; sample frequency (actually offset, so we remove $100)
	dc.w 0			; unused!
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Workaround the ASS bug where you ca only put 1024 bytes per line of code
; ---------------------------------------------------------------------------

asdata		macro count, byte
.c :=		(count)
	while .c > $400
		dc.b [$400] byte
.c :=		.c - $400
	endm

	if .c > 0
		dc.b [.c] byte
	endif
    endm
; ===========================================================================
	!org 0
	phase 0
