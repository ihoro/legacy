program M_Olymp87_5;
var
    a:array[1..200] of integer;
    i:array[1..200] of integer;
    n,f,l:byte;
    e:integer;
begin
write('n=');readln(n);
for f:=1 to n do
  begin
    write('a[',f,']=');
    readln(a[f]);
    i[f]:=f
  end;
for l:=1 to n-1 do
  for f:=1 to n-l do
    if a[f]>a[f+1] then
      begin
        e:=a[f];
        a[f]:=a[f+1];
        a[f+1]:=e;
        e:=i[f];
        i[f]:=i[f+1];
        i[f+1]:=e
      end;
for f:=1 to n do write(i[f],'  ');
readln
end.