program UpdateJCE;

uses
  Forms,
  MainFrm in '..\JapScan\MainFrm.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'JAP Scaner';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
