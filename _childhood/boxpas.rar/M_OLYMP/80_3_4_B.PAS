program M_Olymp80_3_4_B;
var
    x:array[1..300] of byte;
    n,f,nu,e,d:byte;
begin
write('n=');readln(n);
for f:=1 to n do
  begin
    write('x[',f,']=');
    readln(x[f])
  end;
nu:=0;
e:=0;
d:=0;
for f:=1 to n do
  begin
    if x[f]=0 then nu:=nu+1;
    if x[f]=1 then e:=e+1;
    if x[f]=2 then d:=d+1
  end;
for f:=1 to nu do write('0 ');
for f:=1 to e do write('1 ');
for f:=1 to d do write('2 ');
readln
end.