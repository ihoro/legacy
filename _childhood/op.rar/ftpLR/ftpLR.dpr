program ftpLR;

uses
  Forms,
  mainFrm in 'mainFrm.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
