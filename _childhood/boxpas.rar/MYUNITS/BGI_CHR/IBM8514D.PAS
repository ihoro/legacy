{ (C) OIV Company Ltd. 18.06.2000 }
unit IBM8514D;
Interface
Implementation
uses Graph;
procedure IBM8514Driver;external;
{$L ibm8514d.obj}
begin
if RegisterBGIDriver(@IBM8514Driver)<0 then
  begin
    writeln('Ошибка при регистрации драйвера ibm8514.bgi');
    halt
  end
end.