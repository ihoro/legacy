var x1,y1,x2,y2,x3,y3 :real;
function dlina(a1,b1,a2,b2:real):real;
begin
 dlina:=sqrt( sqr(a1-a2) + sqr(b1-b2) )
end;
function ok(s,a:real):boolean;
begin
 if s>a then ok:=true
        else ok:=false;
end;
begin
writeln('Введите x1,y1,x2,y2,x3,y3:');
readln(x1,y1,x2,y2,x3,y3);
if (ok( dlina(x3,y3,x2,y2) + dlina(x3,y3,x1,y1),dlina(x1,y1,x2,y2) )=true)
 and (ok( dlina(x3,y3,x1,y1) + dlina(x2,y2,x1,y1),dlina(x2,y2,x3,y3) )=true)
 and (ok( dlina(x2,y2,x1,y1) + dlina(x2,y2,x3,y3),dlina(x1,y1,x3,y3) )=true)
  then writeln('Эти точки являются вершинами треугольника!')
  else writeln('Эти точки не являются вершинами треугольника!');
readln
end.