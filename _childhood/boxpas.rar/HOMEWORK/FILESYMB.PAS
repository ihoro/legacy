uses Crt, Dos;
var
   namefile:string;
   fil:text;
   f,l:word;
   s:array[1..250] of string;
   symbol,znak:char;
begin
textbackground(0);
textcolor(10);
clrscr;
writeln;write(' Введите имя файла: ');
textcolor(9);
readln(namefile);
writeln;
textcolor(14);
write(' Какой символ изменить? '); readln(symbol);
write(' Каким символом заменить? '); readln(znak);
Assign(fil,namefile);
Reset(fil);
l:=0;
while not EOF(fil) do
 begin
  l:=l+1;
  readln(fil,s[l]);
  for f:=1 to length(s[l]) do if s[l][f]=symbol then
       begin
        Delete(s[l],f,1);
        Insert(znak,s[l],f)
       end
 end;
Close(fil);
Rewrite(fil);
for f:=1 to l do writeln(fil,s[f]);
Close(fil);
textcolor(13);
writeln; write(' Готово!')
end.