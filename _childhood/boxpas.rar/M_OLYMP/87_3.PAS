program M_Olymp87_3; {Сумма кубов}
var
    c:array[1..9000] of word;
    n,f,a,b,k:word;
    Ok:Boolean;
begin
write('n=');readln(n);
a:=0;
k:=0;
repeat
repeat
a:=a+1;
Ok:=true;
for f:=1 to k do
  if a=c[f] then
    begin
      Ok:=false;
      f:=k
    end;
until Ok;
for b:=1 to trunc(sqrt(n))-1 do
  begin
    if (b*b*b) > (n-a*a*a) then b:=trunc(sqrt(n))-1;
    if (b*b*b+a*a*a)=n then
      begin
        k:=k+1;
        c[k]:=b;
        writeln(a,'^3 + ',b,'^3 = ',n)
      end;
  end
until a>=(trunc(sqrt(n))-1);
if k=0 then writeln('0 способов!');
readln
end.