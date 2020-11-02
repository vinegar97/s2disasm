; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 2 format
; --------------------------------------------------------------------------------

SME_XoSgb:	
		dc.w SME_XoSgb_C-SME_XoSgb, SME_XoSgb_26-SME_XoSgb	
		dc.w SME_XoSgb_40-SME_XoSgb, SME_XoSgb_5A-SME_XoSgb	
		dc.w SME_XoSgb_74-SME_XoSgb, SME_XoSgb_86-SME_XoSgb	
SME_XoSgb_C:	dc.b 0, 3	
		dc.b $90, 1, $20, 0, $20, 0, 0, $20	
		dc.b $80, $D, $20, $E, $20, 7, 0, 0	
		dc.b $90, $D, $20, 6, $20, 3, 0, 0	
SME_XoSgb_26:	dc.b 0, 3	
		dc.b $90, 1, 0, 0, 0, 0, 0, $20	
		dc.b $80, $D, $20, $E, $20, 7, 0, 0	
		dc.b $90, $D, 0, 6, 0, 3, 0, 0	
SME_XoSgb_40:	dc.b 0, 3	
		dc.b $90, 1, $20, 0, $20, 0, 0, $20	
		dc.b $80, $D, 0, $E, 0, 7, 0, 0	
		dc.b $90, $D, $20, 6, $20, 3, 0, 0	
SME_XoSgb_5A:	dc.b 0, 3	
		dc.b $90, 1, 0, 0, 0, 0, 0, $20	
		dc.b $80, $D, 0, $E, 0, 7, 0, 0	
		dc.b $90, $D, 0, 6, 0, 3, 0, 0	
SME_XoSgb_74:	dc.b 0, 2	
		dc.b $40, 5, 1, $A, 1, $85, 0, 0	
		dc.b $40, $D, $21, $E, $21, $87, 0, $10	
SME_XoSgb_86:	dc.b 0, 2	
		dc.b $40, 5, 0, $1C, 0, $E, 0, 0	
		dc.b $40, $D, $20, $78, $20, $3C, 0, $10	
		even