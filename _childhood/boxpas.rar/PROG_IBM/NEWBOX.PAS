{$M 14000,0,0}
uses Dos;
var s:string;
procedure command(s:string);
begin
Exec(GetEnv('COMSPEC'),'/c '+s)
end;
begin
GetDir(0,s);
command('move /y c:\tp\bin\abox\boxpas.exe c:\tp\bin\bakfiles');
command('c:');
command('cd\tp\bin\abox');
command('rar a -sfx -r -rr[N] -pOIVCompany010585 c:\tp\bin\abox\boxpas.exe *.*');
command('cd '+s)
end.