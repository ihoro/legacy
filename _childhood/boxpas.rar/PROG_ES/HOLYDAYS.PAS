{$M $800,0,0}
uses crt,dos,holyday;
var k:procedure;
    fil:text;
    god,mes,den,den_ned:word;
    s:strinG;x,y,F,l:Integer;
{$F+}
procedure ke; interrupt;
begin

if port[$60] < $80 then
begin
       l:=l+1;

       if l>=20 then
 begin

    if (mes=3) and (den=3) then
   begin

       papa(150,10);music;

   end;
 end
end;
inline($9C);
k;
end;
{$F-}
begin
 l:=0;
 getdate(god,mes,den,den_ned);
 getintvec($9,@k);
 setintvec($9,addr(ke));
 keep(0);
end.