program MapViewer;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'FAD MapViewer';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
