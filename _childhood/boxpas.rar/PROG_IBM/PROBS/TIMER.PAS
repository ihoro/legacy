uses crt;
var
    CHAS,MIN:Byte;
begin
{Port[$70]:=5;
ch:=Port[$71];
Port[$70]:=3;
m:=Port[$71];}
repeat
asm
MOV AL,9H
OUT 70H,AL
IN AL,71H
MOV CHAS,AL
{MOV AL,9H
OUT 70H,AL
IN AX,71H
MOV MIN,AX}
end;
{min:=(chas div 16)*10+chas mod 16;}
write(chas);
until KeyPressed;
end.