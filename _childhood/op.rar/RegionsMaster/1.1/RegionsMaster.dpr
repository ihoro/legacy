program RegionsMaster;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Main},
  AboutFrm in 'AboutFrm.pas' {AboutBox},
  TransColorFrm in 'TransColorFrm.pas' {TransColor},
  PictureFrm in 'PictureFrm.pas' {Picture};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Regions Master';
  Application.HelpFile := 'RMHELP.HLP';
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TTransColor, TransColor);
  Application.CreateForm(TPicture, Picture);
  Application.Run;
end.
