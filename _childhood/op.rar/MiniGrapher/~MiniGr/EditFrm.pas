unit EditFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Analyser;

type
  TEditForm = class(TForm)
    edtVir: TEdit;
    sp7: TSpeedButton;
    sp8: TSpeedButton;
    sp4: TSpeedButton;
    sp5: TSpeedButton;
    sp9: TSpeedButton;
    sp6: TSpeedButton;
    sp1: TSpeedButton;
    sp2: TSpeedButton;
    sp3: TSpeedButton;
    sp0: TSpeedButton;
    spT: TSpeedButton;
    spOpenP: TSpeedButton;
    spCloseP: TSpeedButton;
    spOpenKP: TSpeedButton;
    spCloseKP: TSpeedButton;
    spOpenFP: TSpeedButton;
    spCloseFP: TSpeedButton;
    SpeedButton8: TSpeedButton;
    spDiv: TSpeedButton;
    spUmn: TSpeedButton;
    spMinus: TSpeedButton;
    spPlus: TSpeedButton;
    spStep: TSpeedButton;
    spDelChar: TSpeedButton;
    GroupBox1: TGroupBox;
    cbFunc: TComboBox;
    btnAddFunc: TButton;
    lblDes: TLabel;
    btnOk: TButton;
    procedure cbFuncChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sp0Click(Sender: TObject);
    procedure spTClick(Sender: TObject);
    procedure spStepClick(Sender: TObject);
    procedure spPlusClick(Sender: TObject);
    procedure sp1Click(Sender: TObject);
    procedure sp2Click(Sender: TObject);
    procedure sp3Click(Sender: TObject);
    procedure spMinusClick(Sender: TObject);
    procedure spOpenFPClick(Sender: TObject);
    procedure spCloseFPClick(Sender: TObject);
    procedure sp4Click(Sender: TObject);
    procedure sp5Click(Sender: TObject);
    procedure sp6Click(Sender: TObject);
    procedure spUmnClick(Sender: TObject);
    procedure spOpenKPClick(Sender: TObject);
    procedure spCloseKPClick(Sender: TObject);
    procedure sp7Click(Sender: TObject);
    procedure sp8Click(Sender: TObject);
    procedure sp9Click(Sender: TObject);
    procedure spDivClick(Sender: TObject);
    procedure spOpenPClick(Sender: TObject);
    procedure spClosePClick(Sender: TObject);
    procedure spDelCharClick(Sender: TObject);
    procedure btnAddFuncClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    FCons: TConstants;
    FTotalCons: 0..MaxConsts;
    { Public declarations }
  end;

var
  EditForm: TEditForm;

implementation

{$R *.DFM}

procedure TEditForm.cbFuncChange(Sender: TObject);
begin
  if (cbFunc.ItemIndex>0) and (cbFunc.ItemIndex<13) then
    lblDes.Caption:=Des[cbFunc.ItemIndex+1];
  if (cbFunc.ItemIndex>12) and (cbFunc.ItemIndex<13+FTotalCons) then
    lblDes.Caption:=FCons[cbFunc.ItemIndex-12].Value;
  if (cbFunc.ItemIndex>12+FTotalCons) and (cbFunc.ItemIndex<13+FTotalCons+
    TotalDefConsts) then
    lblDes.Caption:=DefaultConsts[cbFunc.ItemIndex-12-FTotalCons].Value
end;

procedure TEditForm.FormCreate(Sender: TObject);
begin
  cbFunc.ItemIndex:=0;
  lblDes.Caption:=Des[1]
end;

procedure TEditForm.sp0Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'0'
end;

procedure TEditForm.spTClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'.'
end;

procedure TEditForm.spStepClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'^'
end;

procedure TEditForm.spPlusClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'+'
end;

procedure TEditForm.sp1Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'1'
end;

procedure TEditForm.sp2Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'2'
end;

procedure TEditForm.sp3Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'3'
end;

procedure TEditForm.spMinusClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'-'
end;

procedure TEditForm.spOpenFPClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'{'
end;

procedure TEditForm.spCloseFPClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'}'
end;

procedure TEditForm.sp4Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'4'
end;

procedure TEditForm.sp5Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'5'
end;

procedure TEditForm.sp6Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'6'
end;

procedure TEditForm.spUmnClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'*'
end;

procedure TEditForm.spOpenKPClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'['
end;

procedure TEditForm.spCloseKPClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+']'
end;

procedure TEditForm.sp7Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'7'
end;

procedure TEditForm.sp8Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'8'
end;

procedure TEditForm.sp9Click(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'9'
end;

procedure TEditForm.spDivClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'/'
end;

procedure TEditForm.spOpenPClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'('
end;

procedure TEditForm.spClosePClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+')'
end;

procedure TEditForm.spDelCharClick(Sender: TObject);
begin
  edtVir.Text:=Copy(edtVir.Text,1,Length(edtVir.Text)-1)
end;

procedure TEditForm.btnAddFuncClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+cbFunc.Text
end;

procedure TEditForm.FormShow(Sender: TObject);
var
  f: 1..MaxConsts;
begin
  for f:=1 to FTotalCons do
    cbFunc.Items.Add(FCons[f].Name);
  for f:=1 to TotalDefConsts do
    cbFunc.Items.Add(DefaultConsts[f].Name)
end;

procedure TEditForm.btnOkClick(Sender: TObject);
begin
  Close
end;

end.
