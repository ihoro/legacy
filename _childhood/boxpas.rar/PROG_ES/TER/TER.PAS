{$M 8192,0,0}
uses Dos, Crt;
label menu;
var s,Address,NewAddress:string;
    f,l,v:word;
    fil:text;
    err:integer;
    h:char;
    c:array[1..200] of string;
procedure doscom(q:string);
begin
SwapVectors;
Exec(GetEnv('COMSPEC'),'/C '+q);
SwapVectors;
err:=2;
if DosError <> 0 then
 begin
   gotoxy(26,9);
   Write('Не могу исполнить COMMAND.COM!');
   err:=1;
   exit
 end;
end;
procedure Change(A,NewA,n:string);
begin
Assign(fil,n);
Reset(fil);
l:=0;
while not EOF(fil) do
  begin
    l:=l+1;
    readln(fil,c[l]);
    if Length(c[l])>3 then
    for f:=1 to Length(c[l])-3 do
        if copy(c[l],f,4)=A then
          begin
            Delete(c[l],f,4);
            Insert(NewA,c[l],f)
          end
  end;
Close(fil);
Rewrite(fil);
for f:=1 to l do
  if f<>l then writeln(fil,c[f])
          else write(fil,c[f]);
Close(fil)
end;
begin
menu:
textbackground(0);
clrscr;
gotoxy(38,7);
write('Меню:');
gotoxy(28,9);
write('1. Форматирование дискет');
gotoxy(28,11);
write('2. Установка адреса терминала');
gotoxy(34,13);
write('Ваш выбор:[ ]');
gotoxy(45,13);
repeat
h:=readkey;
until (h='1') or (h='2');
write(h);
gotoxy(45,13);
Delay(300);
clrscr;
if h='2' then
begin
Assign(fil,'main.ini');
Reset(fil);
repeat
readln(fil,s);
until EOF(fil);
Address:=copy(s,13,4);
Close(fil);
textcolor(7);
gotoxy(29,7);
write('Адрес терминала: ',Address);
gotoxy(35,9);
write('Esc - Выход');
gotoxy(28,11);
write('Введите новый адрес: ');
f:=1;s:='';
REPEAT
repeat
h:=ReadKey;
until ((ord(h)>=48) and (ord(h)<=57)) or (h=#27) or (h=#8) or (h=#13);
if h=#27 then goto menu;
if h=#8 then if f>1 then
 begin
  f:=f-1;
  s:=copy(s,1,f-1);
  gotoxy(49,11);
  write(s,'    ');
  gotoxy(48+f,11)
 end;
if (h<>#8) and (h<>#13) and (f<5) then
begin
s:=s+h;
f:=f+1;
write(h);
end;
UNTIL (f=5) and (h=#13);
NewAddress:=s;
Change(Address,NewAddress,Address+'.ini');
Change(Address,NewAddress,'main.ini');
doscom('ren '+Address+'.ini '+NewAddress+'.ini');
if err=2 then
begin
gotoxy(32,9);
write('Адрес установлен!')
end;
Delay(1450);
goto menu
end;
if h='1' then
begin
gotoxy(1,7);
doscom('format.com a:');
goto menu
end;
end.