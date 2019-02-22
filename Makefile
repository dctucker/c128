ASM=acme
VICEDIR=/Applications/VICE/tools
C128=x128
TOKENIZER=petcat -w70 -nh -f

matrix.prg: common.inc matrix.asm matrix.bas Katakana-charset.s
	${TOKENIZER} -o matrix.seq matrix.bas
	${ASM} matrix.asm

clean:
	rm -f *.seq *.prg


run:
	${C128} -remotemonitor matrix.prg

