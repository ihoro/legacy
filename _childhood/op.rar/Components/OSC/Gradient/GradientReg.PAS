unit GradientReg;

interface

uses
  DsgnIntf, Classes, Gradient, GradientCE;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OSC', [TGradient]);
  RegisterComponentEditor(TGradient,TGradientCE)
end;

end.
