;
; File generated by cc65 v 2.17 - Git N/A
;
	.fopt		compiler,"cc65 v 2.17 - Git N/A"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	on
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.dbg		file, "main.c", 56, 1550790657
	.forceimport	__STARTUP__
	.dbg		sym, "start", "00", extern, "_start"
	.import		_start
	.export		_main

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

	.dbg	func, "main", "00", extern, "_main"

.segment	"CODE"

	.dbg	line, "main.c", 4
	ldy     #$00
	jsr     _start
	.dbg	line, "main.c", 5
	ldx     #$00
	txa
	.dbg	line, "main.c", 6
	rts
	.dbg	line

.endproc

