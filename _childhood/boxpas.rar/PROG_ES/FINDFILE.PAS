uses Dos;
var
  c:string;
  S: PathStr;
begin
write(' File Name: ');
readln(c);
S:=FSearch(c,GetEnv('PATH'));
if S='' then WriteLn(c,' not found')
          else { Show full path } WriteLn('Found as ',FExpand(s));
readln
end.
