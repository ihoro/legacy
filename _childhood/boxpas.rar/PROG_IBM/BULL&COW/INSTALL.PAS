{$M 8192,0,0}
uses Dos, Crt;
var c:string;
procedure comdos(s:string);
begin
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C '+s);
  SwapVectors;
  if DosError <> 0 then
  WriteLn('Could not execute COMMAND.COM')
end;
begin
textbackground(0);
clrscr;
textcolor(0);
comdos('instzip.exe -d -s010585 bull&cow.zip');
GetDir(0,c);
comdos('cpas.exe -e'+c+'\bull&cow -l '+c+'\bull&cow\sounds.pas');
comdos('cpas.exe -e'+c+'\bull&cow -l '+c+'\bull&cow\bull&cow.pas');
comdos('del '+c+'\bull&cow\*.pas');
comdos('del '+c+'\bull&cow\eventman.tpu');
comdos('del '+c+'\bull&cow\extobj.tpu');
comdos('del '+c+'\bull&cow\grdriver.tpu');
comdos('del '+c+'\bull&cow\images.tpu');
comdos('del '+c+'\bull&cow\lowgraph.tpu');
comdos('del '+c+'\bull&cow\memory.tpu');
comdos('del '+c+'\bull&cow\objects.tpu');
comdos('del '+c+'\bull&cow\strings.tpu');
comdos('del '+c+'\bull&cow\xms.tpu ');
textcolor(9);
writeln('Инсталляция закончена!');
textcolor(7)
end.
