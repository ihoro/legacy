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
    spIs: TSpeedButton;
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
    spMIs: TSpeedButton;
    spBIs: TSpeedButton;
    spM: TSpeedButton;
    spB: TSpeedButton;
    spNotIs: TSpeedButton;
    spX: TSpeedButton;
    spY: TSpeedButton;
    spClear: TSpeedButton;
    procedure cbFuncChange(Sender: TObject);
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
    procedure spIsClick(Sender: TObject);
    procedure spMIsClick(Sender: TObject);
    procedure spBIsClick(Sender: TObject);
    procedure spMClick(Sender: TObject);
    procedure spBClick(Sender: TObject);
    procedure spNotIsClick(Sender: TObject);
    procedure spXClick(Sender: TObject);
    procedure spYClick(Sender: TObject);
    procedure spClearClick(Sender: TObject);
    procedure cbFuncEnter(Sender: TObject);
    procedure edtVirEnter(Sender: TObject);
    procedure btnOkEnter(Sender: TObject);
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
  if (cbFunc.ItemIndex>=0) and (cbFunc.ItemIndex<12) then
    lblDes.Caption:=Des[cbFunc.ItemIndex+1];
  if (cbFunc.ItemIndex>11) and (cbFunc.ItemIndex<12+FTotalCons) then
    lblDes.Caption:=FCons[cbFunc.ItemIndex-11].Value;
  if (cbFunc.ItemIndex>11+FTotalCons) and (cbFunc.ItemIndex<12+FTotalCons+
    TotalDefConsts) then
    lblDes.Caption:=DefaultConsts[cbFunc.ItemIndex-11-FTotalCons].Value
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
  cbFunc.Clear;
  for f:=1 to 12 do
    cbFunc.Items.Add(cbFuncName[f]);
  for f:=1 to FTotalCons do
    cbFunc.Items.Add(FCons[f].Name);
  for f:=1 to TotalDefConsts do
    cbFunc.Items.Add(DefaultConsts[f].Name);
  cbFunc.ItemIndex:=0;
  lblDes.Caption:=Des[1]  
end;

procedure TEditForm.btnOkClick(Sender: TObject);
begin
  Close
end;

procedure TEditForm.spIsClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'='
end;

procedure TEditForm.spMIsClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'<='
end;

procedure TEditForm.spBIsClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'>='
end;

procedure TEditForm.spMClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'<'
end;

procedure TEditForm.spBClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'>'
end;

procedure TEditForm.spNotIsClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'<>'
end;

procedure TEditForm.spXClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'x'
end;

procedure TEditForm.spYClick(Sender: TObject);
begin
  edtVir.Text:=edtVir.Text+'y'
end;

procedure TEditForm.spClearClick(Sender: TObject);
begin
  edtVir.Text:=''
end;

procedure TEditForm.cbFuncEnter(Sender: TObject);
begin
  btnAddFunc.Default:=true;
  btnOk.Default:=false
end;

procedure TEditForm.edtVirEnter(Sender: TObject);
begin
  btnOk.Default:=true;
  btnAddFunc.Default:=false
end;

procedure TEditForm.btnOkEnter(Sender: TObject);
begin
  btnOk.Default:=true;
  btnAddFunc.Default:=false
end;

end.
