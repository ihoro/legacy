program M_Olymp88_5;
var
   a:array[1..100,1..100] of integer;
   s,c:array[1..100] of Boolean;
   m,n,f,l:byte;
begin
write('m=');readln(m);
write('n=');readln(n);
for l:=1 to m do s[l]:=false;
for f:=1 to n do c[f]:=false;
for l:=1 to m do
  for f:=1 to n do
    begin
      write('a[',l,',',f,']=');
      readln(a[l,f]);
      if a[l,f]=0 then
        begin
          s[l]:=true;
          c[f]:=true
        end
    end;
for l:=1 to m do
  for f:=1 to n do
    if s[l] or c[f] then a[l,f]:=0;
for l:=1 to m do
  for f:=1 to n do
    if f=n then writeln(a[l,f])
           else write(a[l,f],'  ');
readln
end.