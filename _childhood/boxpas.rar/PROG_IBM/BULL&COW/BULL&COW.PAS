{ (C) OIV Company Ltd.  March,2000}
Program Bulls_Cows;
Uses  Objects, Crt, Dos, Graph, Sounds, GrDriver, Images, EventMan;
Const Key=15;
Label Start, Finish, KillStart;
var
   Filter:TBmpFilter;
   Image:TImage;
   PicName:string;
   igrok:array[1..10] of
       record
         nomer:byte;
         name :string[20];
         scor :LongInt;
         vrem :string
       end;
   h:char;
   x,y,xxx,yyy,Dg,Dm,err,q:integer;
   sc,score,time,timetime:LongInt;
   ex:boolean;
   fil:text;
   comchislo,s,sss,otgad,sou:string;
   god,mes,den,den_ned,comm,hh,c,c1,l,f,ot:word;
   kol,st,ch,com,tis,sot,des,edi,ti,so,de,ed,bull,cow,bull1,cow1,b,co:byte;
   chislo,stoit:array[1..4] of byte;
   vc:array[1..3] of byte;
   dc:array[1..2] of byte;
   variant:array[1..6] of boolean;

procedure Zastavka;
begin
PicName:='Bull&Cow.bmp';
xxx:=0; yyy:=0;
InitVideo;
Filter.Init;
Image.Import(PicName,@Filter);
Image.draw(xxx,yyy,NormalPut);
repeat until KeyPressed;
h:=ReadKey;
Image.Done;
Filter.Done;
DoneVideo
end;

procedure cas(yy:integer);
begin
case yy of
150:outtextxy(100,150,'Старт игры');
190:outtextxy(100,190,'Отгадывает ');
230:outtextxy(100,230,'Звук');
270:outtextxy(100,270,'Таблица рекордов');
310:outtextxy(100,310,'Инструкция');
350:outtextxy(100,350,'Выход')
end
end;

procedure Menu;
begin
y:=150;
setbkcolor(0);
ClearDevice;
settextstyle(4,0,8);
setcolor(10);
outtextxy(30,20,'Быки и коровЫ');
settextstyle(7,0,4);
setcolor(14);
outtextxy(100,150,'Старт игры');
outtextxy(100,190,'Отгадывает ');outtextxy(370,190,otgad);
outtextxy(100,230,'Звук');outtextxy(230,230,sou);
outtextxy(100,270,'Таблица рекордов');
outtextxy(100,310,'Инструкция');
outtextxy(100,350,'Выход');
REPEAT
repeat
setcolor(12);
cas(y);
h:=ReadKey;
if h=#0 then if (ReadKey=#80) and (y<>350)
then
 begin
   setcolor(14);
   cas(y);
   y:=y+40;
   if sou='вкл.' then SoundMenu
 end
else
 begin
  if y<>150 then
  begin
   setcolor(14);
   cas(y);
   y:=y-40;
   if sou='вкл.' then SoundMenu
  end
 end
until h=#13;
if y=190 then
 begin
  setcolor(0);
  outtextxy(370,190,otgad);
  if otgad='игрок' then otgad:='компьютер'
                   else otgad:='игрок';
  setcolor(14);
  outtextxy(370,190,otgad);
  if sou='вкл.' then SoundEnter
 end;
if y=230 then
 begin
  setcolor(0);
  outtextxy(230,230,sou);
  if sou='вкл.' then sou:='выкл.'
                 else sou:='вкл.';
  setcolor(14);
  outtextxy(230,230,sou);
  if sou='вкл.' then SoundEnter
 end;
if y=270 then
 begin
  Assign(fil,'records.dat');
  Reset(fil);
  ClearDevice;
  setcolor(10);
  settextstyle(4,0,7);
  outtextxy(20,20,'Таблица рекордов:');
  settextstyle(7,0,1);
  setcolor(13);
  for f:=1 to 10 do
   begin
    readln(fil,s);
    for l:=1 to length(s) do s[l]:=chr(ord(s[l])+key);
    outtextxy(20,80+f*30,s)
   end;
  Close(fil);
  repeat until keypressed;
  ClearDevice;
  settextstyle(4,0,8);
  setcolor(10);
  outtextxy(30,20,'Быки и коровЫ');
  settextstyle(7,0,4);
  setcolor(14);
  outtextxy(100,150,'Старт игры');
  outtextxy(100,190,'Отгадывает ');outtextxy(370,190,otgad);
  outtextxy(100,230,'Звук');outtextxy(230,230,sou);
  outtextxy(100,270,'Таблица рекордов');
  outtextxy(100,310,'Инструкция');
  outtextxy(100,350,'Выход')
 end;
