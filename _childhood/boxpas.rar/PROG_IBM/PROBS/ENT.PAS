{$M $800,0,0 }
uses Crt, Dos;
var
  KbdIntVec : Procedure;
  l,f:LongInt;
  dc,dm:byte;
{$F+}
procedure Keyclick; interrupt;
var
    x,y,chas,min,c,m:byte;
begin
asm
MOV AL,4H
OUT 70H,AL
IN AL,71H
MOV CHAS,AL
MOV AL,2H
OUT 70H,AL
IN AL,71H
MOV MIN,AL
end;
c:=(chas div 16)*10+chas mod 16;
m:=(min div 16)*10+min mod 16;
x:=WhereX;
y:=WhereY;
gotoxy(1,1);
write(c,':',m);
gotoxy(x,y);
inline ($9C);
KbdIntVec;
end;
{$F-}
begin
  {write('Час: ');
  readln(dc);
  write('Минуты: ');
  readln(dm);}
  dc:=0;dm:=0;
  l:=0;
  GetIntVec($8,@KbdIntVec);
  SetIntVec($8,Addr(Keyclick));
  Keep(0)
end.

