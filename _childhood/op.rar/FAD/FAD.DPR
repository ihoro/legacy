program FAD;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Main};

{$R *.RES}

begin
  Randomize;
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
