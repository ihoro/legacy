
uses Graph;
var f,h,d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
for f:= 1 to 30 do begin
  for h:= 1 to 240 do begin Circle(320,240,h);SetColor(0);Circle(320,240,h);SetColor(10) end;
  end;
read(f);
CloseGraph;
end.