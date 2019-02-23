#import "common.inc"

.const mvsrc = $fa
.const pages = $fc
.const mvdst = $fd
.const screen = $0400
.const VIC_BG_COL = $d021
.const color_ram = $d800
.const vic_scroll_y = $d011
.const JESCAPE = $c9c1

.pc = $1400 "Assembly main"

start:
	jsr set_character_ram
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

matrix_iter:
	random(40)
	sta rx
	random(20)
	sta ry
	random(46)
	tay
	lda kana,y
	sta rc
	random(4)
	sta rk
	
	jsr putchar
	jsr scroll
	rts


.word 0
irq:
/*
	sec
	lda $d019
	and #$01
	beq !end+
	sta $d019

*/
	jsr matrix_iter
!end:
	jmp (irq-2)

setup_irq:
	sei

	lda #240
	sta $d012 // set raster line number
	lda #1
	sta $d019

	ldx $0314
	ldy $0315
	stx irq-2
	sty irq-1
	
	lda #<irq
	sta $0314
	lda #>irq
	sta $0315

	lda #$ff
	sta.a $00d8

	cli
	rts

/* C64 maybe
	lda #%01110111
	sta $dc0d // switch off CIA-1
	and $d011
	sta $d011 // clear MSB in raster register
	lda #210
	sta $d012 // set raster line number
	lda #<irq
	sta $0314
	lda #>irq
	sta $0315 // set irq vector
	lda #1
	sta $d01a // enable raster interrupt from VIC
	rts
*/

.align $100
scroll:
	inc count
	lda #%00000001
	bit count
	beq scroll_iter
	rts

scroll_iter:
	lda vic_scroll_y
	and #%11111000
	ora value
	sta vic_scroll_y

	lda value
	inc value
	cmp #8
	bcs !+
	rts
!:
	fast()
	//jsr Scroll_Row
	//jsr Edit_Scroll_Down

	jsr block_scroll
	slow()

	lda #1
	sta value
	rts
//*/

/*
	lda vic_scroll_y
	tax
	and #%11111000
	sta value
	inx
	txa
	and #%00000111
	tax
	ora value
	sta vic_scroll_y
	cpx #0
	bne !+
	jsr block_scroll
	//lda #87
	//jsr JESCAPE
//*/
value:
	.byte 0
count:
	.byte 0

block_scroll:
	ldx #0
!loop:
	.for(var i=24;i>=0;i--) {
		lda screen+(i+0)*40,x
		sta screen+(i+1)*40,x
		//lda color_ram+(i+0)*40,x
		//sta color_ram+(i+1)*40,x
	}
	inx
	cpx #40
	beq !+
	jmp !loop-

!:
	lda #$20
	ldx #0
!:
	sta screen,x
	inx
	cpx #40
	bne !-
	rts

.align $100
putchar:
/*
	lda #<screen
	sta offset
	lda #>screen
	sta offset+1
*/

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
	
/*
	clc
	ldx rx
	ldy ry
	jsr plot
	
	ldx.a $00e0
	stx offset
	ldx.a $00e1
	stx offset+1

	lda rc
	ldy rx
	sta (offset),y
	rts
*/
	
	
/*
	lda ry
	sta sy
	lda #0
	sta sy+1 // sy = 0x00ff & ry

	mul2(3,sy)
	bigadd(sy,offset)
	mul2(2,sy)
	bigadd(sy,offset)
	
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
*/

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
