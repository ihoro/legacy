
uses Graph;
var q,r,m,n,s,f,h,d,g:integer;
procedure hi(x,y,c:integer);
     begin
     SetColor(c);
     PutPixel(x,y,c);
     line((x-1),(y+1),(x-3),(y+1));
     line((x+1),(y+1),(x+3),(y+1));
     line((x-4),(y+2),(x-5),(y+2));
     line((x+4),(y+2),(x+5),(y+2));
     line((x-6),(y+3),(x-6),(y+11));
     line((x+6),(y+3),(x+6),(y+11));
     line((x-5),(y+12),(x-5),(y+17));
     line((x+5),(y+12),(x+5),(y+17));
     line((x-4),(y+18),(x-4),(y+22));
     line((x+3),(y+23),(x+2),(y+23));
     line((x+4),(y+18),(x+4),(y+22));
     line((x-3),(y+23),(x-2),(y+23));
     line((x-1),(y+24),(x-1),(y+30));
     line((x+1),(y+24),(x+1),(y+30));
     line(x,(y+31),x,(y+41));
     line((x-1),(y+42),(x+1),(y+42));
     line((x-2),(y+43),(x+2),(y+43))
     end;
procedure pr(x,y,k,c:integer);
     begin
     SetColor(c); SetFillStyle(1,c);
     PiesLice(x,(y-5),k,(k+1),20);
     PiesLice(x,(y-5),(k+180),(k+181),20)

     end;
begin
d:=Detect;
InitGraph (d,g,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
m:=320;n:=240;
for f:= 1 to 20 do begin
  r:=trunc(Random(1));
  if r=0 then n:=(n-1); if r=1 then n:=(n+1);
  if n>440 then n:=440;
  if n<20 then n:=20;
  hi(m,n,10);
          for s:= 0 to 359 do begin
          pr(m,(n+12),s,14);
          pr(m,(n+12),s,0);
          hi(m,n,10);
               { for q:= 1 to 1 do begin end;}
          end;
      hi(m,n,0)
end;
read(f);
CloseGraph;
end.