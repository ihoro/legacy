program calc;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'calculator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
