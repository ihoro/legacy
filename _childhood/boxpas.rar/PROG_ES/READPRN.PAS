uses Dos;
var k:text;
    s:array[1..2] of string;
    f:word;
begin
writeln(' Информация считывается из принтера!');
Assign(k,'LPT1');
Reset(k);
for f:=1 to 2 do readln(k,s[f]);
Close(k);
writeln('Информация:');
for f:=1 to 2 do Writeln(s[f])
end.