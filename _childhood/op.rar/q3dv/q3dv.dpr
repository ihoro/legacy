program q3dv;

//{$APPTYPE CONSOLE}

uses
  Windows, Registry, SysUtils, classes;

var
  reg: TRegistry;
  rar,q3,q3dir,cfg,curdir,q3d,q3d_filename,dext: string;
  done: Boolean;
  
  pkey: string = 'software\OIVSoft\q3dv';
  tempd: string = 'q3dv_tempdemo.dm_68';

function CopyFile(InFile,OutFile: String; From,Count: Longint): Longint;
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
  if ParamCount=0 then
    begin
      MessageBox(0,'use:  q3dv.exe [*.q3d | *.*]','q3dv',MB_OK+MB_ICONINFORMATION);
      Exit;
    end;
  q3d:=ParamStr(1);
  if not FileExists(q3d) then
    begin
      MessageBox(0,'no such file!','q3dv error',MB_OK+MB_ICONERROR);
      Exit
    end;
  q3d_filename:=ExtractFileName(q3d);
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  if not reg.OpenKey(pkey,false) then
    begin
      MessageBox(0,'registry error. use q3dvs.exe for setup.','q3dv error',MB_OK+MB_ICONERROR);
      Exit
    end;
  curdir:=ExtractFileDir(ParamStr(0));
  q3:=reg.ReadString('q3');
  q3dir:=ExtractFileDir(q3);
  rar:=reg.ReadString('rar');
  cfg:=reg.ReadString('cfg');
  if (not FileExists(q3)) or (not FileExists(rar)) or (not FileExists(cfg)) then
    begin
      MessageBox(0,'no settings. use q3dvs.exe for setup.','q3dv error',MB_OK+MB_ICONERROR);
      Exit
    end;

  DeleteFile(q3dir+'\osp\demos\'+tempd);
  winexec(PChar(rar+' e -inul -o+ '+q3d+' '+q3dir+'\osp\demos'),0);
  done:=false;
  repeat
    if FileExists(q3dir+'\osp\demos\'+ChangeFileExt(q3d_filename,'.dm_67')) then
      begin
        dext:='.dm_67';
        done:=true
      end;
    if FileExists(q3dir+'\osp\demos\'+ChangeFileExt(q3d_filename,'.dm_68')) then
      begin
        dext:='.dm_68';
        done:=true
      end
  until done;
  Sleep(1000);
  RenameFile(q3dir+'\osp\demos\'+ChangeFileExt(q3d_filename,dext),q3dir+'\osp\demos\'+tempd);
  //rar:=q3dir+'\osp\demos\'+tempd;
  {done:=false;
  repeat
    if FileExists(q3dir+'\osp\demos\'+tempd) then
      done:=true
  until done;}

  CopyFile(cfg,q3dir+'\osp\q3dv_cfg.cfg',0,0);

//  quake3.exe +cvar_restart +set fs_game osp +exec d:\1.cfg +vid_restart +demo somedemo

  ChDir(q3dir);
  winexec(PChar(q3+' +cvar_restart +set fs_game osp +exec q3dv_cfg.cfg +vid_restart +demo '+tempd),1);

  reg.Free
end.
