uses dos;
var god,mes,den,den_ned,chas,min,sec,sotki:word;
    ok:char;
begin
 getdate(god,mes,den,den_ned);
 writeln('ᥣ����  ',den,'.',mes,' ',god,' ����');
 gettime(chas,min,sec,sotki);
 writeln(' ᥩ�� ',chas,' ��. ',min,' ���. � ',sec,' ᥪ.');
 writeln('������ ���,����� � ����:');
 readln(god,mes,den);
 writeln('������ ���,������,ᥪ㭤� � ��� ���� ᥪ㭤�:');
 readln(chas,min,sec,sotki);
 writeln('��⠭����� �� �६�?(1-��,2-���)');
 readln(ok);
 if not (ok='1') then begin writeln('����� ��室��!'); halt end;
 writeln('��⠭������� �६� � ����!');
 setdate(god,mes,den);
 settime(chas,min,sec,sotki);
 writeln('��⠭���� �����祭�!');
 readln
end.