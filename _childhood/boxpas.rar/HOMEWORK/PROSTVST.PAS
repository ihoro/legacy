var i,k,a,f,l:word;
    e:array[1..1000] of integer;
    c:integer;
begin
 write('Введите число элементов: ');
 readln(a);
 write('Сколько первых элементов уже расставленно?');
 readln(k);
 f:=1;
 write('Введите ',f,'-й элемент:');
 readln(e[f]);
repeat
 f:=f+1;
 repeat
  write('Введите ',f,'-й элемент:');
  readln(e[f]);
 until ((e[f] > e[f-1]) and (f>1)) or (f=1);
until f = k;
 for f:= 1 to k do write(e[f],' ');
 writeln('');
 for f:= k+1 to a do
   begin
    write('Введите ',f,'-й элемент:');
    readln(e[f]);
   end;
 for f:= k+1 to a do
  for i:=1 to f-1 do if e[f] < e[i] then
          begin
           c:=e[f];
           for l:= f-1 downto i do e[l+1]:=e[l];
           e[i]:=c
          end;
 for f:= 1 to a do write(e[f],' ');
 readln
end.