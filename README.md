# Commodore 128 notes


```
  F1         F2        F3         F4
GRAPHIC    DLOAD"   DIRECTORY   SCNCLR

  F5         F6        F7         F8
DSAVE"      RUN       LIST      MONITOR
111
```


`COLOR 0,1:COLOR 4,12:COLOR 5,6`

Figure 6-1. Source Numbers.

|Source|Description|
|----|----|
|0|	40-column background color (VIC)|
|1|	Foreground for the graphics screen (VIC)|
|2|	Foreground color 1 for the multicolor screen (VIC)|
|3|	Foreground color 2 for the multicolor screen (VIC)|
|4|	40-column (VIC) border (whether in text or graphics mode)|
|5|	Character color for 40- or 80-column text screen|
|6|	80-column background color (8563)|

Figure 6-2. Color Numbers in 40-Column Format.

|Number|Color|
|----|----|
|1|	Black |	
|9|	Orange|
|2|	White |	
|10|	Brown|
|3|	Red |	
|11|	Light Red|
|4|	Cyan |	
|12|	Dark Gray|
|5|	Purple |	
|13|	Medium Gray|
|6|	Green |	
|14|	Light Green|
|7|	Blue |	
|15|	Light Blue|
|8|	Yellow |	
|16|	Light Gray|


Figure 6-3. Color Numbers in 80-Column Format.

|Number|Color|
|----|----|
|1	|Black|
|9	|Dark Purple|
|2	|White|
|10	|Brown|
|3	|Dark Red|
|11	|Light Red|
|4	|Light Cyan|
|12	|Dark Cyan|
|5	|Light Purple|
|13	|Medium Gray|
|6	|Dark Green|
|14	|Light Green|
|7	|Dark Blue|
|15	|Light Blue|
|8	|Light Yellow|
|16	|Light Gray|



```
SPRITE #,O,C,P,X,Y,M

#	Sprite number (1 to 8)
O	Turn On (O=1) or Off (O=0)
C	Color (1-16)
P	Priority
	if P=0, sprite is in front of objects on the screen
	if P=1, sprite is behind objects on the screen
X	if X=1, expands sprite in horizontal (X) direction
	if X=0, sprite in normal horizontal size
Y	if Y=1, expands sprite in vertical (Y) direction
	if Y=0, sprite in normal vertical size
M	if M=1, sprite is multicolor
	if M=0, sprite is standard
```



```
8722 MEMORY MANAGEMENT UNIT DECLARATIONS
;
mmucr =$ff00 ;configuration...
;
;0xxxxxxx
; |||||||
; ||||||+---> $D000-$DFFF: 0 = I/O hardware
; ||||||                   1 = RAM or character ROM
; |||||+----> $4000-$7FFF: 0 = system ROM
; |||||                    1 = RAM
; |||++-----> $8000-$BFFF: 00 = system ROM
; |||                      01 = internal function ROM
; |||                      10 = external function ROM
; |||                      11 = RAM
; |++-------> $C000-$FFFF: 00 = system ROM
; |                        01 = internal function ROM
; |                        10 = external function ROM
; |                        11 = RAM
; +---------> RAM bank: 0 = RAM-0
;                       1 = RAM-1
;
lcra =mmucr+1 ;select configuration A
lcrb =mmucr+2 ;select configuration B
lcrc =mmucr+3 ;select configuration C
lcrd =mmucr+4 ;select configuration D
```

```
MEMORY MANAGEMENT C128
====================
Standard BANKs:
0 - RAM 0
1 - RAM 1
2 - RAM 0
3 - RAM 1
4 - Internal ROM/RAM 0/ I/O
5 - Internal ROM/RAM 1/ I/O
6 - Internal ROM/RAM 0/ I/O
7 - Internal ROM/RAM 1/ I/O
8 - External ROM/RAM 0/ I/O
9 - External ROM/RAM 1/ I/O
10 - External ROM/RAM 0/ I/O
11 - External ROM/RAM 1/ I/O
12 - KERNAL/Internal ROM(lo)/RAM 0/ I/O
13 - KERNAL/External ROM(lo)/RAM 0/ I/O
14 - KERNAL/BASIC ROM/RAM 0/Character ROM
15 - KERNAL/BASIC ROM/RAM 0/ I/O
```


# Character ROM hack from [Atari Magazine](https://www.atarimagazines.com/compute/issue67/346_1_Advanced_Commodore_128_Video.php)

```
100 POKE 58, DEC ("C0")
110 CLR
120 TRAP 500
130 BANK 15
140 POKE DEC ("DD00"), 148
150 POKE DEC ("0A2C"), 32
160 POKE DEC ("D506"), 68
170 POKE 217, 4

200 FOR J = 0 TO 999
210 BANK 0 : X = PEEK (1024 + J)
220 BANK 1 : POKE DEC("C800") + J, X
230 NEXT J

300 FOR J = DEC ("C000") TO DEC ("C7FF") STEP 8
310 FOR K = 0 TO 7
320 BANK 14
330 X = PEEK (J + 4096 + 7 - K)
340 BANK 1
350 POKE J + K, X
360 NEXT K
370 NEXT J

500 BANK 15
510 POKE DEC ("DD00"), 151
520 POKE DEC ("0A2C"), 20
530 POKE DEC ("D506"), 4
540 POKE 217, 0
550 POKE 58, DEC ("FF")
560 CLR
```


Routine to copy ROM to RAM

```
a 1400
lda #$00
sta $ff00
LDA #$08
STA $FA
LDA #$00
STA $FB
LDA #$20
STA $FC
LDA #$00
STA $FD
LDA #$D0
STA $FE
LDY #$00
LDX #$0E
LDA #$FD
JSR $FF74
STA ($FB),Y
INY
BNE $1416
INC $FC
INC $FD
DEC $FA
BNE $1414
RTS
```

Move BASIC to $1c01
```
jsr $a022
```

Routine from book

```
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
................................

```

Routine to select bank and set character ram to $2000

```
a 0c00
lda #$00
sta $ff00
lda $dd00
and #$fc
ora #$00
sta $dd00
lda $0a2c
and #$f0
ora #$08
sta $0a2c
rts
```

```
Bits  Offset for character set
3 2 1
0 0 0           0/$0000
0 0 1        2048/$0800
0 1 0        4096/$1000
0 1 1        6144/$1800
1 0 0        8192/$2000
1 0 1       10240/$2800
1 1 0       12288/$3000
1 1 1       14336/$3800
```
