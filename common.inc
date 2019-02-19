
.macro BasicUpstart128(address) {
	.pc = $1c01 "C128 Basic"
	.word upstartEnd  // link address
	.word 1   // line num
	.byte $51
	.byte $b2
	.byte $d1  // dec
	.byte '('
	.byte '"'
	.text toHexString(address).toUpperCase()
	.byte '"'
	.byte ')'
	.byte 0
	.var basic = LoadBinary("matrix.seq","C64FILE")
	.fill basic.getSize(), basic.get(i)
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
