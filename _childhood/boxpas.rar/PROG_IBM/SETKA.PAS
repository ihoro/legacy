program text;
uses Graph;
var f,d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
   setbkcolor(15);
   setcolor(1);
for f:= 1 to 64 do begin
                   line(f*10,0,f*10,480)
                   end;
for f:= 1 to 48 do begin
                   line(0,f*10,640,f*10)
                   end;
read(d);
CloseGraph;
end.