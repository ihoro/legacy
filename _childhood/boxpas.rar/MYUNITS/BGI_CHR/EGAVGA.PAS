{ (C) OIV Company Ltd. 18.06.2000 }
unit EgaVga;
Interface
Implementation
uses Graph;
procedure EgaVgaDriver;external;
{$L egavga.obj}
begin
if RegisterBGIDriver(@EgaVgaDriver)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 �ࠩ��� EgaVga.bgi');
    halt
  end
end.