uses Dos;
var
   e:array[1..5,1..5] of integer;
   fil:text;
   f,l,p:word;
begin
for f:=1 to 5 do
 for l:=1 to 5 do
  begin
   write(' Введите ',f,',',l,'-й элемент: ');
   readln(e[f,l])
  end;
Assign(fil,'array.dat');
Rewrite(fil);
for f:=1 to 5 do
 for l:=1 to 5 do
  begin
   if l=5 then writeln(fil,e[f,l])
          else write(fil,e[f,l],'  ');
  end;
p:=0;
for f:=1 to 5 do
 for l:=1 to 5 do if e[f,l] >=0 then p:=p+1;
writeln(fil,' Положительных элементов ',p);
Close(fil)
end.