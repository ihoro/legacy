unit CongratulationsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MPlayer, ExtCtrls, Buttons;

type
  TCongratulations = class(TForm)
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Congratulations: TCongratulations;

implementation

{$R *.DFM}

procedure TCongratulations.FormShow(Sender: TObject);
begin
  {MediaPlayer1.Play}
end;

procedure TCongratulations.SpeedButton1Click(Sender: TObject);
begin
  Close
end;

end.
