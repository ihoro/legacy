uses Dos, Crt;
{program CopyBmpFile;}
{ Simple, fast file copy program with NO error-checking }
var
  FromF, ToF: file;
  s,c:string;
  NumRead, NumWritten: Word;
  Buf: array[1..2048] of Char;
begin
  writeln;
  write('Input file: ');
  readln(s);
  write('Output file: ');
  readln(c);
  Assign(FromF,s); { Open input file }
  Reset(FromF, 1);  { Record size = 1 }
  Assign(ToF,c); { Open output file }
  Rewrite(ToF, 1);  { Record size = 1 }
  Writeln('Copying ', FileSize(FromF), ' bytes...');
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  Close(FromF);
  Close(ToF);
  writeln('Ok!')
end.