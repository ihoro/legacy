program M_Olymp80_3_3;
var x:array[1..100,1..100] of integer;
    m,n,f,l,s:byte;
    min,max:integer;
    Yes:Boolean;
begin
write('m=');readln(m);
write('n=');readln(n);
for l:=1 to m do
  for f:=1 to n do
    begin
      write('x[',l,',',f,']=');
      readln(x[l,f])
    end;
Yes:=false;
s:=0;
for l:=1 to m do
  begin
    min:=x[l,1];
    for f:=2 to n do
      if x[l,f]<min then min:=x[l,f];
    if not Yes then begin max:=min;s:=l end;
    if Yes and (min>max) then begin max:=min;s:=l end;
  end;
writeln('В строке номер ',s,' число ',max);
readln
end.