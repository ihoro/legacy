program M_Olymp80_3_4_A;
var
    x:array[1..300] of byte;
    n,f,l,e:byte;
begin
write('n=');readln(n);
for f:=1 to n do
  begin
    write('x[',f,']=');
    readln(x[f])
  end;
for l:=1 to n-1 do
  for f:=1 to n-l do
    if x[f]>x[f+1] then
      begin
        e:=x[f];
        x[f]:=x[f+1];
        x[f+1]:=e
      end;
for f:=1 to n do write(x[f],' ');
readln
end.