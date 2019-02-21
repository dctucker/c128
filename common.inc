.define Free_Graphics_RAM $a022
.define indfet $ff74
.define indsta $ff77
.define vshtxt $0a2c
.define txttab $4000
.define noise  $d41b

.macro BasicUpstart128 address
	.org $1c01
	; "C128 Basic"
	.word upstartEnd  ; link address
	.word 1   ; line num
	.byte $51 ; q
	.byte $b2 ; =
	.byte $d1  ; dec
	.byte '('
	.byte '"'
	.byte "1400"
	.byte '"'
	.byte ')'
	;.byte ':'
	;.byte $9e ; sys
	;.byte $51 ; q
	.byte 0
	.incbin "matrix.seq", $2

upstartEnd:
	.word 0  ; empty link signals the end of the program
	.org $1c12
	; "Basic End"
.endmacro

.macro Bank id
	.if id = 0
		lda #%00111111  ; no roms, RAM 0
	.elseif id = 1
		lda #%01111111  ; no roms, RAM 1
	.elseif id = 12
		lda #%00000110  ; int.func. ROM, Kernal, IO, RAM 0
	.elseif id = 14
		lda #%00000001  ; all roms, char ROM, RAM 0
	.elseif id = 15
		lda #%00000000  ; all roms, RAM 0. default.
	.elseif id = 99
		lda #%00001110  ; IO, kernal, RAM0. No basic
	.endif
	sta $ff00
.endmacro

.macro mul2 scale, reg
	clc
	.repeat scale
		asl reg
		rol reg+1
	.endrepeat
.endmacro

.macro bigadd input,result
	clc
	lda input
	adc result
	sta result
	lda input+1
	adc result+1
	sta result+1
.endmacro

.macro ceil_bitmask max
	.if max < 128
		mask = %01111111
	.elseif max < 64
		mask = %00111111
	.elseif max < 32
		mask = %00011111
	.elseif max < 16
		mask = %00001111
	.elseif max < 8
		mask = %00000111
	.elseif max < 4
		mask = %00000011
	.elseif max < 2
		mask = %00000001
	.endif
.endmacro

.macro random max
	.scope
:
		clc
		lda noise
		ceil_bitmask max
		and mask
		cmp #max
		bcs :-
	.endscope
.endmacro

.macro random_init
	lda #$ff
	sta $d40e
	sta $d40f
	lda #$80
	sta $d412
.endmacro

.macro move_basic addr
	lda #<addr
	sta txttab
	lda #>addr
	sta txttab+1
.endmacro
