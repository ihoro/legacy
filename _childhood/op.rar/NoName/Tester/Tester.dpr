program Tester;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Form1};

{$R *.RES}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'Tester';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
