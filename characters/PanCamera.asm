; ---------------------------------------------------------------------------
; Subroutine to    horizontally pan the camera view ahead of the player
; (Ported from the US version of Sonic CD's "R11A__.MMD" by Nat The Porcupine)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B    R O U T    I N E |||||||||||||||||||||||||||||||||||||||


PanCamera:
        move.w    (Camera_Pan).w,d1        ; get the current camera pan value
        move.w    inertia(a0),d0        ; get sonic's inertia
        bpl.s    .abs_inertia            ; if sonic's inertia is positive, branch ahead
        neg.w    d0                        ; otherwise, we negate it to get the absolute value

    .abs_inertia:

; These lines aren't part of the original routine; I added them myself.
; If you've ported the Spin Dash, uncomment the following lines of code
; to allow the camera to pan ahead while charging the Spin Dash:
        tst.b    spindash_flag(a0)                    ; is sonic charging up a spin dash?
        beq.s    .skip                    ; if not, branch
        btst    #0,status(a0)            ; check the direction that sonic is facing
        bne.s    .pan_right                ; if he's facing right, pan the camera to the right
        bra.s    .pan_left                ; otherwise, pan the camera to the left

    .skip:
        cmpi.w    #$600,d0                ; is sonic's inertia greater than $600
        blt.s    .reset_pan                ; if not, recenter the screen (if needed)
        tst.w    inertia(a0)            ; otherwise, check the direction of inertia (by subtracting it from 0)
        bpl.s    .pan_left                ; if the result was positive, then inertia was negative, so we pan the screen left

    .pan_right:
        addq.w    #2,d1                    ; add 2 to the pan value
        cmpi.w    #64,d1                    ; is the pan value greater than 224 pixels?
        blt.s    .update_pan                ; if not, branch
        move.w    #64,d1                    ; otherwise, cap the value at the maximum of 224 pixels
        bra.s    .update_pan                ; branch
; ---------------------------------------------------------------------------

    .pan_left:
        subq.w    #2,d1                    ; subtract 2 from the pan value
        cmpi.w    #-64,d1                    ; is the pan value less than 96 pixels?
        bge.s    .update_pan                ; if not, branch
        move.w    #-64,d1                    ; otherwise, cap the value at the minimum of 96 pixels
        bra.s    .update_pan                ; branch
; ---------------------------------------------------------------------------

    .reset_pan:
        cmpi.w    #0,d1                    ; is the pan value 160 pixels?
        beq.s    .update_pan                ; if so, branch
        bge.s    .reset_left                ; otherwise, branch if it greater than 160
     
    .reset_right:
        addq.w    #2,d1                    ; add 2 to the pan value
        bra.s    .update_pan                ; branch
; ---------------------------------------------------------------------------

    .reset_left:
        subq.w    #2,d1                    ; subtract 2 from the pan value

    .update_pan:
        move.w    d1,(Camera_Pan).w        ; update the camera pan value
        rts                                ; return
     
; End of function PanCamera