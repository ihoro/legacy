unit UpString;
Interface
function UpStr(s:string):string;
Implementation
function UpStr(s:string):string;
var f:integer;
begin
for f:=1 to Length(s) do
  s[f]:=UpCase(s[f]);
UpStr:=s
end;
end.