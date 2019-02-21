160 print"{clr}"
161 for k=0 to 1
162 for j=32 to 127 step 16
163 for i=0 to 15:print chr$(k*128+j+i);:next
166 print:next
168 print:next
170 return
200 x=int(rnd(1)*40):y=int(rnd(1)*25)
210 c=64+int(rnd(1)*32)
220 poke 1024+y*40+x,c+int(rnd(1)*2)*128
230 k=5+int(rnd(1)*2)*8
230 pokedec("d800")+y*40+x,k
290 return
300 gosub 200
310 color 5,6
320 gosub 200
330 color 5,12
340 goto 300

