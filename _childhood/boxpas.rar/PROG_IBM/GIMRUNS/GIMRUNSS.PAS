{$M 4000,0,0}
uses Dos;
const
      ExtTemp = '.$im';
var
    TFile:SearchRec;
    DelFile:text;
procedure Command(s:string);
begin
SwapVectors;
Exec(GetEnv('COMSPEC'),'/C '+s);
SwapVectors
end;
begin
Command('ren gimruns.uni start.exe');
Command('start.exe');
Command('ren start.exe gimruns.uni');
FindFirst('*'+ExtTemp,AnyFile,TFile);
  while DosError=0 do
    begin
      Assign(DelFile,TFile.Name);
      Erase(DelFile);
      FindNext(TFile)
    end;
Command('cls');
Command('ren screen.uni screen.exe');
Command('screen.exe');
Command('ren screen.exe screen.uni')
end.