program text;
uses  Crt,Graph;
var d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
randomize;
       repeat
                 setcolor(random(256)+1);
                 circle(random(640),random(480),random(50));
                 for d:= 1 to 3000 do begin end;
       until keypressed;
CloseGraph;
end.