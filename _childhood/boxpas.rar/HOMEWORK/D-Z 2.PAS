var
   a,b,p,x:real;
   f,n:integer;
BEGIN
  b:=1;
   p:=1;
writeln('введите x и n');
read(x,n);
for f:= 1 to n do
     begin
         a:=sin(x*f);
         b:=b*f;
         p:=p*(1+a/b)
     end;
writeln('произведение:',p:5:2);
readln(f)
END.