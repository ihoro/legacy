program M_Olymp82_4;
var a:array[1..200] of integer;
    m,f,l,d:byte;
begin
write('m=');readln(m);
for f:=1 to m do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
l:=m;
repeat
for f:=1 to l-1 do
  if a[f]=0 then
    begin
      for d:=f+1 to l do a[d-1]:=a[d];
      a[l]:=0;
      f:=l-1
    end;
l:=l-1
until l=1;
for f:=1 to m do write(a[f],' ');
readln
end.
