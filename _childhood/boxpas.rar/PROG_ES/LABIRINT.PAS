uses  Crt,Graph;
var fa,f,d,g:integer;
    faza,go,ekr:array[1..2] of byte;
    r,t:array[1..2] of integer;
    h:char;
procedure wind;
begin
setcolor(1);
line(319,0,319,199);
rectangle(0,150,639,199);
settextstyle(7,0,1);
outtextxy(10,152,'Player 1');
outtextxy(540,152,'Player 2');
rectangle(2,152,130,173);
rectangle(514,152,642,173);
settextstyle(8,0,1);
outtextxy(10,170,'Energy');
outtextxy(552,170,'Energy');
end;
procedure sector1(x,y:integer);
begin
setcolor(1);
line(x+10,y+10,x+280,y+10);
line(x+10,y+10,x+10,y+90);
line(x+190,y+10,x+190,y+50);
line(x+140,y+50,x+190,y+50);
line(x+140,y+50,x+140,y+70);
rectangle(x+40,y+30,x+110,y+70);
line(x+80,y+30,x+80,y+50);
line(x+110,y+30,x+160,y+30);
line(x+10,y+90,x+60,y+90);
line(x+90,y+70,x+90,y+90);
line(x+210,y+30,x+230,y+30);
line(x+210,y+30,x+210,y+70);
line(x+200,y+70,x+210,y+70);
line(x+280,y+10,x+280,y+20);
rectangle(x+280,y+20,x+310,y+50);
line(x+250,y+30,x+250,y+110);
line(x+230,y+50,x+250,y+50);
line(x+120,y+90,x+170,y+90);
line(x+170,y+70,x+170,y+90);
rectangle(x+90,y+90,x+120,y+110);
line(x+50,y+110,x+90,y+110);
line(x+20,y+90,x+20,y+130);
line(x+20,y+130,x+60,y+130);
line(x+60,y+130,x+60,y+150);
line(x+90,y+130,x+90,y+150);
rectangle(x+130,y+130,x+170,y+150);
line(x+120,y+110,x+120,y+130);
line(x+120,y+130,x+130,y+130);
line(x+150,y+110,x+200,y+110);
line(x+200,y+70,x+200,y+130);
line(x+200,y+130,x+320,y+130);
line(x+250,y+110,x+270,y+110);
line(x+310,y+50,x+310,y+70);
line(x+310,y+70,x+280,y+70);
line(x+280,y+70,x+280,y+90);
line(x+280,y+90,x+300,y+90);
line(x+300,y+90,x+300,y+130);
end;
procedure man(x,y:integer;c,faz,goo:byte);
begin
  setcolor(c);
 if goo=1 then begin
  rectangle(x+4,y+3,x+6,y+4);
  rectangle(x+2,y+5,x+8,y+6);
  line(x+2,y+7,x+8,y+7);
  putpixel(x+1,y+6,c);
  putpixel(x+9,y+6,c);
  line(x+10,y+3,x+10,y+5);
  line(x+9,y+2,x+9,y+3);
  line(x+8,y+1,x+8,y+2);
  if faz=1 then line(x,y+3,x,y+5);
  if (faz=2) or (faz=8) then line(x,y+4,x,y+5);
  if (faz=3) or (faz=7) then line(x,y+5,x,y+6);
  if (faz=4) or (faz=6) then putpixel(x,y+6,c);
  if faz=5 then line(x,y+6,x,y+7)
               end;
  if goo=3 then begin
  rectangle(x+4,y+3,x+6,y+4);
  rectangle(x+2,y+1,x+8,y+2);
  line(x+2,y,x+8,y);
  putpixel(x+1,y+1,c);
  putpixel(x+9,y+1,c);
  line(x,y+2,x,y+4);
  line(x+1,y+4,x+1,y+5);
  line(x+2,y+5,x+2,y+7);
  if faz=1 then line(x+10,y+2,x+10,y+4);
  if (faz=2) or (faz=8) then line(x+10,y+2,x+10,y+3);
  if (faz=3) or (faz=7) then line(x+10,y+1,x+10,y+2);
  if (faz=4) or (faz=6) then putpixel(x+10,y+1,c);
  if faz=5 then line(x+10,y,x+10,y+1)
                end;
  if goo=2 then begin
  rectangle(x+4,y+3,x+5,y+4);
  rectangle(x+2,y+2,x+3,y+5);
  rectangle(x,y+2,x+1,y+5);
  putpixel(x+2,y+1,c);
  putpixel(x+2,y+6,c);
  line(x+3,y+7,x+5,y+7);
  line(x+5,y+6,x+6,y+6);
  line(x+6,y+5,x+8,y+5);
  if faz=1 then line(x+3,y,x+5,y);
  if (faz=2) or (faz=8) then line(x+3,y,x+4,y);
  if (faz=3) or (faz=7) then line(x+2,y,x+3,y);
  if (faz=4) or (faz=6) then putpixel(x+2,y,c);
  if faz=5 then line(x+1,y,x+2,y)
                end;
  if goo=4 then begin
  rectangle(x+3,y+3,x+4,y+4);
  rectangle(x+5,y+2,x+6,y+5);
  rectangle(x+7,y+2,x+8,y+5);
  putpixel(x+6,y+1,c);
  putpixel(x+6,y+6,c);
  line(x+3,y,x+5,y);
  line(x+2,y+1,x+3,y+1);
  line(x,y+2,x+2,y+2);
  if faz=1 then line(x+3,y+7,x+5,y+7);
  if (faz=2) or (faz=8) then line(x+4,y+7,x+5,y+7);
  if (faz=3) or (faz=7) then line(x+5,y+7,x+6,y+7);
  if (faz=4) or (faz=6) then putpixel(x+6,y+7,c);
  if faz=5 then line(x+7,y+7,x+8,y+7)
                end;
