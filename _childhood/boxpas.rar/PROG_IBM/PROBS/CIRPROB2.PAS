uses Graph;
var
    grd,grm,A,x,y:integer;
const
      R=10;
begin
grd:=0;
InitGraph(grd,grm,'');
for A:=1 to 90 do PutPixel(320+R*Round(cos((PI/180)*A)),240-R*Round(sin((PI/180)*A)),10);
readln;
CloseGraph
end.