uses WinDos,WinCrt,UpString;
const
      MesText:array[1..12] of string[8]=
                ('������','�������','�����','������','���','����','���g','�������','��������','�������','������','�������');
      DenText:array[0..6] of string[11]=
                ('�����������','�����������','�������','�����','�������','�������','�������');
var
    s:String;
    God,Mes,Den,Den_Ned,Chas,Min,Sec,Sotki:Word;
    Setup:Text;
    f:Byte;
    p:PChar;
begin
Assign(Setup,'computer.ini');
{$I-}
Reset(Setup);
if IOResult<>0 then
  begin
    GetDate(God,Mes,Den,Den_Ned);
    GetTime(Chas,Min,Sec,Sotki);
    Rewrite(Setup);
    writeln(Setup,God);
    writeln(Setup,Mes);
    writeln(Setup,Den);
    writeln(Setup,Den_Ned);
    writeln(Setup,Chas);
    writeln(Setup,Min);
    Close(Setup)
  end
               else
  Close(Setup);
{$I+}
Reset(Setup);
readln(Setup,God);
readln(Setup,Mes);
readln(Setup,Den);
readln(Setup,Den_Ned);
readln(Setup,Chas);
readln(Setup,Min);
Close(Setup);
if UpStr(ParamStr(1))<>'NO' then
  begin
s:='���� ���������� ��������� ����������';
for f:=0 to Length(s)-1 do
  begin
    p:=ptr(seg(InactiveTitle^),ofs(InactiveTitle^)+f);
    p^:=s[f+1]
  end;
WindowSize.X:=390;
WindowSize.Y:=30;
writeln('��������� ��� ��������� ���������');
str(Den,s);
write(s+' '+MesText[Mes]+'('+DenText[Den_Ned]+') ');
str(God,s);
write(s+' ���� � ');
str(Chas,s);
write(s+':');
str(Min,s);
write(s);
GotoXY(10,10);
end;
GetDate(God,Mes,Den,Den_Ned);
GetTime(Chas,Min,Sec,Sotki);
Rewrite(Setup);
writeln(Setup,God);
writeln(Setup,Mes);
writeln(Setup,Den);
writeln(Setup,Den_Ned);
writeln(Setup,Chas);
writeln(Setup,Min);
Close(Setup)
end.