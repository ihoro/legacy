unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ImgList, ComCtrls, Classes, StdActns, ActnList;

type
  TMainForm = class(TForm)
    ImageList: TImageList;
    mmMain: TMainMenu;
    mmiFile: TMenuItem;
    mmiNew: TMenuItem;
    mmiOpen: TMenuItem;
    MenuItem7: TMenuItem;
    mmiExitProg: TMenuItem;
    mmiWindow: TMenuItem;
    mmiCascade: TMenuItem;
    mmiHorizontal: TMenuItem;
    mmiVertical: TMenuItem;
    mmiMinimizeAll: TMenuItem;
    mmiArrangeIcons: TMenuItem;
    tlbMain: TToolBar;
    tbNew: TToolButton;
    tbOpen: TToolButton;
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
    procedure mmiNewClick(Sender: TObject);
    procedure tbNewClick(Sender: TObject);
  private
    { Private declarations }
  public
    FCount: Word;
    { Public declarations }
  end;

var
  clSysBackground: TColor = clSilver;
  clSysColor: TColor = clBlue;
  clSysLimits: TColor = clBlack;

var
  MainForm: TMainForm;

implementation

uses
  ProjectFrm;

{$R *.DFM}

procedure TMainForm.mmiNewClick(Sender: TObject);
begin
  TProjectForm.Create(Self)
end;

procedure TMainForm.tbNewClick(Sender: TObject);
begin
  mmiNewClick(Self)
end;

end.
