var a,b,c,e,f,d1,d2,s :real;
function geron(a1,b1,c1:real):real;
 var p:real;
begin
 p:=(a1+b1+c1)/2;
 p:=p*(p-a1)*(p-b1)*(p-c1);
 geron:=sqrt(p)
end;
begin
writeln('Введите 5 сторон и две диагонали:');
readln(a,b,c,e,f,d1,d2);
s:=geron(a,b,d1)+geron(d1,c,d2)+geron(d2,e,f);
writeln('Площадь: ',s:5:1);
readln
end.
