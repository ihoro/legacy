unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan, Registry;

type
  TfrmMain = class(TForm)
    gbQ3dvs: TGroupBox;
    lbdQuake3: TLabeledEdit;
    lbdRar: TLabeledEdit;
    lbdCfg: TLabeledEdit;
    btnQuake3: TButton;
    btnRar: TButton;
    btnCfg: TButton;
    btnDone: TButton;
    btnCancel: TButton;
    gbCopyright: TGroupBox;
    OpenDialog: TOpenDialog;
    btnCopyright: TButton;
    XPManifest: TXPManifest;
    mmCopyright: TMemo;
    procedure btnQuake3Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRarClick(Sender: TObject);
    procedure btnCfgClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnCopyrightClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  reg: TRegistry;
  pkey: string = 'software\OIVSoft\q3dv';

implementation

{$R *.dfm}

procedure TfrmMain.btnQuake3Click(Sender: TObject);
begin
  with OpenDialog do
    begin
      Filter:='quake3.exe|quake3.exe';
      Title:='Open file ''quake3.exe''';
    end;
  if OpenDialog.Execute then
    lbdQuake3.Text:=OpenDialog.FileName
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfrmMain.btnRarClick(Sender: TObject);
begin
  with OpenDialog do
    begin
      Filter:='rar.exe|rar.exe';
      Title:='Open file ''rar.exe''';
    end;
  if OpenDialog.Execute then
    lbdRar.Text:=OpenDialog.FileName
end;

procedure TfrmMain.btnCfgClick(Sender: TObject);
begin
  with OpenDialog do
    begin
      Filter:='q3 config files|*.cfg';
      Title:='Open q3 config file';
    end;
  if OpenDialog.Execute then
    lbdCfg.Text:=OpenDialog.FileName
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  if not reg.OpenKey(pkey,false) then
    begin
      reg.OpenKey(pkey,true);
      reg.WriteString('q3','');
      reg.WriteString('rar','');
      reg.WriteString('cfg','')
    end;
  lbdQuake3.Text:=reg.ReadString('q3');
  lbdRar.Text:=reg.ReadString('rar');
  lbdCfg.Text:=reg.ReadString('cfg');
  reg.Free
end;

procedure TfrmMain.btnDoneClick(Sender: TObject);
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  reg.OpenKey(pkey,false);
  reg.WriteString('q3',lbdQuake3.Text);
  reg.WriteString('rar',lbdRar.Text);
  reg.WriteString('cfg',lbdCfg.Text);
  reg.Free;
  Close
end;

procedure TfrmMain.btnCopyrightClick(Sender: TObject);
var
  i: Integer;
begin
  if frmMain.Height=314 then
    for i:=314 downto 224 do
      frmMain.Height:=i
                        else
    for i:=224 to 314 do
      frmMain.Height:=i;
end;

end.
