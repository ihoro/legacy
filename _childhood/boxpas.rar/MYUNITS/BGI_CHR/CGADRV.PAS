{ (C) OIV Company Ltd. 18.06.2000 }
unit CGADrv;
Interface
Implementation
uses Graph;
procedure CGADriver;external;
{$L cgadrv.obj}
begin
if RegisterBGIDriver(@CGADriver)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 �ࠩ��� cga.bgi');
    halt
  end
end.