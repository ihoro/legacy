{$M $800,0,0}
uses crt,dos;
var k:procedure;
    fil:text;

    s:strinG;F,l:Integer;
{$F+}
procedure ke; interrupt;
begin

if port[$60] < $80 then
begin
       l:=l+1;

       if l=20 then
 begin
       getdir(0,s);
       l:=0;
       if s='d:\pas55' then
             begin
               sound(5000); delay(200);nosound
             end;


 end;
end;
inline($9C);
k;
end;
{$F-}
begin
 l:=0; getdir(0,s);
 getintvec($9,@k);
 setintvec($9,addr(ke));
 keep(0);
end.