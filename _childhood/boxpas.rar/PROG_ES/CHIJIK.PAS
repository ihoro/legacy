uses crt;
var f:byte;
procedure doo; BEGIN sound(523); delay(500); nosound; delay(20) END;
procedure re;  BEGIN sound(587); delay(500); nosound; delay(20) END;
procedure mi;  BEGIN sound(659); delay(500); nosound; delay(20) END;
procedure fa;  BEGIN sound(698); delay(500); nosound; delay(20) END;
procedure sol; BEGIN sound(784); delay(500); nosound; delay(20) END;
procedure la;  BEGIN sound(880); delay(500); nosound; delay(20) END;
procedure si;  BEGIN sound(988); delay(500); nosound; delay(20) END;
begin
 f:=1;
 repeat
  if f=1 then mi;
  if f=2 then doo;
  if f=3 then mi;
  if f=4 then doo;
  if f=5 then fa;
  if f=6 then mi;
  if f=7 then re;
  if f=8 then sol;
  if f=9 then sol;
  if f=10 then la;
  if f=11 then si;
  if f=12 then doo;
  if f=13 then doo;
  if f=14 then doo;
  f:=f+1; if f=15 then f:=1;
 until keypressed
end.