uses Dos;
var k:text;
    s:array[1..2] of string;
    f:word;
begin
for f:=1 to 2 do
 begin
  writeln('������ ',f,' ��ப�:');
  readln(s[f]);
 end;
Assign(k,'LPT1');
Rewrite(k);
for f:=1 to 2 do Writeln(k,s[f]);
Close(k);
writeln(' ���ଠ�� ��।��� � �ਭ��!')
end.