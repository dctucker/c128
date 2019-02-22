.const Free_Graphics_RAM = $a022
.const indfet = $ff74
.const indsta = $ff77
.const vshtxt = $0a2c
.const txttab = $4000
.const noise  = $d41b

.macro BasicUpstart128(address) {
	.pc = $1c01 "C128 Basic"
	.word upstartEnd  // link address
	.word 1   // line num
	.byte $51 // q
	.byte $b2 // =
	.byte $d1  // dec
	.byte '('
	.byte '"'
	.text toHexString(address).toUpperCase()
	.byte '"'
	.byte ')'
	//.byte ':'
	//.byte $9e // sys
	//.byte $51 // q
	.byte 0
	.import binary "matrix.seq", $2

upstartEnd:
	.word 0  // empty link signals the end of the program
	.pc = $1c12 "Basic End"
}

.macro Bank(id) {
	.if(id==0) {
		lda #111111  // no roms, RAM 0
	}
	.if(id==1) {
		lda #%01111111  // no roms, RAM 1
	}
	.if(id==12) {
		lda #000110  // int.func. ROM, Kernal, IO, RAM 0
	}
	.if(id==14) {
		lda #000001  // all roms, char ROM, RAM 0
	}
	.if(id==15) {
		lda #000000  // all roms, RAM 0. default.
	}
	.if(id==99) {
		lda #001110  // IO, kernal, RAM0. No basic
	}
	sta $ff00
}

.macro mul2(scale,reg) {
	clc
	.for(var i=0; i < scale; i++){
		asl reg
		rol reg+1
	}
}

.macro bigadd(input,result) {
	clc
	lda input
	adc result
	sta result
	lda input+1
	adc result+1
	sta result+1
}

.macro random(max) {
!:
	clc
	lda noise
	and #pow(2,ceil(log(max)/log(2)))-1
	cmp #max
	bcs !-
}

.macro random_init() {
	lda #$ff
	sta $d40e
	sta $d40f
	lda #$80
	sta $d412
}

.macro move_basic(addr) {
	lda #<addr
	sta txttab
	lda #>addr
	sta txttab+1
}

.const C64 = 72
.const C128 = 23
.const CPlus4 = 255
.const VIC20 = 114
.const C65 = 135
.macro detect_platform(platform) {
	ldy 65534
	cpy #platform
}
