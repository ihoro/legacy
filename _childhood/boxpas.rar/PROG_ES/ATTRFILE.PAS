uses WinDos;

var
  F: file;
  Attr: Word;
  c:string;
begin
Readln(c);
  Assign(F,c);
  GetFAttr(F, Attr);
  Writeln(c);
  if DosError <> 0 then
    Writeln('DOS error code = ', DosError)
  else
  begin
    Writeln('Attribute = ', Attr);
    if Attr and faReadOnly <> 0 then
      Writeln('Read only file');
    if Attr and faHidden <> 0 then
      Writeln('Hidden file');
    if Attr and faSysFile <> 0 then
      Writeln('System file');
    if Attr and faVolumeID <> 0 then
      Writeln('Volume ID');
    if Attr and faDirectory <> 0 then
      Writeln('Directory name');
    if Attr and faArchive <> 0 then
      Writeln('Archive (normal file)');
  end; { else }
readln
end.