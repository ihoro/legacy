unit ProjectFrm;

interface

uses
  Windows, Forms, Grids, Classes, Controls,
  ExtCtrls, Graphics, Analyser, ComCtrls;

type
  TProjectForm = class(TForm)
    pnlSystem: TPanel;
    sgSystem: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FNumber: Word;
    FConstants: TConstants;
    FTotalConst: 0..MaxConsts;
    FIdentity: TIdentity;
    procedure SetNewFont(aFont: TFont);
    { Public declarations }
  end;

var
  ProjectForm: TProjectForm;

implementation

uses
  MainFrm;

{$R *.DFM}

procedure TProjectForm.FormResize(Sender: TObject);
begin
  sgSystem.DefaultColWidth:=sgSystem.ClientWidth
end;

procedure TProjectForm.FormActivate(Sender: TObject);
begin
  FCurrentProject:=FNumber;
  FormResize(nil)
end;

procedure TProjectForm.SetNewFont(aFont: TFont);
begin
  sgSystem.Font:=aFont;
  sgSystem.DefaultRowHeight:=-sgSystem.Font.Height-sgSystem.Font.Height div 2
end;

procedure TProjectForm.FormCreate(Sender: TObject);
begin
  SetNewFont(sgSystem.Font)
end;

end.
