program lin;
uses Graph;
var f,x,y,x1,y1,l,c,d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');  halt end;
for l:= 1 to 10000 do
 begin
 randomize;
  x:=random(319)+1;
  y:=random(239)+1;
  c:=random(16);
  setcolor(c);
    x1:=random(640-x);
    y1:=random(480-y);
  rectangle(x1,y1,x1+x,y1+y);
     for g:= 1 to y-1 do begin
                          setcolor(0);
                          line(x1+1,y1+g,x1+x-1,y1+g)
                         end;
  setfillstyle(random(12),random(16));
  floodfill(x1+1,y1+1,c);
  end;
read(d);
CloseGraph;
end.