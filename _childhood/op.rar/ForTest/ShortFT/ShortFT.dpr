program ShortFT;

uses
  SysUtils;

const
  AddText = '     ';
  TempExt = '$';
  FindMask = '*.tst';

var
  sfer,sfew: TextFile;
  s,d: string;
  m,o: array[1..5] of string;
  Total,f: Byte;

procedure FoundFile(AFileName: string);
begin
  AssignFile(sfer,AFileName);
  AssignFile(sfew,AFileName+TempExt);
  Reset(sfer);
  Rewrite(sfew);
  while not EOF(sfer) do
    begin
      Total:=0;
      readln(sfer,s);
      if Length(s)>=7 then
        if (Copy(s,1,7)='Variant') and (Total=0) then
          begin
            m[1]:=s;
            for f:=2 to 5 do
              readln(sfer,m[f]);
            for f:=1 to 5 do
              begin
                readln(sfer,o[f]);
                if o[f][Length(o[f])]='1' then
                  if Copy(m[f],Length(m[f])-Length(AddText)+1,
                    Length(AddText))<>AddText then
                    m[f]:=m[f]+AddText
              end;
            for f:=1 to 5 do
              writeln(sfew,m[f]);
            for f:=1 to 5 do
              writeln(sfew,o[f])
          end
                                                 else
          writeln(sfew,s)
    end;
  CloseFile(sfer);
  Erase(sfer);
  CloseFile(sfew);
  Rename(sfew,AFileName)
end;

procedure FindFiles(ADir: string;AMask: string);
var
  SearchRec, DirSearchRec: TSearchRec;
  FindResult: Integer;

  function IsDirNotation(ADir: string): Boolean;
  begin
    Result:=(ADir='.') or (ADir='..')
  end;

begin
  FindResult:=FindFirst(ADir+'\'+AMask,faAnyFile,SearchRec);
  try
    while FindResult=0 do
      begin
        FoundFile(ADir+'\'+SearchRec.Name);
        FindResult:=FindNext(SearchRec)
      end;
    FindResult:=FindFirst(ADir+'\*.*',
      faDirectory,DirSearchRec);
    while FindResult=0 do
      begin
        if ((DirSearchRec.Attr and faDirectory)=faDirectory) and
          not IsDirNotation(DirSearchRec.Name) then
          FindFiles(ADir+'\'+DirSearchRec.Name,AMask);
        FindResult:=FindNext(DirSearchRec)
      end
  finally
    FindClose(SearchRec)
  end
end;

begin
  GetDir(0,d);
  FindFiles(ExtractFileDrive(d),FindMask)
end.
