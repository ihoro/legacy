program testing;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  LoginFrm in 'LoginFrm.pas' {LoginForm},
  global in 'global.pas',
  TestFrm in 'TestFrm.pas' {TestForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Testing System';
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
