var p:^Word;
begin
p:=ptr(0,$0402);
writeln('Порт COM2: ',p^);
write('Содержимое: ',Port[p^])
end.