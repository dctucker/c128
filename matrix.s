.include "common.inc"

.define mvsrc $fa
.define pages $fc
.define mvdst $fd
.define screen $0400

.export _start

_start:
start:
	lda $ff00
	sta ffbackup
	
	Bank 0
	; jsr set_character_ram
	lda vshtxt
	and #$f0
	ora #$0c
	sta vshtxt
	jsr Free_Graphics_RAM
	; move_basic $4000
	random_init
	jmp matrix_loop
	;jsr copy_character_rom
	;jsr edit_character_ram
	
	lda ffbackup
	sta $ff00
	rts
ffbackup:
	.byte 0

copy_character_rom:
	Bank 0
	lda #$00    ; pointer to $D000
	sta mvsrc   ;
	lda #$d0    ;
	sta mvsrc+1 ;
	lda #$10
	sta pages   
	lda #$00    ; pointer to $3000
	sta mvdst   ;
	lda #$30    ;
	sta mvdst+1 ;
outer_loop:
	ldy #0      ; indfet source index
inner_loop:
	lda #mvsrc  ; indfet source pointer
	ldx #14     ; indfet bank
	jsr indfet

	sta (mvdst),y ; reuse as dest index
	iny
	cpy #0
	bne inner_loop

	inc mvsrc+1 ; src+=$10
	inc mvdst+1 ; dst+=$10
	dec pages
	ldy pages
	cpy #0
	bne outer_loop

	rts

;.org $1500 ;"Matrix"

rx = $f0
ry = $f1
rc = $f2
rk = $f3
offset = $f4
sy = $f6

matrix_loop:
	random 40
	sta rx
	random 25
	sta ry
	random 46
	tay
	lda kana,y
	sta rc
	random 4
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
	sta sy+1 ; sy = 0x00ff & ry

	mul2 3,sy
	bigadd sy,offset
	mul2 2,sy
	bigadd sy,offset
	
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
	; wht, l.grn, grn, d.gry, blk
	.byte 1,13,5,11,0
	
kana:
	.repeat 93-64, i
		.byte i
	.endrepeat
	.byte 102
	.repeat 127-113, i
		.byte i
	.endrepeat


;.org $2f00 ;.section "Character RAM routine"
edit_character_ram:
	ldy #0
:
	lda charset,y
	sta $2000,y
	iny
	cpy #8
	bne :-
	
	rts

set_character_ram:
	Bank 15
	lda $dd00
	and #$fc
	ora #$00
	sta $dd00
	lda $0a2c
	and #$f1
	ora #$08
	sta $0a2c
	rts

.segment "DATA"
;.org $3000 ; .section "Character set"
charset:
.include "Katakana-charset.s"
;.org $3800 ; .section "Character set"
.include "Katakana-charset.s"