end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
r[1]:=20; t[1]:=20; faza[1]:=1; go[1]:=1;ekr[1]:=1;
r[2]:=500; t[2]:=150; faza[2]:=1; go[2]:=1;ekr[2]:=1;
sector1(0,0);
wind;
man(r[1],t[1],1,faza[1],go[1]);
REPEAT
  repeat
  until keypressed;
  h:=readkey;
if (h='i') and (getpixel(r[1],t[1]-2)=0) and (getpixel(r[1]+10,t[1]-2)=0)
and (getpixel(r[1]+9,t[1]-2)=0) and (getpixel(r[1]+8,t[1]-2)=0)
and (getpixel(r[1]+7,t[1]-2)=0) and (getpixel(r[1]+6,t[1]-2)=0)
and (getpixel(r[1]+5,t[1]-2)=0) and (getpixel(r[1]+4,t[1]-2)=0)
and (getpixel(r[1]+3,t[1]-2)=0) and (getpixel(r[1]+2,t[1]-2)=0)
and (getpixel(r[1]+1,t[1]-2)=0) then
             begin
              man(r[1],t[1],0,faza[1],go[1]);
              go[1]:=1; t[1]:=t[1]-2;
              faza[1]:=faza[1]+1;
              if faza[1]=9 then faza[1]:=1;
              man(r[1],t[1],1,faza[1],go[1])
             end;
if (h='k') and (getpixel(r[1],t[1]+10)=0) and (getpixel(r[1]+10,t[1]+10)=0)
and (getpixel(r[1]+9,t[1]+10)=0) and (getpixel(r[1]+8,t[1]+10)=0)
and (getpixel(r[1]+7,t[1]+10)=0) and (getpixel(r[1]+6,t[1]+10)=0)
and (getpixel(r[1]+5,t[1]+10)=0) and (getpixel(r[1]+4,t[1]+10)=0)
and (getpixel(r[1]+3,t[1]+10)=0) and (getpixel(r[1]+2,t[1]+10)=0)
and (getpixel(r[1]+1,t[1]+10)=0) then
             begin
              man(r[1],t[1],0,faza[1],go[1]);
              go[1]:=3; t[1]:=t[1]+2;
              faza[1]:=faza[1]+1;
              if faza[1]=9 then faza[1]:=1;
              man(r[1],t[1],1,faza[1],go[1])
             end;
if (h='l') and (getpixel(r[1]+15,t[1]+7)=0) and (getpixel(r[1]+15,t[1]+6)=0)
and (getpixel(r[1]+15,t[1]+5)=0) and (getpixel(r[1]+15,t[1]+4)=0)
and (getpixel(r[1]+15,t[1]+3)=0) and (getpixel(r[1]+15,t[1]+2)=0)
and (getpixel(r[1]+15,t[1]+1)=0) and (getpixel(r[1]+15,t[1])=0) then
             begin
              man(r[1],t[1],0,faza[1],go[1]);
              go[1]:=2; r[1]:=r[1]+5;
              faza[1]:=faza[1]+1;
              if faza[1]=9 then faza[1]:=1;
              man(r[1],t[1],1,faza[1],go[1])
             end;
