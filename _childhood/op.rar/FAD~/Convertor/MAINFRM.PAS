unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, StdCtrls, Gauges, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    Edit1: TEdit;
    Gauge1: TGauge;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FFileName: string;
    FBMP: TBitmap;
    FMap: Text;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBMP:=TBitmap.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FBMP.Free
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    begin
      FFileName:=OpenPictureDialog1.FileName;
      Edit1.Text:=FFileName;
      SpeedButton2.Enabled:=true
    end
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  f,l: Integer;
begin
  AssignFile(FMap,ExtractFileDir(FFileName)+'\'+
    Copy(ExtractFileName(FFileName),1,
    Pos('.',ExtractFileName(FFileName))-1)+'.map');
  Rewrite(FMap);
  FBMP.LoadFromFile(FFileName);
  Gauge1.MaxValue:=FBMP.Width*FBMP.Height;
  SpeedButton2.Visible:=false;
  Gauge1.Visible:=true;
  Gauge1.Progress:=0;
  writeln(FMap,FBMP.Width);
  writeln(FMap,FBMP.Height);
  for l:=1 to FBMP.Height do
    for f:=1 to FBMP.Width do
      begin
        case FBMP.Canvas.Pixels[f-1,l-1] of
          clSilver:write(FMap,'0');
          clBlue:write(FMap,'1');
          clNavy:write(FMap,'2');
          clRed:write(FMap,'3');
          clLime:write(FMap,'4');
          clMaroon:write(FMap,'5');
          clOlive:write(FMap,'6')
          else
          write(FMap,'0')
        end;
        Gauge1.Progress:=Gauge1.Progress+1
      end;
  CloseFile(FMap);
  SpeedButton2.Visible:=true;
  Gauge1.Visible:=false
end;

end.
