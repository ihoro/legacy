program MiniGr;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  ProjectFrm in 'ProjectFrm.pas' {ProjectForm},
  EditFrm in 'EditFrm.pas' {EditForm},
  ConsFrm in 'ConsFrm.pas' {ConsForm},
  GraphFrm in 'GraphFrm.pas' {GraphForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TConsForm, ConsForm);
  Application.Run;
end.
