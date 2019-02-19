/*
copy_character_rom:
	:Bank(14)
	lda #$20
	sta $fa
	lda #$fa
	sta $02b9
	ldx #0
	ldy #0
	lda $d000
	jsr indsta
	rts
*/
	

/* // from https://www.commodore.ca/gallery/magazines/ahoy/Ahoy-issue-31.pdf
copy_character_rom:
	lda #<chrbas
	sta mvsrc
	lda #>chrbas
	sta mvsrc + 1
	
	lda #<newadr
	sta mvdst
	lda #>newadr
	sta mvdst + 1
	
	lda #<tablen
	sta lenptr
	lda #>tablen
	sta lenptr + 1
	
	lda #0
	sta $ff00
	ldy #0
	ldx lenptr + 1
	beq mvpart
mvpage:
	jsr getdata
	iny
	bne mvpage
	inc mvsrc + 1
	inc mvdst + 1
	dex
	bne mvpage
mvpart:
	ldx lenptr
	beq mvexit
mvlast:
	jsr getdata
	iny
	dex
	bne mvlast
mvexit:
	lda #0
	sta $ff00
	rts

getdata:
	pha
	txa
	pha
	lda #mvsrc
	ldx #14
	jsr indfet
	jsr stordata
	pla
	tax
	pla
	rts
stordata:
	sta $ff01
	sta (mvdst),y
	lda #0
	sta $ff00
	rts
*/


/*
// from https://www.cubic.org/~doj/c64/mapping128.pdf
copy_character_rom:
	:Bank(15)
	lda #$08
	sta $fa
	lda #$00
	sta $fb
	lda #$20
	sta $fc
	lda #$00
	sta $fd
	lda #$d0
	sta $fe
ldyoo:
	ldy #$00
ldxoe:
	ldx #$0e
	lda #$fd
	jsr indfet
	sta ($fb),y
	iny
	bne ldxoe
	inc $fc
	inc $fd
	dec $fa
	bne ldyoo
	:Bank(15)
	rts
//*/


/*
copy_character_rom:
	lda #$00
	sta $fa
	lda #$d0
	sta $fb
	lda #$00
	sta $fc
	lda #$20
	sta $fd
	lda #$00
	sta $c3
	lda #$08
	sta $c4

	lda #0
	sta $ff00
	ldy #0
	ldx $c4
	beq 
*/
