uses  Crt,Graph;
label start;
var err,pis,zones,ogn,bom,go,faza,r,t,f,d,g,
    pisx,pisy         :integer;
    pp                :pointer;
    size,laser        :word;
    h                 :char;
    s                 :string;
    pistolet,is       :array[1..1000] of boolean;
    fazas,gos,en      :array[1..1000] of byte;
    rs,ts,ras,rr      :array[1..1000] of integer;
    point             :array[1..23,1..68] of boolean;
    energy,sel        :byte;
    fil               :text;
    dver2,kartochka   :boolean;
procedure k(x,y:integer);
begin
setcolor(0);
for d:=1 to 15 do line(x,y-1+d,x+66,y-1+d)
end;
procedure gameover;
begin
setcolor(0);
for f:=0 to 320 do begin
line(f,0,f,200);line(640-f,0,640-f,200) end;
setcolor(1);
settextstyle(7,0,6);
outtextxy(130,60,'Game oveR');
readln;
halt
end;
procedure vrag1(x,y,c,faz,goo:integer);
var col:byte;
begin
if c=1 then col:=1 else col:=0;
setcolor(col);
if goo=1 then begin
rectangle(x+2,y,x+4,y+1);
putpixel(x+5,y+1,col);
putpixel(x+3,y+2,col);
rectangle(x,y+3,x+2,y+4);
line(x+1,y+5,x+2,y+5);
line(x+3,y+4,x+5,y+4);
line(x+5,y+3,x+8,y+3);
putpixel(x+7,y+2,col);
if faz=1 then
        begin
         line(x+1,y+6,x+1,y+7);
         line(x+4,y+7,x+4,y+8);
         putpixel(x,y+8,col);
         putpixel(x+3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x+1,y+6,x+1,y+8);
         line(x+3,y+7,x+3,y+8);
         putpixel(x+2,y+6,col)
        end;
      if faz=3 then rectangle(x+1,y+6,x+2,y+8)
              end;
if goo=2 then begin
rectangle(x-2,y,x-4,y+1);
putpixel(x-5,y+1,col);
putpixel(x-3,y+2,col);
rectangle(x,y+3,x-2,y+4);
line(x-1,y+5,x-2,y+5);
line(x-3,y+4,x-5,y+4);
line(x-5,y+3,x-8,y+3);
putpixel(x-7,y+2,col);
if faz=1 then
        begin
         line(x-1,y+6,x-1,y+7);
         line(x-4,y+7,x-4,y+8);
         putpixel(x,y+8,col);
         putpixel(x-3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x-1,y+6,x-1,y+8);
         line(x-3,y+7,x-3,y+8);
         putpixel(x-2,y+6,col)
        end;
      if faz=3 then rectangle(x-1,y+6,x-2,y+8)
              end;
end;
procedure man(x,y,c,faz,goo:integer);
var col:byte;
begin
 if c=1 then col:=1 else col:=0;
 setcolor(col);
 if goo=1 then
    begin
      rectangle(x+3,y,x+4,y+1);
      putpixel(x+5,y+1,col);
      putpixel(x+3,y+2,col);
      rectangle(x+1,y+3,x+2,y+5);
      line(x+3,y+4,x+4,y+4);
      line(x+5,y+5,x+5,y+3);
      line(x+6,y+3,x+8,y+3);
      if faz=1 then
        begin
         line(x+1,y+6,x+1,y+7);
         line(x+4,y+7,x+4,y+8);
         putpixel(x,y+8,col);
         putpixel(x+3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x+1,y+6,x+1,y+8);
         line(x+3,y+7,x+3,y+8);
         putpixel(x+2,y+6,col)
        end;
      if faz=3 then rectangle(x+1,y+6,x+2,y+8)
    end;
if goo=2 then
    begin
      rectangle(x-3,y,x-4,y+1);
      putpixel(x-5,y+1,col);
      putpixel(x-3,y+2,col);
      rectangle(x-1,y+3,x-2,y+5);
      line(x-3,y+4,x-4,y+4);
      line(x-5,y+5,x-5,y+3);
      line(x-6,y+3,x-8,y+3);
      if faz=1 then
        begin
         line(x-1,y+6,x-1,y+7);
         line(x-4,y+7,x-4,y+8);
         putpixel(x,y+8,col);
         putpixel(x-3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x-1,y+6,x-1,y+8);
         line(x-3,y+7,x-3,y+8);
         putpixel(x-2,y+6,col)
        end;
      if faz=3 then rectangle(x-1,y+6,x-2,y+8)
    end;
