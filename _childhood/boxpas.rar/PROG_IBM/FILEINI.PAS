uses Dos;
var f:text;
    l:integer;
begin
Assign(f,'file.ini');
Rewrite(f);
for l:=32 to 255 do write(f,chr(l));
Close(f);
writeln('Готово!')
end.