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
gotoxy(35,3); write('���㪠 ��৥');
textcolor(10); gotoxy(36,8);
write('����: ');
  textbackground(0);
             gotoxy(30,9);
             writeln('����� ᫮�');
             gotoxy(30,10);
             writeln('�����᫥��� ⥪��');
             gotoxy(30,11);
             writeln('����⨥ ������');
             gotoxy(30,12);
             writeln('����⮢� 䠩�');
             gotoxy(30,13);
             write('����ன�� ��। ⥪�⮬   ');
             if nas=true then write('���. ')
                         else write('�몫.');
             gotoxy(30,14);
             writeln('��室');
              gotoxy(30,y);
             textbackground(12);
             textcolor(14);
             if y=9 then write('����� ᫮�');
             if y=10 then write('�����᫥��� ⥪��');
             if y=11 then write('����⨥ ������');
             if y=12 then write('����⮢� 䠩�');
             if y=13 then write('����ன�� ��। ⥪�⮬');
             if y=14 then write('��室');
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
'�','�','a','A':begin t;ti end;
'�','�','b','B':begin ti;t;t;t end;
'�','�','w','W':begin t;ti;ti end;
'�','�','g','G':begin ti;ti;t end;
'�','�','d','D':begin ti;t;t end;
'�','�','e','E','�','�':t;
'�','�','v','V':begin t;t;t;ti end;
'�','�','z','Z':begin ti;ti;t;t end;
'�','�','i','I':begin t;t end;
'�','�','j','J':begin t;ti;ti;ti end;
'�','�','k','K':begin ti;t;ti end;
'�','�','l','L':begin t;ti;t;t end;
'�','�','m','M':begin ti;ti end;
'�','�','n','N':begin ti;t end;
'�','�','o','O':begin ti;ti;ti end;
'�','�','p','P':begin t;ti;ti;t end;
'�','�','r','R':begin t;ti;t end;
'�','�','s','S':begin t;t;t end;
'�','�','t','T':ti;
'�','�','u','U':begin t;t;ti end;
'�','�','f','F':begin t;t;ti;t end;
'�','�','h','H':begin t;t;t;t end;
'�','�','c','C':begin ti;t;ti;t end;
'�','�':begin ti;ti;ti;t end;
'�','�':begin ti;ti;ti;ti end;
'�','�','q','Q':begin ti;ti;t;ti end;
'�','�','�','�','x','X':begin ti;t;t;ti end;
'�','�','y','Y':begin ti;t;ti;ti end;
'�','�':begin t;t;ti;t;t end;
'�','�':begin t;t;ti;ti end;
'�','�':begin t;ti;t;ti end;
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
1:sy:='�';
2:sy:='�';
3:sy:='�';
4:sy:='�';
5:sy:='�';
6:sy:='�';
7:sy:='�';
8:sy:='�';
9:sy:='�';
10:sy:='�';
11:sy:='�';
12:sy:='�';
13:sy:='�';
14:sy:='�';
15:sy:='�';
16:sy:='�';
17:sy:='�';
18:sy:='�';
19:sy:='�';
20:sy:='�';
21:sy:='�';
22:sy:='�';
23:sy:='�';
24:sy:='�';
25:sy:='�';
26:sy:='�';
27:sy:='�';
28:sy:='�';
29:sy:='�';
30:sy:='�';
31:sy:='�';
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
             writeln('����� ᫮�');
             gotoxy(30,10);
             writeln('�����᫥��� ⥪��');
             gotoxy(30,11);
             writeln('����⨥ ������');
             gotoxy(30,12);
             writeln('����⮢� 䠩�');
             gotoxy(30,13);
             writeln('����ன�� ��। ⥪�⮬');
             gotoxy(30,14);
             writeln('��室');
             y:=y+1;
             gotoxy(30,y);
             textbackground(12);
             textcolor(14);
             if y=9 then write('����� ᫮�');
             if y=10 then write('�����᫥��� ⥪��');
             if y=11 then write('����⨥ ������');
             if y=12 then write('����⮢� 䠩�');
             if y=13 then write('����ன�� ��। ⥪�⮬');
             if y=14 then write('��室')
            end
        else if y<>9 then
            begin
             textbackground(0);
             textcolor(10);
             gotoxy(30,9);
             writeln('����� ᫮�');
             gotoxy(30,10);
             writeln('�����᫥��� ⥪��');
             gotoxy(30,11);
             writeln('����⨥ ������');
             gotoxy(30,12);
             writeln('����⮢� 䠩�');
             gotoxy(30,13);
             writeln('����ன�� ��। ⥪�⮬');
             gotoxy(30,14);
             writeln('��室');
             y:=y-1;
             gotoxy(30,y);
             textbackground(12);
             textcolor(14);
             if y=9 then write('����� ᫮�');
             if y=10 then write('�����᫥��� ⥪��');
             if y=11 then write('����⨥ ������');
             if y=12 then write('����⮢� 䠩�');
             if y=13 then write('����ன�� ��। ⥪�⮬');
             if y=14 then write('��室')
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
write(' ������ ᪮����(5-1000): ');
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
beep('�');delay(s*3);beep('�');delay(s*3);beep('�');delay(s*3);
beep('=');delay(s*7) end;
for f:=1 to 10 do
   begin
    for l:=1 to length(slovo[f]) do begin gotoxy(1+l,f+1);write(slovo[f][l]);beep(slovo[f][l]);delay(s*3)  end;
    delay(s*4);
   end;
if nas=true then beep('=');
writeln;
textcolor(13);
write('�� ࠧ?(y/n) ');
textcolor(9);
readln(ss);
UNTIL upcase(ss[1])='N';

IF y=10 THEN
REPEAT
textbackground(0);
clrscr;
repeat
textcolor(10);
write(' ������ ᪮����(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
textcolor(14);
if nas=true then begin
beep('�');delay(s*3);beep('�');delay(s*3);beep('�');delay(s*3);
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
write('�� ࠧ?(y/n) ');
textcolor(9);
readln(ss);
UNTIL upcase(ss[1])='N';

IF y=11 THEN
begin
textbackground(0);
clrscr;
repeat
textcolor(10);
write(' ������ ᪮����(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
REPEAT
textcolor(13);
clrscr; writeln('  Esc - ��室');
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
write(' ������ ��� 䠩��: ');
textcolor(9);
readln(namefile);
repeat
textcolor(10);
write(' ������ ᪮����(5-1000): ');
textcolor(12);
readln(s);
until (s>=5) and (s<=1000);
Assign(fil,namefile);
Reset(fil);
if nas=true then begin
beep('�');delay(s*3);beep('�');delay(s*3);beep('�');delay(s*3);
beep('=');delay(s*7) end;
while not EOF(fil) do
 begin
  readln(fil,ss);
  for f:=1 to length(ss) do begin beep(ss[f]);delay(s*3) end
 end;
if nas=true then beep('=');
writeln;
textcolor(13);
write('�� ࠧ?(y/n) ');
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
writeln('�� ���뢠�� ����� ��৥!')
end.