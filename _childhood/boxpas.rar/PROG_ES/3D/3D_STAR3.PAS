uses Graph, Crt;
var
    star:array[1..400] of
           record
             x1,y1,x2,y2:integer;
             x,y,k,b:real;
             speed:byte;
             corner:1..4
           end;
    f,l,d,MaxX,MaxY:integer;
    Stars:word;
    Col:byte;
    h:Char;
function StarY(s:word;xx:real):real;
begin
with Star[s] do StarY:=k*xx+b
end;
procedure StarXYRandom(s:word);
begin
with Star[s] do
begin
case Corner of
  1:begin
      x:=Random(MaxX);
      y:=StarY(s,x)
    end;
  2:begin
      x:=Random(MaxX div 2)+MaxX div 2;
      y:=StarY(s,x)
    end;
  3:begin
      x:=Random(MaxX);
      y:=StarY(s,x)
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
        repeat
        y2:=Random(MaxY)
        until y2<>(MaxY div 2)
      end;
    3:begin
        x2:=Random(MaxX-1)+1;
        y2:=MaxY
      end;
    4:begin
        x2:=0;
        repeat
        y2:=Random(MaxY)
        until y2<>(MaxY div 2)
      end
  end;
  if (Corner=2) or (Corner=4) then
    begin
      if x1>x2 then x1:=x1-speed
               else x1:=x1+speed;
      if ABS(y1)>ABS(y2) then y1:=y1-Random(speed)
                         else y1:=y1+Random(speed)
    end
                 else
    begin
      if ABS(y1)>ABS(y2) then y1:=y1-speed
                         else y1:=y1+speed;
      if x1>x2 then x1:=x1-Random(speed)
               else x1:=x1+Random(speed)
    end
  until x1<>x2;
  k:=(y1-y2) div (x1-x2);
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
  PutPixel(Round(x),Round(y),0);
  case Corner of
    1:begin
        if x1>x2 then x:=x-speed
                 else x:=x+speed;
        y:=StarY(f,x)
      end;
    2:begin
        x:=x+speed;
        y:=StarY(f,x)
      end;
    3:begin
        if x1>x2 then x:=x-speed
                 else x:=x+speed;
        y:=StarY(f,x)
      end;
    4:begin
        x:=x-speed;
        y:=StarY(f,x)
      end;
  end;
  if (x<0) or (x>MaxX) or (y<0) or (y>MaxY) then StarRandom(f);
  PutPixel(Round(x),Round(y),Col)
end;
Delay(25)
until KeyPressed;
h:=ReadKey;
if h=#0 then h:=ReadKey;
CloseGraph
end.