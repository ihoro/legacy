var f: file of byte;
    size: longint;
    p:string;
begin
read(p);
writeln('size-',length(p));
read(p);
Assign(f,ParamStr(1));
Reset(f);
size:= FileSize(f);
writeln('ࠧ���-',size);
seek(f,size div 2);
writeln('c����-',filePos(f));
close(f)
end.