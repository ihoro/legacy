uses crt;
var f,l:integer;
begin
for l:= 1 to 50 do
for f:= 1 to 15 do
begin
 textcolor(f);
 gotoxy(35,12);
 delay(40);
 write('OIV Company Ltd.')
end;
readln
end.