program M_Olymp80_1_1;
var
    p:array[1..600] of word;
    k,f,m,t,l:word;
function Ok(k:word):Boolean;
var f:word;
begin
Ok:=true;
if k div 2>t then l:=t
             else l:=k div 2;
for f:=2 to l do
  if (k/p[f])=trunc(k/p[f]) then
    begin
      Ok:=false;
      exit
    end
end;
begin
write('m=');readln(m);
p[1]:=1; p[2]:=2;
k:=2;
t:=2;
repeat
k:=k+1;
if not odd(k) then k:=k+1;
if k>m then k:=m;
if Ok(k) then
  begin
    t:=t+1;
    p[t]:=k
  end;
until k>=m;
for l:=0 to t div 15 do
  for f:=l*15+1 to l*15+15 do
    begin
      if f=l*15+15 then writeln(p[f])
                   else write(p[f],' ');
      if p[f+1]=0 then
        begin
          f:=l*15+15;
          l:=t div 15
        end
    end;
readln
end.