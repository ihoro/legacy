program M_Olymp80_2_1;
{const a:array[1..2,1..15] of integer =
      ((7,-1,-2,2,0,1,3,6,9,12,-5,13,10,8,5),
       (-3,-4,15,16,17,18,19,20,21,22,23,24,3,25,26));}
var a:array[1..2,1..15] of integer;
    b:array[1..30] of integer;
    k,f,h,l,i,j:byte;
    Yes:Boolean;
begin
for l:=1 to 2 do
  for f:=1 to 15 do
    begin
      write('a[',l,',',f,']=');
      readln(a[l,f])
    end;
for f:=1 to 15 do b[f]:=a[1,f];
for f:=1 to 15 do b[f+15]:=a[2,f];
k:=0;
i:=0;
j:=1;
Yes:=false;
repeat
i:=i+1;
if i=16 then begin i:=1;j:=2 end;
for f:=1 to 30-k-1 do b[f]:=b[f+1];
k:=k+1;
for f:=1 to 30-k do
  if b[f]=a[j,i] then
    begin
      for l:=1 to 2 do
        for h:=1 to 15 do
          if a[l,h]=a[j,i] then write('(',l,',',h,')  ');
      f:=30-k;
      Yes:=true
    end
until Yes;
readln
end.