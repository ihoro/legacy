var p:^Word;
begin
p:=ptr(0,$0400);
writeln('���� COM1: ',p^);
write('����ন���: ',Port[p^])
end.