{$M $800,0,0 }
uses Crt, Dos;
var
  KbdIntVec : Procedure;
  l,f:LongInt;
{$F+}
procedure Keyclick; interrupt;
begin
  if Port[$60] = $1C then
    begin
    l:=l+1;
    for f:=1 to l do
    begin
      gotoxy(Random(72)+1,Random(25)+1);
      textcolor(Random(15)+1);
      write('Энтерок!');
      Sound(5000);
      Delay(110);
      Nosound
    end;
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

