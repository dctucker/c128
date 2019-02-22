ASM=acme
VICEDIR=/Applications/VICE/tools
C128=${VICEDIR}/x128
TOKENIZER=${VICEDIR}/petcat -w70 -nh -f

matrix.prg: common.inc matrix.asm matrix.bas Katakana-charset.s
	${TOKENIZER} -o matrix.seq matrix.bas
	${ASM} matrix.asm

clean:
	rm -f *.seq *.prg


run:
	${C128} -remotemonitor matrix.prg

