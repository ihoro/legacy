program Spiral_Olymp81_3;
var m:array[1..30,1..30] of word;
    f,x,y,n:byte;
    r,t:ShortInt;
    c:word;
    stop:boolean;
procedure Move;
begin
if (m[x-1,y]=0) and (m[x,y-1]<>0) and (m[x+1,y]<>0) and (m[x,y+1]<>0) then
  begin
    r:=-1;
    t:=0;
    exit
  end;
if (m[x-1,y]<>0) and (m[x,y-1]=0) and (m[x+1,y]<>0) and (m[x,y+1]<>0) then
  begin
    r:=0;
    t:=-1;
    exit
  end;
if (m[x-1,y]<>0) and (m[x,y-1]<>0) and (m[x+1,y]=0) and (m[x,y+1]<>0) then
  begin
    r:=1;
    t:=0;
    exit
  end;
if (m[x-1,y]<>0) and (m[x,y-1]<>0) and (m[x+1,y]<>0) and (m[x,y+1]=0) then
  begin
    r:=0;
    t:=1;
    exit
  end;
if (m[x-1,y]<>0) and (m[x,y-1]<>0) and (m[x+1,y]<>0) and (m[x,y+1]<>0) then Stop:=true
end;

begin
stop:=false;
writeln;
write('n=');readln(n);
writeln;
for y:=1 to n do
  for x:=1 to n do m[x,y]:=0;
for f:=1 to n do m[f,1]:=f;
for f:=2 to n do m[n,f]:=n+f-1;
for f:=n-1 downto 1 do m[f,n]:=3*n-1-f;
c:=3*n-1-f;
for f:=n-1 downto 2 do m[1,f]:=c-f+n;
c:=c-f+n+1;
x:=2;y:=2;r:=1;t:=0;
repeat
m[x,y]:=c;
c:=c+1;
Move;
x:=x+r;
y:=y+t;
until Stop;
for y:=1 to n do
 begin
  for x:=1 to n do write(m[x,y],'   ');
  writeln
 end;
readln
end.