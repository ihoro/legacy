program M_Olymp84_5;
var a,b:array[1..100] of integer;
    c:array[1..200] of integer;
    m,n,d,f,l:byte;
begin
write('m=');readln(m);
write('n=');readln(n);
for f:=1 to m do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
for f:=1 to n do
  begin
    write('b[',f,']=');
    readln(b[f])
  end;
for f:=1 to m do c[f]:=a[f];
for f:=m+1 to m+n do c[f]:=b[f-m];
for l:=1 to m+n-1 do
  for f:=1 to m+n-l do
    if c[f]>c[f+1] then
      begin
        d:=c[f];
        c[f]:=c[f+1];
        c[f+1]:=d
      end;
writeln('Слитый массив:');
for f:=1 to m+n do write(c[f],' ');
readln
end.