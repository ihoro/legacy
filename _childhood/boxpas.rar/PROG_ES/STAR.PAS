program text;
uses  Crt,Graph;
var f,r,t,h,k,d,g:integer;n,m:word;
procedure a(x,y,b,c:integer);
      begin
        setcolor(c);
        line(x-b,y,x+b,y);
        line(x,y-b,x,y+b);
        line(x-b,y-b,x+b,y+b);
        line(x-b,y+b,x+b,y-b);
        for d:= 1 to 100 do begin end
      end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then
                      begin
                        writeln('инициализация не закончена!');
                        halt
                      end;
for f:= 1 to 100 do
      begin
        randomize;
        r:=random(600)+20;
        t:=random(440)+20;
        k:=random(255)+1;
     for h:= 0 to 10 do
                      begin
                       a(r,t,h,k);
                       a(r,t,h,0)
                      end;
     for h:=10 downto 0 do
                         begin
                          a(r,t,h,k);
                          a(r,t,h,0)
                         end;
     end;
CloseGraph;
end.