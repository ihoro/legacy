{$M $800,0,0 }
uses Crt, Dos;
type
     Cell = record
              Symbol:Char;
              Color:Byte
            end;
     Display = array[1..25,1..80] of Cell;
var
  Dis:Display absolute $0000:$B800;
  Soh:^Display;
  KbdIntVec:procedure;
  l,f:LongInt;
  dc,dm,fx,fy:byte;
procedure CurrentTime(chas,min:byte);
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
chas:=(chas div 16)*10+chas mod 16;
min:=(min div 16)*10+min mod 16
end;

{$F+}
procedure Keyclick; interrupt;
var
    x,y,chas,min,c,m:byte;
procedure Face;
var f,l:integer;
begin
for l:=fy to fy+5 do
  for f:=fx to fx+4 do
    begin
    end;
Soh^:=Dis;

end;
procedure CurrentTime(chas,min:byte);
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
chas:=(chas div 16)*10+chas mod 16;
min:=(min div 16)*10+min mod 16
end;
begin
CurrentTime(c,m);
if (c<>dc) or (m<>dm) then
  begin
    Face;
    dc:=c;
    dm:=m
  end;
{x:=WhereX;
y:=WhereY;
gotoxy(1,1);
write(c,':',m);
gotoxy(x,y);}
inline ($9C);
KbdIntVec;
end;
{$F-}
begin
  {write('Час: ');
  readln(dc);
  write('Минуты: ');
  readln(dm);}
  randomize;
  new(soh);
  fx:=random(76)+1;
  fy:=random(20)+1;
  CurrentTime(dc,dm);
  l:=0;
  GetIntVec($8,@KbdIntVec);
  SetIntVec($8,Addr(Keyclick));
  Keep(0)
end.

