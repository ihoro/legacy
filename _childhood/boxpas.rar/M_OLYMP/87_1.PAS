program M_Olymp87_1;
var
    a,b:array[1..200] of word;
    p:array[1..200] of byte;
    n,f,l:byte;
    i:integer;
    s,z,zmax:word;
begin
write('n=');readln(n);
writeln('Массив A(вес):');
for f:=1 to n do
  begin
    write('a[',f,']=');
    readln(a[f])
  end;
writeln('Массив B(цена):');
for f:=1 to n do
  begin
    write('b[',f,']=');
    readln(b[f])
  end;
for f:=1 to n do
  if a[f]>=30 then
    begin
      for l:=f to n-1 do
        begin
          a[l]:=a[l+1];
          b[l]:=b[l+1]
        end;
      n:=n-1
    end;
i:=0;
s:=0;
z:=0;
zmax:=0;
repeat
while i<n do
begin
  i:=i+1;
  if (s+a[i])<30 then
    begin
      s:=s+a[i];
      z:=z+b[i];
      p[i]:=0
    end
                 else
    p[i]:=1;
end;
if z>zmax then zmax:=z;
for f:=n downto 1 do
  begin
    if p[f]=0 then
      begin
        s:=s-a[f];
        z:=z-b[f]
      end;
    if (f<>n) and (p[f]=0) and (p[f+1]=1) then
      begin
        i:=f;
        f:=1
      end;
    if (f=1) and (p[f+1]=0) then i:=-1
  end;
until i=-1;
write('Цена: ',zmax);
readln
end.