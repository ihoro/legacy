unit Sounds;
interface
procedure SoundKey;
procedure SoundMenu;
procedure SoundEnter;
implementation
uses Crt;
procedure SoundKey;
var
   f:integer;
begin
for f:=1 to 10 do
 begin
  Sound(19400-f*150);
  Delay(35+f*4);
  NoSound
 end;
end;
procedure SoundMenu;
var
   f:integer;
begin
for f:=1 to 10 do
 begin
  Sound(8000+f*130);
  Delay(25-f);
  NoSound
 end;
end;
procedure SoundEnter;
var
   f:integer;
begin
for f:=1 to 12 do
 begin
  Sound(30+f*30);
  Delay(25-f);
  NoSound
 end;
end;
begin
end.