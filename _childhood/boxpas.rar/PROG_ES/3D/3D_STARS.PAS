uses CGADrv, Graph, Crt;
var
    d,m,f:integer;
    x,y:array[1..500] of integer;
    s:array[1..500] of word;
    Col:byte;
    Stars:Word;
begin
writeln('************************* 3D Stars *****************************');
write(' Total Stars: ');readln(Stars);
Randomize;
for f:=1 to Stars do s[f]:=Random(20)+1;
d:=Detect;
InitGraph(d,m,'');
if d=CGA then SetGraphMode(1);
for f:=1 to Stars do x[f]:=Random(GetMaxX);
for f:=1 to Stars do y[f]:=Random(GetMaxY);
if d=CGA then Col:=1
         else Col:=15;
f:=0;
repeat
f:=f+1; if f=Stars+1 then f:=1;
PutPixel(x[f],y[f],0);
x[f]:=x[f]-s[f];
if x[f]<0 then
  begin
    x[f]:=GetMaxX;
    y[f]:=Random(GetMaxY)
  end;
PutPixel(x[f],y[f],Col)
until KeyPressed;
CloseGraph
end.