if (h='j') and (getpixel(r[1]-5,t[1]+7)=0) and (getpixel(r[1]-5,t[1]+6)=0)
and (getpixel(r[1]-5,t[1]+5)=0) and (getpixel(r[1]-5,t[1]+4)=0)
and (getpixel(r[1]-5,t[1]+3)=0) and (getpixel(r[1]-5,t[1]+2)=0)
and (getpixel(r[1]-5,t[1]+1)=0) and (getpixel(r[1]-5,t[1])=0) then
             begin
              man(r[1],t[1],0,faza[1],go[1]);
              go[1]:=4; r[1]:=r[1]-5;
              faza[1]:=faza[1]+1;
              if faza[1]=9 then faza[1]:=1;
              man(r[1],t[1],1,faza[1],go[1])
             end;
if (h='8') and (getpixel(r[2],t[2]-2)=0) and (getpixel(r[2]+10,t[2]-2)=0)
and (getpixel(r[2]+9,t[2]-2)=0) and (getpixel(r[2]+8,t[2]-2)=0)
and (getpixel(r[2]+7,t[2]-2)=0) and (getpixel(r[2]+6,t[2]-2)=0)
and (getpixel(r[2]+5,t[2]-2)=0) and (getpixel(r[2]+4,t[2]-2)=0)
and (getpixel(r[2]+3,t[2]-2)=0) and (getpixel(r[2]+2,t[2]-2)=0)
and (getpixel(r[2]+1,t[2]-2)=0) then
             begin
              man(r[2],t[2],0,faza[2],go[2]);
              go[2]:=1; t[2]:=t[2]-2;
              faza[2]:=faza[2]+1;
              if faza[2]=9 then faza[2]:=1;
              man(r[2],t[2],1,faza[2],go[2])
             end;
if (h='5') and (getpixel(r[2],t[2]+10)=0) and (getpixel(r[2]+10,t[2]+10)=0)
and (getpixel(r[2]+9,t[2]+10)=0) and (getpixel(r[2]+8,t[2]+10)=0)
and (getpixel(r[2]+7,t[2]+10)=0) and (getpixel(r[2]+6,t[2]+10)=0)
and (getpixel(r[2]+5,t[2]+10)=0) and (getpixel(r[2]+4,t[2]+10)=0)
and (getpixel(r[2]+3,t[2]+10)=0) and (getpixel(r[2]+2,t[2]+10)=0)
and (getpixel(r[2]+1,t[2]+10)=0) then
             begin
              man(r[2],t[2],0,faza[2],go[2]);
              go[2]:=3; t[2]:=t[2]+2;
              faza[2]:=faza[2]+1;
              if faza[2]=9 then faza[2]:=1;
              man(r[2],t[2],1,faza[2],go[2])
             end;
if (h='6') and (getpixel(r[2]+15,t[2]+7)=0) and (getpixel(r[2]+15,t[2]+6)=0)
and (getpixel(r[2]+15,t[2]+5)=0) and (getpixel(r[2]+15,t[2]+4)=0)
and (getpixel(r[2]+15,t[2]+3)=0) and (getpixel(r[2]+15,t[2]+2)=0)
and (getpixel(r[2]+15,t[2]+1)=0) and (getpixel(r[2]+15,t[2])=0) then
             begin
              man(r[2],t[2],0,faza[2],go[2]);
              go[2]:=2; r[2]:=r[2]+5;
              faza[2]:=faza[2]+1;
              if faza[2]=9 then faza[2]:=1;
              man(r[2],t[2],1,faza[2],go[2])
             end;
if (h='4') and (getpixel(r[2]-5,t[2]+7)=0) and (getpixel(r[2]-5,t[2]+6)=0)
and (getpixel(r[2]-5,t[2]+5)=0) and (getpixel(r[2]-5,t[2]+4)=0)
and (getpixel(r[2]-5,t[2]+3)=0) and (getpixel(r[2]-5,t[2]+2)=0)
and (getpixel(r[2]-5,t[2]+1)=0) and (getpixel(r[2]-5,t[2])=0) then
             begin
              man(r[2],t[2],0,faza[2],go[2]);
              go[2]:=4; r[2]:=r[2]-5;
              faza[2]:=faza[2]+1;
              if faza[2]=9 then faza[2]:=1;
              man(r[2],t[2],1,faza[2],go[2])
             end;
if h=' ' then begin
               for f:=1 to 10 do begin
               sound(6000+f*10);delay(1);nosound end;
              end;
UNTIL h=#27;
CloseGraph
end.