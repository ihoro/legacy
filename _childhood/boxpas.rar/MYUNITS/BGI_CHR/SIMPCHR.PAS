{ (C) OIV Company Ltd. 18.06.2000 }
unit SimpChr;
Interface
Implementation
uses Graph;
procedure SimpFont;external;
{$L simp.obj}
begin
if RegisterBGIFont(@SimpFont)<0 then
  begin
    writeln('Ошибка при регистрации шрифта Simp.chr');
    halt
  end;
end.
