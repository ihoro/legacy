program ts;

uses
  Forms,
  MainFrm in '..\ts\MainFrm.pas' {MainForm},
  LoginFrm in '..\ts\LoginFrm.pas' {LoginForm},
  global in '..\ts\global.pas',
  TestFrm in '..\ts\TestFrm.pas' {TestForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Testing System';
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
