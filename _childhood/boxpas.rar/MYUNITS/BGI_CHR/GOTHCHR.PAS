{ (C) OIV Company Ltd. 18.06.2000 }
unit GothChr;
Interface
Implementation
uses Graph;
procedure GothFont;external;
{$L goth.obj}
begin
if RegisterBGIFont(@GothFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Goth.chr');
    halt
  end;
end.
