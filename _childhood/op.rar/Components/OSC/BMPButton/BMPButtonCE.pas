unit BMPButtonCE;

interface

uses
  SysUtils, Forms, DsgnIntf, BMPButtonAboutFrm;

type
  TBMPButtonCE = class(TComponentEditor)
  private
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation

procedure TBMPButtonCE.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:begin
        AboutBox:=TAboutBox.Create(Application);
        AboutBox.Execute;
        AboutBox.Free;
        AboutBox:=nil
      end;
  end
end;

function TBMPButtonCE.GetVerb(Index: Integer): string;
begin
  case Index of
    0:Result:='About...'
  end
end;

function TBMPButtonCE.GetVerbCount: Integer;
begin
  Result:=1
end;

end.
