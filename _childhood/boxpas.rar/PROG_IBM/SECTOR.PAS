uses Graph,Crt;
var d,f,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
setFillStyle(1,9);SetColor(9);
for f:= 0 to 359 do begin
if (f=0) or (f=89) or (f=179) or (f=359) then begin
    SetFillStyle (1,9); SetColor(9) end;
PiesLice (320,240,f,f+1,100);
Delay(200);
SetColor(9)
end;
CloseGraph;
end.