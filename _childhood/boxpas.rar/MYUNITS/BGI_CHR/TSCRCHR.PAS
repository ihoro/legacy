{ (C) OIV Company Ltd. 18.06.2000 }
unit TscrChr;
Interface
Implementation
uses Graph;
procedure TscrFont;external;
{$L tscr.obj}
begin
if RegisterBGIFont(@TscrFont)<0 then
  begin
    writeln('Ошибка при регистрации шрифта Tscr.chr');
    halt
  end;
end.
