{ (C) OIV Company Ltd. 18.06.2000 }
unit LcomChr;
Interface
Implementation
uses Graph;
procedure LcomFont;external;
{$L lcom.obj}
begin
if RegisterBGIFont(@LcomFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Lcom.chr');
    halt
  end;
end.
