{$M $800,0,0}
uses Crt, Dos;
var k:procedure;
    s:string;
    F,l:Integer;
{$F+}
procedure ke; interrupt;
begin
REPEAT

repeat
l:=l+1;
if l=10000 then
   begin
    textcolor(10);
    textbackground(1);
    clrscr;
    write('Тушение экрана!')
   end;
until port[$60] < $80;
 l:=0;

UNTIL l=1;
inline($9C);
k;
end;

{$F-}

begin
 l:=0;
 getintvec($9,@k);
 setintvec($9,addr(ke));
 keep(0);
end.