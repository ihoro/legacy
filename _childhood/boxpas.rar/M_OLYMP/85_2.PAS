program M_Olymp85_2;
var
   A:array[1..100,1..100] of word;
   TekX,TekY,F,L,m,n,OkNo:byte;
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
TekX:=0;
TekY:=1;
repeat
TekX:=TekX+1;
if TekX>n then begin TekX:=1;TekY:=TekY+1 end;
OkNo:=0;
for L:=1 to m do
  for F:=1 to n do
    if A[L,F]=A[TekY,TekX] then begin OkNo:=OkNo+1;F:=n end;
if (OkNo<m) and (TekX=n) and (TekY=m) then
  begin
    write('Такого числа нет!');
    readln;
    halt
  end;
until OkNo>=m;
write('Число ',A[TekY,TekX]);
readln
end.