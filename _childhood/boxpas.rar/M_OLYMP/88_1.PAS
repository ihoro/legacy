program M_Olymp88_1;
var
   A,B:array[1..100] of word;
   f,l:integer;
   n:byte;
begin
writeln;
write('n = ');readln(n);
for f:=1 to n do
  begin
    write('A[',f,'] = ');
    readln(A[f])
  end;
B[n]:=0;
for f:=n-1 downto 1 do
  for l:=f+1 to n do
    if A[f]<A[l] then
      begin
        B[f]:=A[l];
        l:=n
      end;
for f:=1 to n do
   if f<>n then write(B[f],', ')
           else writeln(B[f])
end.