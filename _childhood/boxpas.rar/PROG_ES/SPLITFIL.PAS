uses Dos;
var
  P: PathStr;
  D: DirStr;
  N: NameStr;
  E: ExtStr;
begin
  Write('Filename and path: ');
  Readln(P);
  FSplit(P, D, N, E);
writeln('Name: ',N);
writeln('Ext: ',E);
writeln('Path: ',D);
readln
end.
