uses TextWind, Crt;
label Finish;
var
     m:MenuType;
     p:array[1..3,1..3] of byte;
     f,l,ll,hod,x,y,yx,yy:integer;
     k,com,you:byte;
     h:Char;
procedure SetZ(x,y,s:byte);
begin
textbackground(1);
textcolor(14);
gotoxy(32+x*3,5+y*2);
if s=1 then write('><');
if s=2 then write('OO');
if s=0 then write('  ');
SetCursor
end;
procedure SetYou(x,y,s:byte);
begin
textbackground(12);
textcolor(14);
gotoxy(32+x*3,5+y*2);
if s=1 then write('><');
if s=2 then write('OO');
if s=0 then write('  ');
SetCursor
end;
begin
Randomize;
textbackground(0);
ClrScr;
textcolor(10);
gotoxy(33,6);write('Šà¥áâ¨ª¨-­®«¨ª¨');
FirstActive:=1;
MenuY:=2;
m[1]:=' Šà¥áâ¨ª ';
m[2]:='  ®«¨ª  ';
m[3]:='  ‚ëå®¤  ';
repeat
TextWindow(35,9,11,5,'');
ll:=Menu(2,2,m,3);
if ll=3 then goto Finish;
case ll of
  1:begin
      you:=1;
      com:=2
    end;
  2:begin
      you:=2;
      com:=1
    end;
end;
hod:=0;
textbackground(0);ClrScr;
textbackground(1);textcolor(12);
 gotoxy(35,7);write('  ³  ³  ');
 gotoxy(35,8);write('ÄÄÅÄÄÅÄÄ');
 gotoxy(35,9);write('  ³  ³  ');
gotoxy(35,10);write('ÄÄÅÄÄÅÄÄ');
gotoxy(35,11);write('  ³  ³  ');
for l:=1 to 3 do
  for f:=1 to 3 do p[f,l]:=0;
if Random(2)+1=2 then
  begin
    f:=Random(3)+1;
    l:=Random(3)+1;
    p[f,l]:=com;
    SetZ(f,l,com);
    hod:=hod+1
  end;
yx:=2;yy:=2;
repeat
repeat
h:=ReadKey;
if h=#0 then h:=ReadKey;
if (h=#72) and (yy<>1) then
  begin
    SetZ(yx,yy,p[yx,yy]);
    yy:=yy-1;
    SetYou(yx,yy,p[yx,yy])
  end;
if (h=#80) and (yy<>3) then
  begin
    SetZ(yx,yy,p[yx,yy]);
    yy:=yy+1;
    SetYou(yx,yy,p[yx,yy])
  end;
if (h=#75) and (yx<>1) then
  begin
    SetZ(yx,yy,p[yx,yy]);
    yx:=yx-1;
    SetYou(yx,yy,p[yx,yy])
  end;
if (h=#77) and (yx<>3) then
  begin
    SetZ(yx,yy,p[yx,yy]);
    yx:=yx+1;
    SetYou(yx,yy,p[yx,yy])
  end;
until (h=#27) or (h=' ');
if h=' ' then
  begin
    hod:=hod+1;
    p[yx,yy]:=you;
    SetYou(yx,yy,p[yx,yy]);
    k:=0;
    for f:=1 to 3 do
      if p[f,yy]=you then k:=k+1;

  end;
if (hod<>9) and (h=' ') then
begin
hod:=hod+1;
repeat
f:=Random(3)+1;
l:=Random(3)+1;
until p[f,l]=0;
p[f,l]:=com;
SetZ(f,l,com)
end;
until (hod=9) or (h=#27);
until ll=3;
Finish:
textbackground(0);
ClrScr
end.