unit LoseFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  TLose = class(TForm)
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Bevel1: TBevel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Lose: TLose;

implementation

uses MainFrm;

{$R *.DFM}

procedure TLose.SpeedButton1Click(Sender: TObject);
begin
  Close
end;

procedure TLose.Timer1Timer(Sender: TObject);
begin
  Main.DXWaveList.Items.Find('Lose').Play(false);
  Timer1.Enabled:=false
end;

procedure TLose.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true
end;

end.
