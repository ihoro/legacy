program text;
uses Graph;
var u,l,f,d,g:integer;
procedure a(x,y,b:integer);
      var h:integer;
      begin
      line(x,y,(x+3),y);
      line((x-1),(y-1),(x+4),(y-1));
      for h:= 1 to b do begin
                        line((x-2),(y-1-h),(x+5),(y-1-h));
                        end;
      line((x-1),(y-2-h),(x+5),(y-2-h));
      line(x,(y-3-h),(x+3),(y-3-h))
      end;
procedure b(x,y,b:integer);
      begin
      SetColor(0);
      Rectangle((x-2),y,(x+5),(y-3-b));
      floodfill(x,(y-2),10)
      end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
setfillstyle(1,0);
setcolor(9);
line(300,479,340,479);
setcolor(10);
 FOR l:= 1 to 10 do begin
 for f:= 1 to 471 do begin
                     a(320,f,4);
                     b(320,f,4)
                     for u:= 1 to 20 do begin end;
                     end; read(d);
 for f:= 1 to 3 do begin
                   a(320,(471+f),(4-f));
                   b(320,(471+f),(4-f))
                   end;
for f:= 3 downto 1 do begin
                      a(320,(471+f),(4-f));
                      b(320,(471+f),(4-f))
                      end;
for f:= 471 downto 1 do begin
                        a(320,f,4);
                        b(320,f,4)
                        end;
end;
read(d);
CloseGraph;
end.