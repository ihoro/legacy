program M_Olymp84_7;
var
    a:array[1..100,1..100] of byte;
    m,f,l:byte;
    k:word;
    v:set of byte;
    Yes:Boolean;
begin
write('m=');readln(m);
for l:=1 to m do
  for f:=1 to m do
    begin
      write('a[',l,',',f,']=');
      readln(a[l,f])
    end;
k:=0;
for l:=1 to m-1 do
  for f:=1 to m-1 do
    begin
      v:=[];
      Yes:=true;
      if not (a[l,f] in v) then v:=v+[a[l,f]]
                           else Yes:=false;
      if not (a[l,f+1] in v) then v:=v+[a[l,f+1]]
                             else Yes:=false;
      if not (a[l+1,f+1] in v) then v:=v+[a[l+1,f+1]]
                               else Yes:=false;
      if not (a[l+1,f] in v) then v:=v+[a[l+1,f]]
                             else Yes:=false;
      if Yes then k:=k+1
    end;
writeln('Количество квадратиков: ',k);
readln
end.