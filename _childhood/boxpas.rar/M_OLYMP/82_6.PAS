program M_Olymp82_6;
var
   X:array[1..100] of word;
   Y:array[1..100] of word;
   d,f,l,n,k:byte;
   OkNo:Boolean;
begin
writeln;
write('n = ');readln(n);
write('k = ');readln(k);
writeln;
for f:=1 to n do
  begin
    write('X[',f,'] = ');
    readln(X[f])
  end;
writeln;
for f:=1 to k do
  begin
    write('Y[',f,'] = ');
    readln(Y[f])
  end;
OkNo:=false;
for f:=1 to n-k+1 do
  begin
    d:=0;
    for l:=1 to k do
      if X[f+l-1] = Y[l] then d:=d+1;
    if d=k then
      begin
        OkNo:=true;
        f:=n-k+1
      end;
  end;
if OkNo then writeln('Да!')
        else writeln('Нет!')
end.