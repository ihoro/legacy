program ConstructorLabirint;
uses Crt,Dos,CGADrv,Graph;
Label Start,Start2;
type Labirint=0..11;
     Colors=0..15;
var t:array[1..200,1..200] of Labirint;
    youx,youy,err,Gd,Gm,r,p,x,y,xx,yy,f,l,ff,ll:integer;
    time:LongInt;
    name,q:string;
    lab:text;
    Cursor,Ekran:byte;
    col:array[0..11] of Colors;
    You,ExitEnd:boolean;
    h:char;
    ex,ko:array[1..11] of Integer;

function construct(code:labirint):string;
begin
case code of
0:begin construct:='  ';textcolor(0);end;
1:begin construct:='██';textcolor(1);end;
9:begin construct:='██';textcolor(9);end;
2:begin construct:='██';textcolor(8);end;
3:begin construct:='└┘';textcolor(1);end;
4:begin construct:='OO';textcolor(14);end;
5:begin construct:='';textcolor(11);end;
6:begin construct:='$$';textcolor(10);end;
7:begin construct:='░░';textcolor(14);end;
8:begin construct:='EX';textcolor(13);end;
10:begin construct:='[]';textcolor(6);end;
11:begin construct:='ТЫ';textcolor(13);end
end
end;

procedure Effect(code:byte);
begin
for f:=1 to 15 do
 begin
  q:=construct(code);
  gotoxy(r,p);
  textcolor(f);
  write(q);
  Sound(38000);
  Delay(4);
  NoSound;
  gotoxy(r,p);
  q:=construct(Code);
  textcolor(4);
  write(q)
 end;
end;

procedure Status;
begin
gotoxy(67,25);textbackground(0);
textcolor(10);write('│ X=',x,' Y=',y);
end;

procedure Display;
begin
textbackground(0);
gotoxy(1,25);for f:=1 to 79 do write(' ');
gotoxy(1,25);textcolor(0);write('██');textcolor(6);write('-0  ');
textcolor(1);write('██');textcolor(6);write('-1  ');
textcolor(8);write('██');textcolor(6);write('-2  ');
textcolor(1);write('└┘');textcolor(6);write('-3  ');
textcolor(14);write('OO');textcolor(6);write('-4  ');
textcolor(11);write('');textcolor(6);write('-5  ');
textcolor(10);write('$$');textcolor(6);write('-6  ');
textcolor(14);write('░░');textcolor(6);write('-7  ');
textcolor(13);write('EX');textcolor(6);write('-8  ');
textcolor(1);write('██');textcolor(6);write('-9  ');
textcolor(13);write('ТЫ');textcolor(6);write('-Y  ');
Status;
textbackground(0);
case Ekran of
1,6,11,16,21,26,31,36:ff:=1;
2,7,12,17,22,27,32,37:ff:=41;
3,8,13,18,23,28,33,38:ff:=81;
4,9,14,19,24,29,34,39:ff:=121;
5,10,15,20,25,30,35,40:ff:=161
end;
case Ekran of
1,2,3,4,5:ll:=1;
6,7,8,9,10:ll:=25;
11,12,13,14,15:ll:=49;
16,17,18,19,20:ll:=73;
21,22,23,24,25:ll:=97;
26,27,28,29,30:ll:=121;
31,32,33,34,35:ll:=145;
36,37,38,39,40:ll:=169
end;
  for f:=ff to ff+39 do
   for l:=ll to ll+23 do
     begin
       gotoxy((f+1-ff)*2-1,l+1-ll);write(construct(t[f,l]));
     end;
end;

