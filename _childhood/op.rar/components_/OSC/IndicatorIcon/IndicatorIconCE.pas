unit IndicatorIconCE;

interface

uses
  DsgnIntf, Forms, AboutFrm;

type
  TIndicatorIconCE = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation

function TIndicatorIconCE.GetVerbCount: Integer;
begin
  Result:=1
end;

function TIndicatorIconCE.GetVerb(Index: Integer): string;
begin
  case Index of
    0:Result:='About..'
  end
end;

procedure TIndicatorIconCE.ExecuteVerb(Index: Integer);
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

end.
