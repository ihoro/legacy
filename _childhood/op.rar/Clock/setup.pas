unit setup;

interface

Uses TMLiProf,  
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, Mask;

type
  TForm2 = class(TForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox3: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    SpinChas: TSpinEdit;
    SpinMin: TSpinEdit;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox3Click(Sender: TObject);
    procedure SpinChasExit(Sender: TObject);
    procedure SpinMinExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  SSek,SChas,SBud,fs,fc: Boolean;
  CChas,MMin: Word;

implementation

uses main;

{$R *.DFM}

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
LProfiler.StartFunc(12); Try
if CheckBox1.Checked then fs:=true
                     else fs:=false
    Finally LProfiler.EndFunc(12); End;
end;

procedure TForm2.CheckBox2Click(Sender: TObject);
begin
LProfiler.StartFunc(13); Try
if CheckBox2.Checked then fc:=true
                     else fc:=false
    Finally LProfiler.EndFunc(13); End;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
LProfiler.StartFunc(14); Try
if fs then SSek:=true
      else SSek:=false;
if fc then SChas:=true
      else SChas:=false;
CChas:=SpinChas.Value;
MMin:=SpinMin.Value;
Form1.Enabled:=true;
Hide
    Finally LProfiler.EndFunc(14); End;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
LProfiler.StartFunc(15); Try
if SSek then CheckBox1.Checked:=true
        else CheckBox1.Checked:=false;
if SChas then CheckBox2.Checked:=true
         else CheckBox2.Checked:=false;
if SBud then
  begin
    CheckBox3.Checked:=true;
    SpinChas.Enabled:=true;
    SpinMin.Enabled:=true
  end
        else
  begin
    CheckBox3.Checked:=false;
    SpinChas.Enabled:=false;
    SpinMin.Enabled:=false
  end
    Finally LProfiler.EndFunc(15); End;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
LProfiler.StartFunc(16); Try
if fs then SSek:=true
      else SSek:=false;
if fc then SChas:=true
      else SChas:=false;
CChas:=SpinChas.Value;
MMin:=SpinMin.Value;
Form1.Enabled:=true
    Finally LProfiler.EndFunc(16); End;
end;

procedure TForm2.CheckBox3Click(Sender: TObject);
begin
LProfiler.StartFunc(17); Try
if CheckBox3.Checked then
  begin
    SBud:=true;
    SpinChas.Enabled:=true;
    SpinMin.Enabled:=true
  end
                     else
  begin
    SBud:=false;
    SpinChas.Enabled:=false;
    SpinMin.Enabled:=false
  end
    Finally LProfiler.EndFunc(17); End;
end;

procedure TForm2.SpinChasExit(Sender: TObject);
begin
LProfiler.StartFunc(18); Try
if SpinChas.Text='' then SpinChas.Value:=0;
if SpinChas.Value>SpinChas.MaxValue then SpinChas.Value:=SpinChas.MaxValue
    Finally LProfiler.EndFunc(18); End;
end;

procedure TForm2.SpinMinExit(Sender: TObject);
begin
LProfiler.StartFunc(19); Try
if SpinMin.Text='' then SpinMin.Value:=0;
if SpinMin.Value>SpinMin.MaxValue then SpinMin.Value:=SpinMin.MaxValue
    Finally LProfiler.EndFunc(19); End;
end;

end.
