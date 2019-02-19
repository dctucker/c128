#import "common.inc"

* = $1400

.const mvsrc = $fa
.const pages = $fc
.const mvdst = $fd
.const indfet = $ff74
.const indsta = $ff77
/*
chrbas: .word $d000
newadr: .word $2000
tablen: .word $800
lenptr: .byte $c3
getcfg: .word $ff6b
*/


start:
	// jsr set_character_ram
	jsr copy_character_rom
	rts

copy_character_rom:
	:Bank(0)
	lda #$00
	sta mvsrc
	lda #$d0
	sta mvsrc+1
	lda #$10
	sta pages
	lda #$00
	sta mvdst
	lda #$20
	sta mvdst+1
copy_loop:
	ldy #0
inner_loop:
	lda #mvsrc
	ldx #14
	jsr indfet
	sta (mvdst),y
	iny
	cpy #0
	bne inner_loop
	inc mvsrc+1
	inc mvdst+1
	dec pages
	ldy pages
	cpy #0
	bne copy_loop
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
