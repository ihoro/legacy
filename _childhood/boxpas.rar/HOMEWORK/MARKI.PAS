uses Crt, Dos;
type
    mar = record
           name:string[20];
           country:string[20];
           cena:integer;
           year:word
          end;
var
     marka:array[1..900] of mar;
     f,l:integer;
     m:word;
     c:LongInt;
     inputfile,outputfile:text;
begin
textbackground(0);
textcolor(10);
clrscr;
writeln;
write(' Введите число марок: ');
readln(m);
writeln; textcolor(14);
for f:=1 to m do
 begin
  with marka[f] do
  begin
   write(' Введите название ',f,'-й марки: '); readln(name);
   writeln(' Введите название страны, в которой была сделана эта марка: ');
    readln(country);
   write(' Введите год выпуска марки: '); readln(year);
   write(' Введите цену этой марки: '); readln(cena)
  end
 end;
Assign(inputfile,'marki.dat');
Rewrite(inputfile);
for f:=1 to m do
 begin
  with marka[f] do
  begin
  write(inputfile,name);
   for l:=1 to 20-length(name) do write(inputfile,' ');
  write(inputfile,country);
   for l:=1 to 20-length(country) do write(inputfile,' ');
  write(inputfile,year);
  write(inputfile,' ');
  writeln(inputfile,cena)
  end
 end;
Close(inputfile);
c:=0;
for f:=1 to m do c:=c+marka[f].cena;
Assign(outputfile,'cenamark.dat');
Rewrite(outputfile);
writeln(outputfile,c);
Close(outputfile)
end.