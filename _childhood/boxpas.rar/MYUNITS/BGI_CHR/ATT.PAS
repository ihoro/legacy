{ (C) OIV Company Ltd. 18.06.2000 }
unit Att;
Interface
Implementation
uses Graph;
procedure AttDriver;external;
{$L att.obj}
begin
if RegisterBGIDriver(@AttDriver)<0 then
  begin
    writeln('�訡�� �� ॣ����樨 �ࠩ��� att.bgi');
    halt
  end
end.