program M_Olymp87_4;
var
    a:array[1..200] of integer;
    n,f,d,l,k:byte;
begin
write('n=');readln(n);
for f:=1 to n do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
for l:=n downto 2 do
  for f:=1 to n-l+1 do
    begin
      k:=0;
      for d:=1 to l div 2 do
        if a[f+d-1]=a[f+l-d] then k:=k+1;
      if k=l div 2 then
        begin
          write('Длина отрезка: ',l);
          readln;
          halt
        end;
    end;
write('Длина отрезка: ',0);
readln
end.
