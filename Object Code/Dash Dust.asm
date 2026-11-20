Obj_DashDust:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	DashDust_Index(pc,d0.w),d1
		jmp	DashDust_Index(pc,d1.w)
; ---------------------------------------------------------------------------
DashDust_Index:
		dc.w loc_18B54-DashDust_Index
		dc.w loc_18BAA-DashDust_Index
		dc.w loc_18CB2-DashDust_Index
		dc.w loc_18CB6-DashDust_Index
; ---------------------------------------------------------------------------

loc_18B54:
		addq.b	#2,routine(a0)
		move.l	#Map_DashDust,mappings(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#make_art_tile(ArtTile_DashDust,0,0),art_tile(a0)
		move.w	#Player_1,parent(a0)
		move.w	#tiles_to_bytes(ArtTile_DashDust),vram_art(a0)
		cmpa.w	#Dust,a0
		beq.s	loc_18BAA
		move.b	#1,$38(a0)
		cmpi.w	#2,(Player_mode).w
		beq.s	loc_18BAA
		move.w	#make_art_tile(ArtTile_DashDust_P2,0,0),art_tile(a0)
		move.w	#Player_2,parent(a0)
		move.w	#tiles_to_bytes(ArtTile_DashDust_P2),vram_art(a0)

loc_18BAA:
		movea.w	parent(a0),a2
		moveq	#0,d0
		move.b	anim(a0),d0
		add.w	d0,d0
		move.w	off_18BBE(pc,d0.w),d1
		jmp	off_18BBE(pc,d1.w)
; ---------------------------------------------------------------------------
off_18BBE:
		dc.w loc_18C94-off_18BBE
		dc.w loc_18BC8-off_18BBE
		dc.w loc_18C20-off_18BBE
		dc.w loc_18C84-off_18BBE
		dc.w loc_18BEC-off_18BBE
; ---------------------------------------------------------------------------

loc_18BC8:
		move.w	(Water_level).w,y_pos(a0)
		tst.b	prev_anim(a0)
		bne.w	loc_18C94
		move.w	x_pos(a2),x_pos(a0)
		move.b	#0,status(a0)
		andi.w	#drawing_mask,art_tile(a0)
		bra.w	loc_18C94
; ---------------------------------------------------------------------------

loc_18BEC:
		tst.b	prev_anim(a0)
		bne.s	loc_18C04
		move.w	x_pos(a2),x_pos(a0)
		move.b	#0,status(a0)
		andi.w	#drawing_mask,art_tile(a0)

loc_18C04:
		lea	(Ani_DashSplashDrown).l,a1
		jsr	(Animate_Sprite).l
		move.l	#ArtUnc_SplashDrown,d6
		bsr.w	SplashDrown_Load_DPLC
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_18C20:
		cmpi.b	#12,air_left(a2)
		blo.w	loc_18CAA
		cmpi.b	#4,routine(a2)
		bhs.s	loc_18CAA
		tst.b	spin_dash_flag(a2)
		beq.s	loc_18CAA
		move.w	x_pos(a2),x_pos(a0)
		move.w	y_pos(a2),y_pos(a0)
		move.b	status(a2),status(a0)
		andi.b	#1,status(a0)
		moveq	#4,d1
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_18C60
		ori.b	#2,status(a0)
		neg.w	d1

loc_18C60:
		tst.b	$38(a0)
		beq.s	loc_18C6A
		sub.w	d1,y_pos(a0)

loc_18C6A:
		tst.b	prev_anim(a0)
		bne.s	loc_18C94
		andi.w	#drawing_mask,art_tile(a0)
		tst.w	art_tile(a2)
		bpl.s	loc_18C94
		ori.w	#high_priority,art_tile(a0)
		bra.s	loc_18C94
; ---------------------------------------------------------------------------

loc_18C84:
		cmpi.b	#12,air_left(a2)
		blo.s	loc_18CAA
		btst	#6,status(a0)
		bne.s	loc_18CAA

loc_18C94:
		lea	(Ani_DashSplashDrown).l,a1
		jsr	(Animate_Sprite).l
		bsr.w	DashDust_Load_DPLC
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_18CAA:
		move.b	#0,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_18CB2:
		bra.w	Delete_Current_Sprite
; ---------------------------------------------------------------------------

loc_18CB6:
		movea.w	parent(a0),a2
		moveq	#$10,d1
		cmpi.b	#$D,anim(a2)
		beq.s	loc_18CE4
		cmpi.b	#2,character_id(a2)
		bne.s	loc_18CD6
		moveq	#6,d1
		cmpi.b	#3,double_jump_flag(a2)
		beq.s	loc_18CE4

loc_18CD6:
		move.b	#2,routine(a0)
		move.b	#0,$36(a0)
		rts
; ---------------------------------------------------------------------------

loc_18CE4:
		subq.b	#1,$36(a0)
		bpl.s	loc_18D66
		move.b	#3,$36(a0)
		btst	#Status_Underwater,status(a2)
		bne.s	loc_18D66
		bsr.w	AllocateObject
		bne.s	loc_18D66
		move.l	(a0),(a1)
		move.w	x_pos(a2),x_pos(a1)
		move.w	y_pos(a2),y_pos(a1)
		tst.b	$38(a0)
		beq.s	loc_18D14
		subq.w	#4,d1

loc_18D14:
		tst.b	(Reverse_gravity_flag).w
		beq.s	loc_18D1C
		neg.w	d1

