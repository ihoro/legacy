{ (C) OIV Company Ltd. 18.06.2000 }
unit BoldChr;
Interface
Implementation
uses Graph;
procedure BoldFont;external;
{$L bold.obj}
begin
if RegisterBGIFont(@BoldFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Bold.chr');
    halt
  end;
end.
