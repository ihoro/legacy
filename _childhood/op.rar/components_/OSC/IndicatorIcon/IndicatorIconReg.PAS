unit IndicatorIconReg;

interface

uses
  DsgnIntf, Classes, IndicatorIcon, IndicatorIconCE;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OSC', [TIndicatorIcon]);
  RegisterComponentEditor(TIndicatorIcon,
    TIndicatorIconCE)
end;

end.
