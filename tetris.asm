#import "common.inc"

.const mvsrc = $fa
.const pages = $fc
.const mvdst = $fd
.const screen = $0400

.pc = $1400 "Assembly main"

start:
	//jsr set_character_ram
	move_basic($4000)
	random_init()
	jsr set_colors
	jsr setup_irq

	jsr Cursor_To_Window_Home
	jsr Edit_Steady_Cursor
	jsr Edit_Blink_Off
	jsr Edit_Cursor_Off

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
vshtxts:
	.word $0a2c, $d018

set_colors:
	lda #0
	sta VIC_BG_COL-1
	sta VIC_BG_COL
	rts


.pc = $1500 "Game loop"

.const well_x = $10
.const well_height = $20
.const t = $f0
.const cx = $f1
.const cy = $f2
.const rotation = $f2
.const offset = $f4
.const state = $f7
.const piece = $f8

tetris_iter:
	/*
	random(40)
	sta rx
	random(16)
	adc #01
	sta ry
	random(46)
	tay
	lda kana,y
	sta rc
	random(4)
	sta rk
	*/
	//jsr putchar

	inc t
	lda t
	beq fall
fell:
	rts

fall:
	ldx cy

	lda E_40_Line_Lo,x
	ldy E_40_Line_Hi,x
	sta offset
	sty offset+1
	ldx cx
	ldy #4
!:
	lda (offset + well_x), x
	cmp #0
	bne check_below
	inx
	dey
	cpy #0
	bne !-
check_below:
	cmp (40 + offset + well_x), x
	beq land
	dec cy
	jmp fell
land:
	lda well_height
	sta cy
	jmp fell

new_piece:
	random(6)
	sta piece
	rts

.word 0
irq:
	sec
	lda $d019
	and #$01
	beq !end+
	sta $d019

	jsr tetris_iter
!end:
	asl $d019
	jmp $fa6b

setup_irq:
	sei

	lda #240
	sta $d012 // set raster line number
	lda #1
	sta $d019

	lda #<irq
	sta $0314
	lda #>irq
	sta $0315
	lda #1
	sta $d01a // enable raster interrupt from VIC

	cli
	rts

/*
.align $100
putchar:
.const plot = $fff0
	ldx ry
	lda E_40_Line_Lo,x
	ldy E_40_Line_Hi,x
	sta offset
	sty offset+1

	lda rc
	ldy rx
	sta (offset),y

	lda #>(color_ram-screen)
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
*/


/*
.pc = $3000 "Character set"
charset:
#import "tetris-charset.s"
.pc = $3800 "Character set"
#import "tetris-charset.s"
*/

.pc = $1c01
BasicUpstart(start)
