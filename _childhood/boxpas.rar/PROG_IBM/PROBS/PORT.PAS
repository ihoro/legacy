var p:^Word;
begin
p:=ptr(0,$0402);
writeln('���� COM2: ',p^);
write('����ন���: ',Port[p^])
end.