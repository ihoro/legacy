uses WinCrt;
var s:string;
    f:byte;
    p:PChar;
begin
s:='OIV Company Ltd.      2000';
{InactiveTitle^:='(';}
for f:=0 to Length(s)-1 do
  begin
    p:=ptr(seg(InactiveTitle^),ofs(InactiveTitle^)+f);
    p^:=s[f+1]
  end;
WindowSize.X:=300;
WindowSize.Y:=150;
writeln('нркхвмн!');
end.
