program M_Olymp80_3_1;
var c,s,d,e:word;
begin
write('c=');readln(c);
if (c<3) or (c>27) then
  begin
    writeln('Таких трехзначных чисел нет!');
    halt
  end;
writeln('Возможные варианты:');
for s:=1 to 9 do
  for d:=1 to 9 do
    begin
      e:=c-s-d;
      if (e>=1) and (e<=9) then
        writeln('Число ',s,d,e,'  >>>>  ',s,'+',d,'+',e,'=',c)
    end;
readln
end.