unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ImgList, ComCtrls, Classes, StdActns, ActnList;

type
  TMainForm = class(TForm)
    mmMain: TMainMenu;
    tlbMain: TToolBar;
    mmiFile: TMenuItem;
    ImageList: TImageList;
    mmiWindow: TMenuItem;
    mmiCascade: TMenuItem;
    mmiHorizontal: TMenuItem;
    mmiVertical: TMenuItem;
    mmiMinimizeAll: TMenuItem;
    mmiNew: TMenuItem;
    mmiOpen: TMenuItem;
    N9: TMenuItem;
    mmiExitProg: TMenuItem;
    mmiClose: TMenuItem;
    mmiSave: TMenuItem;
    mmiSaveAs: TMenuItem;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    ToolButton1: TToolButton;
    tbCascade: TToolButton;
    tbHorizontal: TToolButton;
    tbVertical: TToolButton;
    ActionList: TActionList;
    WindowCascade: TWindowCascade;
    WindowTileHorizontal: TWindowTileHorizontal;
    WindowTileVertical: TWindowTileVertical;
    WindowMinimizeAll: TWindowMinimizeAll;
    WindowArrange: TWindowArrange;
    mmiArrange: TMenuItem;
    tbAddVir: TToolButton;
    ToolButton3: TToolButton;
    tbDeleteVir: TToolButton;
    tbInsertVir: TToolButton;
    mmiVir: TMenuItem;
    mmiAddVir: TMenuItem;
    mmiInsertVir: TMenuItem;
    mmiDeleteVir: TMenuItem;
    tbEditVir: TToolButton;
    mmiEditVir: TMenuItem;
    procedure tbNewClick(Sender: TObject);
    procedure mmiNewClick(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure mmiOpenClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure mmiSaveClick(Sender: TObject);
    procedure tbAddVirClick(Sender: TObject);
    procedure mmiAddVirClick(Sender: TObject);
    procedure tbInsertVirClick(Sender: TObject);
    procedure mmiInsertVirClick(Sender: TObject);
    procedure tbDeleteVirClick(Sender: TObject);
    procedure mmiDeleteVirClick(Sender: TObject);
    procedure tbEditVirClick(Sender: TObject);
    procedure mmiEditVirClick(Sender: TObject);
  private
    { Private declarations }
  public
    FCount: Word;
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  FCurrentProject: Word;

implementation

uses
  ProjectFrm, ClipBrd, EditFrm;

{$R *.DFM}

procedure TMainForm.tbNewClick(Sender: TObject);
begin
  mmiNewClick(Self)
end;

procedure TMainForm.mmiNewClick(Sender: TObject);
var
  pr: TProjectForm;
begin
  pr:=TProjectForm.Create(nil);
  with pr do
    begin
      inc(FCount);
      FNumber:=FCount
    end
end;

procedure TMainForm.tbOpenClick(Sender: TObject);
begin
  mmiOpenClick(Self)
end;

procedure TMainForm.mmiOpenClick(Sender: TObject);
begin
  {}
end;

procedure TMainForm.tbSaveClick(Sender: TObject);
begin
  mmiSaveClick(Self)
end;

procedure TMainForm.mmiSaveClick(Sender: TObject);
begin
  {}
end;

procedure TMainForm.tbAddVirClick(Sender: TObject);
begin
  mmiAddVirClick(Self)
end;

procedure TMainForm.mmiAddVirClick(Sender: TObject);
begin
  with TProjectForm(MainForm.MDIChildren[FCurrentProject]) do
    Clipboard.AsText:=sgSystem.Cells[0,sgSystem.Row]
end;

procedure TMainForm.tbInsertVirClick(Sender: TObject);
begin
  mmiInsertVirClick(Self)
end;

procedure TMainForm.mmiInsertVirClick(Sender: TObject);
begin
  with TProjectForm(MainForm.MDIChildren[FCurrentProject]) do
    sgSystem.Cells[0,sgSystem.Row]:=Clipboard.AsText;
end;

procedure TMainForm.tbDeleteVirClick(Sender: TObject);
begin
  mmiDeleteVirClick(Self)
end;

procedure TMainForm.mmiDeleteVirClick(Sender: TObject);
begin
  with TProjectForm(MainForm.MDIChildren[FCurrentProject]) do
    begin
      Clipboard.AsText:=sgSystem.Cells[0,sgSystem.Row];
      sgSystem.Cells[0,sgSystem.Row]:=''
    end
end;

procedure TMainForm.tbEditVirClick(Sender: TObject);
begin
  mmiEditVirClick(Self)
end;

procedure TMainForm.mmiEditVirClick(Sender: TObject);
begin
  with EditForm,TProjectForm(MDIChildren[FCurrentProject]) do
    begin
      FCons:=FConstants;
      FTotalCons:=FTotalConst;
      ShowModal
    end
end;

end.
