{ (C) OIV Company Ltd. 18.06.2000 }
unit LcomChr;
Interface
Implementation
uses Graph;
procedure LcomFont;external;
{$L lcom.obj}
begin
if RegisterBGIFont(@LcomFont)<0 then
  begin
    writeln('Ошибка при регистрации шрифта Lcom.chr');
    halt
  end;
end.
