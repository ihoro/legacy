var
   a,b,s:real;
   f:integer;
BEGIN
 a:=-1;
  b:=1;
   s:=0;
for f:= 1 to 10 do
     begin
         a:=a*(-1);
         b:=b*f;
         s:=s+a/b
     end;
writeln('αγ¬¬ :',s:3:2);
readln(f)
END.