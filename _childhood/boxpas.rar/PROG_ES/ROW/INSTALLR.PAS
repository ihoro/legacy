{$M 8192,0,0}
uses Dos, Crt;
const symbols:string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_'+#8+#13;
var c,s,k:string;
    f,l:integer;
    OkNo:boolean;
    h:char;
    i,o:text;
procedure doscom(s:string);
begin
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C '+s);
  SwapVectors;
  if DosError <> 0 then
  WriteLn('Could not execute COMMAND.COM')
end;
begin
textbackground(0);clrscr;
for l:=1 to 12 do
begin
case l of
1:begin textcolor(14);c:='************ Инсталляция программы "Regime of Windows" Version 1.0 *************' end;
2:c:='';
3:begin textcolor(10);c:='    Сейчас вы должны будете ввести свой пароль пользователя,                    ' end;
4:c:=' который будет включать работу данной программы.                                ';
5:c:=' Пароль может состоять из английских букв, цифр и символа "_".                  ';
6:c:=' Например, пароль называется "MyPassword_67p", тогда программа:                 ';
7:begin textcolor(12);c:=' uses ROW;                                                                      ' end;
8:c:=' ...                                                                            ';
9:c:=' begin                                                                          ';
10:c:=' MyPassword_67p;                                                                ';
11:c:=' ...                                                                            ';
12:c:=' end.                                                                           ';
end;
for f:=1 to Length(c) do
  begin
    gotoxy(81-f,l+1);
    write(copy(c,1,f));
    Delay(80-f)
  end
end;
textcolor(13);gotoxy(10,15);write('Введите свой пароль: ');
textcolor(11);c:='';
REPEAT
repeat
h:=ReadKey;
OkNo:=false;
for l:=1 to Length(symbols) do if h=symbols[l] then begin OkNo:=true;l:=Length(symbols) end;
until OkNo;
if (h<>#13) and (h<>#8) then
begin
  c:=c+h;
  gotoxy(31,15);write(c);
end;
if (h=#8) and (Length(c)<>0) then
begin
  c:=copy(c,1,Length(c)-1);
  gotoxy(31,15);write(c,' ');
  gotoxy(31,15);write(c)
end;
f:=Length(c);
if h=#13 then f:=25;
UNTIL (f=25) and (h=#13);
writeln;textcolor(10);
write('         Вы уверены?(y/n): ');
repeat h:=ReadKey; until (upcase(h)='Y') or (upcase(h)='N');
write(h);Delay(345);
if upcase(h)='N' then begin clrscr;halt end;
textbackground(0);textcolor(15);clrscr;
getdir(0,s);
doscom('instzip.exe -d -s'+#48+#49+#95+#48+#53+#95+#56+#53+' row.zip');
Assign(i,s+'\ROW\row.pas');
Assign(o,s+'\ROW\row');
Reset(i);Rewrite(o);
for f:=1 to 127 do begin readln(i,k);writeln(o,k) end;
readln(i,k);Delete(k,11,1);Insert(c,k,11);writeln(o,k);
for f:=1 to 33 do begin readln(i,k);writeln(o,k) end;
readln(i,k);Delete(k,11,1);Insert(c,k,11);writeln(o,k);
for f:=1 to 689 do begin readln(i,k);writeln(o,k) end;
readln(i,k);write(o,k);
Close(i);Close(o);
doscom('del '+s+'\ROW\row.pas');
doscom('ren '+s+'\ROW\row row.pas');
doscom('cpas.exe -e'+s+'\ROW '+s+'\ROW\row.pas');
{doscom('del '+s+'\ROW\row.pas');}
doscom('ren '+s+'\ROW\row.tpu row.t');
doscom('cpas.exe -e'+s+'\ROW '+s+'\ROW\rowhelp.pas');
doscom('del '+s+'\ROW\rowhelp.pas');
doscom('del '+s+'\ROW\*.tpu');
doscom('ren '+s+'\ROW\row.t row.tpu');
doscom('del '+s+'\ROW\row.pas');
textcolor(12);
writeln;writeln(' Инсталляция закончена!')
end.
