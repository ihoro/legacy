program M_Olymp82_5;
var
   a:array[1..100,1..100] of integer;
   m,n,f,l,d,s:byte;
   min,max:integer;
   Yes:Boolean;
begin
write('m=');readln(m);
write('n=');readln(n);
for l:=1 to m do
  for f:=1 to n do
    begin
      write('a[',l,',',f,']=');
      readln(a[l,f])
    end;
for l:=1 to m do
  begin
    min:=a[l,1];
    d:=1;
    for f:=1 to n do
      if a[l,f]<min then
        begin
          min:=a[l,f];
          d:=f
        end;
    max:=a[l,d];
    s:=l;
    Yes:=true;
    for f:=1 to m do
     begin
       if (a[f,d]>max) and (f<>l) then
         begin
           Yes:=false;
           f:=m
         end;
       if (f=m) and Yes then
         begin
           writeln('(',s,',',d,') число ',a[s,d]);
           readln;
           halt
         end;
     end;
  end;
writeln('Такого числа нет!');
readln
end.