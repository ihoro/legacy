{$M 8192,0,0}
uses Dos;
procedure doscom(s:string);
begin
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C '+s);
  SwapVectors;
  if DosError <> 0 then
  WriteLn('Could not execute COMMAND.COM')
end;
begin
doscom('pkzip.exe -r -p -sMyBoxOfPasPrograms boxpas');
writeln('Ok!')
end.
