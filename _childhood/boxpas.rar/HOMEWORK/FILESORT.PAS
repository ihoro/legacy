var a,f,l:word;
    e:array[1..1000] of integer;
    c:integer;
    fil:text;
begin
 write('Введите число элементов: ');
 readln(a);
 for f:=1 to a do
  begin
   write('Введите ',f,'-й элемент:');
   readln(e[f])
  end;
 for f:= 1 to a do write(e[f],' ');
 writeln('');
 Assign(fil,'nosort.dat');
 rewrite(fil);
  for f:=1 to a do writeln(fil,e[f]);
 close(fil);
for l:= 1 to a-1 do
 for f:=1 to a-l do
  if e[f] > e[f+1] then
   begin
    c:=e[f];
    e[f]:=e[f+1];
    e[f+1]:=c
   end;
 for f:= 1 to a do write(e[f],' ');
 Assign(fil,'sorted.dat');
 rewrite(fil);
  for f:=1 to a do writeln(fil,e[f]);
 close(fil);
 readln
end.