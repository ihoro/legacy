unit undertpu;
Interface
var
    Map:array[1..100,1..100] of Char;
    U,V:3..100;
    r,t:Integer;
    h:Char;
procedure Start;
function Look(dir:char):char;
procedure Move(dir:char);
procedure Finish(x,y:integer);
Implementation
uses Dos;
var
    f:text;
    sx,sy,youx,youy:3..100;
    TotalLook:LongInt;
procedure Start;
begin
TotalLook:=0;
{repeat
youx:=Random(U-2)+1;
youy:=Random(V-2)+1;
until Map[youx,youy]='O';}
youx:=3; sx:=3;
youy:=5; sy:=5
end;
function Look(dir:Char):Char;
begin
TotalLook:=TotalLook+1;
case UpCase(dir) of
'N':Look:=Map[youx,youy+1];
'S':Look:=Map[youx,youy-1];
'W':Look:=Map[youx-1,youy];
'E':Look:=Map[youx+1,youy]
end;
end;
procedure Move(dir:Char);
begin
case UpCase(dir) of
'N':if Map[youx,youy+1]='O' then
      youy:=youy+1
                            else
      begin
        writeln('�訡��! �� ����⠫��� ��������� �� �⥭�.');
        halt
      end;
'S':if Map[youx,youy-1]='O' then
      youy:=youy-1
                            else
      begin
        writeln('�訡��! �� ����⠫��� ��������� �� �⥭�.');
        halt
      end;
'W':if Map[youx-1,youy]='O' then
      youx:=youx-1
                            else
      begin
        writeln('�訡��! �� ����⠫��� ��������� �� �⥭�.');
        halt
      end;
'E':if Map[youx+1,youy]='O' then
      youx:=youx+1
                            else
      begin
        writeln('�訡��! �� ����⠫��� ��������� �� �⥭�.');
        halt
      end;
end;
end;
procedure Finish(x,y:integer);
begin
if (x<>sx) and (y<>sy) then
  begin
    writeln('�� ���ࠢ��쭮 ��।����� ᢮� ���न����!');
    halt
  end;
writeln('���न���� ��।����� �ࠢ��쭮!');
writeln('��窠 (',x,';',y,')');
writeln('��楤�� Look ��뢠���� ',TotalLook,' ࠧ(�).');
halt
end;
begin
Assign(f,'under.inp');
Reset(f);
read(f,U);read(f,h);readln(f,V);
for t:=V downto 1 do
  for r:=1 to U do
    if r<>U then
      read(f,Map[r,t])
            else
      readln(f,Map[r,t]);
Close(f);
end.