end;
procedure patroni(x,y,c:integer);
var col:byte;
begin
if c=1 then col:=1 else col:=0;
setcolor(col);
line(x+1,y,x+6,y);line(x,y+1,x,y+6);line(x+1,y+6,x+7,y+6);
line(x+7,y+1,x+7,y+6);line(x+2,y+3,x+5,y+3);putpixel(x+2,y+4,col);putpixel(x+4,y+2,col)
end;
procedure fire(x,y,c,goo:integer);
var col:byte;
begin
 if c=1 then col:=1 else col:=0;
 setcolor(col);
 if goo=1 then
  begin
   rectangle(x-2,y,x-1,y+1);
   putpixel(x,y+1,col);
   putpixel(x-2,y+2,col);
   rectangle(x-1,y+3,x,y+5);
   line(x+1,y+3,x+2,y+3);
   line(x+3,y+2,x+3,y+4);
   line(x+4,y+2,x+6,y+2);
   line(x-1,y+6,x+1,y+8);
   line(x+1,y+6,x+2,y+6);
   putpixel(x+3,y+7,col)
  end;
 if goo=2 then
  begin
   rectangle(x+2,y,x+1,y+1);
   putpixel(x,y+1,col);
   putpixel(x+2,y+2,col);
   rectangle(x+1,y+3,x,y+5);
   line(x-1,y+3,x-2,y+3);
   line(x-3,y+2,x-3,y+4);
   line(x-4,y+2,x-6,y+2);
   line(x+1,y+6,x-1,y+8);
   line(x-1,y+6,x-2,y+6);
   putpixel(x-3,y+7,col)
  end;
end;
procedure clearmessage;
begin
 setcolor(0);
 for f:=1 to 43 do line(431,152+f,636,152+f);
 setcolor(1)
end;
procedure message1;
begin
clearmessage;
s:='Найди проходную карточку!';
for f:= 1 to length(s) do
 begin
   outtextxy(432,154,copy(s,1,f));
   sound(10000);delay(1);nosound
 end;
end;
procedure message0;
begin
clearmessage;
s:='У вас нет проходной кар-';
for f:= 1 to length(s) do
 begin
   outtextxy(432,154,copy(s,1,f));
   sound(10000);delay(1);nosound
 end;
s:='  точки!';
for f:= 1 to length(s) do
 begin
   outtextxy(432,164,copy(s,1,f));
   sound(10000);delay(1);nosound
 end;
end;
procedure message_1;
begin
clearmessage;
s:='У вас кончилась энергия!';
for f:= 1 to length(s) do
 begin
   outtextxy(432,154,copy(s,1,f));
   sound(10000);delay(1);nosound
 end
end;
procedure parametr;
begin
setcolor(0);
for f:=1 to 48 do line(87,150+f,150,150+f);
setcolor(1);
str(pis,s);
outtextxy(90,152,s);
str(ogn,s);
outtextxy(90,162,s);
str(bom,s);
outtextxy(90,172,s);
end;
procedure filekorabl;
begin
assign(fil,'korabl.stu');
reset(fil);
for f:=1 to 13 do
 for d:=1 to 68 do
  begin
   read(fil,h);read(fil,h);
   val(h,g,err);
   if g=1 then point[f,d]:=true
          else point[f,d]:=false;
   if d=68 then readln(fil)
  end;
close(fil)
end;
procedure filecosmic;
begin
assign(fil,'cosmic.stu');
reset(fil);
for f:=1 to 23 do
 for d:=1 to 68 do
  begin
   read(fil,h);read(fil,h);
   val(h,g,err);
   if g=1 then point[f,d]:=true
          else point[f,d]:=false;
   if d=68 then readln(fil)
  end;
close(fil)
end;
procedure cosmic(x,y,c:integer);
var col:byte;
begin
if c=1 then col:=1 else col:=0;
setcolor(col);
for f:=1 to 23 do
 for d:=1 to 68 do
   if point[f,d]=true then putpixel(d+x,y+f,col);
