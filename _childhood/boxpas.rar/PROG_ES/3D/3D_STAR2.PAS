uses Graph, Crt;
var
    star:array[1..400] of
           record
             x,y,x1,y1,x2,y2,k,b:integer;
             speed:byte;
             corner:1..4
           end;
    f,l,d,MaxX,MaxY:integer;
    Stars:word;
    Col:byte;
    h:Char;
function StarX(s:word;yy:integer):integer;
begin
with Star[s] do StarX:=(yy-b) div k
end;
function StarY(s:word;xx:integer):integer;
begin
with Star[s] do StarY:=k*xx+b
end;
procedure StarXYRandom(s:word);
begin
with Star[s] do
begin
case Corner of
  1:begin
      y:=Random(MaxY div 2);
      x:=StarX(s,y)
    end;
  2:begin
      x:=Random(MaxX div 2)+MaxX div 2;
      y:=StarY(s,x)
    end;
  3:begin
      y:=Random(MaxY div 2)+MaxY div 2;
      x:=StarX(s,y)
    end;
  4:begin
      x:=Random(MaxX div 2);
      y:=StarY(s,x)
    end;
end;
end
end;
procedure StarRandom(s:word);
begin
with Star[s] do
begin
  x1:=MaxX div 2;
  y1:=MaxY div 2;
  Corner:=Random(4)+1;
  repeat
  case Corner of
    1:begin
        x2:=Random(MaxX-1)+1;
        y2:=0
      end;
    2:begin
        x2:=MaxX;
        y2:=Random(MaxY)
      end;
    3:begin
        x2:=Random(MaxX-1)+1;
        y2:=MaxY
      end;
    4:begin
        x2:=0;
        y2:=Random(MaxY)
      end;
  end;
  k:=(y1-y2) div (x1-x2);
  until (((Corner=1) or (Corner=3)) and (k<>0)) OR ((Corner=2) or (Corner=4));
  b:=y1-k*x1;
  x:=x1;
  y:=y1
end
end;
begin
write('Stars=');readln(stars);
Randomize;
f:=Detect;
InitGraph(f,l,'');
if f=CGA then
  begin
    SetGraphMode(1);
    Col:=1
  end
         else
  Col:=15;
MaxX:=GetMaxX;
MaxY:=GetMaxY;
for f:=1 to Stars do
  begin
    Star[f].speed:=Random(50)+1;
    StarRandom(f);
    StarXYRandom(f)
  end;
f:=0;
repeat
f:=f+1; if f=Stars+1 then f:=1;
with Star[f] do
begin
  PutPixel(x,y,0);
  case Corner of
    1:begin
        y:=y-speed;
        x:=StarX(f,y)
      end;
    2:begin
        x:=x+speed;
        y:=StarY(f,x)
      end;
    3:begin
        y:=y+speed;
        x:=StarX(f,y)
      end;
    4:begin
        x:=x-speed;
        y:=StarY(f,x)
      end;
  end;
  if (x<0) or (x>MaxX) or (y<0) or (y>MaxY) then StarRandom(f);
  PutPixel(x,y,Col)
end;
until KeyPressed;
h:=ReadKey;
if h=#0 then h:=ReadKey;
CloseGraph
end.