program M_Olymp84_3;
var
    m,c,d,s:LongInt;
begin
write('m=');readln(m);
c:=0;
repeat
c:=c+1;
s:=0;
for d:=1 to c-1 do
  if (c mod d)=0 then s:=s+d;
if s=c then writeln(c)
until c=m;
readln
end.