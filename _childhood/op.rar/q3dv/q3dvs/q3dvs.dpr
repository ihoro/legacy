program q3dvs;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'q3dvs';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
