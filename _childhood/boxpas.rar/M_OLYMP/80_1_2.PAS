program M_Olymp80_1_2; { Перестановки чисел }
type Mass = array[1..100] of integer;
var
   a:Mass;
   m,i,j,f:byte;
   Yes:Boolean;
   e:integer;
   v:LongInt;
procedure Print(a:Mass);
var f:byte;
begin
v:=v+1;
for f:=1 to m do
  begin
    if f=m then writeln(a[f])
           else write(a[f],' ')
  end
end;
begin
write('m=');readln(m);
for i:=1 to m do
  begin
    write('a[',i,']=');
    readln(a[i])
  end;
for j:=1 to m-1 do
  for i:=1 to m-j do
    if a[i]>a[i+1] then
      begin
        e:=a[i];
        a[i]:=a[i+1];
        a[i+1]:=e
      end;
Yes:=false;
v:=0;
Print(a);
repeat
for i:=m-1 downto 1 do
  if a[i]<a[i+1] then
    begin
      for j:=m downto i+1 do
        if a[i]<a[j] then
          begin
            e:=a[i];
            a[i]:=a[j];
            a[j]:=e;
            j:=i+1
          end;
      for j:=1 to m-i-1 do
        for f:=i+1 to m-j do
          if a[f]>a[f+1] then
            begin
              e:=a[f];
              a[f]:=a[f+1];
              a[f+1]:=e
            end;
      i:=1;
      Print(a)
    end
                 else
    if i=1 then
      begin
        Yes:=true;
        i:=1
      end
until Yes;
writeln(' Количество перестановок: ',v);
readln
end.