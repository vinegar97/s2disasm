    include "OptionsScreen/Data.asm"


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; a1 = Pointer to text
OptionsScreen_DrawLabelDeselected:
	move.w	#palette_line_1,d0
	lea	(Chunk_Table+$160+(39*1*2)+(1*2)).l,a2 ; Label location
	bra.w	MenuScreenTextToRAM

; a1 = Pointer to text
OptionsScreen_DrawLabelSelected:
	move.w	#palette_line_3,d0
	lea	(Chunk_Table+(39*1*2)+(1*2)).l,a2 ; Label location
	bra.w	MenuScreenTextToRAM


; a1 = Pointer to text
OptionsScreen_DrawValueDeselected:
	move.w	#palette_line_1,d0
	lea	(Chunk_Table+$160+(39*1*2)+(18*2)).l,a2 ; Value location
	bra.w	MenuScreenTextToRAM

; a1 = Pointer to text
OptionsScreen_DrawValueSelected:
	move.w	#palette_line_3,d0
	lea	(Chunk_Table+(39*1*2)+(18*2)).l,a2 ; Value location
	bra.w	MenuScreenTextToRAM


; d0 = #vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(x,y),VRAM,WRITE) [long]
OptionsScreen_DrawBoxDeselected:
	lea		(Chunk_Table+$160).l,a1
	bra.s	OptionsScreen_DrawBox

; d0 = #vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(x,y),VRAM,WRITE) [long]
OptionsScreen_DrawBoxSelected:
	lea		(Chunk_Table).l,a1

; [internal]
OptionsScreen_DrawBox:
	moveq	#38,d1 ; Box width - 1
	moveq	#3,d2 ; Box height - 1
	jmpto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40

; ===========================================================================

OptionsScreen_DrawMenu:
	move.l	(Options_menu_pointer).l,a0
	move.w	(a0)+,d5	; d5 = max list index
	moveq	#0,d6	; d6 = current item to draw
-
	bsr.s	OptionsScreen_DrawMenuItem

	addi.w	#1,d6 ; increment current item

	cmpi.w	#7,d6 ; limit number of items drawn
	bge.s	+
	cmp.b	d5,d6 ; make sure we don't overflow (TODO: scroll)
	bhi.s	+
	bra.s	-
+
	rts

; ===========================================================================

OptionsScreen_BoxLocations:
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,1),VRAM,WRITE)
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,5),VRAM,WRITE)
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,9),VRAM,WRITE)
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,13),VRAM,WRITE)
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,17),VRAM,WRITE)
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,21),VRAM,WRITE)
	dc.l vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(1,25),VRAM,WRITE)

OptionsScreen_DrawMenuItem_GetLoc:
	lea		(OptionsScreen_BoxLocations).l,a1
	moveq	#0,d0
	move.w	d6,d0
	lsl.l	#2,d0
	add.l	d0,a1
	move.l	(a1),d0
	rts

OptionsScreen_DrawMenuItem:
	move.w	(a0)+,d4	; d4 = item type
	; Draw Label Text
	move.l	(a0)+,a1 ; a1 = item label text
	cmp.w	(Options_menu_selection).l,d6
	bne.s	OptionsScreen_DrawMenuItemDeselected

OptionsScreen_DrawMenuItemSelected:
	bsr.w	OptionsScreen_DrawLabelSelected
	bsr.w	OptionsScreen_GetValTextPtr
	bsr.w	OptionsScreen_DrawValueSelected
	bsr.s	OptionsScreen_DrawMenuItem_GetLoc
	bra.w	OptionsScreen_DrawBoxSelected

OptionsScreen_DrawMenuItemDeselected:
	bsr.w	OptionsScreen_DrawLabelDeselected
	bsr.w	OptionsScreen_GetValTextPtr
	bsr.w	OptionsScreen_DrawValueDeselected
	bsr.s	OptionsScreen_DrawMenuItem_GetLoc
	bra.w	OptionsScreen_DrawBoxDeselected

; ===========================================================================

OptionsScreen_GetValTextPtr:
	moveq	#0,d0
	move.w	d4,d0
	move.w	OptionsScreen_GetValTextPtr_Index(pc,d0.w),d1
	jsr	OptionsScreen_GetValTextPtr_Index(pc,d1.w)
	addi.l	#4,a0	; increment to next menu item pointer
	rts

