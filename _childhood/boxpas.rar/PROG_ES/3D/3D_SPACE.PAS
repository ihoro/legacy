uses CGADrv, Graph, Crt, Dos;
label En;
var
    d,m,f:integer;
    x,y:array[1..501] of integer;
    s:array[1..501] of word;
    h:char;
    Col,no,n:byte;
    Stars,ko:Word;
    point:array[1..2,1..23,1..23] of 0..3;
procedure ReadStu(FileName:string;b:byte);
var f,l:byte;
    fil:text;
    ch:char;
    p:0..3;
    err:integer;
begin
Assign(fil,FileName+'.stu');
Reset(fil);
for l:=1 to 23 do
  for f:=1 to 23 do
    begin
      read(fil,ch);
      if f=23 then readln(fil,ch)
              else read(fil,ch);
      Val(ch,p,err);
      Point[b,l,f]:=p
    end;
Close(fil)
end;
procedure WriteStu(x,y,MaxX,MaxY:integer;b,c:byte);
var f,l:byte;
begin
if c<>0 then
for l:=1 to MaxY do
  for f:=1 to MaxX do
    if Point[b,l,f]<>0 then PutPixel(x+f-1,y+l-1,Point[b,l,f]);
if c=0 then
for l:=1 to MaxY do
  for f:=1 to MaxX do
    if Point[b,l,f]<>0 then PutPixel(x+f-1,y+l-1,0)
end;
begin
readstu('type1',1);readstu('type2',2);
Stars:=40;
Randomize;
for f:=1 to Stars do s[f]:=Random(20)+1;
s[501]:=5;
d:=Detect;
InitGraph(d,m,'');
if d=CGA then SetGraphMode(1);
for f:=1 to Stars do x[f]:=Random(GetMaxX);
for f:=1 to Stars do y[f]:=Random(GetMaxY);
if d=CGA then Col:=1
         else Col:=15;
no:=1;
n:=1;
x[501]:=GetMaxX+50;
y[501]:=Random(GetMaxY);
ko:=0;
f:=0;
repeat
f:=f+1; if f=Stars+2 then f:=1;
if f=Stars+1 then
begin
writestu(x[501],y[501],18,8,n,0);
no:=no+1; if no=5 then begin no:=1;n:=n+1;if n=3 then n:=1 end;
x[501]:=x[501]-s[501];
writestu(x[501],y[501],18,8,n,Col)
end
             else
begin
PutPixel(x[f],y[f],0);PutPixel(x[f]+1,y[f],0);PutPixel(x[f]+2,y[f],0);
x[f]:=x[f]-s[f];
if x[f]<0 then
  begin
    x[f]:=GetMaxX;
    y[f]:=Random(GetMaxY)
  end;
PutPixel(x[f],y[f],Col)
end;
ko:=ko+1;
if ko=6500 then goto En
until KeyPressed;
h:=ReadKey;
if h=#0 then h:=ReadKey;
En:
CloseGraph;
textcolor(7);
writeln('Компьютер улетел!')
end.