uses Graph;
const
      R = 20;
var grd,grm,x,y:integer;
begin
grd:=0;
InitGraph(grd,grm,'');
for x:=0 to R do
  PutPixel(320+x,round(240+SQRT(ABS(R-SQR(x)))),10);
for x:=R downto 0 do
  PutPixel(320+x,round(240-SQRT(ABS(R-SQR(x)))),10);
for x:=0 to R do
  PutPixel(320-x,round(240-SQRT(ABS(R-SQR(x)))),10);
for x:=R downto 0 do
  PutPixel(320-x,round(240+SQRT(ABS(R-SQR(x)))),10);
readln;
CloseGraph
end.