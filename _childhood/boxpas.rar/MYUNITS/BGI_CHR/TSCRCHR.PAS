{ (C) OIV Company Ltd. 18.06.2000 }
unit TscrChr;
Interface
Implementation
uses Graph;
procedure TscrFont;external;
{$L tscr.obj}
begin
if RegisterBGIFont(@TscrFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Tscr.chr');
    halt
  end;
end.
