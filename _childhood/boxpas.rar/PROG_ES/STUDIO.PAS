uses CGADrv,TscrChr,DOS,Crt,Graph;
label start,fn,fin;
var mode,err,l,f,ff,ll,fff,lll,x,y,d,g,kol,bk,
    menu,cursor,metka                          :integer;
    h,cif,znak,back,enter,left,right,up,down   :char;
    point                                      : array[1..23,1..68] of byte;
    po                                         : array[1..23,1..68] of byte;
    s,name,sym                                 :string;
    fil                                        :text;
    Color                                      :byte;
procedure coo;
begin
 gotoxy(72,20);textbackground(bk); textcolor(menu); write('X ',x-1,' ');
 gotoxy(72,22); write('Y ',y-1,' ');
 gotoxy(72,24); write('Mode: ',mode);
 gotoxy(72,23); write('Color ',Color);
 gotoxy(71,25)
end;
procedure iff;
begin
 if x=1 then x:=2;
 if x=70 then x:=69;
 if y=1 then y:=2;
 if y=25 then y:=24;
 if point[y-1,x-1]<>0 then begin back:='Û';kol:=metka end;
 if point[y-1,x-1]=0 then begin back:=' ';kol:=bk end;
end;
begin
mode:=4;
Color:=1;
x:=35; y:=12; sym:='-_$#&@!%(){}''`~^';
bk:=10; menu:=13; cursor:=1; metka:=12;
enter:=' '; left:='j'; right:='l'; up:='i'; down:='k';
for f:=1 to 23 do
 for l:=1 to 68 do point[f,l]:=0;
znak:='+';
start: back:=' ';
textbackground(bk); clrscr;
textcolor(14);
gotoxy(1,1);
write('Ú'); for f:=1 to 68 do write('Ä'); write('¿');
textcolor(4); gotoxy(30,1); writeln(' OIV Studio ');
textcolor(14);
for f:= 1 to 23 do writeln('³                                                                    ³');
write('À'); for f:=1 to 68 do write('Ä'); write('Ù');
textcolor(metka);
for f:=1 to 23 do
 for l:=1 to 68 do
   if point[f,l]<>0 then begin gotoxy(l+1,f+1); write('Û') end;
textcolor(menu); gotoxy(73,2);
write('Menu:');
gotoxy(71,4); write('F1 view');
gotoxy(71,6); write('9 mode');
gotoxy(71,8); write('7 clear');
gotoxy(71,10); write('1 save');
gotoxy(71,12); write('2 load');
gotoxy(71,14); write('Esc Exit');
gotoxy(71,16); write('C Color');
textcolor(cursor); gotoxy(x,y); write('+');
iff;
coo;
gotoxy(71,25);
repeat
REPEAT
UNTIL KEYPRESSED;
h:=readkey;
if UpCase(h)='C' then
  begin
    Color:=Color+1;
    if Color=4 then Color:=1;
    coo
  end;
if h=enter then
              begin
               if point[y-1,x-1]<>0 then begin point[y-1,x-1]:=0;back:=' ';kol:=bk end
                                    else
               if point[y-1,x-1]=0 then begin back:='Û';point[y-1,x-1]:=Color;kol:=metka end;
               textcolor(cursor);textbackground(kol); gotoxy(x,y); write(znak);
               gotoxy(71,25)
              end;
if h=#0 then if readkey=#59 then
                begin
                 d:=detect; initgraph(d,g,'');
                 SetGraphMode(mode);
                 cleardevice;
                 rectangle(10,40,80,66);
                 settextstyle(7,0,2);
                 outtextxy(15,6,'1 : 1');
                 for f:=1 to 23 do
                  for l:=1 to 68 do
                      if point[f,l]<>0 then putpixel(11+l,41+f,point[f,l]);
                 rectangle(10,80,150,130);
                 outtextxy(10,131,'1 : 2');
                 for f:=1 to 23 do
                  for l:=1 to 68 do
                      if point[f,l]<>0 then begin SetColor(point[f,l]);rectangle(10+l*2,80+f*2,11+l*2,81+f*2) end;
                 rectangle(150,2,360,77);
                 outtextxy(152,78,'1 : 3');
                 for f:=1 to 23 do
                  for l:=1 to 68 do
                     if point[f,l]<>0 then
                  begin SetColor(point[f,l]);rectangle(149+l*3,1+f*3,151+l*3,3+f*3);putpixel(150+l*3,2+f*3,point[f,l]) end;
                 rectangle(360,2,639,102);
                 outtextxy(365,103,'1 : 4');
                 for f:=1 to 23 do
                  for l:=1 to 68 do
                    if point[f,l]<>0 then
                  begin SetColor(point[f,l]);rectangle(358+l*4,f*4,361+l*4,3+f*4);rectangle(359+l*4,1+f*4,360+l*4,2+f*4) end;
                  settextstyle(7,0,6);
                 outtextxy(260,150,'V i e w');
                 repeat until keypressed;
                 closegraph;
                 goto start
                end;
