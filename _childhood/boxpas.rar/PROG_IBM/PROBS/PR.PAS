uses Graph;
var f,
grD,grM:Integer;
begin
grD:=0;
InitGraph(grD,grM,'');
SetColor(3);
circle(300,200,20);
SetFillStyle(1,3);
FloodFill(300,200,3);
readln;
for f:=3 to 18 do
  begin
    SetRGBPalette(3,f,f+1,f+2);{SetPalette}
    readln
  end;
CloseGraph
end.