begin
for f:=0 to 11 do col[f]:=0;
col[11]:=11;
Start:
textbackground(0);
ClrScr;
textcolor(10);
gotoxy(3,3);writeln('1 - Редактирование     2 - Создать     3 - Графический просмотр');
writeln;write('         Esc - Выход');
ex[1]:=11;ko[1]:=1;
ex[2]:=13;ko[2]:=-1;
ex[3]:=12;ko[3]:=1;
ex[4]:=13;ko[4]:=-1;
ex[5]:=12;ko[5]:=1;
ex[6]:=12;ko[6]:=-1;
ex[7]:=13;ko[7]:=-1;
ex[8]:=12;ko[8]:=1;
ex[9]:=13;ko[8]:=-1;
ex[10]:=11;ko[10]:=1;
ex[11]:=12;ko[11]:=1;
h:=' ';
repeat
for f:=1 to 11 do
 begin
   textcolor(0);
   gotoxy(25+f*3,ex[f]);
   write(' ');
   if ex[f]=11 then ko[f]:=1;
   if ex[f]=13 then ko[f]:=-1;
   ex[f]:=ex[f]+ko[f];
   gotoxy(25+f*3,ex[f]);
   textcolor(f);
   case f of
   1:write('C');
   2:write('O');
   3:write('N');
   4:write('S');
   5:write('T');
   6:write('R');
   7:write('U');
   8:write('C');
   9:write('T');
   10:write('O');
   11:write('R')
   end;
   delay(11);
 end;
