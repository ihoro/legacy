uses Crt,TextWind;
var v:byte;
    m:MenuType;
procedure Title;
begin
textbackground(0);
clrscr;
LimitColor:=15;
NameColor:=12;
TextWindow(1,1,80,24,'2000');
textcolor(11);
gotoxy(23,2);
writeln('ﬂﬂﬂﬂﬂﬂﬂ    ﬂﬂﬂ    ﬂﬂﬂﬂﬂ      ﬂﬂﬂ');
gotoxy(23,3);
writeln('ﬂﬂ        ﬂ   ﬂ        ﬂ    ﬂ   ﬂ ');
gotoxy(23,4);
writeln('ﬂﬂ       ﬂﬂ   ﬂﬂ       ﬂﬂ  ﬂﬂ   ﬂﬂ');
gotoxy(23,5);
writeln('ﬂﬂﬂﬂﬂﬂ   ﬂﬂﬂﬂﬂﬂﬂ    ﬂﬂﬂﬂ   ﬂﬂﬂﬂﬂﬂﬂ');
textcolor(14);
gotoxy(23,6);
writeln('ﬂﬂ   ﬂﬂ  ﬂﬂ   ﬂﬂ       ﬂﬂ  ﬂﬂ   ﬂﬂ');
gotoxy(23,7);
writeln('ﬂﬂ   ﬂﬂ  ﬂﬂ   ﬂﬂ       ﬂﬂ  ﬂﬂ   ﬂﬂ');
gotoxy(23,8);
writeln('ﬂﬂ   ﬂﬂ  ﬂﬂ   ﬂﬂ       ﬂﬂ  ﬂﬂ   ﬂﬂ');
gotoxy(23,9);
writeln('ﬂﬂﬂﬂﬂﬂ   ﬂﬂ   ﬂﬂ  ﬂﬂﬂﬂﬂﬂ   ﬂﬂ   ﬂﬂ');
textcolor(10);
gotoxy(32,11);write('§†≠≠ÎÂ (‚†°´®ÊÎ)');
end;
begin
Title;
TextWindow(20,5,20,8,'å•≠Ó');
m[1]:='è‡Æ·¨Æ‚‡';
m[2]:='ê•§†™‚®‡Æ¢†≠®•';
m[3]:='î†©´Î';
m[4]:='ÇÎÂÆ§';
v:=Menu(2,2,m,4)
end.