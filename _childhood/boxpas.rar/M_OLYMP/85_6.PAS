program M_Olymp85_6;
var
   I,F:byte;
   M:array[1..9] of byte;
   J,D,L:LongInt;
begin
writeln;
write('I = ');readln(I);
for f:=1 to 9 do
  begin
    write('M[',f,'] = ');
    readln(M[f])
  end;
D:=M[1];
L:=I;
for f:=2 to 9 do
  begin
    D:=D+M[f]*L;
    L:=L*I
  end;
writeln('Это число ',D);
writeln;
write('J = ');readln(J);
L:=SQR(SQR(SQR(J)));
for f:=9 downto 2 do
  begin
    if D>=L then begin M[f]:=D div L; D:=D-(D div L)*L end
            else M[f]:=0;
    L:=L div J
  end;
M[1]:=D;
for f:=1 to 9 do write(M[f]);
readln
end.