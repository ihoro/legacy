uses Crt, Dos;
Label Runn,Start;
type labirint=0..9;
var  x,y,d,f,l,p:integer;
     h:char;
     OK:byte;
     lab:text;
     Level:byte;
     Name,nam,k,pass:string;
     ex,ko:array[1..8] of integer;
     {}{}{}{}{  *.Lab   }{}{}{}{}
       t:array[1..200,1..200] of labirint;
       tx,ty,youx,youy:byte;
       time:integer;
     {}{}{}{}{}{}{ you  }{}{}{}{}
       patron:integer;
       score:word;
     {}{}{}{}{}{}{ Music  }{}{}{}
procedure SoundMove;
begin
Sound(45000);
Delay(1);
NoSound
end;
procedure SoundScore;
begin
for f:=1 to 11 do
begin
  Sound(7000+f*10);
  Delay(12-f);
  NoSound
end
end;
     {}{}{}{}{}{}{}{}{}{}{}{}{}{}
function construct(code:labirint):string;
begin
case code of
0:begin construct:='  ';textcolor(0);end;
1,9:begin construct:='██';textcolor(1);end;
2:begin construct:='██';textcolor(8);end;
3:begin construct:='└┘';textcolor(1);end;
4:begin construct:='OO';textcolor(14);end;
5:begin construct:='';textcolor(11);end;
6:begin construct:='$$';textcolor(10);end;
7:begin construct:='░░';textcolor(14);end;
8:begin construct:='EX';textcolor(13);end
end
end;

procedure WriteDisplay;
begin
textcolor(6);
gotoxy(36,9);write('╔══════════╗');
for f:=1 to 5 do begin gotoxy(36,9+f);write('║          ║'); end;
gotoxy(36,15);write('╚══════════╝');
for l:=1 to 5 do
 for f:=1 to 5 do
  begin
   gotoxy(35+f*2,9+l);
   write(construct(t[youx-3+f,youy-3+l]))
  end;
textcolor(13);gotoxy(41,12);write('██')
end;

procedure Harac;
begin
textcolor(10);gotoxy(21,13);write('Патроны:    ');
gotoxy(21,13);write('Патроны:',patron);
gotoxy(21,15);write('Очки:       ');
gotoxy(21,15);write('Очки:',score);
gotoxy(21,17);write('Время:      ');
gotoxy(21,17);write('Время:',time);
end;

procedure Tamojnya;
begin
OK:=0;
if (t[youx,youy]=1) or (t[youx,youy]=2) then
  begin
   if h=#72 then youy:=youy+1;
   if h=#80 then youy:=youy-1;
   if h=#75 then youx:=youx+1;
   if h=#77 then youx:=youx-1;
  end;
if t[youx,youy]=3 then
  begin
    patron:=patron+1;
    t[youx,youy]:=0;
    Harac;
    SoundScore
  end;
if t[youx,youy]=4 then
  begin
    score:=score+10;
    t[youx,youy]:=0;
    Harac;
    SoundScore
  end;
if t[youx,youy]=5 then
  begin
    score:=score+30;
    t[youx,youy]:=0;
    Harac;
    SoundScore
  end;
if t[youx,youy]=6 then
  begin
    score:=score+15;
    t[youx,youy]:=0;
    Harac;
    SoundScore
  end;
if t[youx,youy]=7 then
  begin
    score:=score+20;
    t[youx,youy]:=0;
    Harac;
    SoundScore
  end;
if (t[youx,youy]=8) and (nam=Name) then
  begin
    textcolor(10);gotoxy(20,2);write('Молодец!');
    Delay(20000);
    OK:=1
  end;
if (t[youx,youy]=8) and (nam<>Name) then
  begin
    textcolor(10);gotoxy(20,2);write('Молодец!');
    Level:=Level+1;
    case Level of
    2:write('   Password: Limited');
    3:write('   Password: SunSet');
    4:write('   Password: House');
    5:write('   Password: PopCorn');
    6:write('   Password: SuperJo');
    7:write('   Password: Cocker');
    8:write('   Password: Pacific');
    9:write('   Password: Streets');
    10:write('   Password: Moons');
    11:write('   Password: Slower');
    end;
    Delay(20000);
    OK:=2
  end;
