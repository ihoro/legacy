unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, OIVSoftInt;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
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
  SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,0,0);
  ShowOIVSoft(Application.Handle);
  SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,0,0)
end;

end.
 