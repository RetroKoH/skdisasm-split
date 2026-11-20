Obj_SuperSonic_Stars:
		move.l	#ArtUnc_SuperSonic_Stars,d1
		move.w	#tiles_to_bytes(ArtTile_Shield),d2
		move.w	#$1A0,d3
		jsr	(Add_To_DMA_Queue).l
		move.l	#Map_SuperSonic_Stars,mappings(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#$18,height_pixels(a0)
		move.w	#make_art_tile(ArtTile_Shield,0,0),art_tile(a0)
		btst	#7,(Player_1+art_tile).w
		beq.s	loc_17EEA
		bset	#7,art_tile(a0)

loc_17EEA:
		move.l	#loc_17EF0,(a0)

loc_17EF0:
		tst.b	(Super_Sonic_Knux_flag).w
		beq.w	loc_17F7C
		tst.b	anim(a0)
		beq.s	loc_17F02
		bsr.w	sub_17F82

loc_17F02:
		tst.b	$34(a0)
		beq.s	loc_17F4C
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	loc_17F34
		move.b	#1,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#6,mapping_frame(a0)
		blo.s	loc_17F34
		move.b	#0,mapping_frame(a0)
		move.b	#0,$34(a0)
		move.b	#1,$35(a0)
		rts
; ---------------------------------------------------------------------------

loc_17F34:
		tst.b	$35(a0)
		bne.s	loc_17F46

loc_17F3A:
		move.w	(Player_1+x_pos).w,x_pos(a0)
		move.w	(Player_1+y_pos).w,y_pos(a0)

loc_17F46:
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17F4C:
		tst.b	(Player_1+object_control).w
		bne.s	loc_17F6E
		move.w	(Player_1+ground_vel).w,d0
		bpl.s	loc_17F5A
		neg.w	d0

loc_17F5A:
		cmpi.w	#$800,d0
		blo.s	loc_17F6E
		move.b	#0,mapping_frame(a0)
		move.b	#1,$34(a0)
		bra.s	loc_17F3A
; ---------------------------------------------------------------------------

loc_17F6E:
		move.b	#0,$34(a0)
		move.b	#0,$35(a0)
		rts
; ---------------------------------------------------------------------------

loc_17F7C:
		jmp	(Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================


sub_17F82:
		move.b	#0,anim(a0)
		lea	(Player_1).w,a2
		moveq	#$10-1,d5
		move.w	#$488,d4

loc_17F92:
		bsr.w	AllocateObject
		bne.w	locret_1800A
		move.l	#Obj_SuperSonic_Stars_Timer,(a1)
		move.w	x_pos(a2),x_pos(a1)
		move.w	y_pos(a2),y_pos(a1)
		move.l	#Map_SuperSonic_Stars2,mappings(a1)
		move.w	#make_art_tile($79C,0,1),art_tile(a1)
		move.b	#$84,render_flags(a1)
		move.w	#$380,priority(a1)
		move.b	#8,width_pixels(a1)
		move.b	#8,height_pixels(a1)
		tst.w	d4
		bmi.s	loc_17FFA
		move.w	d4,d0
		jsr	(GetSineCosine).l
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	loc_17FFA
		subi.w	#$80,d4
		bcc.s	loc_17FFA
		move.w	#$488,d4

loc_17FFA:
		move.w	d2,x_vel(a1)
		move.w	d3,y_vel(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,loc_17F92

locret_1800A:
		rts
; End of function sub_17F82

; ---------------------------------------------------------------------------

Obj_SuperSonic_Stars_Timer:
		tst.b	render_flags(a0)
		bmi.s	loc_18018
		jmp	(Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_18018:
		addq.b	#1,mapping_frame(a0)
		andi.b	#3,mapping_frame(a0)
		bsr.w	MoveSprite2
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------
Map_SuperSonic_Stars:
		include "General/Sprites/Shields/Map - Super Sonic Stars.asm"
; ---------------------------------------------------------------------------