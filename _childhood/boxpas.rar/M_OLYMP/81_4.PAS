program M_Olymp81_4;
var
    a:array[1..4] of 0..10;
    f:byte;
    v:LongInt;
function Ok(n:byte):Boolean;
var f,k:byte;
begin
k:=0;
for f:=1 to 4 do
  if (f<>n) and (a[f]=a[n]) then k:=k+1;
Ok:=true;
if k<>0 then Ok:=false
end;
begin
writeln('Числа:');
a[1]:=1;
a[2]:=0;
a[3]:=2;
a[4]:=2;
v:=0;
repeat
a[4]:=a[4]+1;
if a[4]=10 then
  begin
    a[4]:=0;
    for f:=3 downto 1 do
      if a[f]=9 then
        a[f]:=0
                else
        begin
          a[f]:=a[f]+1;
          f:=1
        end;
  end;
if Ok(1) and Ok(2) and Ok(3) and Ok(4) then begin writeln(a[1],a[2],a[3],a[4]);v:=v+1 end
until (a[1]=9) and (a[2]=9) and (a[3]=9) and (a[4]=9);
write('Всего чисел: ',v);
readln
end.
