{ (C) OIV Company Ltd. 18.06.2000 }
unit PC3270D;
Interface
Implementation
uses Graph;
procedure PC3270Driver;external;
{$L pc3270d.obj}
begin
if RegisterBGIDriver(@PC3270Driver)<0 then
  begin
    writeln('Ошибка при регистрации драйвера pc3270.bgi');
    halt
  end
end.