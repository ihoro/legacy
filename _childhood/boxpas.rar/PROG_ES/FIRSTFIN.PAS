uses Crt, Dos, WinDos;
var
  List:array[1..60] of array[1..60] of string[12];
  Files:array[1..400] of record
                           name:string[12];
                           at:byte
                         end;
  Info: TSearchRec;
  TotalList:byte;
  Total:word;
  F:integer;
procedure FindFile;
begin
  total:=0;
  FindFirst('*.*',faAnyFile,Info);
  while DosError=0 do
  begin
    total:=total+1;
    with Files[total] do
    begin
      Name:=Info.Name;
      if Info.Attr and faReadOnly<>0 then at:=1;
      if Info.Attr and faHidden<>0 then at:=2;
      if Info.Attr and faSysFile<>0 then at:=3;
      if Info.Attr and faVolumeID<>0 then at:=4;
      if Info.Attr and faDirectory<>0 then at:=5;
      if Info.Attr and faArchive<>0 then at:=6;
      if Info.Attr and faAnyFile<>0 then at:=7
    end;
    FindNext(Info)
  end;
end;
begin
TotalList:=0;
FindFile;
if total<>0 then
begin
TotalList:=TotalList+1;
for f:=1 to total
end;
end.
