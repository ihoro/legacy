program Test;

uses
  Forms,
  testFrm in 'testFrm.pas' {Form1},
  Analyser in 'Analyser.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
