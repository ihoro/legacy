{ (C) OIV Company Ltd. 18.06.2000 }
unit SansChr;
Interface
Implementation
uses Graph;
procedure SansFont;external;
{$L sans.obj}
begin
if RegisterBGIFont(@SansFont)<0 then
  begin
    writeln('Ошибка при регистрации шрифта Sans.chr');
    halt
  end;
end.
