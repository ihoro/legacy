uses Crt, Dos;
label Start,Metka,Mm;
 var
    s:word;
    fil:text;
    h:char;
    y:byte;
    slovo:array[1..10] of string[30];
    ss,namefile:string;
    p,f,l,j:word;
    nas:boolean;
    v:integer;
procedure menu(yy:word);
begin
textbackground(0);
clrscr; textcolor(14);
gotoxy(35,3); write('Азбука Морзе');
textcolor(10); gotoxy(36,8);
write('Меню: ');
  textbackground(0);
             gotoxy(30,9);
             writeln('Набор слов');
             gotoxy(30,10);
             writeln('Бессмысленный текст');
             gotoxy(30,11);
             writeln('Нажатие клавиши');
             gotoxy(30,12);
             writeln('Текстовый файл');
             gotoxy(30,13);
             write('Настройка перед текстом   ');
             if nas=true then write('вкл. ')
                         else write('выкл.');
             gotoxy(30,14);
             writeln('Выход');
              gotoxy(30,y);
             textbackground(12);
             textcolor(14);
             if y=9 then write('Набор слов');
             if y=10 then write('Бессмысленный текст');
             if y=11 then write('Нажатие клавиши');
             if y=12 then write('Текстовый файл');
             if y=13 then write('Настройка перед текстом');
             if y=14 then write('Выход');
textcolor(11);
textbackground(0);
gotoxy(17,22);
write('(C)  OIV  Company Ltd.  March,2000');
gotoxy(17,22);

end;

procedure t;
begin
sound(900);
delay(s);
nosound;
delay(s)
end;

procedure ti;
begin
sound(900);
delay(s*3);
nosound;
delay(s)
end;

procedure beep(symbol:char);
begin
case symbol of
'а','А','a','A':begin t;ti end;
'б','Б','b','B':begin ti;t;t;t end;
'в','В','w','W':begin t;ti;ti end;
'г','Г','g','G':begin ti;ti;t end;
'д','Д','d','D':begin ti;t;t end;
'е','Е','e','E','ё','Ё':t;
'ж','Ж','v','V':begin t;t;t;ti end;
'з','З','z','Z':begin ti;ti;t;t end;
'и','И','i','I':begin t;t end;
'й','Й','j','J':begin t;ti;ti;ti end;
'к','К','k','K':begin ti;t;ti end;
'л','Л','l','L':begin t;ti;t;t end;
'м','М','m','M':begin ti;ti end;
'н','Н','n','N':begin ti;t end;
'о','О','o','O':begin ti;ti;ti end;
'п','П','p','P':begin t;ti;ti;t end;
'р','Р','r','R':begin t;ti;t end;
'с','С','s','S':begin t;t;t end;
'т','Т','t','T':ti;
'у','У','u','U':begin t;t;ti end;
'ф','Ф','f','F':begin t;t;ti;t end;
'х','Х','h','H':begin t;t;t;t end;
'ц','Ц','c','C':begin ti;t;ti;t end;
'ч','Ч':begin ti;ti;ti;t end;
'ш','Ш':begin ti;ti;ti;ti end;
'щ','Щ','q','Q':begin ti;ti;t;ti end;
'ь','Ь','ъ','Ъ','x','X':begin ti;t;t;ti end;
'ы','Ы','y','Y':begin ti;t;ti;ti end;
'э','Э':begin t;t;ti;t;t end;
'ю','Ю':begin t;t;ti;ti end;
'я','Я':begin t;ti;t;ti end;
'1':begin t;ti;ti;ti;ti end;
'2':begin t;t;ti;ti;ti end;
'3':begin t;t;t;ti;ti end;
'4':begin t;t;t;t;ti end;
'5':begin t;t;t;t;t end;
'6':begin ti;t;t;t;t end;
'7':begin ti;ti;t;t;t end;
'8':begin ti;ti;ti;t;t end;
'9':begin ti;ti;ti;ti;t end;
'0':begin ti;ti;ti;ti;ti end;
'.':begin t;t;delay(s);t;t;delay(s);t;t end;
',':begin t;ti;t;ti;t;ti end;
'?':begin t;t;ti;ti;t;t end;
'!':begin ti;ti;t;t;ti;ti end;
'=':begin ti;t;t;t;ti end;
' ':delay(s*7)
end
end;

function sy:char;
begin
case Random(41)+1 of
1:sy:='а';
2:sy:='б';
3:sy:='в';
4:sy:='г';
5:sy:='д';
6:sy:='е';
7:sy:='ж';
8:sy:='з';
9:sy:='и';
10:sy:='й';
11:sy:='к';
12:sy:='л';
13:sy:='м';
14:sy:='н';
15:sy:='о';
16:sy:='п';
17:sy:='р';
18:sy:='с';
19:sy:='т';
20:sy:='у';
21:sy:='ф';
22:sy:='х';
23:sy:='ц';
24:sy:='ч';
25:sy:='ш';
26:sy:='щ';
27:sy:='ь';
28:sy:='ы';
29:sy:='э';
30:sy:='ю';
31:sy:='я';
32:sy:='1';
33:sy:='2';
34:sy:='3';
35:sy:='4';
36:sy:='5';
37:sy:='6';
38:sy:='7';
39:sy:='8';
40:sy:='9';
41:sy:='0';
 end;
end;

