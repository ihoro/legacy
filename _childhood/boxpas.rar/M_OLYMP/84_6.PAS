program Calendar_M_Olymp_84_6;
const
     D:array[1..12] of byte = (31,28,31,30,31,30,31,31,30,31,30,31);
type
    typ = 0..1;
var
   f,a,b,c,n:word;
function Vis(god:word):typ;
begin
Vis:=0;
if (god mod 400) = 0 then Vis:=1;
if ((god mod 4) = 0) and ((god mod 100) <> 0) then Vis:=1
end;

begin
writeln;
write('Число: ');readln(a);
write('Месяц: ');readln(b);
write('Год: ');readln(c);
n:=0;
for f:=1 to b-1 do
  begin
    n:=n+D[f];
    if f=2 then n:=n+Vis(c)
  end;
n:=n+a;
writeln(n,'-й день')
end.