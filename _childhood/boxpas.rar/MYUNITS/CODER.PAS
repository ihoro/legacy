unit Coder;
Interface
function CoderStr(s:string;Key:Integer):string;
Implementation
function CoderStr(s:string;Key:Integer):string;
var f:integer;
begin
if s='' then
  begin
    CoderStr:='';
    Exit
  end;
for f:=1 to Length(s) do
  s[f]:=chr(ord(s[f])+Key);
CoderStr:=s
end;
end.