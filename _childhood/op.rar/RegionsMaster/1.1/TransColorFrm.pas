unit TransColorFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, MainFrm, PictureFrm;

type
  TTransColor = class(TForm)
    ColorDialog1: TColorDialog;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Shape1: TShape;
    Button2: TButton;
    GroupBox2: TGroupBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TransColor: TTransColor;

implementation

{$R *.DFM}

procedure TTransColor.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
    Shape1.Brush.Color:=ColorDialog1.Color
end;

procedure TTransColor.Button1Click(Sender: TObject);
begin
  Close
end;

procedure TTransColor.Button2Click(Sender: TObject);
begin
  with Picture do
    begin
      Image1.Align:=alNone;
      Image1.Picture.LoadFromFile(
        Main.opdImport.FileName);
      ClientWidth:=Image1.Width;
      ClientHeight:=Image1.Height;
      ShowModal;
      Shape1.Brush.Color:=FColor
    end;
end;

end.
