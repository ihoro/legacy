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
  WriteLn;
  WriteLn('Transformation System. Copyright (c) 2003 OIVSoft.');
  WriteLn;
  WriteLn('How to Use: transys.exe FileName');
  if ParamCount=0 then
    halt;
  WriteLn;
  WriteLn('(de)Transforming...');
  WriteLn;
  WriteLn('0%           50%          100%');
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
         inc(w);
         Write('.')
       end
    end;
  WriteLn;
  Writeln('Done.');
  CloseFile(sour);
  CloseFile(dest)
end.