if KeyPressed then h:=ReadKey;
until (h=#27) or (h='1') or (h='2') or (h='3');
{}{}{}{}
if h=#27 then begin ClrScr;Halt end;
r:=5;p:=3;x:=3;y:=3;You:=false;ExitEnd:=false;
if h='1' then
  begin
    ClrScr;
    textcolor(14);
    gotoxy(28,12);
    write('Имя файла без .lab: ');
    readln(Name);
    Assign(lab,Name+'.lab');
    Reset(lab);
    readln(lab,time);
    readln(lab,youx);
    readln(lab,youy);
    readln(lab,xx);
    readln(lab,yy);
    for l:=1 to yy do
      for f:=1 to xx do begin readln(lab,t[f,l]);if t[f,l]=8 then ExitEnd:=true end;
    t[youx,youy]:=11;
    You:=true;
    Close(lab);
  end;
if h='2' then
  begin
   repeat
    ClrScr;
    textcolor(14);
    gotoxy(28,10);write('Имя файла: ');
    readln(Name);
    gotoxy(28,12);write('Длина по горизонтали: ');
    readln(xx);
    gotoxy(28,14);write('Длина по вертикали: ');
    readln(yy);
    gotoxy(28,16);write('Ok?(y/n): ');
    repeat
    h:=ReadKey;
    until (UpCase(h)='N') or (UpCase(h)='Y');
    write(h);
   until UpCase(h)='Y';
   for l:=1 to yy do
    for f:=1 to xx do t[f,l]:=0;
    for f:=2 to xx-1 do t[f,2]:=1;
    for f:=2 to xx-1 do t[f,yy-1]:=1;
    for l:=2 to yy-1 do t[2,l]:=1;
    for l:=2 to yy-1 do t[xx-1,l]:=1;
  end;
if h='3' then
  begin
    ClrScr;
    textcolor(14);
    gotoxy(28,3);
    write('Имя файла без .lab: ');
    readln(Name);
    Assign(lab,Name+'.lab');
    Reset(lab);
    readln(lab,time);
    readln(lab,youx);
    readln(lab,youy);
    readln(lab,xx);
    readln(lab,yy);
    for l:=1 to yy do
      for f:=1 to xx do readln(lab,t[f,l]);
    Close(lab);
    textcolor(10);
    gotoxy(42,6);write('Цвет:');
    gotoxy(35,7);textcolor(6);write('[]');textcolor(10);write('-0   ',col[0]);
    gotoxy(35,8);textcolor(1);write('██');textcolor(10);write('-1   ',col[1]);
    gotoxy(35,9);textcolor(8);write('██');textcolor(10);write('-2   ',col[2]);
    gotoxy(35,10);textcolor(1);write('└┘');textcolor(10);write('-3   ',col[3]);
    gotoxy(35,11);textcolor(14);write('OO');textcolor(10);write('-4   ',col[4]);
    gotoxy(35,12);textcolor(11);write('');textcolor(10);write('-5   ',col[5]);
    gotoxy(35,13);textcolor(10);write('$$');textcolor(10);write('-6   ',col[6]);
    gotoxy(35,14);textcolor(14);write('░░');textcolor(10);write('-7   ',col[7]);
    gotoxy(35,15);textcolor(13);write('EX');textcolor(10);write('-8   ',col[8]);
    gotoxy(35,16);textcolor(1);write('██');textcolor(10);write('-9   ',col[9]);
    gotoxy(35,17);textcolor(13);write('ТЫ');textcolor(10);write('-Y   ',col[10]);
    gotoxy(35,18);textcolor(14);write('Рамка');textcolor(10);write('  ',col[11]);
    gotoxy(35,19);textcolor(12);write('Просмотр');
    y:=7;
    textcolor(13);gotoxy(32,y);write('██');
    gotoxy(28,3);
    repeat
     repeat
     h:=ReadKey;
     until (h=#0) or (h=#13) or (h=#27);
     if h=#13 then
       begin
         if y<>19 then
           begin
             textcolor(0);gotoxy(42,y);write('  ');
             if col[y-7]=15 then col[y-7]:=0
                            else col[y-7]:=col[y-7]+1;
             textcolor(10);gotoxy(42,y);write(col[y-7]);
             gotoxy(28,3);
           end;
         if y=19 then
           begin
             Gd:=Detect;
             InitGraph(Gd,Gm,'');
             SetColor(col[11]);
             Line(0,0,xx+1,0);
             Line(xx+1,0,xx+1,yy+1);
             Line(xx+1,yy+1,0,yy+1);
             Line(0,yy+1,0,0);
             t[youx,youy]:=10;
             for l:=1 to yy do
               for f:=1 to xx do PutPixel(f,l,col[t[f,l]]);
             repeat
             until KeyPressed;
             CloseGraph;
             ClrScr;
             textcolor(10);
             gotoxy(42,6);write('Цвет:');
             gotoxy(35,7);textcolor(6);write('[]');textcolor(10);write('-0   ',col[0]);
             gotoxy(35,8);textcolor(1);write('██');textcolor(10);write('-1   ',col[1]);
             gotoxy(35,9);textcolor(8);write('██');textcolor(10);write('-2   ',col[2]);
             gotoxy(35,10);textcolor(1);write('└┘');textcolor(10);write('-3   ',col[3]);
             gotoxy(35,11);textcolor(14);write('OO');textcolor(10);write('-4   ',col[4]);
             gotoxy(35,12);textcolor(11);write('');textcolor(10);write('-5   ',col[5]);
             gotoxy(35,13);textcolor(10);write('$$');textcolor(10);write('-6   ',col[6]);
             gotoxy(35,14);textcolor(14);write('░░');textcolor(10);write('-7   ',col[7]);
             gotoxy(35,15);textcolor(13);write('EX');textcolor(10);write('-8   ',col[8]);
             gotoxy(35,16);textcolor(1);write('██');textcolor(10);write('-9   ',col[9]);
             gotoxy(35,17);textcolor(13);write('ТЫ');textcolor(10);write('-Y   ',col[10]);
             gotoxy(35,18);textcolor(14);write('Рамка');textcolor(10);write('  ',col[11]);
             gotoxy(35,19);textcolor(12);write('Просмотр');
             y:=7;
             textcolor(13);gotoxy(32,y);write('██');
             gotoxy(28,3)
           end;
       end;
     if h=#0 then
       begin
        h:=ReadKey;
        if h=#72 then
         begin
          textcolor(0);gotoxy(32,y);write('██');
          if y=7 then y:=19
                 else y:=y-1;
          textcolor(13);gotoxy(32,y);write('██');
          gotoxy(28,3);
         end;
        if h=#80 then
         begin
          textcolor(0);gotoxy(32,y);write('██');
          if y=19 then y:=7
                  else y:=y+1;
          textcolor(13);gotoxy(32,y);write('██');
          gotoxy(28,3);
         end;
       end;
    until h=#27;
    goto Start
  end;
Start2:
ClrScr;
Ekran:=1;Cursor:=1;
Display;
gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q);
Status;
repeat
h:=ReadKey;
if (UpCase(h)<>'Y') and (h<>'0') and (h<>'8') and (ord(h)>48) and(ord(h)<=57) then begin val(h,Cursor,err);gotoxy(r,p);
      q:=construct(Cursor);textcolor(4);write(q); end;
if (UpCase(h)='Y') and not You then begin Cursor:=11;gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q); end;
if h='0' then begin Cursor:=10;gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q); end;
if (h='8') and not ExitEnd then begin Cursor:=8;gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q); end;
if h=' ' then
  begin
    Case Cursor of
    1,2,3,4,5,6,7,9:begin if t[x,y]=8 then ExitEnd:=false;if t[x,y]=11 then You:=false;t[x,y]:=Cursor;Effect(Cursor) end;
    8:if not ExitEnd then begin if t[x,y]=11 then You:=false;ExitEnd:=true;t[x,y]:=8;Effect(8) end;
    10:begin if t[x,y]=8 then ExitEnd:=false;if t[x,y]=11 then You:=false;t[x,y]:=0;Effect(10) end;
    11:if not You then
         begin
           You:=true;
           if t[x,y]=8 then ExitEnd:=false;t[x,y]:=11;
           Effect(11);
           youx:=x;
           youy:=y
         end;
    end;
  end;
