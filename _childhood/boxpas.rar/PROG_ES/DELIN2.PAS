uses Dos, Crt;
 var
     file1,file2 :text;
     s,namefile  :string;
     f:word;
begin
textcolor(10);
textbackground(0);
clrscr;
write('Имя файла: ');
readln(namefile);
 Assign(file1,namefile);
 Assign(file2,'output.dat');
 Reset(file1);
 Rewrite(file2);
while not EOF(file1) do
 begin
  readln(file1,s);
  for f:=1 to length(s) do if ((ord(s[f]) >=65) and (ord(s[f]) <=90)) OR
  ((ord(s[f]) >=97) and (ord(s[f]) <=122)) OR
   ((ord(s[f]) >=48 ) and (ord(s[f]) <=57) ) then begin sound(100);delay(1);nosound end
                                             else Delete(s,f,1);
  writeln(file2,s)
 end;
textcolor(13);
write('Готово! Загляни в файл output.dat')
end.