end;
procedure ener;
begin
setcolor(1);
for f:=1 to energy*2 do line(149+f,164,149+f,167)
end;
procedure ener_;
begin
setcolor(0);
for f:=1 to 200-energy*2 do line(350-f,164,350-f,167)
end;
procedure kartoch(x,y,c:integer);
var col:byte;
begin
if c=1 then col:=1 else col:=0;
setcolor(col);
line(x,y,x+9,y);
line(x+9,y,x+9,y+4);
line(x+9,y+4,x,y+4);
line(x,y+4,x,y);
line(x+2,y+2,x+3,y+2);
putpixel(x+5,y+2,col);
putpixel(x+7,y+2,col)
end;
procedure wind;
begin
setcolor(1);rectangle(0,150,639,199);
settextstyle(11,0,1);
outtextxy(20,152,'Пистолет');
outtextxy(20,162,'Огнемет');
outtextxy(20,172,'Бомба');
outtextxy(170,152,'Энергия');
rectangle(430,152,637,197)
end;
procedure zone1;
begin
 setcolor(1);
 rectangle(-1,109,640,149);
 setfillstyle(11,1);
 floodfill(1,110,1);
 line(0,0,0,150);pisx:=-20; pisy:=-20;
 rs[2]:=390;ts[2]:=100;fazas[2]:=1;gos[2]:=1;ras[2]:=140;
 is[2]:=true; rr[2]:=140; en[2]:=2;
 vrag1(rs[2],ts[2],1,fazas[2],gos[2]);
 rs[3]:=10;ts[3]:=100;fazas[3]:=1;gos[3]:=1;ras[3]:=160;
 is[3]:=true; rr[3]:=160; en[3]:=2;
 vrag1(rs[3],ts[3],1,fazas[3],gos[3]);
 kartoch(15,104,1);filecosmic;cosmic(400,10,1)
end;
procedure zone2;
begin
 setcolor(1);
 rectangle(-1,109,640,149);
 setfillstyle(11,1);
 floodfill(1,110,1);
 rectangle(400,-1,450,80);for f:=1 to 29 do line(440,80+f,444,80+f);
 setfillstyle(6,1);floodfill(401,1,1);
 rectangle(450,40,640,50);floodfill(451,41,1);
 if pistolet[2]=true then begin
 patroni(300,102,1); pisx:=300; pisy:=102
                          end
                     else begin pisx:=-20; pisy:=-20 end;
 rs[1]:=390;ts[1]:=100;fazas[1]:=1;gos[1]:=2;ras[1]:=140;
 is[1]:=true; rr[1]:=140; en[1]:=2;
 vrag1(rs[1],ts[1],1,fazas[1],gos[1])
end;
procedure smert1(x,y,goo,dim:integer);
begin
if goo=1 then for d:=1 to 100 do
  begin
   putpixel(random(9)+x,random(9)+y,0);
   delay(10)
  end;
if goo=2 then for d:=1 to 100 do
  begin
   putpixel(random(9)+x-9,random(9)+y,0);
   delay(10)
  end;
vrag1(x,y,0,fazas[dim],gos[dim])
end;
procedure kor(x,y,c:integer);
var col:byte;
begin
 if c=1 then col:=1 else col:=0;
 setcolor(col);
 {line(x,y,x+100,y);
 line(x+100,y,x+120,y+20);
 line(x+120,y+20,x,y+20);
 line(x,y+20,x,y);
 line(x+75,y,x+75,y+10);
 line(x+75,y+10,x+110,y+10);
 line(x,y+6,x-4,y+6);
 line(x-4,y+6,x-4,y+18);
 line(x-4,y+18,x,y+18);}
 for g:=1 to 13 do
  for d:=1 to 68 do if point[g,d]=true then putpixel(d+x,y+g,col)
end;
procedure so;
begin
 sound(1000); delay(1); nosound
end;
procedure goin1(dim:integer);
begin
vrag1(rs[dim],ts[dim],0,fazas[dim],gos[dim]);
rr[dim]:=rr[dim]-1;
if (rr[dim]=0) and (gos[dim]=2) then begin rr[dim]:=ras[dim];gos[dim]:=1 end;
if (rr[dim]=0) and (gos[dim]=1) then begin rr[dim]:=ras[dim];gos[dim]:=2 end;
if gos[dim]=2 then rs[dim]:=rs[dim]-1;
if gos[dim]=1 then rs[dim]:=rs[dim]+1;
fazas[dim]:=fazas[dim]+1;
if fazas[dim]=5 then fazas[dim]:=1;
vrag1(rs[dim],ts[dim],1,fazas[dim],gos[dim]);
if random(25)=4 then begin
                      for f:= 1 to 10 do begin
                      sound(200-f*4);delay(1);nosound
                                         end;
                      f:=0;
    if gos[dim]=1 then repeat
                       f:=f+1;
                       putpixel(rs[dim]+8+f,ts[dim]+3,1);
                       delay(1);
                       putpixel(rs[dim]+8+f,ts[dim]+3,0);
                       if (ts[dim]=t) and (rs[dim]+8+f=r) then
                         begin
                          energy:=energy-1;
                          ener_;
                          f:=200;
                          if energy=0 then begin
                                            message_1;
                                            delay(20);
                                            gameover
                                           end;
                         end;
                 until f=200;
    if gos[dim]=2 then repeat
                       f:=f+1;
                       putpixel(rs[dim]-8-f,ts[dim]+3,1);
                       delay(1);
                       putpixel(rs[dim]-8-f,ts[dim]+3,0);
                       if (ts[dim]=t) and (rs[dim]-8-f=r) then
                         begin
                          energy:=energy-1;
                          ener_;
                          f:=200;
                          if energy=0 then begin
                                            message_1;
                                            delay(20);
                                            gameover
                                          end
                         end;
                 until f=200;
             if (dver2=false) and (zones=2) then
                begin
                   setcolor(1);
                   line(440,103,444,103)
                end;
             if zones=1 then putpixel(0,103,1)
                    end
