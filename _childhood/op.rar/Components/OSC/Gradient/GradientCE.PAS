unit GradientCE;

interface

uses
  DsgnIntf, Forms, GradientAboutFrm;

type
  TGradientCE = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation

procedure TGradientCE.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:begin
        AboutBox:=TAboutBox.Create(Application);
        AboutBox.ShowModal;
        AboutBox.Free;
        AboutBox:=nil
      end
  end
end;

function TGradientCE.GetVerb(Index: Integer): string;
begin
  case Index of
    0:Result:='About...'
  end
end;

function TGradientCE.GetVerbCount: Integer;
begin
  Result:=1
end;

end.
