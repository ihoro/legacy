unit BMPButtonPE;

interface

uses
  SysUtils, DsgnIntF, ExtDlgs, Dialogs, Forms;

type
  TBMPButtonPE = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

implementation

function TBMPButtonPE.GetAttributes: TPropertyAttributes;
begin
  Result:=[paDialog]
end;

procedure TBMPButtonPE.Edit;
var
  OpenBMP: TOpenPictureDialog;
begin
  OpenBMP:=TOpenPictureDialog.Create(Application);
  try
    OpenBMP.Filter:='Bitmap files|*.bmp';
    if OpenBMP.Execute then
      SetStrValue(OpenBMP.FileName)
  finally
    OpenBMP.Free
  end
end;

end.
