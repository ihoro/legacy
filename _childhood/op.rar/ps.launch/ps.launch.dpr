program ps.launch;

uses
  Windows;

var
  i,err: Integer;

begin
  val(ParamStr(1),i,err);
  Sleep(i*1000);
  WinExec(PAnsiChar(ParamStr(2)+' '+ParamStr(3)),SW_HIDE)
end.
 