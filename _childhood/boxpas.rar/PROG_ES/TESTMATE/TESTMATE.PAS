uses Crt, Dos;
const
     key = -10;
var
   v,f,l,nomer:word;
   err:integer;
   x,y,yes,pravotv:byte;
   h:char;
   s1,s2,s3,s4,s5,name,famil,otch,class,let,gorod:string;
   fil:text;
   p:boolean;
   nomvop,vop:array[1..10] of byte;

procedure ClearScreen;
begin
textbackground(0);
clrscr
end;

procedure Anketa;
begin
repeat
ClearScreen;
textcolor(14);
gotoxy(20,2); write(' Заполните, пожалуйста, анкету:');
textcolor(10);
gotoxy(5,5); write(' Ваше имя: ');textcolor(13);readln(name);
gotoxy(5,7); write(' Ваша фамилия: ');textcolor(13);readln(famil);
gotoxy(5,9); write(' Ваше отчество: ');textcolor(13);readln(otch);
gotoxy(5,11); write(' Возраст: ');readln(let);
gotoxy(5,13); write(' В каком классе учитесь: ');readln(class);
gotoxy(5,15); write(' Город, в котором живете: ');readln(gorod);
textcolor(13);
gotoxy(7,20); write(' Перезаписаться?(y/n) ');
textcolor(15);
repeat
gotoxy(29,20);
h:=ReadKey; write(h);
until (UpCase(h)='Y') or (UpCase(h)='N');
until UpCase(h)='N'
end;

procedure PrintVopros(n:byte);
begin
Assign(fil,'question.dat');
Reset(fil);
repeat
 readln(fil,s1);
 readln(fil,s2);
 readln(fil,s3);
 readln(fil,s4);
 readln(fil,s5);
if chr(ord(s1[2])+key)<>' ' then val(chr(ord(s1[1])+key)+chr(ord(s1[2])+key),nomer,err)
                           else val(chr(ord(s1[1])+key),nomer,err);
until nomer=n;
Close(fil);
textcolor(13);
gotoxy(30,4); write(v,'-й вопрос:');
for f:=1 to length(s1) do s1[f]:=chr(ord(s1[f])+key);
for f:=1 to length(s2) do s2[f]:=chr(ord(s2[f])+key);
for f:=1 to length(s3) do s3[f]:=chr(ord(s3[f])+key);
for f:=1 to length(s4) do s4[f]:=chr(ord(s4[f])+key);
val(chr(ord(s5[3])+key),pravotv,err);
textcolor(10);
gotoxy(3,8); write(copy(s1,4,length(s1)-3));
textcolor(14); gotoxy(10,12);
write(s2);gotoxy(10,14);write(s3);gotoxy(10,16);write(s4);
textcolor(13); gotoxy(40,16); write(' Данные об тестируемом:');
 gotoxy(56,18); write(famil,name,otch);
 gotoxy(60,19); write(let,' лет');
 gotoxy(56,20); write(' Учится в ',class,' классе');
 gotoxy(56,21); write(' Живет в городе ',gorod)
end;

procedure Vibor;
begin
for f:=1 to 10 do vop[f]:=0;
for f:=1 to 10 do nomvop[f]:=0;
l:=1;
Assign(fil,'question.dat');
Reset(fil);
REPEAT
repeat
if EOF(fil) then Reset(fil);
 readln(fil,s1);
 readln(fil,s2);
 readln(fil,s3);
 readln(fil,s4);
 readln(fil,s5);
if chr(ord(s1[2])+key)<>' ' then val(chr(ord(s1[1])+key)+chr(ord(s1[2])+key),nomer,err)
                           else val(chr(ord(s1[1])+key),nomer,err);
p:=true;
for f:=1 to 10 do if nomer=nomvop[f] then p:=false;
for f:=1 to 10 do if nomer=vop[f] then p:=false;
until (p=true) and (Random(5)=1);
vop[l]:=nomer; l:=l+1;
UNTIL l=11;
Close(fil);
for f:=1 to 10 do nomvop[f]:=vop[f]
end;

procedure SoundKey;
begin
for f:=1 to 10 do
 begin
  Sound(1200+f*130);
  Delay(25-f);
  NoSound
 end
end;

procedure SoundOK;
begin
for f:=1 to 10 do
 begin
  Sound(3200+f*130);
  Delay(25+f);
  NoSound
 end
end;

procedure SoundNO;
begin
for f:=1 to 10 do
 begin
  Sound(150+f*30);
  Delay(25+f);
  NoSound
 end
end;

begin
Randomize;
Anketa;
Vibor;
Yes:=0;
FOR v:=1 to 10 do
BEGIN
y:=12;
ClearScreen;
PrintVopros(vop[v]);
textcolor(9);
gotoxy(10,y); write('Ў');
gotoxy(30,4);
REPEAT
h:=ReadKey;
if h='1' then
   begin
      textcolor(0);
      gotoxy(10,y);
      write('Ў');
      y:=12;
      textcolor(9);
      gotoxy(10,y); write('Ў');
      gotoxy(30,4);
      SoundKey
   end;
if h='2' then
   begin
      textcolor(0);
      gotoxy(10,y);
      write('Ў');
      y:=14;
      textcolor(9);
      gotoxy(10,y); write('Ў');
      gotoxy(30,4);
      SoundKey
   end;
if h='3' then
   begin
      textcolor(0);
      gotoxy(10,y);
      write('Ў');
      y:=16;
      textcolor(9);
      gotoxy(10,y); write('Ў');
      gotoxy(30,4);
      SoundKey
   end;
if h=#0 then
 if (Readkey=#80) and (y<>16) then
   begin
    textcolor(0);
    gotoxy(10,y);
    write('Ў');
    y:=y+2;
    textcolor(9);
    gotoxy(10,y); write('Ў');
    gotoxy(30,4);
    SoundKey
   end
                              else
   begin
    if y<>12 then
     begin
      textcolor(0);
      gotoxy(10,y);
      write('Ў');
      y:=y-2;
      textcolor(9);
      gotoxy(10,y); write('Ў');
      gotoxy(30,4);
      SoundKey
     end
   end;
UNTIL (h=#13) or (h=#27);
case y of
12:x:=1;
14:x:=2;
16:x:=3
end;
if (h=#13) and (pravotv=x) then
 begin
  yes:=yes+1;
  textcolor(12);
  gotoxy(8,20);
  write(' Правильно!');
  SoundOK;
  Delay(500)
 end;
if (h=#13) and (pravotv<>x) then
 begin
  textcolor(12);
  gotoxy(8,20);
  write(' Неправильно!');
  SoundNO;
  Delay(500)
 end;
END;
end.