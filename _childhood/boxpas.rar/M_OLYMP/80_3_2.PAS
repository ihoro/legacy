program M_Olymp80_3_2;
var a:array[0..200] of byte;
    n,f:byte;
    Yes:boolean;
begin
writeln('Число M:');
write('n=');readln(n);
for f:=0 to n-1 do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
writeln('Число M+1:');
Yes:=true;
for f:=0 to n-1 do
  begin
    if not Yes then writeln('a[',f,']=',a[f]);
    if (a[f]=0) and Yes then
      begin
        writeln('a[',f,']=1');
        Yes:=false
      end;
    if (a[f]=1) and (f=n-1) and Yes then
      begin
        writeln('a[',f,']=0');
        writeln('a[',f+1,']=1');
        Yes:=false
      end;
    if (a[f]=1) and Yes then writeln('a[',f,']=0');
  end;
readln
end.