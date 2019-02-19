#import "common.inc"

.const mvsrc = $fa
.const pages = $fc
.const mvdst = $fd
.const indfet = $ff74
.const indsta = $ff77
.const vshtxt = $0a2c

.pc = $1400 "Assembly main"

start:
	// jsr set_character_ram
	lda vshtxt
	and #$f0
	ora #$08
	sta vshtxt
	jsr $a022
	jsr copy_character_rom
	jsr edit_character_ram
	rts

copy_character_rom:
	:Bank(0)
	lda #$00    // pointer to $D000
	sta mvsrc   //
	lda #$d0    //
	sta mvsrc+1 //
	lda #$10
	sta pages   
	lda #$00    // pointer to $2000
	sta mvdst   //
	lda #$20    //
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

.align $100
characters:
	.byte %00110110
	.byte %01001001
	.byte %01001001
	.byte %00110110
	.byte %01001001
	.byte %01001001
	.byte %00110110
	.byte %00000000
edit_character_ram:
	ldy #0
!:
	lda characters,y
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

:BasicUpstart128(start)
