program LoadBMP;
uses Graph,GrDriver,Images,Crt;
var
  Filter : TBmpFilter;
  Image : TImage;
  r,t,f,Gd,Gm: Integer;
  ex1,ex2,ex3,ex4,ex5,ex6,ex7,ex8,space,gun,enemy1,enemy2:pointer;
  size:word;
  s:string;
  h:char;
procedure picture(s:string;x,y:integer);
begin
Image.Import (s+'.pfp',@Filter);
Image.Draw (x,y,NormalPut);
Image.Done;
end;
begin
Gd:=Detect;
InitGraph(Gd,Gm,'');
InitVideo;
Filter.Init;
SetTextStyle(4,0,6);
SetColor(10);
OutTextXY(252,198,'Begin');OutTextXY(252,298,'Exit');
SetColor(13);
OutTextXY(250,200,'Begin');OutTextXY(250,300,'Exit');
picture('explode1',180,200);
Size:=ImageSize(180,200,244,264);
GetMem(ex1,size);
GetImage(180,200,244,264,ex1^);
{picture('space',200,200);}
t:=200;r:=0;
REPEAT
repeat
repeat
h:=ReadKey
until (h=#0) or (h=#13);
if h<>#13 then h:=ReadKey;
if (h=#80) and (t<>300) then
 begin
  SetFillStyle(1,0);
  Bar(180,t,244,t+64);
  t:=t+100;
  PutImage(180,t,ex1^,0)
 end;
if (h=#72) and (t<>200) then
 begin
  SetFillStyle(1,0);
  Bar(180,t,244,t+64);
  t:=t-100;
  PutImage(180,t,ex1^,0)
 end;
until h=#13;
for f:=2 to 8 do
begin
{if r<>0 then
case f of
2:PutImage(180,t,ex2^,0);
3:PutImage(180,t,ex3^,0);
4:PutImage(180,t,ex4^,0);
5:PutImage(180,t,ex5^,0);
6:PutImage(180,t,ex6^,0);
7:PutImage(180,t,ex7^,0);
8:PutImage(180,t,ex8^,0)
end;}
if r=0 then
begin
{r:=r+1;}
str(f,s);
picture('explode'+s,180,t);
Delay(500-f*8);
SetFillStyle(1,0);
if f=8 then Bar(180,t,244,t+64);
{Size:=ImageSize(180,t,244,t+64);
 case f of
 2:begin GetMem(ex2,Size);GetImage(180,t,244,t+64,ex2^) end;
 3:begin GetMem(ex3,Size);GetImage(180,t,244,t+64,ex3^) end;
 4:begin GetMem(ex4,Size);GetImage(180,t,244,t+64,ex4^) end;
 5:begin GetMem(ex5,Size);GetImage(180,t,244,t+64,ex5^) end;
 6:begin GetMem(ex6,Size);GetImage(180,t,244,t+64,ex6^) end;
 7:begin GetMem(ex7,Size);GetImage(180,t,244,t+64,ex7^) end;
 8:begin GetMem(ex8,Size);GetImage(180,t,244,t+64,ex8^) end
 end;}
end;
end;
UNTIL t=300;

Filter.Done;
DoneVideo;
CloseGraph
end.