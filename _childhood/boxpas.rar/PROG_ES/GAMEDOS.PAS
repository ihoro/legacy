{$M 8192,0,0}
uses Dos;
var command,s,maindir:string;
    fil:text;
    heops,
    com
    :boolean;
procedure doscom(s:string);
begin
SwapVectors;
Exec(GetEnv('COMSPEC'),'/C '+s);
SwapVectors;
if DosError <> 0 then
  WriteLn('Could not execute COMMAND.COM')
end;
function srez(s:string):string;
var f:word;
begin
for f:=1 to Length(s) do
  if s[f]=' ' then Delete(s,f,1);
srez:=s
end;
begin
heops:=false;
GetDir(0,maindir);
maindir:=maindir+'\KLAD';
doscom('md '+maindir);
Assign(fil,maindir+'\begin.txt');
Rewrite(fil);
writeln(fil,'  ��ண�� ���! ���� ���� ������ � ���᭮� �����⢨�');
writeln(fil,'� ���᪠� �����. �᫨ �� ��⮢, ��ࠢ���� ��  ����-');
writeln(fil,'����(��⠫��), ��� ��� ������� ��� � �����  �����');
writeln(fil,'��ଠ���. ����� � ���⠩ ⠬ 䠩�, ��� ���ண� ���-');
writeln(fil,'室�� ��� ���� ?i?.?x?');
Close(fil);
doscom('md '+maindir+'\AFRICA');
doscom('md '+maindir+'\AFRICA\HEOPS');
Assign(fil,maindir+'\AFRICA\nil.txt');
Rewrite(fil);
writeln(fil,'  ����� � ���⠩ ����������, ���஥ ���뢠�� �室');
writeln(fil,'� ��ࠬ��� �����! ��� ��室���� � ��࠭� �������!');
Close(fil);
Assign(fil,maindir+'\AFRICA\sfinx.txt');
Rewrite(fil);
writeln(fil,'  �����! ���� ࠧ � ����� � 㢨��� �䨭��!');
Close(fil);
Assign(fil,maindir+'\AFRICA\read.me');
Rewrite(fil);
writeln(fil,'  ���� ���� 蠭�, ����� �� ��ਪ�!');
Close(fil);
Assign(fil,maindir+'\AFRICA\kair.doc');
Rewrite(fil);
writeln(fil,'  ��த ��� ��த!');
Close(fil);

doscom('md '+maindir+'\AUSTRAL');
Assign(fil,maindir+'\AUSTRAL\magic.txt');
Rewrite(fil);
writeln(fil,'  ����������: bamphltionuffaire do!');
Close(fil);
Assign(fil,maindir+'\AUSTRAL\jungle.doc');
Rewrite(fil);
writeln(fil,'  �த� �� ��㭣��, �� �믨�� �� ������ ����!');
writeln(fil,'�᫨ �� �� ������ ����, � ��� �� �����!');
Close(fil);
REPEAT
repeat
Getdir(0,s);
write(s+'>');
readln(command);
until command<>'';
com:=true;
if command='exit' then com:=false;
if (upcase(srez(command))='DIRHEOPS') and (upcase(s)=(upcase(maindir)+'\AFRICA'))
   and (heops=false) then
    begin
     com=false;
     writeln('  �室 � ��ࠬ��� ����� ������!')
    end;
if com then
begin
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C '+command);
  SwapVectors;
  if DosError <> 0 then
    WriteLn('Could not execute COMMAND.COM')
end;
UNTIL command='exit';
end.