program RegionsMaster;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Main},
  AboutFrm in 'AboutFrm.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Regions Master';
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
