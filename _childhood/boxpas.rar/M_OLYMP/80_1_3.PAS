program M_Olymp80_1_3;
var
   a,b:real;
   k:integer;
begin
write('a=');readln(a);
write('k=');readln(k);
b:=1;
repeat
if not odd(k) then
  begin
    k:=k div 2;
    a:=sqr(a)
  end
          else
  begin
    k:=k-1;
    b:=b*a
  end
until k=0;
write('A^k =',b:15:2);
readln
end.