program bytasm;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils;

const
  ConfigFileName:string = 'config.ini';
  cmdFile: string = 'last.cmd';
  sep = ' & ';
  str_Begin = ';modules';
  str_End = ';-';
  str_Debug = 'DEBUG';

var
  f: TextFile;
  do0,do2,do3,fp: string;  //do2 - tasm; do3 - tlink
  modules: array of string;
  Count,i: Integer;
  Catch: Boolean = false;
  debug_tasm: string = ' ';
  debug_tlink: string = ' ';

begin
  if ParamCount=0 then
    Exit;
  if ParamCount>1 then
    if UpperCase(ParamStr(2))=str_Debug then
      begin
        debug_tasm:=' /zi ';
        debug_tlink:=' /v ';
      end;

  Count:=0;
  SetLength(modules,Count);
  fp:=ExtractFilePath(ParamStr(1));
  AssignFile(f,ParamStr(1));
  Reset(f);
  while not EOF(f) do
    begin
      Readln(f,do0);
      if not Catch and (do0=str_Begin) then
        begin
          Catch:=true;
          Continue
        end;
      if Catch then
        if do0=str_End then
          Break
        else
          begin
            inc(Count);
            SetLength(modules,Count);
            Delete(do0,1,1);
            modules[Count-1]:=fp+do0
          end
    end;
  CloseFile(f);

  // read config:
  AssignFile(f,ExtractFilePath(ParamStr(0))+ConfigFileName);
  Reset(f);
  Readln(f,do2);
  Readln(f,do3);
  CloseFile(f);

  //create cmd's file:
  AssignFile(f,ExtractFilePath(ParamStr(0))+cmdFile);
  Rewrite(f);

  //make cmd's string:
  Writeln(f,'cd /d '+ExtractFilePath(ParamStr(1)));
  Writeln(f,do2+debug_tasm+ParamStr(1)+','+copy(ParamStr(1),1,Length(ParamStr(1))-4)+
    ','+copy(ParamStr(1),1,Length(ParamStr(1))-4));
  if Count<>0 then
  for i:=0 to Count-1 do
    begin
      Writeln(f,'cd /d '+ExtractFilePath(modules[i]));
      Writeln(f,do2+debug_tasm+modules[i]+','+copy(modules[i],1,Length(modules[i])-4)+
        ','+copy(modules[i],1,Length(modules[i])-4))
    end;
  do0:=do3+debug_tlink+copy(ParamStr(1),1,Length(ParamStr(1))-4);
  if Count<>0 then
  for i:=0 to Count-1 do
    do0:=do0+'+'+copy(modules[i],1,Length(modules[i])-4);
  do0:=do0+','+copy(ParamStr(1),1,Length(ParamStr(1))-4);
  Writeln(f,do0);

  CloseFile(f);
//  WinExec(PAnsiChar(ExtractFilePath(ParamStr(0))+cmdFile),SW_HIDE)
end.
