#import "common.inc"

.const mvsrc = $fa
.const pages = $fc
.const mvdst = $fd
.const screen = $0400
.const VIC_BG_COL = $d021

.pc = $1400 "Assembly main"

start:
	jsr set_character_ram
	:move_basic($4000)
	:random_init()
	jsr set_colors
	jmp matrix_loop
	//jsr copy_character_rom
	//jsr edit_character_ram
	rts

set_character_ram:
	lda $d018
	and #$f0
	ora #$0c
	sta $d018

	detect_platform(C128)
	bne !+
	sta vshtxt
	jsr Free_Graphics_RAM
!:
	rts
/*
	:Bank(15)
	lda $dd00
	and #$fc
	ora #$00
	sta $dd00
	lda $0a2c
	and #$f1
	ora #$08
	sta $0a2c
*/
vshtxts:
	.word $0a2c, $d018



set_colors:
	lda #0
	sta VIC_BG_COL-1
	sta VIC_BG_COL
	rts

copy_character_rom:
	Bank(0)
	lda #$00    // pointer to $D000
	sta mvsrc   //
	lda #$d0    //
	sta mvsrc+1 //
	lda #$10
	sta pages   
	lda #$00    // pointer to $3000
	sta mvdst   //
	lda #$30    //
	sta mvdst+1 //
outer_loop:
	ldy #0      // indfet source index
inner_loop:
	lda #mvsrc  // indfet source pointer
	ldx #14     // indfet bank
	jsr indfet

	sta (mvdst),y // reuse as dest index
	iny
	cpy #0
	bne inner_loop

	inc mvsrc+1 // src+=$10
	inc mvdst+1 // dst+=$10
	dec pages
	ldy pages
	cpy #0
	bne outer_loop

	rts

.pc = $1500 "Matrix"

.const rx = $f0
.const ry = $f1
.const rc = $f2
.const rk = $f3
.const offset = $f4
.const sy = $f6

matrix_loop:
	random(40)
	sta rx
	random(25)
/*
	inc ry
	lda ry
	cmp #25
	bcc !+
	lda #0
!:
*/
	sta ry
	:random(46)
	tay
	lda kana,y
	sta rc
	:random(4)
	sta rk

	jsr putchar
	jmp matrix_loop

putchar:
	lda #<screen
	sta offset
	lda #>screen
	sta offset+1

	lda ry
	sta sy
	lda #0
	sta sy+1 // sy = 0x00ff & ry

	:mul2(3,sy)
	:bigadd(sy,offset)
	:mul2(2,sy)
	:bigadd(sy,offset)
	
	lda rc
	ldy rx
	sta (offset),y

	lda #$d4
	adc offset+1
	sta offset+1
	ldx rk
	lda colors,x
	sta (offset),y
	rts

colors:
	// wht, l.grn, grn, d.gry, blk
	.byte 1,13,5,11,0
	
kana:
	.for(var i=64; i < 94; i++){
	.byte i
	}
	.byte 102
	.for(var i=113; i < 128; i++){
	.byte i
	}


.pc = $2f00 "Character RAM routine"
edit_character_ram:
	ldy #0
!:
	lda charset,y
	sta $2000,y
	iny
	cpy #8
	bne !-
	
	rts

.pc = $3000 "Character set"
charset:
#import "Katakana-charset.s"
.pc = $3800 "Character set"
#import "Katakana-charset.s"

.pc = $1c01
BasicUpstart(start)
