program FAD;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Main},
  LoseFrm in 'LoseFrm.pas' {Lose};

{$R *.RES}
{$R FADCursors.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TLose, Lose);
  Application.Run;
end.
