{ (C) OIV Company Ltd. 18.06.2000 }
unit TrirChr;
Interface
Implementation
uses Graph;
procedure TrirFont;external;
{$L trir.obj}
begin
if RegisterBGIFont(@TrirFont)<0 then
  begin
    writeln('Ошибка при регистрации шрифта Trir.chr');
    halt
  end;
end.
