program MiniGr;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  ProjectFrm in 'ProjectFrm.pas' {ProjectForm},
  EditFrm in 'EditFrm.pas' {EditForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.Run;
end.
