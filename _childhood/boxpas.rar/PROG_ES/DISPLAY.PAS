{$M $800,0,0 }
uses Crt, Dos;
var
  KbdIntVec : Procedure;
  l,f:LongInt;
{$F+}
procedure Keyclick; interrupt;
begin
  if Port[$60] < $80 then l:=0;
  {if not Port[$60] < $80 then} l:=l+1;
  if l=5 then
    begin
      textcolor(10);
      gotoxy(25,12);write('Гашение экрана!');
      Sound(5000);
      Delay(110);
      Nosound;
      repeat
      until Port[$60] < $80;
      l:=0;
    end;
  inline ($9C);
  KbdIntVec;
end;
{$F-}
begin
  l:=0;
  GetIntVec($9,@KbdIntVec);
  SetIntVec($9,Addr(Keyclick));
  Keep(0)
end.

