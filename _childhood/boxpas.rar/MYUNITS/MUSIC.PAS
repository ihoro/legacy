uses Crt;
var
    F:Word;
procedure PlaySound(Hz:Word;Time:Word);
begin
Sound(Hz);
Delay(Time);
NoSound
end;
procedure PlayMusic;
begin
end;
procedure SoundEnter;
begin
PlaySound
for F:=1 to 10 do PlaySound(90+F*12,11-F);
end;
begin
SoundEnter
end.