if h=#0 then
 begin
  h:=ReadKey;
  if h=#83 then
    begin
      for l:=1 to yy do
        for f:=1 to xx do t[f,l]:=0;
      for f:=2 to xx-1 do t[f,2]:=1;
      for f:=2 to xx-1 do t[f,yy-1]:=1;
      for l:=2 to yy-1 do t[2,l]:=1;
      for l:=2 to yy-1 do t[xx-1,l]:=1;
      Display;
      gotoxy(r,p);q:=construct(Cursor);textcolor(12);write(q);
      Status
    end;
  if (h=#72) and (y<>3) then
    begin
     gotoxy(r,p);write(construct(t[x,y]));
     y:=y-1;
     if p=1 then begin Ekran:=Ekran-5;Display;p:=24 end
            else p:=p-1;
     gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q);
     Status;
    end;
  if (h=#80) and (y<>yy-2) then
    begin
     gotoxy(r,p);write(construct(t[x,y]));
     y:=y+1;
     if p=24 then begin Ekran:=Ekran+5;Display;p:=1 end
             else p:=p+1;
     gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q);
     Status;
    end;
  if (h=#75) and (x<>3) then
    begin
     gotoxy(r,p);write(construct(t[x,y]));
     x:=x-1;
     if r=1 then begin Ekran:=Ekran-1;Display;r:=79 end
             else r:=r-2;
     gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q);
     Status;
    end;
  if (h=#77) and (x<>xx-2) then
    begin
     gotoxy(r,p);write(construct(t[x,y]));
     x:=x+1;
     if r=79 then begin Ekran:=Ekran+1;Display;r:=1 end
             else r:=r+2;
     gotoxy(r,p);q:=construct(Cursor);textcolor(4);write(q);
     Status;
    end;
 end;
until h=#27;
textbackground(0);
ClrScr;
textcolor(10);
if you then
begin
  gotoxy(23,5);write('Записать?(y/n): ');
  repeat
  h:=ReadKey;
  h:=UpCase(h);
  until (h='Y') or (h='N');
  write(h);
  if h='Y' then
  begin
    ClrScr;
    gotoxy(23,5);write('Имя файла без .lab: ');
    readln(Name);
    gotoxy(23,7);write('Время в лабиринте: ');
    readln(time);
    Assign(lab,Name+'.lab');
    Rewrite(lab);
    Writeln(lab,time);
    Writeln(lab,youx);
    Writeln(lab,youy);
    Writeln(lab,xx);
    Writeln(lab,yy);
    t[youx,youy]:=0;
    for l:=1 to yy do
      for f:=1 to xx do Writeln(lab,t[f,l]);
    Close(lab);
    gotoxy(23,9);write('Ok!');
    end;
end;
gotoxy(23,11);write('Выйти?(y/n): ');
repeat
h:=ReadKey;
h:=UpCase(h);
until (h='N') or (h='Y');
write(h);
if h='N' then goto Start2;
for l:=1 to 200 do
  for f:=1 to 200 do t[f,l]:=0;
goto Start;
end.