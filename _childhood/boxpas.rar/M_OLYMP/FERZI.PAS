program Ferzi;
label Finish;
const
      a = 8; {вертикаль}
      b = 8; {горизонталь}
      n = 8; {кол. ферзей}
var
    p,i,j:Byte;
    Z:array[1..b] of 1..b;
    Vos,Zak:array[1..a+b] of Boolean;
    Poza:array[1..a] of 1..b;
    k:Word;
begin
for i:=1 to a+b do
  begin
    Vos[i]:=false;
    Zak[i]:=false
  end;
for i:=1 to b do Poza[i]:=i;
i:=1;
j:=0;
k:=0;
repeat
repeat
repeat
if j>b then
  begin
    i:=i-1;
    if i=0 then goto Finish;
    j:=Z[i];
    p:=Poza[i];
    Poza[i]:=Poza[j];
    Poza[j]:=p;
    Vos[p-i+a]:=false;
    Zak[p+i]:=false
  end;
j:=j+1;
until j<=b;
p:=Poza[j];
until not (Vos[p-i+a] and Zak[p+i]);
Vos[p-i+a]:=true;
Zak[p+i]:=true;
Poza[j]:=Poza[i];
Poza[i]:=p;
Z[i]:=j;
i:=i+1;
j:=i-1;
if i>N then
  begin
    k:=k+1;
    i:=i-1;
    if i=0 then goto Finish
  end;
until k<0;
Finish:
write('Количество вариантов: ',k);
readln
end.