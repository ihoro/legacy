program M_Olymp88_3;
var
    m,n,d,j:word;
    Yes:Boolean;
begin
write('n=');readln(m);
writeln('Простые делители:');
d:=1;
j:=0;
writeln(d);
Yes:=false;
n:=m;
repeat
d:=d+1;
if (d<>2) and (not odd(d)) then d:=d+1;
while (n mod d)=0 do
  begin
    n:=n div d;
    if d<>j then
      begin
        writeln(d);
        j:=d
      end
  end;
if (n<>m) and (n=1) then Yes:=true;
if (n<>m) and (n>1) then n:=m;
if d>m then Yes:=true
until Yes;
readln
end.