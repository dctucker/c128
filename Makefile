ASM=java -jar /Applications/KickAssembler/KickAss.jar
C128=x128
TOKENIZER=petcat -w70 -nh -f

matrix.prg: common.inc matrix.asm matrix.bas Katakana-charset.s
	${TOKENIZER} -o matrix.seq matrix.bas
	${ASM} matrix.asm

raster.prg: raster.asm
	${ASM} raster.asm

tetris.prg: tetris.asm common.inc
	${ASM} tetris.asm

clean:
	rm -f *.seq *.prg


run:
	${C128} -remotemonitor matrix.prg

