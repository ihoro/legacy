program transys;

uses
  Windows;

const
  Ext: string = '.tsf';

var
  sour, dest: file of Byte;
  FileName: string;
  Data, Data2, w: Byte;
  f, fs: Integer;
begin
  if ParamCount=0 then
    halt;
  FileName:=ParamStr(1);
  if Copy(FileName,Length(FileName)-3,4)=Ext then
    Ext:='.dsf';
  AssignFile(sour,FileName);
  AssignFile(dest,Copy(FileName,1,Length(FileName)-4)+Ext);
  Reset(sour);
  fs:=FileSize(sour);
  ReWrite(dest);
  w:=0;
  for f:=1 to fs do
    begin
      Read(sour,Data);
      Data2:=Data;
      if Data2 and (1 shl 7)=128 then
        Data2:=Data2 and $7F
                               else
        Data2:=Data2 or (1 shl 7);
      Write(dest,Data2);
      if Round(30*f/fs)>w then
       begin
         inc(w)
       end
    end;
  CloseFile(sour);
  CloseFile(dest)
end.
