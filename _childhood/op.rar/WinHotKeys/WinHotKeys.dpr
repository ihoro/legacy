program WinHotKeys;

uses
  Windows,
  Forms,
  MainFrm in 'MainFrm.pas' {Main},
  AddFrm in 'AddFrm.pas' {Add},
  whkGlobal in 'whkGlobal.pas',
  GlobalFrm in 'GlobalFrm.pas' {Global};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.Title := 'WinHotKeys';
  Application.CreateForm(TGlobal, Global);
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TAdd, Add);
  ShowWindow(Application.Handle,sw_Hide);
  Application.Run;
end.