loc_18D1C:
		add.w	d1,y_pos(a1)
		move.b	#0,status(a1)
		move.b	#3,anim(a1)
		addq.b	#2,routine(a1)
		move.l	mappings(a0),mappings(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	#$80,priority(a1)
		move.b	#4,width_pixels(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	parent(a0),parent(a1)
		andi.w	#drawing_mask,art_tile(a1)
		tst.w	art_tile(a2)
		bpl.s	loc_18D66
		ori.w	#high_priority,art_tile(a1)

loc_18D66:
		bsr.s	DashDust_Load_DPLC
		rts

; =============== S U B R O U T I N E =======================================


DashDust_Load_DPLC:
		move.l	#ArtUnc_DashDust,d6

SplashDrown_Load_DPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	$34(a0),d0
		beq.s	locret_18DBE
		move.b	d0,$34(a0)
		lea	(DPLC_DashSplashDrown).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	locret_18DBE
		move.w	vram_art(a0),d4

loc_18D96:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		add.l	d6,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(Add_To_DMA_Queue).l
		dbf	d5,loc_18D96

locret_18DBE:
		rts
; End of function DashDust_Load_DPLC

; ---------------------------------------------------------------------------
Ani_DashSplashDrown:
		include "General/Sprites/Dash Dust/Anim - Dash Dust.asm"
Map_DashDust:
		include "General/Sprites/Dash Dust/Map - Dash Dust.asm"
DPLC_DashSplashDrown:
		include "General/Sprites/Dash Dust/DPLC - Dash Dust.asm"
; ---------------------------------------------------------------------------

Obj_DashDust2P:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	DashDust2P_Index(pc,d0.w),d1
		jmp	DashDust2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
DashDust2P_Index:
		dc.w loc_18F9C-DashDust2P_Index
		dc.w loc_18FD2-DashDust2P_Index
		dc.w loc_19060-DashDust2P_Index
		dc.w loc_19064-DashDust2P_Index
; ---------------------------------------------------------------------------

loc_18F9C:
		addq.b	#2,routine(a0)
		move.l	#Map_DashDust2P,mappings(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#make_art_tile(ArtTile_DashDust,0,0),art_tile(a0)
		move.w	#Player_1,parent(a0)
		cmpa.w	#Dust,a0
		beq.s	loc_18FD2
		move.w	#Player_2,parent(a0)

loc_18FD2:
		movea.w	parent(a0),a2
		moveq	#0,d0
		move.b	anim(a0),d0
		add.w	d0,d0
		move.w	off_18FE6(pc,d0.w),d1
		jmp	off_18FE6(pc,d1.w)
; ---------------------------------------------------------------------------
off_18FE6:
		dc.w loc_18FEE-off_18FE6
		dc.w loc_18FEE-off_18FE6
		dc.w loc_18FF6-off_18FE6
		dc.w loc_1903E-off_18FE6
; ---------------------------------------------------------------------------

loc_18FEE:
		move.b	#0,mapping_frame(a0)
		bra.s	loc_19046
; ---------------------------------------------------------------------------

loc_18FF6:
		cmpi.b	#12,air_left(a2)
		blo.s	loc_19058
		cmpi.b	#4,routine(a2)
		bhs.s	loc_19058
		tst.b	spin_dash_flag(a2)
		beq.s	loc_19058
		move.w	x_pos(a2),x_pos(a0)
		move.w	y_pos(a2),y_pos(a0)
		move.b	status(a2),status(a0)
		andi.b	#1,status(a0)
		tst.b	prev_anim(a0)
		bne.s	loc_19046
		andi.w	#drawing_mask,art_tile(a0)
		tst.w	art_tile(a2)
		bpl.s	loc_19046
		ori.w	#high_priority,art_tile(a0)
		bra.s	loc_19046
; ---------------------------------------------------------------------------

loc_1903E:
		cmpi.b	#12,air_left(a2)
		blo.s	loc_19058

loc_19046:
		lea	(Ani_DashDust2P).l,a1
		jsr	(Animate_Sprite).l
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_19058:
		move.b	#0,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_19060:
		bra.w	Delete_Current_Sprite
; ---------------------------------------------------------------------------

loc_19064:
		movea.w	parent(a0),a2
		cmpi.b	#$D,anim(a2)
		beq.s	loc_1907E
		move.b	#2,routine(a0)
		move.b	#0,$36(a0)
		rts
; ---------------------------------------------------------------------------

loc_1907E:
		move.b	#0,mapping_frame(a0)
		subq.b	#1,$36(a0)
		bpl.s	locret_190F0
		move.b	#3,$36(a0)
		bsr.w	AllocateObject
		bne.s	locret_190F0
		move.l	(a0),(a1)
		move.w	x_pos(a2),x_pos(a1)
		move.w	y_pos(a2),y_pos(a1)
		addi.w	#$C,y_pos(a1)
		move.b	#0,status(a1)
		move.b	#3,anim(a1)
		addq.b	#2,routine(a1)
		move.l	mappings(a0),mappings(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	#$80,priority(a1)
		move.b	#4,width_pixels(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.w	parent(a0),parent(a1)
		andi.w	#drawing_mask,art_tile(a1)
		tst.w	art_tile(a2)
		bpl.s	locret_190F0
		ori.w	#high_priority,art_tile(a1)

locret_190F0:
		rts
; ---------------------------------------------------------------------------
Ani_DashDust2P:
		include "General/Sprites/Dash Dust/Anim - Dash Dust 2P.asm"
Map_DashDust2P:
		include "General/Sprites/Dash Dust/Map - Dash Dust 2P.asm"
; ---------------------------------------------------------------------------