4 print"{clr}"
5 for i=32 to 127:print chr$(i);:next
6 for i=160 to 255:print chr$(i);:next
7 print
10 poke 217,4
20 graphic 2,1
30 poke 2604,peek(2604) and 240 or 8
45 sys q
48 rem this is the hard way to copy ram... for l=0 to 4095:bank 14:c=peek(53248+l):bank0:poke 8192+l,c:next
50 graphic 0,1
60 print"{clr}"
66 for i=32 to 127:print chr$(i);:next
77 for i=160 to 255:print chr$(i);:next
78 print
100 data 255,129,129,129,129,129,129,255
110 for l=0 to 7:read s:poke 8192+l,s:next
