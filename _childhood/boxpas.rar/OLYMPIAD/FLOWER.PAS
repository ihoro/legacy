const
      MaxF = 100;
      MaxV =100;
      MinA = -50;
      MaxA = 50;
      InputFileName = 'flower.inp';
      OutputFileName = 'flower.out';
type
     AType = MinA..MaxA+1;
var
    A:array[1..MaxF,1..MaxV+1] of AType;
    P,O:array[1..MaxF] of 1..MaxV;
    DataFile:text;
    h:Char;
    F:1..MaxF;
    V:1..MaxV;
    r,t,l:integer;
    Max,Sum:MaxF*MinA..MaxF*MaxA;
    Ok:Boolean;
begin
{Чтение данных}
Assign(DataFile,InputFileName);
Reset(DataFile);
read(DataFile,F);
read(DataFile,h);
read(DataFile,V);
for r:=1 to F do
  for t:=1 to V do
    begin
      if t<>V then
        begin
          read(DataFile,A[r,t]);
          read(DataFile,h)
        end
              else
        readln(DataFile,A[r,t])
    end;
Close(DataFile);
{Обработка данных}
Max:=F*MinA;
Ok:=false;
for l:=F downto 1 do P[l]:=V-F+l;
P[l]:=V-F+1;
repeat
P[1]:=P[1]-1;
if P[1]=0 then
  begin
    P[1]:=P[2]-1;
    for l:=2 to F do
      if P[l]=l then
        if l=F then
          begin
            Ok:=true;
            l:=F
          end
               else
          P[l]:=P[l+1]-1
                else
        begin
          P[l]:=P[l]-1;
          r:=l;
          l:=F
        end;
    if r<>1 then
      for l:=r-1 downto 1 do P[l]:=P[l+1]-1;
  end;
Sum:=0;
for l:=1 to F do Sum:=Sum+A[l,P[l]];
if Sum>=Max then
  begin
    Max:=Sum;
    for l:=1 to F do O[l]:=P[l]
  end;
until Ok;
{Запись данных}
Assign(DataFile,OutputFileName);
Rewrite(DataFile);
writeln(DataFile,Max);
for l:=1 to F do
  begin
    write(DataFile,O[l]);
    write(DataFile,' ')
  end;
Close(DataFile)
end.