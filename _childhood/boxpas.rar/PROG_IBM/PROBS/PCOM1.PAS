var p:^Word;
begin
p:=ptr(0,$0400);
writeln('Порт COM1: ',p^);
write('Содержимое: ',Port[p^])
end.