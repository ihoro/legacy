unit AddFrm;

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, whkGlobal;

type
  TAdd = class(TForm)
    GroupBox1: TGroupBox;
    edtFileName: TEdit;
    btnView: TButton;
    OpenDialog: TOpenDialog;
    GroupBox2: TGroupBox;
    btnOkAdd: TButton;
    btnCancelAdd: TButton;
    edtHotKeys: TEdit;
    btnClear: TButton;
    btnNew: TButton;
    procedure btnViewClick(Sender: TObject);
    procedure btnOkAddClick(Sender: TObject);
    procedure edtHotKeysExit(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure edtHotKeysKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    FAct: TAct;
    FOK: Boolean;
    function Execute: Boolean;
    { Public declarations }
  end;

var
  Add: TAdd;

implementation

{$R *.DFM}

function TAdd.Execute: Boolean;
begin
  FOK:=true;
  ShowModal;
  Result:=FOK
end;

procedure TAdd.btnViewClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    begin
      FAct.FileName:=OpenDialog.FileName;
      edtFileName.Text:=FAct.FileName
    end
end;

procedure TAdd.btnOkAddClick(Sender: TObject);
begin
  if edtFileName.Text='' then
    begin
      ShowMessage('ֲגוהטעו טלÿ פאיכא!');
      Exit
    end;
  if edtHotKeys.Text='' then
    begin
      ShowMessage('ֲגוהטעו Hot Keys!');
      Exit
    end;
  FAct.TotalKeys:=Total;
  FAct.Keys:=TempKeys;
  FAct.FileName:=edtFileName.Text;
  Close
end;

procedure TAdd.edtHotKeysExit(Sender: TObject);
begin
  UnInstallHook
end;

procedure TAdd.btnClearClick(Sender: TObject);
begin
  edtHotKeys.Text:='';
  Total:=0
end;

procedure TAdd.btnNewClick(Sender: TObject);
begin
  edtHotKeys.Text:='';
  edtHotKeys.SetFocus;
  InstallHook
end;

procedure TAdd.edtHotKeysKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtHotKeys.Text:=GetKeysText
end;

procedure TAdd.btnCancelAddClick(Sender: TObject);
begin
  FOK:=false;
  Close
end;

end.
