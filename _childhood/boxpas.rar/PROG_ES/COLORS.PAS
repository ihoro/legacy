uses TextWind, Crt;
const
      Colors:array[1..5] of Byte = (9,12,14,10,7);
var
    d,f,l:integer;
    Time:Word;
    Pole:array[1..25,1..18] of Byte;
    dx,dy,px,py:Byte;
    Color:array[1..3] of Byte;
    Symbol:string[2];
    Hor:Boolean; {true - горизонтально, false - вертикально}
    h:Char;
procedure Standart;
begin
textbackground(0);ClrScr;
TextWindow(41,1,40,24,'');
textbackground(0);textcolor(10);
for f:=1 to 24 do
  begin
    gotoxy(1,f);write('▓▓');
    gotoxy(39,f);write('▓▓')
  end;
gotoxy(1,25);for f:=1 to 20 do write('▓▓');
textcolor(13);gotoxy(42,25);write('(C) OIV Company Ltd.              2000');
end;
procedure You(Clear:Boolean);
begin
textbackground(0);
if Clear then
  begin
    if Hor then
      begin
        gotoxy(dx,dy);
        for f:=px to px+2 do pole[py,f]:=0;
        write('      ')
      end
           else
      for f:=dy to dy+2 do
        begin
          gotoxy(dx,f);write('  ');
          pole[f,px]:=0
        end;
    SetCursor;
    exit
  end;
if Hor then
  begin
    f:=dx;
    l:=1;
    d:=px;
    while f<(dx+5) do
      begin
        gotoxy(f,dy);textcolor(color[l]);
        write(Symbol);
        pole[py,d]:=Color[l];
        d:=d+1;
        l:=l+1;
        f:=f+2
      end;
    SetCursor;
    exit
  end;
for f:=1 to 3 do
  begin
    gotoxy(dx,dy+f-1);textcolor(Color[f]);
    write(Symbol);
    pole[py+f-1,px]:=Color[f]
  end;
SetCursor
end;
procedure Init;
begin
px:=Random(18)+1;
dx:=px*2+1;
py:=1;
dy:=1;
Hor:=false;
for f:=1 to 3 do Color[f]:=Colors[Random(5)+1]
end;
procedure Tamojna;
begin
if hor then
  begin
    if pole[py+1,px]<>0 then
      begin
        You(false);
        Init;
        exit
      end;
    if pole[py+1,px+1]<>0 then
      begin
        You(false);
        Init;
        exit
      end;
    if pole[py+1,px+2]<>0 then
      begin
        You(false);
        Init;
        exit
      end
  end;
if pole[py+3,px]<>0 then
      begin
        You(false);
        Init;
        exit
      end
end;
begin
Randomize;
Symbol:='██';
Standart;
for l:=1 to 24 do
  for f:=1 to 18 do pole[l,f]:=0;
for f:=1 to 18 do pole[25,f]:=255;
Init;
You(false);
repeat
repeat
Time:=Time+1;
if Time=5000 then
  begin
    You(true);
    dy:=dy+1;
    py:=py+1;
    Tamojna;
    You(false);
    Time:=0;
  end;
until KeyPressed;
h:=ReadKey;
if h=' ' then
  begin
    You(true);
    if Hor then Hor:=false
           else
      if px<=16 then Hor:=true;
    Tamojna;
    You(false)
  end;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#72 then
      begin
        f:=Color[3];
        Color[3]:=Color[2];
        Color[2]:=Color[1];
        Color[1]:=f;
        You(false)
      end;
    if (h=#75) and (px<>1) then
      begin
        You(true);
        px:=px-1;
        dx:=dx-2;
        Tamojna;
        You(false)
      end;
    if (h=#77) and (px<>18) and not Hor then
      begin
        You(true);
        px:=px+1;
        dx:=dx+2;
        Tamojna;
        You(false)
      end;
    if (h=#77) and (px<>16) and Hor then
      begin
        You(true);
        px:=px+1;
        dx:=dx+2;
        Tamojna;
        You(false)
      end;
  end; {h=#0}
until h=#27
end.