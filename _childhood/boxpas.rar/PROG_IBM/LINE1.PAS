program lin;
uses Graph;
var f,x,y,d,g:integer;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');  halt end;
 x:=0; y:=0;
 for f:= 1 to 48 do begin
                     x:=x+13;
                     y:=y+10;
                     setcolor(random(11)+1);
                     line(0,y,x,0)
                    end;
                x:=0; y:=0;
 for f:= 1 to 48 do begin
                     x:=x+13;
                     y:=y+10;
                     setcolor(random(11)+1);
                     line(x,480,640,y)
                    end;
Read(d);
CloseGraph;
end.