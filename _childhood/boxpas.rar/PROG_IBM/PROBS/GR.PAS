uses Dos,Graph;
var r:Registers;
    d,m:integer;
    s:string;
begin
{d:=0;
InitGraph(d,m,'');}
with r do
begin
ah:=0;
al:=$11;
Intr($10,r);
for d:=1 to 20 do
  begin
    bh:=1;
    dx:=200;
    cx:=300;
    al:=15;
    Intr($0C,r)
  end;
{str(GetMaxX,s);
SetColor(10);
OutText('MaxX='+s);
str(GetMaxY,s);
OutText('  MaxY='+s);}
readln;
end
end.