program M_Olymp80_2_2;
var m,f,c:integer;
begin
write('m=');readln(m);
for f:=1 to trunc(sqrt(m))-1 do
  begin
    c:=m-sqr(f);
    if (c=abs(c)) and ( (sqr(trunc(sqrt(c)))+sqr(f))=m ) then
      begin
        writeln('Можно, например: ');
        c:=trunc(sqrt(c));
        writeln(f,'*',f,' + ',c,'*',c,' = ',m);
        readln;
        halt
      end;
  end;
writeln('Нельзя!');
readln
end.