program M_Olymp84_1;
var
   P,T:array[1..100] of byte;
   f,i,d,n:byte;
begin
writeln;
write('n = ');readln(n);
for f:=1 to n do
  begin
    write('T[',f,'] = ');
    readln(T[f]);
  end;
for f:=1 to n do P[f]:=0;
for i:=1 to n do
  begin
    d:=0;
    for f:=1 to n do
      begin
        if P[f]=0 then d:=d+1;
        if d = (T[i]+1) then
          begin
            P[f]:=i;
            f:=n
          end;
      end;
  end;
writeln;
writeln('Перестановка:');
for f:=1 to n do write(P[f],' ');
readln
end.