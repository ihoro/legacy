{ (C) OIV Company Ltd. 18.06.2000 }
unit LittChr;
Interface
Implementation
uses Graph;
procedure LittFont;external;
{$L litt.obj}
begin
if RegisterBGIFont(@LittFont)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 ���� Litt.chr');
    halt
  end;
end.