if y=350 then
 begin
  if sou='вкл.' then SoundEnter;
  ClearDevice;
  CloseGraph;
  Halt
 end;
if y=310 then
 begin
  PicName:='B&CInstr.bmp';
  xxx:=0; yyy:=0;
  InitVideo;
  Filter.Init;
  Image.Import(PicName,@Filter);
  Image.draw(xxx,yyy,NormalPut);
  repeat until KeyPressed;
  h:=ReadKey;
  Image.Done;
  Filter.Done;
  DoneVideo;
  Dg:=Detect; InitGraph(Dg,Dm,'');
  if GraphResult <> 0 then begin writeln('инициализация не закончена!');halt end;
  ClearDevice;
  settextstyle(4,0,8);
  setcolor(10);
  outtextxy(30,20,'Быки и коровЫ');
  settextstyle(7,0,4);
  setcolor(14);
  outtextxy(100,150,'Старт игры');
  outtextxy(100,190,'Отгадывает ');outtextxy(370,190,otgad);
  outtextxy(100,230,'Звук');outtextxy(230,230,sou);
  outtextxy(100,270,'Таблица рекордов');
  outtextxy(100,310,'Инструкция');
  outtextxy(100,350,'Выход')
 end;
UNTIL y=150;
end;

procedure nachalo;
begin
repeat
c:=Random(8989)+1011;
tis:=c div 1000;
sot:=(c-1000*tis) div 100;
des:=(c-1000*tis-100*sot) div 10;
edi:=c-1000*tis-100*sot-10*des;
until (tis<>sot) and (tis<>des) and (tis<>edi) and (sot<>des) and (sot<>edi) and (des<>edi);
repeat
c1:=Random(8989)+1011;
ti:=c1 div 1000;
so:=(c1-1000*ti) div 100;
de:=(c1-1000*ti-100*so) div 10;
ed:=c1-1000*ti-100*so-10*de;
until (ti<>so) and (ti<>de) and (ti<>ed) and (so<>de) and (so<>ed) and (de<>ed)
      and (ti<>tis) and (ti<>sot) and (ti<>des) and (ti<>edi) and (so<>tis) and (so<>sot)
      and (so<>des) and (so<>edi) and (de<>tis) and (de<>sot) and (de<>des) and (de<>edi)
      and (ed<>tis) and (ed<>sot) and (ed<>des) and (ed<>edi);
