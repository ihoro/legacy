program M_Olymp88_4;
var c1,c2,c3:real;
    n1,n2,n3,n:word;
begin
writeln('����:');
write('���: ');readln(c3);
write('��離�: ');readln(c2);
write('��஡��: ');readln(c1);
write('������⢮ ��� ��᪮�: ');readln(n);
n1:=n div 144;
n:=n-n1*144;
n2:=n div 12;
n3:=n-n2*12;
if (n3*c3) > c2 then
  begin
    n2:=n2+1;
    n3:=0
  end;
if (n3*c3+n2*c2) > c1 then
  begin
    n1:=n1+1;
    n2:=0;
    n3:=0
  end;
writeln('�㦭� �㯨��:');
writeln('��� ��᪮�: ',n3);
writeln('��燐�: ',n2);
writeln('��஡��: ',n1);
readln
end.