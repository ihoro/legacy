program Poker_M_Olymp86_2;
var
   P:array[1..5] of integer;
   s,f,l:integer;
begin
for f:=1 to 5 do
  begin
    write('P[',f,'] = ');
    readln(P[f])
  end;
s:=0;
for f:=1 to 5 do
  for l:=f+1 to 5 do
    if P[l]=P[f] then s:=s+1;
case s of
10:writeln('1');
6:writeln('2');
4:writeln('3');
3:writeln('4');
2:writeln('5');
1:writeln('6');
0:writeln('7')
end
end.