OptionsScreen_GetValTextPtr_Index:	offsetTable
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_Null ; 0
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_Null ; 2 (MenuItemLabel)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_MenuItemValue ; 4 (MenuItemValue)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_Null ; 6 (MenuItemSub)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_MenuItemSound ; 8 (MenuItemSound)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_MenuItemValue ; 10 (MenuItemValuePlayer)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_MenuItemValue ; 12 (MenuItemValue2P)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_Null ; 14 (MenuItemBack)
	offsetTableEntry.w	OptionsScreen_GetValTextPtr_Null ; 16 (MenuItemCredits)

OptionsScreen_GetValTextPtr_Null:
	move.l	#Txt_Empty,a1
	rts

OptionsScreen_GetValTextPtr_MenuItemSound:
	lea	(Chunk_Table+$160+(39*1*2)+(35*2)).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest
	lea	(Chunk_Table+(39*1*2)+(35*2)).l,a2
	move.w	#palette_line_3,d0
	bsr.w	OptionScreen_HexDumpSoundTest
	move.l	#Txt_NoDraw,a1
	rts

OptionsScreen_GetValTextPtr_MenuItemValue:
	move.l	(a0),a1	 ; (a0)/a1 = otherdataptr
	moveq	#0,d0
	move.w 	(a1)+,d0 ; d0 = max val
	move.l	(a1)+,a2 ; a2 = value address
	move.b	(a2),d1 ; d1 = current value

	cmp.b	d0,d1
	bhi.s	OptionsScreen_GetValTextPtr_MenuItemValue_UnkVal

	lsl.l	#2,d1	; get relative address in text list
	move.l	(a1),a1	; a1 = text list
	add.l	d1,a1
	move.l	(a1),a1	; a1 = text ptr
	rts

OptionsScreen_GetValTextPtr_MenuItemValue_UnkVal:
	move.l	#Txt_Unknown,a1
	rts

; ===========================================================================

OptionsScreen_Input:
	move.l	(Options_menu_pointer).l,a0
	move.w	(a0)+,d1

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.w	#1,(Options_menu_selection).l
	bcc.s	++
	move.w	d1,(Options_menu_selection).l
+
	btst	#button_down,d0
	beq.s	+
	addq.w	#1,(Options_menu_selection).l
	move.w	(Options_menu_selection).l,d2
	subi.w	#1,d2
	cmp.w	d1,d2 ; Number of options
	blo.s	+
	move.w	#0,(Options_menu_selection).l
+
	moveq	#0,d0
	move.w	(Options_menu_selection).l,d0
	mulu.w	#menuitemdata_len,d0
	add.l	d0,a0
	moveq	#0,d0
	move.w	(a0)+,d0 ; d0 = type
	addi.l	#4,a0 ; increment past text label and padding
	move.l	(a0),a0 ; a0 = other data pointer

	move.w	OptionsScreen_Input_Index(pc,d0.w),d1
	jmp	OptionsScreen_Input_Index(pc,d1.w)

OptionsScreen_Input_Index:	offsetTable
	offsetTableEntry.w	OptionsScreen_Input_Null ; 0
	offsetTableEntry.w	OptionsScreen_Input_Null ; 2 (MenuItemLabel)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemValue ; 4 (MenuItemValue)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemSub ; 6 (MenuItemSub)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemSound ; 8 (MenuItemSound)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemValuePlayer ; 10 (MenuItemValuePlayer)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemValue2P ; 12 (MenuItemValue2P)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemBack ; 14 (MenuItemBack)
	offsetTableEntry.w	OptionsScreen_Input_MenuItemCredits ; 16 (MenuItemCredits)

OptionsScreen_Input_Null:
	rts

OptionsScreen_Input_MenuItemValuePlayer:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_start,d0
	beq.s	OptionsScreen_Input_MenuItemValue
	; Start a single player game
	move.w	#0,(Two_player_mode).w
	move.w	#0,(Two_player_mode_copy).w

	move.b	#1,(Level_select_flag).w	; REMOVE THIS
	tst.b	(Level_select_flag).w	; has level select cheat been entered?
	beq.s	+			; if not, branch
	btst	#button_A,(Ctrl_1_Held).w ; is A held down?
	beq.s	+	 		; if not, branch
	move.b	#GameModeID_LevelSelect,(Game_Mode).w ; => LevelSelectMen
	rts
