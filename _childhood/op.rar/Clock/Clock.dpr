program Clock;

uses
TMLiFn in 'TMLiFn.Pas',
  Forms,
  main in 'main.pas' {Form1},
  setup in 'setup.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
