{$M 8192,0,0}
uses Dos;
var command,s,maindir:string;
    fil:text;
    heops,
    com
    :boolean;
procedure doscom(s:string);
begin
SwapVectors;
Exec(GetEnv('COMSPEC'),'/C '+s);
SwapVectors;
if DosError <> 0 then
  WriteLn('Could not execute COMMAND.COM')
end;
function srez(s:string):string;
var f:word;
begin
for f:=1 to Length(s) do
  if s[f]=' ' then Delete(s,f,1);
srez:=s
end;
begin
heops:=false;
GetDir(0,maindir);
maindir:=maindir+'\KLAD';
doscom('md '+maindir);
Assign(fil,maindir+'\begin.txt');
Rewrite(fil);
writeln(fil,'  Дорогой друг! Тебя ждет долгое и опасное путешествие');
writeln(fil,'в поисках клада. Если ты готов, отправляйся на  конти-');
writeln(fil,'нент(каталог), где течет великий Нил и живет  страшный');
writeln(fil,'Бармалей. Найди и прочитай там файл, имя которого под-');
writeln(fil,'ходит под маску ?i?.?x?');
Close(fil);
doscom('md '+maindir+'\AFRICA');
doscom('md '+maindir+'\AFRICA\HEOPS');
Assign(fil,maindir+'\AFRICA\nil.txt');
Rewrite(fil);
writeln(fil,'  Найди и прочитай заклинание, которое открывает вход');
writeln(fil,'в пирамиду Хеопса! Оно находится в стране кенгуру!');
Close(fil);
Assign(fil,maindir+'\AFRICA\sfinx.txt');
Rewrite(fil);
writeln(fil,'  Класс! Первый раз в жизни я увидел сфинкса!');
Close(fil);
Assign(fil,maindir+'\AFRICA\read.me');
Rewrite(fil);
writeln(fil,'  Пока есть шанс, погуляй по Африке!');
Close(fil);
Assign(fil,maindir+'\AFRICA\kair.doc');
Rewrite(fil);
writeln(fil,'  Город как город!');
Close(fil);

doscom('md '+maindir+'\AUSTRAL');
Assign(fil,maindir+'\AUSTRAL\magic.txt');
Rewrite(fil);
writeln(fil,'  Заклинание: bamphltionuffaire do!');
Close(fil);
Assign(fil,maindir+'\AUSTRAL\jungle.doc');
Rewrite(fil);
writeln(fil,'  Бродя по джунглям, вы выпили все запасы воды!');
writeln(fil,'Если вы не найдете воду, то умрете от жажды!');
Close(fil);
REPEAT
repeat
Getdir(0,s);
write(s+'>');
readln(command);
until command<>'';
com:=true;
if command='exit' then com:=false;
if (upcase(srez(command))='DIRHEOPS') and (upcase(s)=(upcase(maindir)+'\AFRICA'))
   and (heops=false) then
    begin
     com=false;
     writeln('  Вход в пирамиду Хеопса закрыт!')
    end;
if com then
begin
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C '+command);
  SwapVectors;
  if DosError <> 0 then
    WriteLn('Could not execute COMMAND.COM')
end;
UNTIL command='exit';
end.