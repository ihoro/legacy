uses Dos, Crt, DirFiles;
Label Start, MiniStart;
const
    Key=24;
    Symbols:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'+
                      '€…๐‘’“”•–— กขฃคฅ๑ฆงจฉชซฌญฎฏเแโใไๅๆ็่้์๋๊ํ๎๏'+
                      '1234567890~&@^{}\<>|[]()-/":,._?%!*; '+#8+#13+#0;
    FileSymbols:String='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'+
                       '1234567890-_$#&@!%(){}`~^'+#13+#8;
var
    kol:array[1..36] of string;
    finame:array[1..500] of string[12];
    granica:array[1..36] of byte;
    h:char;
    nomer,zap:LongInt;
    nomerf,freefiles:word;
    fil:text;
    dl,shirina,ydlina,xx,y,r,t,nkol:byte;
    d,f,l,err:integer;
    OkNo:boolean;
    stolb,nametabl:string[78];
    s,c,namefile,password:string;
    kolon:array[1..36] of
      record
       mesto:byte;
       name:string[72];
       {x:byte}
      end;
procedure WhoFile(n,nf:word);
begin
textcolor(10);textbackground(0);
for f:=4 to 24 do
  begin
    gotoxy(35,f);
    write('บ        บ')
  end;
textcolor(11);
l:=4;
if (n+20)>freefiles then d:=freefiles
                    else d:=n+20;
for f:=n to d do
  begin
    gotoxy(36,l);
    if nf=f then begin textbackground(12);textcolor(14) end
            else begin textbackground(0);textcolor(11) end;
    write(copy(finame[f],1,Length(finame[f])-4));
    l:=l+1
  end;
gotoxy(42,2)
end;
function ReadDirFiles:string;
begin
ReadFiles;
l:=1;
for f:=1 to free do if (copy(files[f].name,Length(files[f].name)-3,4)='.DBT')
  and (Length(files[f].name)>4) then
   begin
    finame[l]:=files[f].name;
    l:=l+1
   end;
freefiles:=l-1;
clrscr;
textcolor(11);
gotoxy(21,8);
write('ÛÛÛÛÛÛÛ  ÛÛ  ÛÛ       ÛÛÛÛÛÛÛ   ÛÛÛÛÛÛ');
gotoxy(21,9);
write('ÛÛ   ÛÛ      ÛÛ       ÛÛ       ÛÛ');
gotoxy(21,10);
write('ÛÛ       ÛÛ  ÛÛ       ÛÛ       ÛÛ');
gotoxy(21,11);
write('ÛÛ       ÛÛ  ÛÛ       ÛÛÛÛÛ     ÛÛÛÛÛ');
textcolor(14);
gotoxy(21,12);
write('ÛÛÛÛ     ÛÛ  ÛÛ       ÛÛ            ÛÛ');
gotoxy(21,13);
write('ÛÛ       ÛÛ  ÛÛ       ÛÛ            ÛÛ');
gotoxy(21,14);
write('ÛÛ       ÛÛ  ÛÛ   ÛÛ  ÛÛ            ÛÛ');
gotoxy(21,15);
write('ÛÛ       ÛÛ  ÛÛÛÛÛÛÛ  ÛÛÛÛÛÛÛ  ÛÛÛÛÛÛ');
Delay(600);
textcolor(10);
gotoxy(35,1);write('ษออออออออป');Delay(50);
gotoxy(35,2);write('บ');textcolor(13);write(' *.dbt  ');textcolor(10);write('บ');Delay(50);
gotoxy(35,3);write('ฬออออออออน');Delay(50);
for f:=4 to 24 do
  begin
    gotoxy(35,f);
    write('บ        บ');
    Delay(50)
  end;
