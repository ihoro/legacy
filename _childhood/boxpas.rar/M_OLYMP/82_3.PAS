program M_Olymp82_3;
uses Crt;
var
   a:array[1..200] of integer;
   m,c:integer;
   n,f,l,d:byte;
   Yes:Boolean;
begin
write('n=');readln(n);
for f:=1 to n do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
write('m=');readln(m);
Yes:=false;
for l:=1 to n do
  for f:=1 to n-l+1 do
    begin
      c:=0;
      for d:=f to f+l-1 do c:=c+a[d];
      if c=m then
        begin
          textbackground(0);
          textcolor(7);
          for d:=1 to f-1 do write(a[d],' ');
          textcolor(12);
          for d:=f to f+l-1 do
            if d=n then writeln(a[d])
                   else write(a[d],' ');
          textcolor(7);
          for d:=f+l to n do
            if d=n then writeln(a[d])
                   else write(a[d],' ');
          if l=1 then writeln(a[f],'=',m);
          if l<>1 then
           begin
            for d:=f to f+l-1 do
                if d=f+l-1 then write(a[d])
                           else write(a[d],'+');
            write('=',m)
           end;
          Yes:=true
        end
             else
        c:=0
    end;
if not Yes then writeln('Такого множества нет!');
readln
end.