5 rem gosub 160
45 sys q
48 rem this is the hard way to copy ram... for l=0 to 4095:bank 14:c=peek(53248+l):bank0:poke 8192+l,c:next
50 graphic 0,1:color 0,1:color 4,12:color 5,6
60 gosub 160
100 data 255,129,129,129,129,129,129,255
110 for l=0 to 7:read s:poke 8192+l,s:next
120 end
160 print"{clr}"
161 for k=0 to 1
162 for j=32 to 127 step 16
163 for i=0 to 15
164 print chr$(k*128+j+i);
165 next
166 print
167 next
168 print
169 next
170 return