gotoxy(35,25);write('ศออออออออผ');
nomerf:=1;
y:=1;
WhoFile(y,nomerf);
REPEAT
h:=ReadKey;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#80 then
      begin
       if (((y+20)<=freefiles) and (nomerf<>y+20)) OR (((y+20)>freefiles) and (nomerf<>freefiles)) then
       begin
        nomerf:=nomerf+1;
        whofile(y,nomerf)
       end;
       if {(}((y+20)<=freefiles) and (nomerf=y+20){) OR (((y+20)>freefiles) and (nomerf=freefiles))} then
         if y<(freefiles-20) then
       begin
        nomerf:=nomerf+1;
        y:=y+1;
        whofile(y,nomerf)
       end;
      end;
    if (h=#72) and (nomerf<>y) then
      begin
        nomerf:=nomerf-1;
        whofile(y,nomerf)
      end;
    if (h=#72) and (nomerf=y) and (y<>1) then
      begin
        nomerf:=nomerf-1;
        y:=y-1;
        whofile(y,nomerf)
      end;
  end;
UNTIL (h=#13) or (h=#27);
if KeyPressed then h:=ReadKey;
clrscr;
if h=#27 then ReadDirFiles:='exit'
         else ReadDirFiles:=finame[nomerf]
end;
procedure menu;
begin
textbackground(0);
clrscr;
textcolor(11);
gotoxy(23,2);
writeln('ÛÛÛÛÛÛÛ    ÛÛÛ    ÛÛÛÛÛ      ÛÛÛ');
gotoxy(23,3);
writeln('ÛÛ        Û   Û        Û    Û   Û ');
gotoxy(23,4);
writeln('ÛÛ       ÛÛ   ÛÛ       ÛÛ  ÛÛ   ÛÛ');
gotoxy(23,5);
writeln('ÛÛÛÛÛÛ   ÛÛÛÛÛÛÛ    ÛÛÛÛ   ÛÛÛÛÛÛÛ');
textcolor(14);
gotoxy(23,6);
writeln('ÛÛ   ÛÛ  ÛÛ   ÛÛ       ÛÛ  ÛÛ   ÛÛ');
gotoxy(23,7);
writeln('ÛÛ   ÛÛ  ÛÛ   ÛÛ       ÛÛ  ÛÛ   ÛÛ');
gotoxy(23,8);
writeln('ÛÛ   ÛÛ  ÛÛ   ÛÛ       ÛÛ  ÛÛ   ÛÛ');
gotoxy(23,9);
writeln('ÛÛÛÛÛÛ   ÛÛ   ÛÛ  ÛÛÛÛÛÛ   ÛÛ   ÛÛ');
textcolor(13);
gotoxy(32,11);write('ค ญญ๋ๅ (โ กซจๆ๋)');
textcolor(10);gotoxy(36,13);write('ฅญ๎:');
gotoxy(32,15);write('เฎแฌฎโเ โ กซจๆ');
gotoxy(32,16);write('‘ฎงค ญจฅ โ กซจๆ๋');
gotoxy(32,17);write('ฅ็ โ์ โ กซจๆ๋');
gotoxy(32,18);write('‘ฎงค โ์ ไ ฉซ-โ กซจๆใ');
gotoxy(32,19);write('๋ๅฎค');
textcolor(13);gotoxy(7,24);write('(C) OIV Company Ltd.  April, 2000');
end;
procedure who(n:byte);
begin
textcolor(10);
textbackground(0);
gotoxy(32,15);write('เฎแฌฎโเ โ กซจๆ');
gotoxy(32,16);write('‘ฎงค ญจฅ โ กซจๆ๋');
gotoxy(32,17);write('ฅ็ โ์ โ กซจๆ๋');
gotoxy(32,18);write('‘ฎงค โ์ ไ ฉซ-โ กซจๆใ');
gotoxy(32,19);write('๋ๅฎค');
textcolor(14);
textbackground(12);
case n of
15:begin gotoxy(32,n);write('เฎแฌฎโเ โ กซจๆ') end;
16:begin gotoxy(32,n);write('‘ฎงค ญจฅ โ กซจๆ๋') end;
17:begin gotoxy(32,n);write('ฅ็ โ์ โ กซจๆ๋') end;
18:begin gotoxy(32,n);write('‘ฎงค โ์ ไ ฉซ-โ กซจๆใ') end;
19:begin gotoxy(32,n);write('๋ๅฎค') end
end;
textbackground(0);textcolor(13);gotoxy(7,24);write('(C) OIV Company Ltd.  April, 2000')
end;
procedure effect;
begin
textbackground(0);
for f:=1 to 80*25 do
begin
gotoxy(random(79),random(25)+1);
write('  ')
end;
clrscr
end;
procedure who2(n:byte);
begin
textcolor(10);
textbackground(0);
gotoxy(32,3);write(' งข ญจฅ โ กซจๆ๋');
gotoxy(32,4);write('ฎซฎญชจ');
gotoxy(32,5);write('๋ๅฎค');
textcolor(14);
textbackground(12);
case n of
3:begin gotoxy(32,n);write(' งข ญจฅ โ กซจๆ๋') end;
4:begin gotoxy(32,n);write('ฎซฎญชจ') end;
5:begin gotoxy(32,n);write('๋ๅฎค') end
end;
textbackground(0);textcolor(13);gotoxy(7,24);write('(C) OIV Company Ltd.  April, 2000')
end;
procedure Tabl;
begin
textcolor(10);
gotoxy(1,10);
write('ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปบ');
write('                                                                              ');
write('บศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
write('ษอออออหออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปบ');
textcolor(14);write('ฎฌฅเ');textcolor(10);write('บ                                                                        ');
write('บฬอออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน');
textcolor(14);gotoxy(41-Length(nametabl) div 2,11);write(nametabl);
gotoxy(8,14);
for l:=1 to Length(stolb) do
  if stolb[l]='บ' then
    begin
      textcolor(10);
      gotoxy(7+l,13);write('ห');
      gotoxy(7+l,15);write('ฮ');
      gotoxy(7+l,14);write(stolb[l]);
      textcolor(14)
    end
                  else write(stolb[l]);
textbackground(0);textcolor(13);gotoxy(7,24);write('(C) OIV Company Ltd.  April, 2000')
end;
procedure NameT;
begin
textcolor(10);textbackground(0);gotoxy(1,1);
write('ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปบ');
write('                                                                              ');
write('บศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
gotoxy(41-Length(nametabl) div 2,2);textcolor(14);write(nametabl)
end;
procedure Zapis;
begin
textcolor(10);textbackground(0);gotoxy(1,4);
write('ษอออออหออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปบ');
textcolor(14);write('ฎฌฅเ');textcolor(10);write('บ                                                                        ');
write('บฬอออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนบ');
textcolor(14);
if nomer<>0 then write(nomer);
textcolor(10);
gotoxy(7,7);write('บ');d:=2;
for l:=1 to nkol{-1} do
    begin
      f:=d+kolon[l].mesto;
      d:=d+kolon[l].mesto+1;
      granica[l]:=f;
      if l<>nkol then begin gotoxy(f,4);write('ห');gotoxy(f,6);write('ฮ') end;
      gotoxy(f,5);write('บ');gotoxy(f,7);write('บ')
    end;
{gotoxy(f+1,7);write('บ');}
textcolor(14);l:=1;
for f:=2 to nkol{-1} do
  begin
    gotoxy(granica[l]+1,5);
    write(kolon[f].name);
    l:=l+1
  end;
textcolor(10);
if (shirina>1) and (zap=0) then
  for l:=1 to shirina do
    begin
      gotoxy(1,7+l);write('บ');
      for f:=1 to nkol do
        begin
          gotoxy(granica[f],7+l);
          write('บ')
        end;
    end;
if zap<>0 then
begin
xx:=0;d:=0;
repeat
xx:=xx+1;
if xx<>1 then  for l:=1 to nkol do begin readln(fil,h);readln(fil,h) end;
readln(fil,h);readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
val(s,shirina,err);d:=d+shirina;readln(fil,h);
until (y>=(d-shirina)) and (y<=(d));
dl:=shirina-y+1;
for l:=1 to nkol do
begin
readln(fil,h);readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
kol[l]:=s
end;
for l:=1 to shirina do
begin
gotoxy(1,6+l);
textcolor(10);textbackground(0);
for f:=1 to nkol do
begin
textcolor(10);write('บ');textcolor(14);write(copy(kol[f],kolon[f].mesto*l-kolon[f].mesto+1,kolon[f].mesto));
for d:=1 to kolon[f].mesto-Length(copy(kol[f],kolon[f].mesto*l-kolon[f].mesto+1,kolon[f].mesto)) do write(' ');
end;
write('บ');
end;
end;
if zap>1 then
for xx:=2 to zap do
begin
readln(fil,h);readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
val(s,shirina,err);dl:=dl+shirina;
if dl>shirina then shirina:=18-dl;
for l:=1 to nkol do
begin
readln(fil,h);
readln(fil,s);for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
kol[l]:=s
end;
for l:=1 to shirina do
begin
gotoxy(1,6+dl-shirina+l);
textbackground(0);
for f:=1 to nkol do
begin
textcolor(10);write('บ');textcolor(14);write(copy(kol[f],kolon[f].mesto*l-kolon[f].mesto+1,kolon[f].mesto));
for d:=1 to kolon[f].mesto-Length(copy(kol[f],kolon[f].mesto*l-kolon[f].mesto+1,kolon[f].mesto)) do write(' ');
end;
write('บ');
end;
if dl>shirina then xx:=zap;
end;
gotoxy(1,7+dl);
write('ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
for f:=1 to nkol-1 do
  begin
    gotoxy(granica[f],7+dl);
    write('ส')
  end;
end;

begin
Start:
menu;
y:=15;who(y);
REPEAT
h:=ReadKey;
if h=#0 then
begin
h:=ReadKey;
if (h=#80) and (y<>19) then
 begin
  who(1);
  y:=y+1;
  who(y)
 end;
if (h=#72) and (y<>15) then
 begin
  who(1);
  y:=y-1;
  who(y)
 end;
end;

IF h=#13 then
BEGIN
if y=15 then
begin
namefile:=ReadDirFiles;
if namefile='exit' then goto Start;
r:=8;t:=7;y:=1;
textcolor(13);textbackground(0);clrscr;
{gotoxy(21,1);write('ฅค ชโจเฎข ญจฅ โ กซจๆ๋(ไ ฉซ ',namefile,')');}
textcolor(13);gotoxy(1,25);
write('Esc-๋ๅฎค  F1-Help  F2-Help ฏฎซ์งฎข โฅซ๏  F4-ฅค ชโจเฎข ญจฅ  F7-ฎจแช');
Assign(fil,namefile);
Reset(fil);
readln(fil,s);readln(fil,c);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
for f:=1 to Length(c) do c[f]:=chr(ord(c[f])-Key);
if (s<>'(C) OIV Company Ltd. April, 2000') and (c<>' ง  ค ญญ๋ๅ(โ กซจๆ๋)  Version 1.00') then
  begin
    textcolor(14);
    gotoxy(13,10);
    write(namefile,' - ํโฎโ ไ ฉซ ญฅ ก๋ซ แฎงค ญ ํโฎฉ ฏเฎฃเ ฌฌฎฉ!');
    repeat until KeyPressed;
    goto Start
  end;
Readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
nametabl:=s;
readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
password:=s;
readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
val(s,nkol,err);
for l:=1 to nkol do
 begin
  With kolon[l] do
  begin
    readln(fil,s);
    for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
    name:=s;
    readln(fil,s);
    for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
    val(s,mesto,err)
  end;
 end;
readln(fil,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
val(s,zap,err);
if zap<>0 then
  begin
    readln(fil,s);
    for l:=1 to nkol do
      begin
        readln(fil,s);readln(fil,s);
        for f:=1 to Length(s) do s[f]:=chr(ord(s[f])-Key);
        kol[l]:=s
      end;
  end;
if zap=0 then
  begin
    shirina:=1;
    for f:=1 to nkol do kol[l]:='';
    ydlina:=8
  end;
{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
MiniStart:
textbackground(0);clrscr;
textcolor(13);gotoxy(1,25);
write('Esc-๋ๅฎค  F1-Help  F2-Help ฏฎซ์งฎข โฅซ๏  F7-ฎจแช');
if zap=0 then nomer:=0
         else nomer:=1;
NameT;
Zapis;
Close(fil);
textcolor(14);gotoxy(r,t);
REPEAT
h:=ReadKey;
if zap<>0 then
begin
OkNo:=false;
for f:=1 to Length(symbols) do
 if h=symbols[f] then
   begin
     OkNo:=true;
     f:=Length(symbols)
   end;
if okno then
begin
OkNo:=true;
for f:=2 to nkol do if r=granica[f] then begin OkNo:=false;f:=nkol end;
if OkNo then
begin
if (h<>#0) and (h<>#13) and (h<>#8) then
  begin
    r:=r+1;textcolor(14);
    write(h);
  end;
if h=#13 then
  begin
    shirina:=shirina+1;
    t:=t+1;
    for f:=r downto 8 do
      for l:=1 to nkol do if f=granica[l] then begin r:=f+1;l:=nkol;f:=8 end;
    goto MiniStart
  end;
end;
end;
end;
if (h=#0) and (zap=0) then
begin
  h:=ReadKey;
  if h=#63 then
    begin
      zap:=zap+1;
      goto MiniStart
    end;
  if h=#59 then
  begin
    textbackground(1);
    textcolor(15);
    gotoxy(20,8);write('ษ');
    for f:=1 to 10 do write('อ');textcolor(14);write(' ฅค ชโจเฎข ญจฅ ');textcolor(15);
    for f:=1 to 11 do write('อ');write('ป');
    for f:=1 to 6 do
      begin
        gotoxy(20,8+f);write('บ ');textcolor(14);
        case f of
          1:write('F5 - ‘ฎงค โ์ ญฎขใ๎ ง ฏจแ์           ');
          2:write('F6 - ฅค ชโจเฎข โ์ help             ');
          3:write('     ฏฎซ์งฎข โฅซ๏                   ');
          4:write('F8 - ‘ชเ๋โ๋ฅ  โเจกใโ๋               ');
          5:write('                                    ');
          6:write('         Esc - ๋ๅฎค                ');
        end;
        textcolor(15);gotoxy(58,8+f);write('บ')
      end;
    gotoxy(20,9+f);write('ศ');
    for f:=1 to 37 do write('อ');write('ผ');gotoxy(78,25);
    repeat h:=ReadKey; until h=#27;
    goto MiniStart
  end;
end;
if zap<>0 then
BEGIN
if (h=#9) and (r<=71) then r:=r+8;
gotoxy(r,t);
if h=#0 then
  begin
    h:=readkey;
    if h=#71 then r:=8;
    if h=#79 then r:=79;
    if (h=#80) and (t<>ydlina-1) then t:=t+1;
    if (h=#72) and (t<>7) then t:=t-1;
    if (h=#75) and (r<>granica[1]+1) then r:=r-1;
    if (h=#77) and (r<>79) then r:=r+1;
    if h=#63 then
      begin
        zap:=zap+1;
        goto MiniStart
      end;
    if h=#62 then
      begin
        textbackground(1);
        textcolor(15);
        gotoxy(20,8);write('ษ');
        for f:=1 to 10 do write('อ');textcolor(14);write(' ฅค ชโจเฎข ญจฅ ');textcolor(15);
        for f:=1 to 11 do write('อ');write('ป');
        for f:=1 to 6 do
          begin
            gotoxy(20,8+f);write('บ ');textcolor(14);
            case f of
            1:write('F5 - ‘ฎงค โ์ ญฎขใ๎ ง ฏจแ์           ');
            2:write('F6 - ฅค ชโจเฎข โ์ help             ');
            3:write('     ฏฎซ์งฎข โฅซ๏                   ');
            4:write('F8 - ‘ชเ๋โ๋ฅ  โเจกใโ๋               ');
            5:write('                                    ');
            6:write('         Esc - ๋ๅฎค                ');
          end;
        textcolor(15);gotoxy(58,8+f);write('บ')
      end;
      gotoxy(20,9+f);write('ศ');
      for f:=1 to 37 do write('อ');write('ผ');gotoxy(78,25);
      repeat h:=ReadKey; until h=#27;
      goto MiniStart
    end;
    gotoxy(r,t)
  end;
END;
UNTIL H=#27;
goto Start
end;
if y=16 then
begin
clrscr;
textcolor(13);gotoxy(29,1);write('‘ฎงค ญจฅ ญฎขฎฉ โ กซจๆ๋');
y:=3;
NameTabl:='';stolb:='';
Tabl;
who2(y);
REPEAT
h:=ReadKey;
if h=#0 then
begin
h:=ReadKey;
if (h=#80) and (y<>5) then
  begin
   who2(1);
   y:=y+1;
   who2(y)
  end;
if (h=#72) and (y<>3) then
  begin
   who2(1);
   y:=y-1;
   who2(y)
  end;
end;
if h=#13 then
begin
if y=4 then
  begin
   stolb:='';
   Tabl;
   gotoxy(2,7);textcolor(11);writeln('ขฅคจโฅ ญ งข ญจ๏ ชฎซฎญฎช จ จๅ ฃเ ญจๆ๋("Insert" - ฃเ ญจๆ ):');
   gotoxy(8,14);
   textcolor(14);
   f:=0;
   repeat
     repeat
      h:=ReadKey;OkNo:=false;
      for l:=1 to Length(symbols) do if h=symbols[l] then begin OkNo:=true;l:=Length(symbols) end;
     until okno=true;
     f:=f+1;
     if (h<>#8) and (h<>#13) and (Length(stolb)<>72) then
       begin
         if (Length(stolb)<>0) and (stolb[Length(stolb)]<>'บ') then
         if h=#0 then
           begin
             h:=ReadKey;
             if h=#82 then
               begin
                 textcolor(10);
                 gotoxy(8+Length(stolb),13);write('ห');
                 gotoxy(8+Length(stolb),15);write('ฮ');
                 textcolor(14);
                 h:='บ'
               end;
           end;
         if (h<>#82) and (h<>#0) then stolb:=stolb+h;
         gotoxy(8,14);
         for l:=1 to Length(stolb) do
           if stolb[l]='บ' then
             begin
               textcolor(10);
               write(stolb[l]);
               textcolor(14)
             end
                           else write(stolb[l]);
         textcolor(14)
       end;
     if (h=#8) and (Length(stolb)<>0) then
       begin
         stolb:=copy(stolb,1,Length(stolb)-1);
         gotoxy(8+Length(stolb),14);write(' ');
         textcolor(10);
         gotoxy(8+Length(stolb),13);write('อ');
         gotoxy(8+Length(stolb),15);write('อ');
         textcolor(14);
         gotoxy(8,14);
         for l:=1 to Length(stolb) do
           if stolb[l]='บ' then
             begin
               textcolor(10);
               write(stolb[l]);
               textcolor(14)
             end
                           else write(stolb[l]);
         f:=f-1
       end;
    until h=#13;
    gotoxy(2,7);for l:=1 to 58 do write(' ');
    Tabl;
  end;
if y=3 then
  begin
   nametabl:='';
   Tabl;
   gotoxy(2,7);textcolor(11);writeln('ขฅคจโฅ ญ งข ญจฅ โ กซจๆ๋:');
   gotoxy(2,11);
   textcolor(14);
   f:=0;
   repeat
     repeat
      h:=ReadKey;OkNo:=false;
      for l:=1 to Length(symbols) do if h=symbols[l] then begin OkNo:=true;l:=Length(symbols) end;
     until okno=true;
     f:=f+1;
     if (h<>#8) and (h<>#13) and (Length(nametabl)<>78) then
       begin
         nametabl:=nametabl+h;
         gotoxy(2,11);write(nametabl)
       end;
     if (h=#8) and (Length(nametabl)<>0) then
       begin
         nametabl:=copy(nametabl,1,Length(nametabl)-1);
         gotoxy(2+Length(nametabl),11);write(' ');
         gotoxy(2,11);write(nametabl);
         f:=f-1
       end;
    until h=#13;
    gotoxy(2,7);for l:=1 to 25 do write(' ');
    Tabl;
  end;
end;
UNTIL (h=#13) and (y=5);
textcolor(13);gotoxy(7,17);write(' ฏจแ โ์ ํโใ โ กซจๆใ?(y/n): ');
repeat h:=ReadKey; until (upcase(h)='Y') or (upcase(h)='N');
textcolor(15);write(h);Delay(400);
if upcase(h)='N' then goto Start;
textcolor(11);gotoxy(7,19);write('ขฅคจโฅ จฌ๏ ไ ฉซ (กฅง เ แ่จเฅญจ๏): ');
namefile:='';
textcolor(14);
REPEAT
repeat
h:=ReadKey;
okno:=false;
for l:=1 to Length(FileSymbols) do if h=FileSymbols[l] then begin OkNo:=true;l:=Length(FileSymbols) end;
until okno=true;
if (h<>#13) and (h<>#8) and (Length(namefile)<>8) then
  begin
    namefile:=namefile+h;
    gotoxy(42,19);
    write(namefile)
  end;
if (h=#8) and (Length(namefile)<>0) then
  begin
    namefile:=copy(namefile,1,Length(namefile)-1);
    gotoxy(42,19);write('        ');
    gotoxy(42,19);write(namefile)
  end;
UNTIL (h=#13) and (Length(namefile)<>0);
Assign(fil,namefile+'.dbt');
Rewrite(fil);
s:='(C) OIV Company Ltd. April, 2000';
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
Writeln(fil,s);
s:=' ง  ค ญญ๋ๅ(โ กซจๆ๋)  Version 1.00';
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
Writeln(fil,s);
s:=nametabl;
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
Writeln(fil,s);
s:='!!!nO!!!';
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
Writeln(fil,s);
nkol:=1;xx:=1;
kolon[1].name:='ฎฌฅเ';
kolon[1].mesto:=5;
s:=stolb;
if s='' then s:=' ';
for f:=1 to 72-Length(s) do if 72-Length(s)>0 then s:=s+' ';
s:=s+'บ';
for f:=1 to Length(s) do
  if s[f]='บ' then
    begin
      nkol:=nkol+1;
      With kolon[nkol] do
        begin
          name:=copy(s,xx,f-xx);
          xx:=f+1;
          {x:=xx+7;}
          mesto:=Length(name)
        end;
    end;
str(nkol,s);
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
Writeln(fil,s);
  for l:=1 to nkol do
    begin
    s:=kolon[l].name;
    for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
    Writeln(fil,s);
    str(kolon[l].mesto,s);
    for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
    Writeln(fil,s)
  end;
s:='0';
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Key);
Writeln(fil,s);
Close(fil);
goto Start
end;
END;
UNTIL (h=#13) and (y=19);
effect
end.