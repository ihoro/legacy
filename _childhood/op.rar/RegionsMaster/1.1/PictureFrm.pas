unit PictureFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TPicture = class(TForm)
    Image1: TImage;
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    FColor: TColor;
    { Public declarations }
  end;

var
  Picture: TPicture;

implementation

{$R *.DFM}

procedure TPicture.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FColor:=Image1.Canvas.Pixels[X,Y];
  Close
end;

procedure TPicture.FormShow(Sender: TObject);
begin
  Image1.Align:=alClient
end;

end.
