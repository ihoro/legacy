program text;
uses  Crt,Graph;
var f,ex,ey,nx,ny,nach,pix,pixe,colors,typ,x,y,d,g:integer;
    h:char;
    col:array[1..8] of integer;
    lx,ly,px,py:array[1..2] of integer;
procedure st(c:byte);
begin
    if c=0 then begin
                  putpixel(x,y,col[1]);
                  putpixel(x+1,y,col[2]);
                  putpixel(x+2,y,col[3]);
                  putpixel(x,y+1,col[4]);
                  putpixel(x+1,y+1,col[5]);
                  putpixel(x,y+2,col[6]);
                  putpixel(x+2,y+2,col[7]);
                  putpixel(x+3,y+3,col[8])
                end
           else begin
                  putpixel(x,y,10);
                  putpixel(x+1,y,10);
                  putpixel(x+2,y,10);
                  putpixel(x,y+1,10);
                  putpixel(x+1,y+1,10);
                  putpixel(x,y+2,10);
                  putpixel(x+2,y+2,10);
                  putpixel(x+3,y+3,10)
                end;
end;
procedure steret;
begin
setcolor(0);
for f:=1 to 445 do line(551,3+f,634,3+f)
end;
procedure color;
begin
   col[1]:=getpixel(x,y);
   col[2]:=getpixel(x+1,y);
   col[3]:=getpixel(x+2,y);
   col[4]:=getpixel(x,y+1);
   col[5]:=getpixel(x+1,y+1);
   col[6]:=getpixel(x,y+2);
   col[7]:=getpixel(x+2,y+2);
   col[8]:=getpixel(x+3,y+3);
end;
procedure main;
begin
steret;
setcolor(13);
for f:= 1 to 14 do
rectangle(560,10+f*30,625,30+f*30);
setcolor(6);
rectangle(4,450,548,475);
setcolor(14);
outtextxy(575,46,'Цвет');
outtextxy(573,76,'Линия');
outtextxy(567,102,'Прямо-');
outtextxy(562,110,'угольник');
outtextxy(561,136,'Карандаш');
outtextxy(565,166,'Стирать');
outtextxy(569,196,'Эллипс');
end;
procedure colormenu;
begin
steret;
for f:= 1 to 15 do
  begin
    setcolor(f);
    rectangle(560,10+f*20,625,25+f*20);
    setfillstyle(1,f);
    floodfill(561,11+f*20,f)
  end;
  for f:= 1 to 8 do col[f]:=2
end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
settextstyle(10,0,1);
 x:=300;
  y:=300;
   typ:=0;
    colors:=14;
     pix:=0;
      pixe:=0;
      nach:=0;
       ex:=0;
        ey:=0;
   for f:= 1 to 8 do col[f]:=0;
 setcolor(9);
 rectangle(0,0,639,479);
 rectangle(2,2,637,477);
 rectangle(550,4,635,475);
 main;
 st(1);
REPEAT
  h:=readkey;
  if h=#27 then halt;
  if h='i' then
                                 begin
                                   st(0);
                                   y:=y-5;
                                   color;
                                   st(1)
                                 end;
  if h='k' then
                                 begin
                                   st(0);
                                   y:=y+5;
                                   color;
                                   st(1)
                                 end;
  if h='j' then
                                 begin
                                   st(0);
                                   x:=x-5;
                                   color;
                                   st(1)
                                 end;
  if h='l' then
                                 begin
                                   st(0);
                                   x:=x+5;
                                   color;
                                   st(1)
                                 end;
  if (h=' ') and (typ=1) and (x>2) and (x<550) and (y>2) and (y<450) then
     begin
       if pix=0 then begin
                        pix:=1;
                        putpixel(x-1,y-1,colors);
                        lx[1]:=x-1;
                        ly[1]:=y-1
                      end
                 else begin
                        pix:=0;
                        setcolor(colors);
                        lx[2]:=x-1;
                        ly[2]:=y-1;
                        line(lx[1],ly[1],lx[2],ly[2])
                      end;
     end;
  if (h=' ') and (x>560) and (x<625) and (y>40) and (y<60)
       then begin
              typ:=5;
              colormenu
            end;
  if (h=' ') and (x>560) and (x<625) and (y>70) and (y<90)
   then
    begin
     typ:=1;
     main;
     setcolor(12);
     outtextxy(573,76,'Линия')
    end;
  if (h=' ') and (x>560) and (x<625) and (y>100) and (y<120)
   then
    begin
     typ:=4;
     main;
     setcolor(12);
     outtextxy(567,102,'Прямо-');
     outtextxy(562,110,'угольник')
    end;
  if (h=' ') and (typ=4) and (x>2) and (x<550) and (y>2) and (y<450) then
     begin
       if pixe=0 then begin
                        pixe:=1;
                        putpixel(x-1,y-1,colors);
                        px[1]:=x-1;
                        py[1]:=y-1
                      end
                 else begin
                        pixe:=0;
                        setcolor(colors);
                        px[2]:=x-1;
                        py[2]:=y-1;
                        rectangle(px[1],py[1],px[2],py[2])
                      end;
     end;
{ if (h=' ') and (x>560) and (x<625) and (y>190) and (y<210)
   then
    begin
       typ:=2;
       main;
       setcolor(12);
       outtextxy(569,196,'Эллипс')
   end;
    if (h=' ') and (typ=2) and (x>2) and (x<550) and (y>2) and (y<450) then
       if nach=0 then begin
                        nach:=1;
                        typ:=3;
                        putpixel(x-1,y-1,colors);
                        nx:=x-1;
                        ny:=y-1
                      end;
    if (h='k') and (typ=3) and (x>2) and (x<550) and (y>2) and (y<450) then
                      begin
                        ey:=ey+5;
                        setcolor(colors);
                        ellips(nx+(ex div 2),ny+(ey div 2),0,360,ex div 2,ey div 2)
                      end;}
 UNTIL x>639;
CloseGraph;
readln
end.