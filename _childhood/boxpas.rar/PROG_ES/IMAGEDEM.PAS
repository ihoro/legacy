uses Graph;
var f,Gd,Gm:integer;
    s:word;
    a,b:pointer;
begin
Gd:=Detect;
InitGraph(Gd,Gm,'');
SetColor(1);
Rectangle(2,2,40,20);
Circle(450,20,16);
s:=ImageSize(0,0,45,25);
GetMem(a,s);
GetImage(0,0,45,25,a^);
s:=ImageSize(430,2,470,40);
{writeln(s,' байт');}
GetMem(b,s);
GetImage(430,2,470,40,b^);
readln;
ClearDevice;
for f:=1 to 200 do
  begin
    PutImage(16,f,a^,0);
    PutImage(416,f,b^,0);
    f:=f+40;
    readln
  end;
CloseGraph
end.