uses crt;
var f:integer;
    x,y:byte;
    h:char;
procedure wind;
begin
  textbackground(1);
  clrscr;

end;
begin
wind;
x:=40; y:=12;
repeat
repeat
until keypressed;
h:=readkey;
if h='i' then
        begin
         gotoxy(x,y);
         textcolor(1);
         write('Û');
         textcolor(10);
         y:=y-1;
         gotoxy(x,y);
         write('Û');
         gotoxy(1,1);
         write('')
        end;
if h='k' then
        begin
         gotoxy(x,y);
         textcolor(1);
         write('Û');
         textcolor(10);
         y:=y+1;
         gotoxy(x,y);
         write('Û');
         gotoxy(1,1);
         write('')
        end;
if h='j' then
        begin
         gotoxy(x,y);
         textcolor(1);
         write('Û');
         textcolor(10);
         x:=x-2;
         gotoxy(x,y);
         write('Û');
         gotoxy(1,1);
         write('')
        end;
if h='l' then
        begin
         gotoxy(x,y);
         textcolor(1);
         write('Û');
         textcolor(10);
         x:=x+2;
         gotoxy(x,y);
         write('Û');
         gotoxy(1,1);
         write('')
        end;
until h=#27;
textbackground(0);
clrscr
end.