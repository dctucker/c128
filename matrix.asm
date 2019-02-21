#import "common.inc"

.const mvsrc = $fa
.const pages = $fc
.const mvdst = $fd
.const screen = $0400

.pc = $1400 "Assembly main"

start:
	// jsr set_character_ram
	lda vshtxt
	and #$f0
	ora #$0c
	sta vshtxt
	jsr Free_Graphics_RAM
	jsr move_basic
	jsr random_init
	jmp matrix_loop
	//jsr copy_character_rom
	//jsr edit_character_ram
	rts

move_basic:
	lda #$00
	sta txttab
	lda #$40
	sta txttab+1
	rts
	
copy_character_rom:
	:Bank(0)
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

.pc = $1c40 "Random"
random_init:
	lda #$ff
	sta $d40e
	sta $d40f
	lda #$80
	sta $d412
	rts
	
random_40:
	clc
	lda $d41b
	//and #%00111111
	cmp #40
	bcs random_40
	rts
random_25:
	clc
	lda $d41b
	//and #%00011111
	cmp #25
	bcs random_25
	rts
random_32:
	clc
	lda $d41b
	and #%00011111
	rts
	
.const rx = $f0
.const ry = $f1
.const rc = $f2
.const offset = $f4
.const sy = $f6
matrix_loop:
	jsr random_40
	sta rx
	jsr random_25
	sta ry
	jsr random_32
	clc
	adc #$40
	sta.zp rc

	lda #$00
	sta offset
	lda #$04
	sta offset+1 // offset = $0400

	lda ry
	sta sy
	lda #0
	sta sy+1 // sy = 0x00ff & ry

	clc
	asl sy
	rol sy+1 // shift sy
	asl sy
	rol sy+1 // shift sy
	asl sy
	rol sy+1 // shift sy

	clc
	lda sy
	adc offset
	sta offset
	lda sy+1
	adc offset+1
	sta offset+1 // offset += sy

	clc
	asl sy
	rol sy+1 // shift sy
	asl sy
	rol sy+1 // shift sy

	clc
	lda sy
	adc offset
	sta offset
	lda sy+1
	adc offset+1
	sta offset+1 // offset += sy
	
	lda rc
	ldy rx
	sta (offset),y
	jmp matrix_loop
colors:
	// wht, l.grn, grn, d.gry, blk
	.byte 1,13,5,11,0
	


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

set_character_ram:
	:Bank(15)
	lda $dd00
	and #$fc
	ora #$00
	sta $dd00
	lda $0a2c
	and #$f1
	ora #$08
	sta $0a2c
	rts

.pc = $3000 "Character set"
charset:
#import "Katakana-charset.s"
.pc = $3800 "Character set"
#import "Katakana-charset.s"


:BasicUpstart128(start)
