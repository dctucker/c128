#ASM=java -jar /Applications/KickAssembler/KickAss.jar
ASM=cl65 -t c128 -C ./c128-asm.cfg -u __EXEHDR__
VICEDIR=/Applications/VICE/tools
C128=${VICEDIR}/x128
TOKENIZER=${VICEDIR}/petcat -w70 -nh -f

matrix.prg: common.inc matrix.s matrix.bas Katakana-charset.s c128-asm.cfg main.c
	${TOKENIZER} -o matrix.seq matrix.bas
	cc65 -g -Oi -t c128 main.c
	ca65 -g -t c128 matrix.s
	ca65 -g -t c128 main.s
	ld65 -t c128 -o matrix.prg matrix.o main.o c128.lib
	#${ASM} -o matrix.prg matrix.s

clean:
	rm -f *.seq *.prg *.sym *.o *.vs *.d64

run:
	${C128} -remotemonitor matrix.prg

