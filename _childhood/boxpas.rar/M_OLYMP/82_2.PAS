program M_Olymp82_2;
var
   m,n,b,a:byte;
procedure Print;
begin
writeln(m,'/',n)
end;
begin
m:=0;
n:=1;
b:=1;
Print;
repeat
a:=m*b div n+1;
if (a/b)<1 then
  begin
    m:=a;
    n:=b;
    Print
  end
           else
  b:=b+1
until b=8;
readln
end.