uses  Crt,Graph;
var l,f,d,g,r,t,faza,go:integer;
    h:char;
procedure car(x,y,c,faz,goo:integer);
begin
if c=1 then setcolor(1) else setcolor(0);
 if goo=1 then
      begin
       line(x,y+2,x,y+11);
       line(x+1,y+1,x+4,y+1);
       line(x+1,y+11,x+4,y+11);
       line(x+5,y+2,x+5,y+11);
       line(x+6,y+1,x+7,y+1);
       line(x+6,y+12,x+19,y+12);
       line(x+8,y,x+17,y);
       line(x+18,y+1,x+19,y+1);
       line(x+9,y+4,x+16,y+4);
       line(x+8,y+5,x+8,y+9);
       line(x+9,y+10,x+16,y+10);
       line(x+17,y+5,x+17,y+9);
       line(x+20,y+2,x+20,y+11);
       line(x+21,y+1,x+24,y+1);
       line(x+25,y+2,x+25,y+10);
       line(x+21,y+11,x+24,y+11);
       f:=3;
       if faz=1 then while f<>11 do
                begin
                 line(x+1,y+f,x+4,y+f);
                 line(x+21,y+f,x+24,y+f);
                 f:=f+2
                end;
       f:=2; if faz=2 then while f<>12 do
                begin
                 line(x+1,y+f,x+4,y+f);
                 line(x+21,y+f,x+24,y+f);
                 f:=f+2
                end;
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
r:=300; t:=170; faza:=1; go:=1;
car(r,t,1,faza,go);
REPEAT
repeat
until keypressed;
h:=readkey;
if h='i' then
    begin
      car(r,t,0,faza,go);
      t:=t-2; faza:=faza+1; if faza=3 then faza:=1;
      car(r,t,1,faza,go);
      sound(15000); delay(2); nosound
    end;
UNTIL h=#27;
CloseGraph
end.