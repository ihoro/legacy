program M_Olymp83_5;
var m,max,n,d,m1,n1:integer;
begin
write('m=');readln(m);
write('n=');readln(n);
m1:=m;
n1:=n;
max:=m;
if n>m then max:=n;
for d:=max downto 2 do
  if ((m1 mod d)=0) and ((n1 mod d)=0) then
    begin
      m1:=m1 div d;
      n1:=n1 div d
    end;
write(m,'/',n,' = ',m1,'/',n1);
readln
end.