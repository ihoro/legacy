program ays;

//{$APPTYPE CONSOLE}

uses
  Windows;

begin
  if ParamStr(1)='s' then
    if MessageBox(0,PAnsiChar('Are you sure? :P'),
         PAnsiChar('Shutdown computer'),MB_YESNO) = ID_YES then
       WinExec(PAnsiChar('shutdown -s -f -t 03 -c "�������� ������ � ��� :) ����� ����� �������, ����, ����������... :P"'),
         SW_SHOW);
  if ParamStr(1)='r' then
    if MessageBox(0,PAnsiChar('Are you sure? :P'),
         PAnsiChar('Reboot computer'),MB_YESNO) = ID_YES then
       WinExec(PAnsiChar('shutdown -r -f -t 03 -c "��, �� ��������������. ����� ��� ����������� :)"'),SW_SHOW);
end.
 