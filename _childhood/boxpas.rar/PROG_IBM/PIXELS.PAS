program text;
uses  Crt,Graph;
var f,d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
randomize;
for f:= 1 to 6000 do
                 begin
                  putpixel(random(640),random(480),random(256)+1);
                 for d:= 1 to 3000 do begin end;
                 end;
readln(f);
CloseGraph;
end.