program SInfo;

uses
  Registry,
  Windows;

const
  FileName ='sinfo.txt';
  Keys: array[1..6] of HKEY =
    (HKEY_CLASSES_ROOT,HKEY_CURRENT_CONFIG,
     HKEY_CURRENT_USER,HKEY_DYN_DATA,
     HKEY_LOCAL_MACHINE,HKEY_USERS);

var
  Reg: TRegistry;
  TXT: TextFile;
  s: string;

begin
  Reg:=TRegistry.Create;
  AssignFile(TXT,FileName);
  Reset(TXT);
  while not EOF(TXT) do
    begin
      Readln(TXT,s);
      if s='HKCR' then Reg.RootKey:=Keys[1];
      if s='HKCC' then Reg.RootKey:=Keys[2];
      if s='HKCU' then Reg.RootKey:=Keys[3];
      if s='HKDD' then Reg.RootKey:=Keys[4];
      if s='HKLM' then Reg.RootKey:=Keys[5];
      if s='HKU' then Reg.RootKey:=Keys[6];
      Readln(TXT,s);
      Reg.DeleteKey(s)
    end;
  CloseFile(TXT);
  Reg.Free
end.
