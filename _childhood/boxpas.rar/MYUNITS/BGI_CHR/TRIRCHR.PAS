{ (C) OIV Company Ltd. 18.06.2000 }
unit TrirChr;
Interface
Implementation
uses Graph;
procedure TrirFont;external;
{$L trir.obj}
begin
if RegisterBGIFont(@TrirFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Trir.chr');
    halt
  end;
end.