begin
nas:=false;
y:=9;
Randomize;
Start:
menu(y);
REPEAT
repeat
until keypressed;
h:=readkey;
if h=#0 then if (readkey=#80) and (y<>14) then
            begin
             textbackground(0);
             textcolor(10);
             gotoxy(30,9);
             writeln('Набор слов');
             gotoxy(30,10);
             writeln('Бессмысленный текст');
             gotoxy(30,11);
             writeln('Нажатие клавиши');
             gotoxy(30,12);
             writeln('Текстовый файл');
             gotoxy(30,13);
             writeln('Настройка перед текстом');
             gotoxy(30,14);
             writeln('Выход');
             y:=y+1;
             gotoxy(30,y);
             textbackground(12);
             textcolor(14);
             if y=9 then write('Набор слов');
             if y=10 then write('Бессмысленный текст');
             if y=11 then write('Нажатие клавиши');
             if y=12 then write('Текстовый файл');
             if y=13 then write('Настройка перед текстом');
             if y=14 then write('Выход')
            end
        else if y<>9 then
            begin
             textbackground(0);
             textcolor(10);
             gotoxy(30,9);
             writeln('Набор слов');
             gotoxy(30,10);
             writeln('Бессмысленный текст');
             gotoxy(30,11);
             writeln('Нажатие клавиши');
             gotoxy(30,12);
             writeln('Текстовый файл');
             gotoxy(30,13);
             writeln('Настройка перед текстом');
             gotoxy(30,14);
             writeln('Выход');
             y:=y-1;
             gotoxy(30,y);
             textbackground(12);
             textcolor(14);
             if y=9 then write('Набор слов');
             if y=10 then write('Бессмысленный текст');
             if y=11 then write('Нажатие клавиши');
             if y=12 then write('Текстовый файл');
             if y=13 then write('Настройка перед текстом');
             if y=14 then write('Выход')
            end;
gotoxy(17,22);
if h=#13 then
BEGIN
IF y=9 then
REPEAT
textbackground(0);
clrscr;
repeat
textcolor(10);
write(' Введите скорость(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
for f:=1 to 10 do slovo[f]:='';
Assign(fil,'morze.slv');
Reset(fil);
for f:=1 to 10 do
while slovo[f]='' do
  begin
   readln(fil,ss);
   p:=0;
   for l:=1 to f-1 do
         if slovo[l]=ss then p:=p+1;
   if (Random(6)=1) and (p=0) then slovo[f]:=ss;
   if EOF(fil) then Reset(fil)
  end;
close(fil);
textcolor(14);
if nas=true then begin
beep('ж');delay(s*3);beep('ж');delay(s*3);beep('ж');delay(s*3);
beep('=');delay(s*7) end;
for f:=1 to 10 do
   begin
    for l:=1 to length(slovo[f]) do begin gotoxy(1+l,f+1);write(slovo[f][l]);beep(slovo[f][l]);delay(s*3)  end;
    delay(s*4);
   end;
if nas=true then beep('=');
writeln;
textcolor(13);
write('Еще раз?(y/n) ');
textcolor(9);
readln(ss);
UNTIL upcase(ss[1])='N';

IF y=10 THEN
REPEAT
textbackground(0);
clrscr;
repeat
textcolor(10);
write(' Введите скорость(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
textcolor(14);
if nas=true then begin
beep('ж');delay(s*3);beep('ж');delay(s*3);beep('ж');delay(s*3);
beep('=');delay(s*7) end;
for f:=1 to 10 do
 for l:=1 to 5 do
  begin
   for j:=1 to 5 do
    begin
     gotoxy(l*6-1+j,f+1);
     h:=sy;
     write(h);
     beep(h);delay(s*3);
     if KeyPressed then
       begin
        h:=ReadKey;
        if h=#27 then goto Start
       end;
    end;
   delay(s*7)
  end;
if nas=true then beep('=');
writeln;
textcolor(13);
write('Еще раз?(y/n) ');
textcolor(9);
readln(ss);
UNTIL upcase(ss[1])='N';

IF y=11 THEN
begin
textbackground(0);
clrscr;
repeat
textcolor(10);
write(' Введите скорость(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
REPEAT
textcolor(13);
clrscr; writeln('  Esc - выход');
Repeat
Until keypressed;
h:=readkey;
beep(h);
UNTIL h=#27
end;

IF y=12 THEN
REPEAT
metka:
textbackground(0);
clrscr;
textcolor(13);
write(' Введите имя файла: ');
textcolor(9);
readln(namefile);
repeat
textcolor(10);
write(' Введите скорость(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
Assign(fil,namefile);
Reset(fil);
if nas=true then begin
beep('ж');delay(s*3);beep('ж');delay(s*3);beep('ж');delay(s*3);
beep('=');delay(s*7) end;
while not EOF(fil) do
 begin
  readln(fil,ss);
  for f:=1 to length(ss) do begin beep(ss[f]);delay(s*3) end
 end;
if nas=true then beep('=');
writeln;
textcolor(13);
write('Еще раз?(y/n) ');
textcolor(9);
readln(ss);
UNTIL UPCASE(SS[1])='N';

IF y=13 THEN
begin
 if nas=true then nas:=false
             else nas:=true
end;

if y=14 then goto mm;
menu(y)
END;
UNTIL y=3;
mm:
textbackground(0);
clrscr;
textcolor(13);
writeln('Не забывайте азбуку Морзе!')
end.