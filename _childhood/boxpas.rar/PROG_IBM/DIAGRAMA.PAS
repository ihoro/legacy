uses  Graph;
type dim= array[1..15] of integer;
var xx,zz,f,l,d,g:integer;
    x,z:dim;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
for f:= 1 to 2 do
begin
 writeln('             ',f,'-е предприятие:');
  for l:=1 to 15 do begin
                      write('  ',l,'-й день : ');
                      if f=1 then readln(x[l]);
                      if f=2 then readln(z[l]);
                    end;
end;
 writeln;
cleardevice;
  for f:=1 to 15 do
    begin
                     if x[f] div 350<>0 then xx:=x[f] div (x[f] div 350)
                                        else xx:=x[f];
                     if z[f] div 350<>0 then zz:=z[f] div (z[f] div 350)
                                        else zz:=z[f];
                     setcolor(14);
                     rectangle(f*40,400,20+f*40,400-xx);
                     setfillstyle(7,14);
                     floodfill(5+f*40,399,14);
                     setcolor(10);
                     rectangle(f*40+1,400-zz,f*40+11,400);
                     setfillstyle(11,10);
                     floodfill(f*40+3,399,10)
    end;
readln;
CloseGraph;
end.