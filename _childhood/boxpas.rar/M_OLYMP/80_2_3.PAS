program M_Olymp80_2_3;
var a,b:array[1..200] of integer;
    f,l,m,k:byte;
    Ok:Boolean;
begin
write('m=');readln(m);
for f:=1 to m do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
k:=0;
for f:=1 to m do
  begin
    Ok:=true;
    for l:=1 to k do
      if a[f]=b[l] then
        begin
          Ok:=false;
          l:=k
        end;
    if Ok then
      begin
        k:=k+1;
        b[k]:=a[f]
      end
  end;
writeln('Количество различных чисел: ',k);
if k<>0 then writeln('Это:');
for f:=1 to k do write(b[f],' ');
readln
end.