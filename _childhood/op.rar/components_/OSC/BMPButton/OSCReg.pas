unit OSCReg;

interface

procedure Register;

implementation

uses
  Windows, SysUtils, DesignIntf, BMPButton, BMPButtonPE,
  Classes, Controls, BMPButtonCE, BMPButtonBMPCategory;

procedure Register;
begin
  RegisterComponents('OSC',[TBMPButton]);
  RegisterPropertyEditor(TypeInfo(TBMP),
    TBMPButton,'',TBMPButtonPE);
  RegisterComponentEditor(TBMPButton,TBMPButtonCE);
  RegisterPropertiesInCategory(TBMPCategory,TBMPButton,
    ['NormalBMP','FocusedBMP','PushedBMP'])
end;

end.
 