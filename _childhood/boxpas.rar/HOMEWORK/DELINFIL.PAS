uses Dos, Crt;
 const
       symbols:string = '~''&@^{}\<>|[]`#+*()-/":,._?%!;=$ ';
 var
     file1,file2 :text;
     s,namefile  :string;
     f,ff:word;
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
  writeln(file2,'Оригинал: ',namefile);
Randomize;
while not EOF(file1) do
 begin
  readln(file1,s);
  for f:=1 to length(s) do
   begin sound(100+random(100));delay(1);nosound;
      for ff:=1 to length(symbols) do if s[f]=symbols[ff] then begin delete(s,f,1);ff:=length(symbols) end
   end;
  writeln(file2,s)
 end;
  close(file1);
  close(file2);
textcolor(13);
write('Готово! Загляни в файл output.dat')
end.