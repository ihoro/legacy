program M_Olymp80_1_4;
const otvet=35;
var a:array[2..6] of byte;{1 +,2 -,3 *,4 /}
    f,l:byte;
    b1,b2,b3,b4,b5,b6:integer;
function s(c1,z,c2:integer):integer;
begin
case z of
1:s:=c1+c2;
2:s:=c1-c2;
3:s:=c1*c2;
4:s:=trunc(c1/c2)
end
end;
function znak(z:byte):char;
begin
case z of
1:znak:='+';
2:znak:='-';
3:znak:='*';
4:znak:='/'
end
end;
begin
for f:=2 to 6 do a[f]:=1;
a[6]:=0;
b1:=1;
repeat
a[6]:=a[6]+1;
if a[6]=5 then
  begin
    a[6]:=1;
    for f:=5 downto 2 do
      begin
        if (a[f]=4) and (f=2) then
          begin
            writeln('Такого выражения нет!');
            halt
          end;
        if a[f]=4 then a[f]:=1
                  else
                    begin
                      a[f]:=a[f]+1;
                      break
                    end;
      end;
  end;
b2:=s(b1,a[2],2);
b3:=s(b2,a[3],3);
b4:=s(b3,a[4],4);
b5:=s(b4,a[5],5);
b6:=s(b5,a[6],6);
until b6=otvet;
writeln('((((1'+znak(a[2])+'2)'+znak(a[3])+'3)'+znak(a[4])+'4)'+znak(a[5])+'5)'+znak(a[6])+'6 = ',otvet);
readln
end.