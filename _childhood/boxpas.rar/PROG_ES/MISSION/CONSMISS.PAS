uses TextWind, Crt, Dos;
label Start;
var
    p:array[1..100,1..100] of Byte;
    Block,ScreenX,ScreenY,f,l,d,MaxX,MaxY,YouX,YouY,X,Y:Byte;
    s:string;
    NameFile:string[12];
    map:text;
    Err:Integer;
    h:Char;
procedure DrawBlock(x,y,Block:Byte);
begin
gotoxy(x,y);
case Block of
0:begin
    textbackground(2);
    textcolor(6);
    write('∞∞')
  end;
1:begin
    textbackground(2);
    textcolor(0);
    write('∞∞')
  end;
2:begin
    textbackground(1);
    textcolor(11);
    write('≤≤')
  end;
3:begin
    textbackground(0);
    textcolor(1);
    write('∞∞')
  end;
4:begin
    textbackground(0);
    textcolor(7);
    write('¿Ÿ')
  end;
5:begin
    textbackground(7);
    textcolor(8);
    write('…Õ')
  end;
6:begin
    textbackground(7);
    textcolor(8);
    write('»Õ')
  end;
7:begin
    textbackground(7);
    textcolor(8);
    write('Õª')
  end;
8:begin
    textbackground(7);
    textcolor(8);
    write('Õº')
  end;
9:begin
    textbackground(7);
    textcolor(8);
    write('ÕÕ')
  end;
10:begin
    textbackground(7);
    textcolor(8);
    write('∫ ')
  end;
11:begin
    textbackground(7);
    textcolor(8);
    write(' ∫')
  end;
12:begin
    textbackground(7);
    textcolor(8);
    write('  ')
  end;
13:begin
    textbackground(2);
    textcolor(10);
    write('‘µ')
  end;
14:begin
    textbackground(2);
    textcolor(10);
    write('‘π')
  end;
15:begin
    textbackground(2);
    textcolor(10);
    write('»º')
  end;
16:begin
    textbackground(2);
    textcolor(10);
    write('‘æ')
  end;
17:begin
    textbackground(2);
    textcolor(10);
    write('¿Ÿ')
  end;
18:begin
    textbackground(1);
    textcolor(9);
    write('‘µ')
  end;
19:begin
    textbackground(1);
    textcolor(9);
    write('‘π')
  end;
20:begin
    textbackground(1);
    textcolor(9);
    write('»º')
  end;
21:begin
    textbackground(1);
    textcolor(9);
    write('‘æ')
  end;
22:begin
    textbackground(1);
    textcolor(9);
    write('¿Ÿ')
  end;
23:begin
    textbackground(6);
    textcolor(13);
    write('##')
  end;
24:begin
    textbackground(2);
    textcolor(0);
    write('€€')
  end;
25:begin
     textbackground(7);
     textcolor(8);
     write('[]')
   end;
end;
SetCursor
end;
procedure Screen(x,y:Byte);
var f,l,ff,ll:byte;
begin
if MaxY<24 then ll:=MaxY
           else ll:=24;
if MaxX<40 then ff:=MaxX
           else ff:=40;
for l:=1 to ll do
  for f:=1 to ff do
    DrawBlock(f*2-1,l,p[y+l-1,x+f-1]);
SetCursor
end;
procedure You(Clear:Boolean);
begin
if Clear then
  DrawBlock(X,Y,p[YouY,YouX])
         else
  begin
    textbackground(0);
    textcolor(13);
    gotoxy(X,Y);
    write('€€')
  end;
SetCursor
end;
begin
NameFile:='';
Start:
textbackground(0);
ClrScr;
textcolor(10);
gotoxy(36,9);write('Name File');
SI:='';
s:=InputData(37,12,8,English+Figures+Others);
NameFile:=s+'.map';
if s='' then
  begin
    textbackground(0);
    ClrScr;
    Halt
  end;
{$I-}
Assign(map,NameFile);
Reset(map);
if IOResult<>0 then
  begin
    Rewrite(map);
    Close(map);
    textbackground(0);gotoxy(36,15);textcolor(10);
    write('X=');
    SI:='';
    s:=InputData(39,15,3,Figures);
    val(s,MaxX,Err);
    textbackground(0);textcolor(10);
    gotoxy(36,18);write('Y=');
    SI:='';
    s:=InputData(39,18,3,Figures);
    val(s,MaxY,Err);
    for l:=1 to MaxY do
      for f:=1 to MaxX do
        p[l,f]:=0;
  end
               else
  begin
    readln(map,MaxX);readln(map,MaxY);
    for l:=1 to MaxY do
      for f:=1 to MaxX do
        readln(map,p[l,f]);
    Close(map);
  end;
{$I+}
Screen(1,1);
ScreenX:=1;
ScreenY:=1;
X:=1;Y:=1;
YouX:=1;
YouY:=1;
Block:=1;
DrawBlock(5,25,Block);
You(false);
repeat
h:=ReadKey;
if h=#13 then
  begin
    Block:=Block+1;
    if Block=26 then Block:=0;
    DrawBlock(5,25,Block)
  end;
if h=' ' then
  begin
    p[YouY,YouX]:=Block;
    Sound(100);
    Delay(20);
    NoSound
  end;
if h=#0 then
  begin
    h:=ReadKey;
    if (h=#72) and (YouY<>1) then
      begin
        You(true);
        if Y=1 then
          begin
            ScreenY:=ScreenY-1;
            Screen(ScreenX,ScreenY);
            YouY:=YouY-1
          end;
        if Y<>1 then
          begin
            YouY:=YouY-1;
            Y:=Y-1
          end;
        You(false)
      end;
    if (h=#80) and (YouY<>MaxY) then
      begin
        You(true);
        if Y=24 then
          begin
            ScreenY:=ScreenY+1;
            Screen(ScreenX,ScreenY);
            YouY:=YouY+1
          end;
        if Y<>24 then
          begin
            YouY:=YouY+1;
            Y:=Y+1
          end;
        You(false)
      end;
    if (h=#75) and (YouX<>1) then
      begin
        You(true);
        if X=1 then
          begin
            ScreenX:=ScreenX-1;
            Screen(ScreenX,ScreenY);
            YouX:=YouX-1
          end;
        if X<>1 then
          begin
            YouX:=YouX-1;
            X:=X-2
          end;
        You(false)
      end;
    if (h=#77) and (YouX<>MaxX) then
      begin
        You(true);
        if X=79 then
          begin
            ScreenX:=ScreenX+1;
            Screen(ScreenX,ScreenY);
            YouX:=YouX+1
          end;
        if X<>79 then
          begin
            YouX:=YouX+1;
            X:=X+2
          end;
        You(false)
      end;
  end; {h=#0}
until h=#27;
Assign(map,NameFile);
Rewrite(map);
writeln(map,MaxX);writeln(map,MaxY);
for l:=1 to MaxY do
  for f:=1 to MaxX do
    writeln(map,p[l,f]);
Close(map);
goto Start
end.