if h=up then
                begin
                 textcolor(metka);
                 gotoxy(x,y);write(back);
                 y:=y-1;
                 iff;coo; gotoxy(x,y);
                 textcolor(cursor);
                 textbackground(kol);
                 write(znak); gotoxy(71,25)
                end;
if h=down then
                begin
                 textcolor(metka);
                 gotoxy(x,y);write(back);
                 y:=y+1;
                 iff;coo; gotoxy(x,y);
                 textcolor(cursor);
                 textbackground(kol);
                 write(znak); gotoxy(71,25)
                end;
if h=left then
                begin
                 textcolor(metka);
                 gotoxy(x,y);write(back);
                 x:=x-1;
                 iff;coo; gotoxy(x,y);
                 textcolor(cursor);
                 textbackground(kol);
                 write(znak); gotoxy(71,25)
                end;
if h=right then
                begin
                 textcolor(metka);
                 gotoxy(x,y);write(back);
                 x:=x+1;
                 iff;coo; gotoxy(x,y);
                 textcolor(cursor);
                 textbackground(kol);
                 write(znak); gotoxy(71,25)
                end;
if h='9' then
  begin
    mode:=mode+1;
    if mode=5 then mode:=0;
    coo
  end;
if h='1' then begin
               textcolor(cursor);
               textbackground(bk);
               gotoxy(72,16); write('FileName');
           fn:
               gotoxy(72,17);
               name:='';
               for f:=1 to 8 do
               begin h:=readkey;name:=name+h;gotoxy(72,17);write(name) end;
               d:=0;
               {for f:=1 to 8 do
                for l:= 65 to 90 do if name[f]<>chr(l) then
                    for ff:=1 to 8 do
                     for ll:= 97 to 122 do if name[ff]<>chr(ll) then
                        for fff:=1 to 8 do
                         for lll:=1 to 16 do if name[fff]=sym[lll] then goto fn;}
               assign(fil,name+'.stu');
               rewrite(fil);
               for f:=1 to 23 do
                for l:=1 to 68 do
                begin
                   write(fil,chr(random(224)+32));write(fil,point[f,l]);
                   if l=68 then writeln(fil,' ')
                end;
               close(fil);
               gotoxy(72,16);write('        ');gotoxy(72,17);write('        ')
              end;
if h='2' then begin
               textcolor(cursor);
               textbackground(bk);
               gotoxy(72,16); write('FileName');
           fin:
               gotoxy(72,17);
               name:='';
               for f:=1 to 8 do
               begin h:=readkey;name:=name+h;gotoxy(72,17);write(name) end;
               {d:=0;
               for f:=1 to 8 do
                for l:= 65 to 90 do if name[f]<>chr(l) then
                    for ff:=1 to 8 do
                     for ll:= 97 to 122 do if name[ff]<>chr(ll) then
                        for fff:=1 to 8 do
                         for lll:=1 to 16 do if name[fff]=sym[lll] then goto fin;}
               getdir(0,s);
               assign(fil,s+'\'+name+'.stu');
               reset(fil);
               for f:=1 to 23 do
                for l:=1 to 68 do
                begin
                   read(fil,h);
                   read(fil,cif);
                   val(cif,point[f,l],err);
                   if l=68 then readln(fil,h)
                end;
               close(fil);
               gotoxy(72,16);write('        ');gotoxy(72,17);write('        ');
               goto start
              end;
if h='7' then begin
               for f:=1 to 23 do
                 for l:=1 to 68 do point[f,l]:=0;
               goto start
              end;
if UpCase(h)='R' then
  begin
    for f:=1 to 11 do
      begin
        for l:=1 to 23 do
          po[l,f]:=Point[l,f];
        for l:=1 to 23 do
          point[l,f]:=point[l,24-f];
        for l:=1 to 23 do
          point[l,24-f]:=po[l,f];
      end;
    goto start
  end;
until h=#27;
textbackground(0);
clrscr
end.