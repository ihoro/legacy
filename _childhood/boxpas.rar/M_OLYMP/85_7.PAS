program M_Olymp85_7;
var
    a:array[1..100,1..100] of integer;
    m,n,f,l,k:byte;
    s:LongInt;
begin
write('m=');readln(m);
write('n=');readln(n);
for l:=1 to m do
  for f:=1 to n do
    begin
      write('a[',l,',',f,']=');
      readln(a[l,f])
    end;
write('k=');readln(k);
l:=0;
s:=0;
repeat
repeat
l:=l+1
until l>k;
for f:=1 to n do
  if (l-f)=k then s:=s+a[l,f]
until l=m;
writeln('‘ã¬¬ : ',s);
readln
end.