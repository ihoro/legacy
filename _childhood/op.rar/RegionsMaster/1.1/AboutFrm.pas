unit AboutFrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Execute;
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.SpeedButton1Click(Sender: TObject);
begin
  Close
end;

procedure TAboutBox.Execute;
begin
  ShowModal
end;

end.
 