end;

begin
Runn:
Level:=1;
nam:='';
textbackground(0);
ClrScr;
textcolor(13);gotoxy(15,5);
write('Самая плохая игра в истории динозавров(хрю-хрю!)');
textcolor(7);gotoxy(12,18);
write('Звукы(и): пищалка,  глаfикa: Super!(Very-very!)');
textcolor(10);gotoxy(5,24);
write('Зробыло за one день(8.6.2000): OIV Company');
ex[1]:=11;ko[1]:=1;
ex[2]:=13;ko[2]:=-1;
ex[3]:=12;ko[3]:=1;
ex[4]:=13;ko[4]:=-1;
ex[5]:=12;ko[5]:=1;
ex[6]:=12;ko[6]:=-1;
ex[7]:=13;ko[7]:=-1;
ex[8]:=12;ko[8]:=1;
repeat
for f:=1 to 8 do
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
   1:write('Л');
   2:write('А');
   3:write('Б');
   4:write('И');
   5:write('Р');
   6:write('И');
   7:write('Н');
   8:write('Т')
   end;
   delay(21);
 end;
until KeyPressed;
h:=ReadKey;
l:=30;
Pass:='';
clrscr;writeln;writeln('    Вмыкаемо гру:');
writeln;writeln('    F3 - из файла ');
writeln;writeln('    ESC - выход ');
textcolor(13);gotoxy(21,17);write('Password:');
ex[1]:=11;ko[1]:=1;
ex[2]:=13;ko[2]:=-1;
ex[3]:=12;ko[3]:=1;
ex[4]:=13;ko[4]:=-1;
ex[5]:=12;ko[5]:=1;
ex[6]:=12;ko[6]:=-1;
ex[7]:=13;ko[7]:=-1;
ex[8]:=12;ko[8]:=1;
REPEAT
repeat
for f:=1 to 8 do
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
   1:write('P');
   2:write('A');
   3:write('S');
   4:write('S');
   5:write('W');
   6:write('O');
   7:write('R');
   8:write('D')
   end;
   delay(13);
 end;
until KeyPressed;
h:=ReadKey;
textcolor(10);
if h=#0 then
  begin
    h:=ReadKey;
    if h=#61 then
      begin
        ClrScr;
        textcolor(14);
        gotoxy(28,12);write('Имя файла без .lab: ');
        readln(Name);
        Level:=0;
        goto Start
      end;
  end;