end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
r:=100;
 t:=100;
  faza:=1; go:=1;
   energy:=100;
    pis:=0; ogn:=0; bom:=0;
     zones:=2;
      sel:=1; dver2:=false;
       kartochka:=false; laser:=0;
filekorabl;kor(80,9,1);
size:=imagesize(80,9,147,22);getmem(pp,size);
getimage(80,9,147,22,pp^);
for f:=1 to 1000 do pistolet[f]:=true;
zone2;wind;parametr;ener;
for f:=10 to 76 do begin {putimage(80,f-1,pp^,3)}k(80,f);putimage(80,f,pp^,1) end;
setcolor(1);
for f:=90 to 108 do begin line(90,f,110,f);delay(15) end;
for f:=108 downto 91 do begin setcolor(0);line(90,f,110,f);setcolor(1);man(r,t,1,faza,go);delay(15) end;
man(r,t,1,faza,go);
for f:=77 downto -25 do begin {putimage(80,f+1,pp^,3)}k(80,f+1);putimage(80,f,pp^,1) end;
message1;
start:
REPEAT
repeat
if (zones=2) and (is[1]=true) then
   begin
     goin1(1);
     if (r>=rs[1]) and (r<=rs[1]+7) and (t=ts[1]) and (gos[1]=1) then
          begin
            sound(100);delay(4);nosound;
            energy:=energy-1;ener_;
            if energy=0 then begin message_1;delay(20);gameover end
          end;
     if (r<=rs[1]) and (r>=rs[1]-7) and (t=ts[1]) and (gos[1]=2) then
          begin
            sound(100);delay(4);nosound;
            energy:=energy-1;ener_;
            if energy=0 then begin message_1;delay(20);gameover end
          end
   end;
if (zones=1) and ((is[2]=true) or (is[3]=true)) then
   begin
     if is[2]=true then goin1(2);
     if is[3]=true then goin1(3);
     if ((r>=rs[2]) and (r<=rs[2]+7) and (t=ts[2]) and (gos[2]=1) and (is[2]=true))
        or ((r>=rs[3]) and (r<=rs[3]+7) and (t=ts[3]) and (gos[3]=1) and (is[3]=true)) then
          begin
            sound(100);delay(4);nosound;
            energy:=energy-1;ener_;
            if energy=0 then begin message_1;delay(20);gameover end
          end;
     if ((r>=rs[2]) and (r<=rs[2]+7) and (t=ts[2]) and (gos[2]=2) and (is[2]=true))
        or ((r>=rs[3]) and (r<=rs[3]+7) and (t=ts[3]) and (gos[3]=2) and (is[3]=true)) then
          begin
            sound(100);delay(4);nosound;
            energy:=energy-1;ener_;
            if energy=0 then begin message_1;delay(20);gameover end
          end
   end;
if pistolet[zones]=true then patroni(pisx,pisy,1);
if (zones=1) and (kartochka=false) then kartoch(15,104,1);
if zones=1 then laser:=laser+1;
if (zones=1) and (laser=10) and (r>=400) and (r<=470) then
    begin
     laser:=0;
     for f:=28 to 108 do begin putpixel(434,f,1);sound(60300);delay(1);nosound end;
     delay(30);
     for f:=28 to 108 do putpixel(434,f,0);
     if ((434>r-8) and (434<r) and (go=2)) or
       ((434>r) and (434<r+8) and (go=1)) then
         energy:=energy-4;ener_
    end;
if (zones=1) and (laser=10) and not ((r>=400) and (r<=470)) then
   laser:=0;
