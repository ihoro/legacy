program text;
uses Graph;
var f,h,l, d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
settextstyle(1,0,10);
for f:= 1 to 50 do begin
 for h:= 0 to 255 do begin setcolor(h); outtextxy(100,100,'PASCAL')  end;

 end;
read(d);
CloseGraph;
end.