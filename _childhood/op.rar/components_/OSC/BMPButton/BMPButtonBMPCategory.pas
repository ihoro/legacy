unit BMPButtonBMPCategory;

interface

uses
  DsgnIntf;

type
  TBMPCategory = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

implementation

class function TBMPCategory.Name: string;
begin
  Result:='Bitmaps'
end;

class function TBMPCategory.Description: string;
begin
  Result:='��������, ��������� � ������������ �������'
end;

end.
