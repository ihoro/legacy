unit MainFrm;

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, whkGlobal, Menus, IndicatorIcon,
  AddFrm;

type
  TMain = class(TForm)
    ListBox: TListBox;
    btnAdd: TButton;
    btnDelete: TButton;
    btnChange: TButton;
    btnOk: TButton;
    IndicatorIcon: TIndicatorIcon;
    PopupMenu: TPopupMenu;
    mmiCloseProgram: TMenuItem;
    N1: TMenuItem;
    mmiSetup: TMenuItem;
    mmiAbout: TMenuItem;
    procedure btnAddClick(Sender: TObject);
    procedure ListBoxExit(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmiCloseProgramClick(Sender: TObject);
    procedure mmiSetupClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpDateList;
    { Public declarations }
  end;

var
  Main: TMain;
  CurDir: string;
  twhk: file of Word;
  dwhk: file of TAct;
  f: Integer;
  Current: Word;
  Yes: Boolean = false;

procedure LoadData;

implementation

{$R *.DFM}

uses
  GlobalFrm;

procedure TMain.UpDateList;
var
  f: Word;
begin
  ListBox.Clear;
  for f:=1 to TotalActs do
    begin
      TempKeys:=Acts[f].Keys;
      Total:=Acts[f].TotalKeys;
      ListBox.Items.Add(Acts[f].FileName+' - '+
        GetKeysText)
    end
end;

procedure LoadData;
begin
  AssignFile(twhk,CurDir+'\'+TotalFileName);
  Reset(twhk);
  read(twhk,TotalActs);
  CloseFile(twhk);
  if TotalActs=0 then
    Exit;
  AssignFile(dwhk,CurDir+'\'+DataFileName);
  Reset(dwhk);
  for f:=1 to TotalActs do
    read(dwhk,Acts[f]);
  CloseFile(dwhk)
end;

procedure SaveData;
begin
  AssignFile(twhk,CurDir+'\'+TotalFileName);
  Rewrite(twhk);
  write(twhk,TotalActs);
  CloseFile(twhk);
  if TotalActs=0 then
    Exit;
  AssignFile(dwhk,CurDir+'\'+DataFileName);
  Rewrite(dwhk);
  for f:=1 to TotalActs do
    write(dwhk,Acts[f]);
  CloseFile(dwhk)
end;

procedure TMain.btnAddClick(Sender: TObject);
begin
  Add.Caption:='Добавить';
  Add.edtHotKeys.Text:='';
  Add.edtFileName.Text:='';
  if Add.Execute then
    begin
      inc(TotalActs);
      Acts[TotalActs]:=Add.FAct;
      UpDateList
    end
end;

procedure TMain.ListBoxExit(Sender: TObject);
begin
  Current:=ListBox.ItemIndex
end;

procedure TMain.btnChangeClick(Sender: TObject);
begin
  ListBox.SetFocus;
  if (Current+1<=0) or (Current+1>TotalActs) then
    Exit;
  Add.Caption:='Изменить';
  Add.edtFileName.Text:=Acts[Current+1].FileName;
  TempKeys:=Acts[Current+1].Keys;
  Total:=Acts[Current+1].TotalKeys;
  Add.edtHotKeys.Text:=GetKeysText;
  if Add.Execute then
    begin
      Acts[Current+1]:=Add.FAct;
      UpDateList
    end
end;

procedure TMain.btnDeleteClick(Sender: TObject);
var
  f: Word;
begin
  if (Current+1<=0) or (Current+1>TotalActs) then
    Exit;
  for f:=Current+2 to TotalActs-1 do
    Acts[f-1]:=Acts[f];
  dec(TotalActs);
  if Current=TotalActs then
    dec(Current);
  UpDateList;
  ListBox.SetFocus;
  ListBox.ItemIndex:=Current
end;

procedure TMain.btnOkClick(Sender: TObject);
begin
  SaveData;
  Hide
end;

procedure TMain.FormShow(Sender: TObject);
begin
  UpDateList
end;

procedure TMain.mmiCloseProgramClick(Sender: TObject);
begin
  UnInstallHook;
  IndicatorIcon.Visible:=false;
  Yes:=true;
  SaveData;
  Global.Close
end;

procedure TMain.mmiSetupClick(Sender: TObject);
begin
  UnInstallGlobalHook;
  Main.Show
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=Yes;
  btnOkClick(nil)
end;

procedure TMain.FormHide(Sender: TObject);
begin
  WorkTotal:=0;
  InstallGlobalHook
end;

end.
