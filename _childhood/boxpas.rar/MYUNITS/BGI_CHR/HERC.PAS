{ (C) OIV Company Ltd. 18.06.2000 }
unit Herc;
Interface
Implementation
uses Graph;
procedure HercDriver;external;
{$L herc.obj}
begin
if RegisterBGIDriver(@HercDriver)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 �ࠩ��� herc.bgi');
    halt
  end
end.