unit GradientReg;

interface

uses
  Classes, Gradient, GradientCE;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OSC', [TGradient]);
  RegisterComponentEditor(TGradient,TGradientCE)
end;

end.