if (h<>#13) and (h<>#27) and (h<>#8) and (Length(pass)<12) then
 begin
  Pass:=Pass+h;
  gotoxy(l,17);
  write(Pass)
 end;
if (h=#8) and (Length(pass)<>0) then
 begin
  pass:=copy(pass,1,Length(pass)-1);
  gotoxy(l,17);
  write(pass,'             ');
 end;
UNTIL (h=#13) OR (h=#27);
if h=#27 then begin clrscr;write('Досвида....................');halt end;
if Pass='Limited' then Level:=2;
if Pass='SunSet' then Level:=3;
if Pass='House' then Level:=4;
if Pass='PopCorn' then Level:=5;
if Pass='SuperJo' then Level:=6;
if Pass='Cocker' then Level:=7;
if Pass='Pacific' then Level:=8;
if Pass='Streets' then Level:=9;
if Pass='Moons' then Level:=10;
if Pass='Slower' then Level:=11;
Start:
ClrScr;
case Level of
0:nam:=Name;
1:nam:='level_1';
2:nam:='level_2';
3:nam:='level_3';
4:nam:='level_4';
5:nam:='level_5';
6:nam:='level_6';
7:nam:='level_7';
8:nam:='level_8';
9:nam:='level_9';
10:nam:='level_10';
11:nam:='level_11';
end;
Assign(lab,nam+'.lab');
Reset(lab);
readln(lab,time);
readln(lab,youx);
readln(lab,youy);
readln(lab,tx);
readln(lab,ty);
for f:=1 to ty do
 for l:=1 to tx do readln(lab,t[l,f]);
Close(lab);
{}{}{}{}{}{}{}
patron:=0;
score:=0;
p:=0;
{}{}{}{}{}{}{}
gotoxy(1,3);
textcolor(1);write('  ██ - ');textcolor(6);writeln('стена');
textcolor(8);write('  ██ - ');textcolor(6);writeln('металлические двери');
textcolor(1);write('  └┘ - ');textcolor(6);writeln('пистолет с одним патроном');
textcolor(14);write('  OO - ');textcolor(6);writeln('монетки');
textcolor(11);write('   - ');textcolor(6);writeln('алмазы');
textcolor(10);write('  $$ - ');textcolor(6);writeln('доллары');
textcolor(14);write('  ░░ - ');textcolor(6);writeln('золотой песок');
textcolor(13);write('  EX - ');textcolor(6);writeln('выход из лабиринта');
textcolor(6);gotoxy(20,12);write('╔════════════╗');
for f:=1 to 5 do begin gotoxy(20,12+f);write('║            ║'); end;
textcolor(6);gotoxy(20,18);write('╚════════════╝');
Harac;
WriteDisplay;
REPEAT
repeat
p:=p+1;
if p=8250 then begin time:=time-1;Harac;p:=0 end;
if time=0 then
  begin
    gotoxy(20,2);textcolor(12);write('Game Over!');
    Delay(20000);
    goto Runn
  end;
until KeyPressed;
h:=ReadKey;
if h=#0 then
 begin
  h:=ReadKey;
  if (h=#72) and (youy<>3) then
   begin
    youy:=youy-1;
    d:=1;
    Tamojnya;
    if OK=1 then goto Runn;
    if OK=2 then goto Start;
    WriteDisplay;
    SoundMove
   end;
  if (h=#80) and (youy<>ty-2) then
   begin
    youy:=youy+1;
    d:=2;
    Tamojnya;
    if OK=1 then goto Runn;
    if OK=2 then goto Start;
    WriteDisplay;
    SoundMove
   end;
  if (h=#75) and (youx<>3) then
   begin
    youx:=youx-1;
    d:=3;
    Tamojnya;
    if OK=1 then goto Runn;
    if OK=2 then goto Start;
    WriteDisplay;
    SoundMove
   end;
  if (h=#77) and (youx<>tx-2) then
   begin
    youx:=youx+1;
    d:=4;
    Tamojnya;
    if OK=1 then goto Runn;
    if OK=2 then goto Start;
    WriteDisplay;
    SoundMove
   end;
 end;
if (h=' ') and (patron<>0) then
 begin
  patron:=patron-1;
  if (d=1) or (d=2) then k:='││'
    else k:='══';
  if d=1 then
   begin
    x:=youx;y:=youy-1;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(41,11);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(41,11);write(k);
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(41,11);write('  ');
     end;
    y:=y-1;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(41,10);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(41,10);write(k);
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(41,10);write('  ');
     end;
   end;
  if d=2 then
   begin
    x:=youx;y:=youy+1;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(41,13);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(41,13);write(k);
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(41,13);write('  ');
     end;
    y:=y+1;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(41,14);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(41,14);write(k);
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(41,14);write('  ');
     end;
   end;
  if d=3 then
   begin
    x:=youx-1;y:=youy;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(39,12);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(39,12);write(k);
      Harac;
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(39,12);write('  ');
     end;
    x:=x-1;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(37,12);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(37,12);write(k);
      Harac;
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(37,12);write('  ');
     end;
   end;
  if d=4 then
   begin
    x:=youx+1;y:=youy;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(43,12);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(43,12);write(k);
      Harac;
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(43,12);write('  ');
     end;
    x:=x+1;
    if t[x,y]=2 then
     begin
       for l:=1 to 15 do
        begin
         textcolor(l);gotoxy(45,12);write('██');
         t[x,y]:=0;
         Sound(300-l*10);Delay(l);NoSound
        end
     end;
    if t[x,y]=0 then
     begin
      textcolor(12);gotoxy(45,12);write(k);
      Harac;
      Sound(38000);
      Delay(9);
      NoSound;
      Delay(6);
      gotoxy(45,12);write('  ');
     end;
   end;
 end;
UNTIL h=#27;
clrscr;
end.