unit PreviewFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TPreview = class(TForm)
    Image: TImage;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Preview: TPreview;

implementation

{$R *.DFM}

procedure TPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close
end;

procedure TPreview.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close
end;

end.
