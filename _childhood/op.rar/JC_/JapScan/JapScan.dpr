program JapScan;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'JAP Scaner';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