+
	move.w	#0,(Current_ZoneAndAct).w	; emerald_hill_zone_act_1
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	rts

OptionsScreen_Input_MenuItemValue2P:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_start,d0
	beq.s	OptionsScreen_Input_MenuItemValue
	; Start a 2P VS game
	move.w	#1,(Two_player_mode).w
	move.w	#1,(Two_player_mode_copy).w
	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	move.b	#0,(Current_Zone_2P).w
	move.b	#0,(Player_mode).w
	rts

OptionsScreen_Input_MenuItemValue:
	moveq	#0,d1
	move.w	(a0)+,d1 ; d1 = max val
	move.l	(a0),a0

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_left,d0
	beq.s	+
	sfx		sfx_Beep
	subq.b	#1,(a0)
	bcc.s	++
	move.b	d1,(a0)
+
	btst	#button_right,d0
	beq.s	+
	sfx		sfx_Beep
	addq.b	#1,(a0)
	move.b	(a0),d2
	subi.b	#1,d2
	cmp.b	d1,d2 ; Number of options
	blo.s	+
	move.b	#0,(a0)
+
	jsr		SaveSRAM
	rts

OptionsScreen_Input_MenuItemBack:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_start,d0
	beq.s	+
	bsr.w	OptionsScreen_Input_MenuItemSubEnter
	sfx		sfx_InstaAttack
+
	rts

OptionsScreen_Input_MenuItemSub:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_start,d0
	beq.s	+
	bsr.w	OptionsScreen_Input_MenuItemSubEnter
	sfx		sfx_Starpost
+
	rts

OptionsScreen_Input_MenuItemSubEnter:
	move.w	#0,(Options_menu_selection).l
	move.l	a0,(Options_menu_pointer).l
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size	; Clear Plane A pattern name table
	bsr.w	OptionsScreen_DrawMenu
+
	rts

OptionsScreen_Input_MenuItemSound:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_start,d0
	beq.s	+
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
+
	bsr.w	OptionsScreen_Input_MenuItemValue

	btst	#button_A,d0
	beq.s	+
	addi.b	#$10,(a0)
	move.b	(a0),d2
	subi.b	#1,d2
	cmp.b	d1,d2 ; Number of options
	blo.s	+
	move.b	#0,(a0)
+
	andi.w	#button_B_mask|button_C_mask,d0
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	move.b	d0,mQueue+1.w
	lea	(level_select_cheat).l,a0
	lea	(continues_cheat).l,a2
	lea	(Level_select_flag).w,a1	; Also Slow_motion_flag
	moveq	#0,d2	; flag to tell the routine to enable the continues cheat
	bsr.w	CheckCheats
+
	rts

OptionsScreen_Input_MenuItemCredits:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_start,d0
	beq.s	+
	move.b	#GameModeID_EndingSequence,(Game_Mode).w
	clr.b	(Ending_PalCycle_flag).w
	move.b	#1,(Credits_Trigger).w
	jmp		EndgameCredits_Loop
+
	rts

; ===========================================================================

; loc_8FCC:
MenuScreen_Options:
	move.l	#OptionsMenu_Main,(Options_menu_pointer).l
	clr.b	(Options_menu_selection).w

	; Load tile graphics
	lea	(Chunk_Table).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	jsr		EniDec
	lea	(Chunk_Table+$160).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	jsr		EniDec
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.w	(Correct_cheat_entries).w
	clr.w	(Correct_cheat_entries_2).w
	bsr.w	OptionsScreen_DrawMenu
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	music	mus_Options

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
; loc_9060:
OptionScreen_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint

	bsr.w	OptionsScreen_Input
	bsr.w	OptionsScreen_DrawMenu

	; Animated BG
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal

	cmpi.b	#GameModeID_OptionsMenu,(Game_Mode).w 
	beq.w	OptionScreen_Main
; ===========================================================================
;loc_9296
OptionScreen_HexDumpSoundTest:
	move.w	(Sound_test_sound).w,d1
	move.b	d1,d2
	lsr.b	#4,d1
	bsr.s	+
	move.b	d2,d1

+
	andi.w	#$F,d1
	cmpi.b	#$A,d1
	blo.s	+
	addi.b	#4,d1

+
	addi.b	#$10,d1
	move.b	d1,d0
	move.w	d0,(a2)+
	rts