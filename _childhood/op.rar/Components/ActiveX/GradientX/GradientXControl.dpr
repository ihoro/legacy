library GradientXControl;

uses
  ComServ,
  GradientXControl_TLB in 'GradientXControl_TLB.pas',
  GradientImpl in 'GradientImpl.pas' {GradientX: CoClass},
  AboutFrm in 'AboutFrm.pas' {GradientXAbout};

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
