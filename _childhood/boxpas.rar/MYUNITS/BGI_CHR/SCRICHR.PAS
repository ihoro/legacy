{ (C) OIV Company Ltd. 18.06.2000 }
unit ScriChr;
Interface
Implementation
uses Graph;
procedure ScriFont;external;
{$L scri.obj}
begin
if RegisterBGIFont(@ScriFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Scri.chr');
    halt
  end;
end.
