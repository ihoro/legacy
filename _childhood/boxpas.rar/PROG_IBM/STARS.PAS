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
        for n:=1 to 60000 do begin end;
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
                       for n:=1 to 20 do begin for m:=1 to 60000 do begin  end; end;
                       a(r,t,h,0)
                      end;
                  for n:=1 to 20 do begin for m:=1 to 60000 do begin  end;  end;
     for h:=10 downto 0 do
                         begin
                          a(r,t,h,k);
                          for n:=1 to 20 do  for m:=1 to 60000 do begin  end; begin end;
                          a(r,t,h,0)
                         end;
       for n:=1 to 20 do begin  for m:=1 to 60000 do begin  end; end;
     end;
CloseGraph;
end.