program Moda_M_Olymp_85_5;
const N = 50;
var
   a:array[1..N] of integer;
   f,l,p,m,r,max,moda:integer;
begin
writeln;
write('m = ');readln(m);
for f:=1 to m do
  begin
    write(f,'-й элемент: ');
    readln(a[f])
  end;
max:=1;
moda:=a[1];
for f:=1 to m do
  begin
    p:=a[1];
    a[1]:=a[f];
    a[f]:=p;
    r:=1;
    for l:=2 to m do
      begin
        if a[l]=a[1] then
          begin
            r:=r+1;
            if r > max then
              begin
                max:=r;
                moda:=a[1]
              end
          end
      end
  end;
writeln('Мода: ',moda)
end.