uses Crt,DOS;
var f:integer;
    x,y:byte;
    t:text;
    free:longint;
    h:char;
    ss,s,name,path,words:string;
procedure wind;
begin
  textbackground(1);
  clrscr;
  gotoxy(20,9);
  textbackground(10);
  textcolor(15);
  write(' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ');
  textcolor(14);
  write('Find Words');
  textcolor(15);
  write(' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ');
  for f:= 1 to 11 do
  begin
   gotoxy(20,9+f);
   write(' ³                                            ³ ');
   textbackground(0);
   write(' ');
   textbackground(10)
  end;
  gotoxy(20,21);
  write(' ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ');
  textbackground(0);
  write(' '); gotoxy(21,22);
  write('                                                ');
  gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00')
end;
procedure menu(f,p,w,fi,c:byte);
begin
  textbackground(f);
  textcolor(14);
  gotoxy(25,11);
  write('   File   '); textbackground(10);textcolor(0);write('Ü');
  gotoxy(26,12); write('ßßßßßßßßßß');
  textbackground(p); gotoxy(25,13);textcolor(14);
  write('   Path   '); textbackground(10);textcolor(0);write('Ü');
  gotoxy(26,14); write('ßßßßßßßßßß');
  textbackground(w); gotoxy(25,15);textcolor(14);
  write('   Word   '); textbackground(10);textcolor(0);write('Ü');
  gotoxy(26,16); write('ßßßßßßßßßß');
  textbackground(fi); gotoxy(25,17);textcolor(14);
  write('   Find   '); textbackground(10);textcolor(0);write('Ü');
  gotoxy(26,18); write('ßßßßßßßßßß');
  textbackground(c); gotoxy(25,19);textcolor(14);
  write('   Quit   '); textbackground(10);textcolor(0);write('Ü');
  gotoxy(26,20); write('ßßßßßßßßßß');
  gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00')
end;
procedure iff;
begin
  if y=11 then menu(4,1,1,1,1);
  if y=13 then menu(1,4,1,1,1);
  if y=15 then menu(1,1,4,1,1);
  if y=17 then menu(1,1,1,4,1);
  if y=19 then menu(1,1,1,1,4)
end;
procedure fil;
begin
  textbackground(1);
  for f:=1 to 3 do
 begin
  gotoxy(40,9+f*2);
  write('                        ')
 end;
  gotoxy(40,11);
  textcolor(13); write(name);
  gotoxy(40,13); write(path);
  gotoxy(40,15); write(words);
  gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00')
end;
procedure filer;
begin
  name:=''; fil;
  gotoxy(40,11);
  repeat
  repeat until keypressed;
  h:=readkey;
  name:=name+h;
  gotoxy(40,11); write(name);
  until h=#13;
  name:=copy(name,1,length(name)-1);
  gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00')
end;
procedure pathe;
begin
  path:=''; fil;
  gotoxy(40,13);
  repeat
  repeat until keypressed;
  h:=readkey;
  path:=path+h;
  gotoxy(40,13); write(path);
  until h=#13;
  path:=copy(path,1,length(path)-1);
  if path='' then begin getdir(0,s); path:=s; gotoxy(40,13); write(path) end;
  gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00')
end;
procedure wor;
begin
  words:=''; fil;
  gotoxy(40,15);
  repeat
  repeat until keypressed;
  h:=readkey;
  words:=words+h;
  gotoxy(40,15); write(words);
  until h=#13;
  words:=copy(words,1,length(words)-1);
  while words[length(words)]=' ' do words:=copy(words,1,length(words)-1);
  gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00')
end;
begin
wind;
menu(4,1,1,1,1);
name:=''; getdir(0,s); path:=s; words:='';
fil;
 y:=11;
repeat
repeat
until keypressed;
h:=readkey;
if h=#0 then if readkey=#80 then
                   begin
                     y:=y+2;
                     if y=21 then y:=11;
                     menu(1,1,1,1,1);
                     iff
                   end
                            else
                   begin
                     y:=y-2;
                     if y=9 then y:=19;
                     menu(1,1,1,1,1);
                     iff
                   end;
if (h=#13) and (y=11) then filer;
if (h=#13) and (y=13) then pathe;
if (h=#13) and (y=15) then wor;
if (h=#13) and (y=17) then
  begin
   wind;
   textbackground(1);textcolor(14);gotoxy(30,15);
                  write('  File is reading...  ');
   textbackground(10); textcolor(0);write('Ü');
   gotoxy(31,16); write('ßßßßßßßßßßßßßßßßßßßßßß');
   gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00');
   assign(t,path+name);
   reset(t);
   free:=0;
   while not eof(t) do
        begin
         readln(t,ss);
         for f:= 1 to length(ss)-length(words) do if copy(ss,f,length(words))=words then free:=free+1;
        end;
   wind;
   textbackground(1);textcolor(14);
   gotoxy(27,14); textbackground(10);
   write(free,' words ('); textcolor(12); write(words);
   textcolor(14); write(')');
   gotoxy(30,15); write('in the file ('); textcolor(12); write(name);
   textcolor(14); write(')');
   textbackground(12); gotoxy(40,19); write('  Cancel  ');
   textbackground(10); textcolor(0);
   write('Ü'); gotoxy(41,20); write('ßßßßßßßßßß');
   gotoxy(1,1);textbackground(1);textcolor(13); write(' 2000 OIV Company Ltd.   Find Words Version 1.00');
   repeat
    h:=readkey;
   until h=#13;
   wind; fil; menu(1,1,1,4,1)
 end;
if (h=#13) and (y=19) then halt;
until h=#27;
textbackground(0);
clrscr
end.