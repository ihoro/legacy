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
 for f:=1 to 100 do
 begin sound(1000); delay(10); nosound end;
 doo; mi; doo; doo; re;
end.