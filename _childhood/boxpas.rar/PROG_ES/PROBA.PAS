uses  Crt,Graph;
var d,g,x,y:integer;
    h:char;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
settextstyle(5,0,3);
outtextxy(100,100,'Press Esc...');
x:=300; y:=158;
    REPEAT
repeat
until keypressed;
h:=readkey;
 if h='i' then
  begin
   putpixel(x,y,0);
   y:=y-4;
   putpixel(x,y,1)
  end;
 if h='k' then
  begin
   putpixel(x,y,0);
   y:=y+4;
   putpixel(x,y,1)
  end;
 if h='j' then
  begin
   putpixel(x,y,0);
   x:=x-8;
   putpixel(x,y,1)
  end;
 if h='l' then
  begin
   putpixel(x,y,0);
   x:=x+8;
   putpixel(x,y,1)
  end;
    UNTIL h=#27;
CloseGraph
end.