{ (C) OIV Company Ltd. 18.06.2000 }
unit EuroChr;
Interface
Implementation
uses Graph;
procedure EuroFont;external;
{$L euro.obj}
begin
if RegisterBGIFont(@EuroFont)<0 then
  begin
    writeln('Ошибка при регистрации шрифта Euro.chr');
    halt
  end;
end.