REPEAT
ClearDevice;
SetColor(14);
Settextstyle(7,0,5);
OutTextxy(100,0,'Мой вариант:');
SetColor(10);
str(c,s);
outtextxy(250,70,s);
SetColor(13);
outtextxy(100,140,'Быков:');
repeat
h:=ReadKey;
if sou='вкл.' then SoundKey;
until ((ord(h) >=48) and (ord(h) <=52)) or (h=#27);
if h=#27 then begin ex:=true;exit end;
val(h,bull,err);
str(bull,s);
outtextxy(280,140,s);
Outtextxy(100,210,'Коров:');
repeat
h:=ReadKey;
if sou='вкл.' then SoundKey;
until ((ord(h) >=48) and (ord(h) <=52)) or (h=#27);
if h=#27 then begin ex:=true;exit end;
val(h,cow,err);
str(cow,s);
outtextxy(280,210,s);
Delay(1000);
UNTIL NOT (COW>BULL);
REPEAT
ClearDevice;
SetColor(14);
Settextstyle(7,0,5);
OutTextxy(100,0,'Мой вариант:');
SetColor(10);
str(c1,s);
outtextxy(250,70,s);
SetColor(13);
outtextxy(100,140,'Быков:');
repeat
h:=ReadKey;
if sou='вкл.' then SoundKey;
until ((ord(h) >=48) and (ord(h) <=52)) or (h=#27);
if h=#27 then begin ex:=true;exit end;
val(h,bull1,err);
str(bull1,s);
outtextxy(280,140,s);
Outtextxy(100,210,'Коров:');
repeat
h:=ReadKey;
if sou='вкл.' then SoundKey;
until ((ord(h) >=48) and (ord(h) <=52)) or (h=#27);
if h=#27 then begin ex:=true;exit end;
val(h,cow1,err);
str(cow1,s);
outtextxy(280,210,s);
Delay(1000);
UNTIL NOT (COW1>BULL1)
end;

procedure opros(ccc:word);
begin
ex:=false;
REPEAT
ClearDevice;
SetColor(14);
Settextstyle(7,0,5);
OutTextxy(100,0,'Мой вариант:');
SetColor(10);
str(ccc,s);
outtextxy(250,70,s);
SetColor(13);
outtextxy(100,140,'Быков:');
repeat
h:=ReadKey;
if sou='вкл.' then SoundKey;
until ((ord(h) >=48) and (ord(h) <=52)) or (h=#27);
if h=#27 then begin ex:=true;exit end;
val(h,b,err);
str(b,s);
outtextxy(280,140,s);
Outtextxy(100,210,'Коров:');
repeat
h:=ReadKey;
if sou='вкл.' then SoundKey;
until ((ord(h) >=48) and (ord(h) <=52)) or (h=#27);
if h=#27 then begin ex:=true;exit end;
val(h,co,err);
str(co,s);
outtextxy(280,210,s);
Delay(1000);
UNTIL NOT (CO>B);
end;

procedure Sort34;
begin
for f:=1 to 4 do
 if stoit[4]=chislo[f] then begin hh:=chislo[f];chislo[f]:=chislo[4];chislo[4]:=hh end;
for f:=1 to 4 do
 if stoit[3]=chislo[f] then begin hh:=chislo[f];chislo[f]:=chislo[3];chislo[3]:=hh end;
end;

procedure Sort4;
begin
for f:=1 to 4 do
 if stoit[4]=chislo[f] then begin hh:=chislo[f];chislo[f]:=chislo[4];chislo[4]:=hh end;
end;

procedure Raspol4;
var variant:array[1..6] of boolean;
begin
for f:=1 to 6 do variant[f]:=true;
REPEAT
repeat
hh:=0;
case Random(6)+1 of
1:if (variant[1]=true) and (chislo[1]<>0) then begin hh:=chislo[1]*1000+chislo[2]*100+chislo[3]*10+chislo[4];
  variant[1]:=false end;
2:if (variant[2]=true) and (chislo[2]<>0) then begin hh:=chislo[2]*1000+chislo[1]*100+chislo[3]*10+chislo[4];
  variant[2]:=false end;
3:if (variant[3]=true) and (chislo[2]<>0) then begin hh:=chislo[2]*1000+chislo[3]*100+chislo[1]*10+chislo[4];
  variant[3]:=false end;
4:if (variant[4]=true) and (chislo[3]<>0) then begin hh:=chislo[3]*1000+chislo[2]*100+chislo[1]*10+chislo[4];
  variant[4]:=false end;
5:if (variant[5]=true) and (chislo[3]<>0) then begin hh:=chislo[3]*1000+chislo[1]*100+chislo[2]*10+chislo[4];
  variant[5]:=false end;
6:if (variant[6]=true) and (chislo[1]<>0) then begin hh:=chislo[1]*1000+chislo[3]*100+chislo[2]*10+chislo[4];
  variant[6]:=false end
end;
until hh<>0;
opros(hh);
UNTIL co=4
end;

procedure otvet;
begin
ClearDevice;
SetColor(10);
Settextstyle(7,0,6);
str(hh,s);
outtextxy(30,100,'Твое число '+s);
repeat until KeyPressed;
h:=Readkey
end;

begin
Zastavka;
Dg:=Detect; InitGraph(Dg,Dm,'');
if GraphResult <> 0 then begin writeln('инициализация не закончена!');
   halt end;
Randomize;
sou:='вкл.';
otgad:='игрок';
KillStart:
Menu;

IF otgad='игрок' then
begin
x:=10; y:=40; kol:=0; s:=''; time:=0; timetime:=0;
ClearDevice;
settextstyle(7,0,1);
setcolor(13);
outtextxy(80,20,'Быки Коровы');
outtextxy(400,20,'Быки Коровы');
repeat
c:=Random(8989)+1011;
str(c,comchislo);
tis:=c div 1000;
sot:=(c-1000*tis) div 100;
des:=(c-1000*tis-100*sot) div 10;
edi:=c-1000*tis-100*sot-10*des;
until (tis<>sot) and (tis<>des) and (tis<>edi) and (sot<>des) and (sot<>edi) and (des<>edi);
REPEAT
repeat
repeat
if kol<14 then x:=10
          else x:=330;
setcolor(0); outtextxy(x,y,s);
settextstyle(7,0,1);
setcolor(14);
outtextxy(200,0,' Ваш вариант: ');
setcolor(10);
s:='';
for f:=1 to 4 do
begin
repeat
repeat
timetime:=timetime+1;
if timetime=60 then
 begin
  time:=time+1;
  if time=600000 then
     begin
      ClearDevice;
      setcolor(12);
      settextstyle(7,0,5);
      outtextxy(80,200,'Ваше время вышло!');
      repeat until KeyPressed;
      goto KillStart
     end;
  timetime:=0
 end;
until KeyPressed;
h:=ReadKey;
if h=#27 then goto KillStart;
until (ord(h)>=48) and (ord(h)<=57);
s:=s+h;
if sou='вкл.' then SoundKey;
outtextxy(x,y,h);
x:=x+12
end;
val(s,ot,err);
until (ot >= 1011) and (ot <= 9999);
kol:=kol+1;
ti:=ot div 1000;
so:=(ot-1000*ti) div 100;
de:=(ot-1000*ti-100*so) div 10;
ed:=ot-1000*ti-100*so-10*de;
until (ti<>so) and (ti<>de) and (ti<>ed) and (so<>de) and (so<>ed) and (de<>ed);
bull:=0; cow:=0;
for f:=1 to 4 do
begin
 case f of
   1:ch:=ti;
   2:ch:=so;
   3:ch:=de;
   4:ch:=ed
 end;
 for l:=1 to 4 do
  begin
   case l of
   1:com:=tis;
   2:com:=sot;
   3:com:=des;
   4:com:=edi
   end;
   if ch=com then bull:=bull+1;
   if (f=l) and (ch=com) then cow:=cow+1
  end;
end;
setcolor(14);
str(bull,s);
outtextxy(x+50,y,s);
str(cow,s);
outtextxy(x+130,y,s);
y:=y+30;
if kol<14 then x:=10
          else x:=330;
if kol=14 then y:=40;
if kol=28 then
   begin
    ClearDevice;
    setcolor(12);
    SetTextStyle(7,0,5);
    OutTextXY(50,120,'Вы не угадали число');
    OutTextXY(50,200,'с 28-и попыток!');
    repeat until KeyPressed;
    goto KillStart
   end;
UNTIL cow=4;
ClearDevice;
SetColor(10);
Settextstyle(7,0,5);
outtextxy(50,60,'Вы угадали!');
outtextxy(50,140,'Мое число '+comchislo);
score:=1000000-(kol*10000+time);
setcolor(13);
str(score,s);
outtextxy(50,220,'Вы заработали');
outtextxy(50,300,s+' очков!');
for time:=1 to 6000000 do begin for l:=1 to 40 do begin end end;
Assign(fil,'records.dat');
Reset(fil);
f:=0;
while not EOF(fil) do
 begin
  f:=f+1;
  with igrok[f] do
   BEGIN
    readln(fil,s);
    for l:=1 to length(s) do s[l]:=chr(ord(s[l])+Key);
    if f<>10 then val(copy(s,1,1),nomer,err)
             else val(copy(s,1,2),nomer,err);
    name:=copy(s,4,20);
    val(copy(s,24,6),scor,err);
    vrem:=copy(s,33,length(s)-32);
   END;
 end;
Close(fil);

if score>igrok[10].scor then
begin
ClearDevice;
setcolor(9);
outtextxy(50,80,'Введите ваше имя:');
setcolor(14);
SetTextStyle(1,0,1);
repeat
setcolor(14);
gotoxy(10,10);
write('                                                                  ');
gotoxy(10,10);
readln(s);
until length(s)<17;
igrok[10].scor:=score;
igrok[10].name:=s;
GetDate(god,mes,den,den_ned);
case mes of
1:sss:='Января';
2:sss:='Февраля';
3:sss:='Марта';
4:sss:='Апреля';
5:sss:='Мая';
6:sss:='Июня';
7:sss:='Июля';
8:sss:='Августа';
9:sss:='Сентября';
10:sss:='Октября';
11:sss:='Ноября';
12:sss:='Декабря'
end;
str(den,s);
igrok[10].vrem:='';
igrok[10].vrem:=igrok[10].vrem+s+' '+sss+' ';
str(god,s);
igrok[10].vrem:=igrok[10].vrem+s+' год';
l:=10;
 for f:=9 downto 1 do
  if igrok[l].scor > igrok[f].scor then
   begin
    sc:=igrok[l].scor;
    igrok[l].scor:=igrok[f].scor;
    igrok[f].scor:=sc;
    s:=igrok[l].name;
    igrok[l].name:=igrok[f].name;
    igrok[f].name:=s;
    s:=igrok[l].vrem;
    igrok[l].vrem:=igrok[f].vrem;
    igrok[f].vrem:=s;
    l:=l-1
   end
       else f:=1;
Rewrite(fil);
for f:=1 to 10 do
begin
with igrok[f] do
begin
str(nomer,s);
if f<>10 then s:=s+' ';
for l:=1 to length(s) do s[l]:=chr(ord(s[l])-Key);
write(fil,s,chr(ord('.')-Key));
s:=name;
for l:=1 to length(s) do s[l]:=chr(ord(s[l])-Key);
write(fil,s);
for l:=1 to 20-length(name) do write(fil,chr(ord(' ')-Key));
str(scor,s);
for l:=1 to length(s) do s[l]:=chr(ord(s[l])-Key);
write(fil,s);
str(scor,s);
for l:=1 to 9-length(s) do write(fil,chr(ord(' ')-Key));
for l:=1 to length(vrem) do vrem[l]:=chr(ord(vrem[l])-Key);
writeln(fil,vrem)
end
end;
Close(fil)
end;
goto KillStart
end

ELSE BEGIN
{Угадывает компьютер:}
ClearDevice;
Settextstyle(7,0,6);
SetColor(12);
outtextxy(120,180,'Загадайте ...');
repeat until KeyPressed;
h:=ReadKey;
ClearDevice;
start:
  nachalo;
if ex=true then goto finish;
st:=0; l:=1;

{ 1-й вариант 0:2}

IF ((bull=0) and (bull1=2)) or ((bull1=0) and (bull=2)) then
begin
for f:=0 to 9 do
  if (f<>tis) and (f<>sot) and (f<>des) and (f<>edi) and (f<>ti)
     and (f<>so) and (f<>de) and (f<>ed) then
     begin
      chislo[l]:=f;
      l:=l+1
     end;
if bull=0 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=hh+tis*1000+sot*100+des*10;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
     if co=1 then stoit[4]:=hh;
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4
    end;
  end;
if st=0 then
 for f:=1 to 2 do
  begin
   c:=chislo[f]+tis*1000+sot*100+des*10;
   opros(c);
   if ex=true then goto finish;
   if co=1 then begin stoit[4]:=chislo[f]; f:=2 end;
  end;
Sort4;
Raspol4;
otvet
end;
if bull1=0 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   c:=hh+ti*1000+so*100+de*10;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
     if co=1 then stoit[4]:=hh;
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4
    end;
  end;
if st=0 then
 for f:=1 to 2 do
  begin
   c:=chislo[f]+ti*1000+so*100+de*10;
   opros(c);
   if ex=true then goto finish;
   if co=1 then begin stoit[4]:=chislo[f]; f:=2 end;
  end;
Sort4;
Raspol4;
otvet
end;
end;

{ 2-й вариант 0:3 }

IF ((bull=0) and (bull1=3)) or ((bull1=0) and (bull=3)) then
begin
for f:=0 to 9 do
  if (f<>tis) and (f<>sot) and (f<>des) and (f<>edi) and (f<>ti)
     and (f<>so) and (f<>de) and (f<>ed) then
     begin
      case bull of
      0:c:=f+tis*1000+sot*100+des*10;
      3:c:=f+ti*1000+so*100+de*10
      end;
      opros(c);
      if ex=true then goto finish;
      if b=1 then
      begin
       if co=1 then stoit[4]:=f;
       chislo[l]:=f;
       l:=l+1;
       f:=9
      end;
     end;
if bull=0 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=hh+tis*1000+sot*100+des*10;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
     if co=1 then stoit[4]:=hh;
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4
    end;
  end;
Sort4;
Raspol4;
otvet
end;
if bull1=0 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   c:=hh+ti*1000+so*100+de*10;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
     if co=1 then stoit[4]:=hh;
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4
    end;
  end;
Sort4;
Raspol4;
otvet
end
end;

{ 3-й вариант 0:4}

IF ((bull=0) and (bull1=4)) or ((bull1=0) and (bull=4)) then
begin
if bull=0 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=hh+tis*1000+sot*100+des*10;
   opros(c);
   if ex=true then goto finish;
   if co=1 then begin stoit[4]:=hh;f:=4 end
  end;
for f:=1 to 4 do
begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
 chislo[f]:=hh
end;
Sort4;
Raspol4;
otvet
end;
if bull1=0 then
begin
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   c:=hh+ti*1000+so*100+de*10;
   opros(c);
   if ex=true then goto finish;
   if co=1 then begin stoit[4]:=hh;f:=4 end
  end;
for f:=1 to 4 do
begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
 chislo[f]:=hh
end;
Sort4;
Raspol4;
otvet
end
end;

{ 4-й вариант 1:2} {- нерабочий, нужно подключить!}

{ 5-й вариант 2:2}

IF ((bull=2) and (bull1=2)) or ((bull1=2) and (bull=2)) then
begin
com:=1;
for f:=0 to 9 do
  if (f<>tis) and (f<>sot) and (f<>des) and (f<>edi) and (f<>ti)
     and (f<>so) and (f<>de) and (f<>ed) then
     begin
      dc[com]:=f;
      com:=com+1
     end;
for f:=1 to 6 do variant[f]:=true;
REPEAT
repeat
hh:=0;
case Random(6)+1 of
1:if (variant[1]=true) and (dc[1]<>0) then begin hh:=dc[1]*1000+dc[2]*100+tis*10+sot;variant[1]:=false;c:=tis;c1:=sot end
  else if (variant[1]=true) and (dc[2]<>0) then begin hh:=dc[2]*1000+dc[1]*100+tis*10+sot;variant[1]:=false;c:=tis;c1:=sot end;
2:if (variant[2]=true) and (dc[1]<>0) then begin hh:=dc[1]*1000+dc[2]*100+edi*10+tis;variant[2]:=false;c:=edi;c1:=tis end
  else if (variant[2]=true) and (dc[2]<>0) then begin hh:=dc[2]*1000+dc[1]*100+edi*10+tis;variant[2]:=false;c:=edi;c1:=tis end;
3:if (variant[3]=true) and (dc[1]<>0) then begin hh:=dc[1]*1000+dc[2]*100+sot*10+des;variant[3]:=false;c:=sot;c1:=des end
  else if (variant[3]=true) and (dc[2]<>0) then begin hh:=dc[2]*1000+dc[1]*100+sot*10+des;variant[3]:=false;c:=sot;c1:=des end;
4:if (variant[4]=true) and (dc[1]<>0) then begin hh:=dc[1]*1000+dc[2]*100+edi*10+sot;variant[4]:=false;c:=edi;c1:=sot end
  else if (variant[4]=true) and (dc[2]<>0) then begin hh:=dc[2]*1000+dc[1]*100+edi*10+sot;variant[4]:=false;c:=edi;c1:=sot end;
5:if (variant[5]=true) and (dc[1]<>0) then begin hh:=dc[1]*1000+dc[2]*100+des*10+tis;variant[5]:=false;c:=des;c1:=tis end
  else if (variant[5]=true) and (dc[2]<>0) then begin hh:=dc[2]*1000+dc[1]*100+des*10+tis;variant[5]:=false;c:=des;c1:=tis end;
6:if (variant[6]=true) and (dc[1]<>0) then begin hh:=dc[1]*1000+dc[2]*100+edi*10+des;variant[6]:=false;c:=edi;c1:=des end
  else if (variant[6]=true) and (dc[2]<>0) then begin hh:=dc[2]*1000+dc[1]*100+edi*10+des;variant[6]:=false;c:=edi;c1:=des end
end;
until hh<>0;
opros(hh);
if ex=true then goto finish;
UNTIL b=2;
chislo[1]:=c; chislo[2]:=c1;
if co=2 then begin stoit[4]:=c1;stoit[3]:=c;st:=st+2 end;
l:=3;
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   if (hh<>c) and (hh<>c1) then begin ch:=hh;f:=4 end;
  end;
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   if dc[1]<>0 then c:=hh+dc[1]*1000+dc[2]*100+ch*10
               else c:=hh+dc[2]*1000+dc[1]*100+ch*10;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
    if co=1 then begin stoit[4]:=hh; st:=st+1 end;
    chislo[l]:=hh;
    l:=l+1;
    if l=5 then f:=4
    end;
  end;
if st=2 then
begin
Sort34;
for f:=1 to 2 do
  begin
   case f of
   1:if chislo[3]<>0 then hh:=chislo[3]*1000+chislo[4]*100+stoit[3]*10+stoit[4]
                     else hh:=chislo[4]*1000+chislo[3]*100+stoit[3]*10+stoit[4];
   2:if chislo[4]<>0 then hh:=chislo[4]*1000+chislo[3]*100+stoit[3]*10+stoit[4]
                     else hh:=chislo[3]*1000+chislo[4]*100+stoit[3]*10+stoit[4];
   end;
   opros(hh);
   if ex=true then goto finish;
   if co=4 then begin f:=2;write(' Твое число ',hh) end
  end
end;
if st=0 then
begin
for f:=1 to 4 do
  begin
   if dc[1]<>0 then c:=chislo[f]+dc[1]*1000+dc[2]*100+ch*10
               else c:=chislo[f]+dc[2]*1000+dc[1]*100+ch*10;
   opros(c);
   if ex=true then goto finish;
   if co=1 then begin stoit[4]:=chislo[f];f:=4;st:=st+1 end
  end
end;
if st=1 then
begin
Sort4;
Raspol4;
otvet
end
end;

{ 6-й вариант 1:1}

IF ((bull=1) and (bull1=1)) or ((bull1=1) and (bull=1)) then
begin
for f:=0 to 9 do
  if (f<>tis) and (f<>sot) and (f<>des) and (f<>edi) and (f<>ti)
     and (f<>so) and (f<>de) and (f<>ed) then
     begin
      chislo[l]:=f;
      l:=l+1
     end;
if chislo[1]<>0 then comm:=chislo[1]*1000+chislo[2]*100
                else comm:=chislo[2]*1000+chislo[1]*100;
for f:=1 to 6 do variant[f]:=true;
REPEAT
repeat
hh:=0;
case Random(6)+1 of
1:if variant[1]=true then begin hh:=comm+tis*10+sot;variant[1]:=false end;
2:if variant[2]=true then begin hh:=comm+tis*10+des;variant[2]:=false end;
3:if variant[3]=true then begin hh:=comm+tis*10+edi;variant[3]:=false end;
4:if variant[4]=true then begin hh:=comm+sot*10+des;variant[4]:=false end;
5:if variant[5]=true then begin hh:=comm+sot*10+edi;variant[5]:=false end;
6:if variant[6]=true then begin hh:=comm+des*10+edi;variant[6]:=false end
end;
until hh<>0;
opros(hh);
if ex=true then goto finish;
UNTIL b=2;
if co=2 then
 begin
  if chislo[1]<>0 then begin stoit[1]:=chislo[1]; stoit[2]:=chislo[2] end
                  else begin stoit[1]:=chislo[2]; stoit[2]:=chislo[1] end;
  st:=2
 end;
dc[1]:=hh-(hh div 10)*10;
if dc[1]<>0 then dc[2]:=(hh-(hh div 100)*100-dc[1]) div 10
            else dc[2]:=(hh-(hh div 100)*100) div 10;
f:=0;
REPEAT
repeat
f:=f+1;
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
until (hh<>dc[1]) and (hh<>dc[2]);
c:=comm+dc[1]*10+hh;
opros(c);
if ex=true then goto finish;
UNTIL b=3;
if co=3 then
   begin
   stoit[4]:=hh;
   st:=st+1
   end;
chislo[3]:=hh;
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   if (hh<>chislo[3]) and (hh<>dc[1]) and (hh<>dc[2]) then ch:=hh;
  end;
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=comm+ch*10+hh;
   opros(c);
   if ex=true then goto finish;
   if b=3 then
    begin
     chislo[4]:=hh;
     f:=4;
     if co=3 then
      begin
      stoit[4]:=hh;
      st:=st+1
      end
    end
  end;
if st=0 then
for f:=1 to 4 do
 begin
  if dc[1]<>0 then comm:=dc[1]*1000+dc[2]*100
              else comm:=dc[2]*1000+dc[1]*100;
  c:=comm+ch*10+chislo[f];
  opros(c);
  if ex=true then goto finish;
  if co=1 then
    begin
     stoit[4]:=chislo[f];
     st:=1;
     f:=4
    end
 end;
if st=1 then
begin
Sort4;
Raspol4;
otvet
end;
if st=3 then
for f:=1 to 4 do
 if (chislo[f]<>stoit[1]) and (chislo[f]<>stoit[2]) and (chislo[f]<>stoit[4])
  then begin hh:=stoit[1]*1000+stoit[2]*100+chislo[f]*10+stoit[4];otvet end
end;

{ 7-й вариант 1:3}

IF ((bull=1) and (bull1=3)) or ((bull1=1) and (bull=3)) then
begin
com:=1;
for f:=0 to 9 do
  if (f<>tis) and (f<>sot) and (f<>des) and (f<>edi) and (f<>ti)
     and (f<>so) and (f<>de) and (f<>ed) then
     begin
      vc[com]:=f;
      com:=com+1
     end;
if vc[1]<>0 then comm:=vc[1]*1000+vc[2]*100
            else comm:=vc[2]*1000+vc[1]*100;
if bull=1 then
BEGIN
for f:=1 to 6 do variant[f]:=true;
REPEAT
repeat
hh:=0;
case Random(6)+1 of
1:if variant[1]=true then begin hh:=comm+tis*10+sot;variant[1]:=false end;
2:if variant[2]=true then begin hh:=comm+tis*10+des;variant[2]:=false end;
3:if variant[3]=true then begin hh:=comm+tis*10+edi;variant[3]:=false end;
4:if variant[4]=true then begin hh:=comm+sot*10+des;variant[4]:=false end;
5:if variant[5]=true then begin hh:=comm+sot*10+edi;variant[5]:=false end;
6:if variant[6]=true then begin hh:=comm+des*10+edi;variant[6]:=false end
end;
until hh<>0;
opros(hh);
if ex=true then goto finish;
UNTIL b=0;
dc[1]:=hh-(hh div 10)*10;
if dc[1]<>0 then dc[2]:=(hh-(hh div 100)*100-dc[1]) div 10
            else dc[2]:=(hh-(hh div 100)*100) div 10;
f:=0;
REPEAT
repeat
f:=f+1;
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
until (hh<>dc[1]) and (hh<>dc[2]);
c:=comm+dc[1]*10+hh;
opros(c);
if ex=true then goto finish;
UNTIL b=1;
if co=1 then
   begin
   stoit[4]:=hh;
   st:=st+1
   end;
chislo[l]:=hh; l:=l+1;
for f:=1 to 4 do
  begin
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
   c:=comm+dc[1]*10+hh;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4;
     if co=1 then
      begin
      stoit[4]:=hh;
      st:=st+1
      end
    end
  end
END;
if bull=3 then
BEGIN
for f:=1 to 6 do variant[f]:=true;
REPEAT
repeat
hh:=0;
case Random(6)+1 of
1:if variant[1]=true then begin hh:=comm+ti*10+so;variant[1]:=false end;
2:if variant[2]=true then begin hh:=comm+ti*10+de;variant[2]:=false end;
3:if variant[3]=true then begin hh:=comm+ti*10+ed;variant[3]:=false end;
4:if variant[4]=true then begin hh:=comm+so*10+de;variant[4]:=false end;
5:if variant[5]=true then begin hh:=comm+so*10+ed;variant[5]:=false end;
6:if variant[6]=true then begin hh:=comm+de*10+ed;variant[6]:=false end
end;
until hh<>0;
opros(hh);
if ex=true then goto finish;
UNTIL b=0;
dc[1]:=hh-(hh div 10)*10;
if dc[1]<>0 then dc[2]:=(hh-(hh div 100)*100-dc[1]) div 10
            else dc[2]:=(hh-(hh div 100)*100) div 10;
f:=0;
REPEAT
repeat
f:=f+1;
   case f of
   1:hh:=ti;
   2:hh:=so;
   3:hh:=de;
   4:hh:=ed
   end;
until (hh<>dc[1]) and (hh<>dc[2]);
c:=comm+dc[1]*10+hh;
opros(c);
if ex=true then goto finish;
UNTIL b=1;
if co=1 then
   begin
   stoit[4]:=hh;
   st:=st+1
   end;
chislo[l]:=hh; l:=l+1;
for f:=1 to 4 do
  begin
   case f of
   1:hh:=tis;
   2:hh:=sot;
   3:hh:=des;
   4:hh:=edi
   end;
   c:=comm+dc[1]*10+hh;
   opros(c);
   if ex=true then goto finish;
   if b=1 then
    begin
     chislo[l]:=hh;
     l:=l+1;
     if l=5 then f:=4;
     if co=1 then
      begin
      stoit[4]:=hh;
      st:=st+1
      end
    end
  end
END;
Sort4;
Raspol4;
otvet
end;

IF ((bull=1) and (bull1=2)) or ((bull1=1) and (bull=2)) then goto start;
END;

Finish:
goto KillStart;
SetColor(7);
SetBKColor(0);
ClearDevice;
CloseGraph
end.