program text;
uses  Crt,Graph;
var f,d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('���樠������ �� �����祭�!');
                        halt
                      end;
f:=1;
repeat
                  setcolor(0);
                  circle(400,100,f-10);
                  setcolor(1);
                  circle(400,100,f);
                  f:=f+10;
until keypressed;
CloseGraph
end.