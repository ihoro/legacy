type s=string[8];
var p:^s;
begin
p:=ptr($f000,$fff5);
writeln(p^);
readln
end.