uses Dos, Crt;
const Key=-19;
var s:string;
    fil:text;
    f,l:integer;
    h:char;
    page:byte;
procedure Limit;
begin
textbackground(0);
ClrScr;
textcolor(2);
write('É');
for f:=1 to 77 do write('Í');
write('»');
for f:=2 to 21 do
 begin
  gotoxy(1,f);
  write('º');
  gotoxy(79,f);
  write('º')
 end;
gotoxy(1,22);
write('È');
for f:=1 to 77 do write('Í');
write('¼');
gotoxy(1,23);
write('É');
for f:=1 to 77 do write('Í');
write('»');
gotoxy(1,24);write('º');
gotoxy(79,24);write('º');
gotoxy(1,25);
write('È');
for f:=1 to 77 do write('Í');
write('¼');
textcolor(14);
gotoxy(10,24);
write('Cursor Down - Page Down    Cursor Up - Page Up    Esc - Exit')
end;
begin
textbackground(0);
clrscr;
textcolor(13);
gotoxy(31,9);
write('"Regime of Windows"');
textcolor(13);
gotoxy(35,10);
write('Version 1.0');
textcolor(14);
gotoxy(36,11);
write('Mini Help');
textcolor(10);
gotoxy(35,12);
write('OIV Company');
textcolor(10);
gotoxy(34,13);
write('April,4 2000');
textcolor(9);
gotoxy(32,19);
write('Press any key...');
repeat until KeyPressed;
Limit;
page:=1;
Assign(fil,'row.hlp');
Reset(fil);
textcolor(11);
for f:=1 to 20 do
 begin
  readln(fil,s);
  for l:=1 to Length(s) do s[l]:=chr(ord(s[l])+Key);
  gotoxy(2,f+1);
  write(s)
 end;
gotoxy(78,21);
repeat
h:=ReadKey;
if h=#0 then
 begin
  h:=ReadKey;
  if (h=#80) and (page<>13) then
    begin
     Limit;
     page:=page+1;
     gotoxy(1,2);
     textcolor(11);
     for f:=1 to 20 do
      begin
       readln(fil,s);
       for l:=1 to Length(s) do s[l]:=chr(ord(s[l])+Key);
       gotoxy(2,f+1);
       write(s)
      end;
     gotoxy(78,21)
    end;
  if (h=#72) and (page<>1) then
    begin
     Limit;
     textcolor(11);
     page:=page-1;
     Reset(fil);
     for f:=1 to page-1 do
      for l:=1 to 20 do readln(fil,s);
     gotoxy(1,2);
     for f:=1 to 20 do
      begin
       readln(fil,s);
       for l:=1 to Length(s) do s[l]:=chr(ord(s[l])+Key);
       gotoxy(2,f+1);
       write(s)
      end;
     gotoxy(78,21)
    end;
 end;
until h=#27;
ClrScr;
textcolor(7);
writeln('"Regime of Windows" Version 1.0    Mini Help');
Close(fil);
end.