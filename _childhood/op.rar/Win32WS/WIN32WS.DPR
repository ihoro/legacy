program Win32WS;

uses
  Windows,
  Forms,
  MainFrm in 'MainFrm.pas' {Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.Title := 'Win32WS';
  Application.CreateForm(TMain, Main);
  ShowWindow(Application.Handle,sw_Hide);
  Application.Run;
end.
