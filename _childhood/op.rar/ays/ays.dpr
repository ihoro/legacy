program ays;

//{$APPTYPE CONSOLE}

uses
  Windows;

begin
  if ParamStr(1)='s' then
    if MessageBox(0,PAnsiChar('Are you sure? :P'),
         PAnsiChar('Shutdown computer'),MB_YESNO) = ID_YES then
       WinExec(PAnsiChar('shutdown -s -f -t 03 -c " омпутер уходит в аут :) —пать хјт€т системы, чипы, микросхемы... :P"'),
         SW_SHOW);
  if ParamStr(1)='r' then
    if MessageBox(0,PAnsiChar('Are you sure? :P'),
         PAnsiChar('Reboot computer'),MB_YESNO) = ID_YES then
       WinExec(PAnsiChar('shutdown -r -f -t 03 -c "ўа, он перезадумаетс€. ∆дите его послезавтра :)"'),SW_SHOW);
end.
 