man(r,t,1,faza,go);
delay(5);
until keypressed;
h:=readkey;
if h='l' then begin
               man(r,t,0,faza,go);
               go:=1;
               r:=r+4;
               faza:=faza+1; if faza=5 then faza:=1;
               man(r,t,1,faza,go);
               so;
               if (zones=1) and (r=640) then
                  begin
                   cleardevice;
                   zones:=2;
                   r:=4;
                   zone2;
                   wind; parametr;
                   ener;
                   goto start
                  end
              end;
if h='j' then begin
               man(r,t,0,faza,go);
               go:=2;
               r:=r-4;
               if (zones=1) and (r=8) then r:=r+4;
               faza:=faza+1; if faza=5 then faza:=1;
               man(r,t,1,faza,go);
               so;
               if (zones=2) and (r=0) then
                  begin
                   cleardevice;
                   zones:=1;
                   r:=640;
                   zone1;
                   wind; parametr;
                   ener;
                   goto start
                  end
              end;
if (h=' ') and (sel=1) and (pis>0) then
   begin
    man(r,t,0,faza,go);
    fire(r,t,1,go);
    for f:= 1 to 10 do begin
    sound(2000+f*4);delay(1);nosound
                       end;
    f:=0;
    if go=1 then repeat
                       f:=f+1;
                       putpixel(r+6+f,t+2,1);
                       delay(1);
                       putpixel(r+6+f,t+2,0);
               if (zones=2) and (is[1]=true) then
                       if r+6+f=rs[1] then
                         begin
                          en[1]:=en[1]-1;
                          f:=200;
                          if en[1]=0 then begin
                                            is[1]:=false;
                                            smert1(rs[1],ts[1],gos[1],1)
                                          end
                         end;
               if (zones=1) and ((is[2]=true) or (is[3]=true)) then
                  begin
                       if (r+6+f=rs[2]) and (is[2]=true) then
                         begin
                          en[2]:=en[2]-1;
                          f:=200;
                          if en[2]=0 then begin
                                            is[2]:=false;
                                            smert1(rs[2],ts[2],gos[2],2)
                                          end
                         end;
                       if (r+6+f=rs[3]) and (is[3]=true) then
                         begin
                          en[3]:=en[3]-1;
                          f:=200;
                          if en[3]=0 then begin
                                            is[3]:=false;
                                            smert1(rs[3],ts[3],gos[3],3)
                                          end
                         end;
                  end;
                 until f=200;
    if go=2 then repeat
                       f:=f+1;
                       putpixel(r-6-f,t+2,1);
                       delay(1);
                       putpixel(r-6-f,t+2,0);
                if (zones=2) and (is[1]=true) then
                       if r-6-f=rs[1] then
                         begin
                          en[1]:=en[1]-1;
                          f:=200;
                          if en[1]=0 then begin
                                            is[1]:=false;
                                            smert1(rs[1],ts[1],gos[1],1)
                                          end
                         end;
                if (zones=1) and ((is[2]=true) or (is[3]=true)) then
                  begin
                       if (r-6-f=rs[2]) and (is[2]=true) then
                         begin
                          en[2]:=en[2]-1;
                          f:=200;
                          if en[2]=0 then begin
                                            is[2]:=false;
                                            smert1(rs[2],ts[2],gos[2],2)
                                          end
                         end;
                       if (r-6-f=rs[3]) and (is[3]=true) then
                         begin
                          en[3]:=en[3]-1;
                          f:=200;
                          if en[3]=0 then begin
                                            is[3]:=false;
                                            smert1(rs[3],ts[3],gos[3],3)
                                          end
                         end;
                  end;
                 until f=200;
    if zones=1 then putpixel(0,102,1);
    pis:=pis-1;parametr;
    fire(r,t,0,go);
    man(r,t,1,faza,go)
   end;
if (pistolet[zones]=true) and (t+2=pisy) and (r>=pisx) and (r<=pisx+7) then
   begin
    patroni(pisx,pisy,0);man(r,t,1,faza,go);
    for f:=1 to 10 do begin sound(6000+f*10);delay(2);nosound end;
    pis:=pis+10;parametr;pistolet[zones]:=false
   end;
if (dver2=false) and (zones=2) then
  begin
    setcolor(1);
    line(440,102,444,102);
    if r=428 then begin
                    for f:=1 to 29 do
                       begin
                        line(425,80+f,440,80+f);
                        delay(30)
                       end;
                     energy:=0;ener_;
                     message0;
                     delay(20);
                     gameover
                  end
  end;
UNTIL h=#27;
CloseGraph
end.