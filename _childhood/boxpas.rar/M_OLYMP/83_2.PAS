program Treugolnik_Tochka_M_Olymp83_2;
var
   X:array[1..4] of integer;
   Y:array[1..4] of integer;
   F,L:integer;

function Geron(x1,y1,x2,y2,x3,y3:integer):real;
var P:real;
function Dlina(x,y,xx,yy:integer):real;
begin
Dlina:=SQRT(SQR(x-xx)+SQR(y-yy))
end;

begin
P:=(Dlina(x1,y1,x2,y2)+Dlina(x2,y2,x3,y3)+Dlina(x1,y1,x3,y3)) / 2;
Geron:=SQRT(P*(P-Dlina(x1,y1,x2,y2))*(P-Dlina(x2,y2,x3,y3))*(P-Dlina(x1,y1,x3,y3)))
end;

begin
writeln('Треугольник:');
for F:=1 to 3 do
  begin
    write('X[',F,'] = ');
    readln(X[F]);
    write('Y[',F,'] = ');
    readln(Y[F])
  end;
writeln('Точка:');
 write('X = ');
 readln(X[4]);
 write('Y = ');
 readln(Y[4]);
if Trunc(Geron(X[1],Y[1],X[2],Y[2],X[3],Y[3]))=
     Trunc(Geron(X[1],Y[1],X[2],Y[2],X[4],Y[4]))+
     Trunc(Geron(X[2],Y[2],X[3],Y[3],X[4],Y[4]))+
     Trunc(Geron(X[1],Y[1],X[3],Y[3],X[4],Y[4]))
      then writeln('Да')
      else writeln('Нет')
end.
