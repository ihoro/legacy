unit ScaleFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TScale = class(TForm)
    tbScale: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    procedure tbScaleChange(Sender: TObject);
    procedure tbScaleKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Scale: TScale;

implementation

{$R *.DFM}

uses
  Main;

procedure TScale.tbScaleChange(Sender: TObject);
var
  f: Byte;
begin
  CurrentPointSize:=ABS(tbScale.Position-6);
  PointSize:=TypeSize[CurrentPointSize];
  Form1.Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
  if CurrentPointSize>=LimitFonts then
    Form1.Cross.Canvas.Font.Name:='MS Sans Serif'
                         else
    Form1.Cross.Canvas.Font.Name:='Small Fonts';
  X1pr:=TypeX1pr[CurrentPointSize];
  if SizeError(CurrentPointSize) then
    for f:=1 to PointMaxTypeSize do
      if SizeError(f) then
        begin
          tbScale.Position:=7-f;
          CurrentPointSize:=f-1;
          PointSize:=TypeSize[CurrentPointSize];
          Form1.Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
          if CurrentPointSize>=LimitFonts then
            Form1.Cross.Canvas.Font.Name:='MS Sans Serif'
                                 else
            Form1.Cross.Canvas.Font.Name:='Small Fonts';
          X1pr:=TypeX1pr[CurrentPointSize];
          Break
        end;
  WhitePole;
  PutFigures;
  PutAllPoint
end;

procedure TScale.tbScaleKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then Hide
end;

end.
