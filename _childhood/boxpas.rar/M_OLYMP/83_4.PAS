program M_Olymp83_4;
var x:array[1..200] of integer;
    m,f,l,max,k,
    z:byte;{ 1 <, 2 > }
begin
write('m=');readln(m);
for f:=1 to m do
  begin
    write('x[',f,']=');
    readln(x[f])
  end;
max:=0;
for l:=1 to m do
  begin
    k:=0;
    z:=0;
    for f:=l to m-1 do
      begin
        z:=z+1;
        if z=3 then z:=1;
        if (z=1) and (x[f]>x[f+1]) then f:=m-1;
        if (z=2) and (x[f]>x[f+1]) then
          begin
            k:=k+1;
            if k>max then max:=k
          end
      end;
  end;
write('Количество зубцов: ',max);
readln
end.