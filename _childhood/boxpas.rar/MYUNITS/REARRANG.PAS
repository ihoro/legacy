{ Перестановки чисел . Rearrangement}
unit Rearrang;

Interface

type
     MassType = array[1..500] of integer;
function TotalRearrang(TotalElement:Word):LongInt;
procedure Rearrangement(var a:MassType;m,nom:LongInt);

Implementation

var
    v:LongInt;
function TotalRearrang(TotalElement:Word):LongInt;
var
    F:Word;
    Total:LongInt;
begin
Total:=1;
for F:=2 to TotalElement do Total:=Total*F;
TotalRearrang:=Total
end;
function Proverka(n:LongInt):Boolean;
begin
if v=n then
  begin
    proverka:=true;
    exit
  end
       else
  proverka:=false
end;
procedure Rearrangement(var a:MassType;m,nom:LongInt);
var
    i,j,f:word;
    e:integer;
    Yes:Boolean;
begin
for j:=1 to m-1 do
  for i:=1 to m-j do
    if a[i]>a[i+1] then
      begin
        e:=a[i];
        a[i]:=a[i+1];
        a[i+1]:=e
      end;
Yes:=false;
v:=1;
if proverka(nom) then exit;
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
      v:=v+1;
      if proverka(nom) then exit;
      i:=1;
    end
                 else
    if i=1 then
      begin
        Yes:=true;
        i:=1
      end
until Yes
end;
end.