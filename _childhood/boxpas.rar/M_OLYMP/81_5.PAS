program M_Olymp81_5;
var
    a:array[1..200] of integer;
    n,nu,max,f:byte;
begin
write('n=');readln(n);
for f:=1 to n do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
max:=0;
nu:=0;
for f:=1 to n do
  if a[f]=0 then
    nu:=nu+1
            else
    begin
      if nu>max then max:=nu;
      nu:=0
    end;
write('Максимальное количество нулей: ',max);
readln
end.