program M_Olymp86_4;
var
   A:array[1..100,1..100] of integer;
   m,n,f,l,c:byte;
begin
writeln;
write('m = ');readln(m);
write('n = ');readln(n);
for l:=1 to m do
  for f:=1 to n do
    begin
      write('A[',l,',',f,'] = ');
      readln(A[l,f])
    end;
write('c = ');readln(c);
l:=1;f:=n;
repeat
if A[l,f]<c then
  begin
    l:=l+1;
    if not (l<=m) then
      begin
        write('Такого числа нет!');
        readln;
        halt
      end
  end;
if A[l,f]>c then
  begin
    f:=f-1;
    if not (f>=1) then
      begin
        write('Такого числа нет!');
        readln;
        halt
      end
  end
until A[l,f]=c;
write('x = ',f);
write(' y = ',l);
readln
end.