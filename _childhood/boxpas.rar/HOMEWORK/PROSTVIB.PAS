var a,f,i,l:word;
    e:array[1..1000] of integer;
    c,p:integer;
begin
 write('Введите число элементов: ');
 readln(a);
 for f:=1 to a do
  begin
   write('Введите ',f,'-й элемент:');
   readln(e[f])
  end;
 for f:= 1 to a do write(e[f],' ');
 writeln('');
for l:=1 to a-1 do
 for f:=l to a do
  begin
   p:=0;
   for i:=l to a do if e[f] <= e[i] then p:=p+1
                                    else i:=a;
   if p=a+1-l then
     begin
      c:=e[l];
      e[l]:=e[f];
      e[f]:=c;
      f:=a
     end;
  end;
 for f:= 1 to a do write(e[f],' ');
 readln
end.