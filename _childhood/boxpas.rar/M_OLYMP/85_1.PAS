program M_Olymp85_1;
var
   A:array[1..100] of integer;
   C,I,K,J,S:integer;
   O,W:boolean;
begin
writeln;
write('C = ');readln(C);
writeln;
I:=1;
A[1]:=C;
write(C,' = ',C);readln;
repeat
W:=false;
for k:=I downto 1 do
  if A[k] > 1 then
    begin
      A[k]:=A[k]-1;
      s:=1+I-k;
      J:=k;
      O:=false;
      repeat
        J:=J+1;
        if s>A[k] then begin A[J]:=A[k];s:=s-A[k] end
                  else begin A[J]:=s;I:=J;O:=true end
      until O;
      k:=1;
      write(C,' = ');
      for j:=1 to I do
        begin
          write(A[j]);
          if j<>I then write('+')
        end;
      readln
    end
          else
    if k=1 then W:=true
until W;
end.