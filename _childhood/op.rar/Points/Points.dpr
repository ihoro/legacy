program Points;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Main},
  NewGameFrm in 'NewGameFrm.pas' {NewGame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TNewGame, NewGame);
  Application.Run;
end.
