uses Crt;
var k:integer; b:char;
begin
for k:= 0 to 256 do begin
 writeln('k= ',k,'  $= ',chr(k));
 b:= ReadKey
 end;
 end.