uses crt,dos;
label start;
var eng,en       : array[1..20] of string[20];
    rus,ru       : array[1..20] of string;
    e            : string[20];
    time,z,game  : word;
    is,iss       : array[1..20] of boolean;
    point,f,d,l,t:integer;
    h            : char;
    p,x,y,now,
    english,oshibka,
    level,w,all  : byte;
    fil          : text;
    name,r,pro   : string;
procedure g;
begin
gotoxy(65,1);
textbackground(1);
textcolor(random(15)+1);
write('English')
end;
begin
for f:=1 to 20 do eng[f]:='';
textbackground(0);clrscr;
f:=0;
repeat
f:=f+1; if f=16 then f:=1;
textcolor(f); gotoxy(35,12); write('English');
gotoxy(32,14); write('Press any key...');
delay(5);
until keypressed;
for f:=1 to 1050 do begin sound(20000-f*25);delay(4);nosound end;
 point:=0;  game:=1;  z:=1;
textbackground(1);clrscr;textcolor(10);gotoxy(30,10);write('Сложность? (1-4)');
repeat
gotoxy(34,12);write('                                    ');
gotoxy(34,12);read(level);
until (level>0) and (level<5);
start:
oshibka:=0; all:=0; t:=0; time:=100;
for f:=1 to 20 do en[f]:=eng[f];
textcolor(14);
gotoxy(30,14); write('Немного подождите!');
f:=2;
case level of
1: name:='level1.eng';
end;
begin
    assign(fil,name);
for f:= 1 to 20 do
begin
 w:=0;
   repeat
    reset(fil);
    while not eof(fil) do
         begin
           read(fil,e);readln(fil,r);
           randomize;
           p:=0;
        for l:=1 to 20 do if (e=en[l]) or (e=eng[l]) then p:=1;
           if (random(7)=1) and (p=0) then
           begin eng[f]:=e;rus[f]:=r;w:=1 end
         end;
   until w=1;
end;
    close(fil);
end;
 clrscr;
 for f:=1 to 20 do ru[f]:=rus[f];
 for f:=1 to 20 do
    for l:=2 to 20 do if random(2)=1 then
           begin
            pro:=ru[1];
            ru[1]:=ru[l];
            ru[l]:=pro
           end
                                     else
           begin
            pro:=ru[1];
            d:=random(19)+2;
            ru[1]:=ru[d];
            ru[d]:=pro
           end;
 for f:=1 to 20 do begin gotoxy(10,1+f); writeln(eng[f]) end;
 for f:=1 to 20 do begin gotoxy(31,1+f); write(ru[f]) end;
 y:=2; x:=10;
 textbackground(1);textcolor(12); gotoxy(60,3); write('Очки:   ',point);
 gotoxy(60,5); write('Ошибки: ',oshibka);
 gotoxy(60,7); write('Время:  ',time);
 textcolor(14);
 now:=1; textbackground(12);
gotoxy(x,y); write(eng[now]);
for f:=1 to 20 do begin is[f]:=true;iss[f]:=true end;
  REPEAT
repeat
g;
t:=t+1;
 if t=500 then
      begin
       t:=0;
       if time<>0 then time:=time-1;
       textcolor(12); gotoxy(68,7); write(time,'  ');
       textcolor(14)
      end;
until keypressed;
h:=readkey;
textcolor(14);
if h=#0 then if readkey=#72 then
                    begin
                     if x=10 then
                        begin
                         textbackground(1);
                         gotoxy(x,y);
                         if is[now]=true then textcolor(14)
                                         else textcolor(13);
                         write(eng[now]);
                         if y=2 then begin y:=21;now:=20 end
                          else  begin
                         y:=y-1;now:=now-1 end;
                         gotoxy(x,y);
                         textbackground(12);
                         if is[now]=true then textcolor(14)
                                         else textcolor(13);
                         write(eng[now])
                        end;
                     if x=31 then
                        begin
                         textbackground(1);
                         gotoxy(x,y);
                         if iss[now]=true then textcolor(14)
                                          else textcolor(13);
                         write(ru[now]);
                         for f:=1 to 20-length(ru[now]) do write(' ');
                         if y=2 then begin y:=21;now:=20 end
                          else  begin
                         y:=y-1;now:=now-1 end;
                         gotoxy(x,y);
                         textbackground(12);
                         if iss[now]=true then textcolor(14)
                                          else textcolor(13);
                         write(ru[now]);
                         for f:=1 to 20-length(ru[now]) do write(' ');
                        end;
                    end
                            else
                    begin
                     if x=10 then
                        begin
                         textbackground(1);
                         gotoxy(x,y);
                         if is[now]=true then textcolor(14)
                                         else textcolor(13);
                         write(eng[now]);

                         if y=21 then begin y:=2;now:=1 end
                          else  begin
                         y:=y+1;now:=now+1 end;
                         gotoxy(x,y);
                         textbackground(12);
                         if is[now]=true then textcolor(14)
                                         else textcolor(13);
                         write(eng[now])
                        end;
                     if x=31 then
                        begin
                         textbackground(1);
                         gotoxy(x,y);
                         if iss[now]=true then textcolor(14)
                                          else textcolor(13);
                         write(ru[now]);
                         for f:=1 to 20-length(ru[now]) do write(' ');

                         if y=21 then begin y:=2;now:=1 end
                          else  begin
                         y:=y+1;now:=now+1 end;
                         gotoxy(x,y);
                         textbackground(12);
                         if iss[now]=true then textcolor(14)
                                          else textcolor(13);
                         write(ru[now]);
                         for f:=1 to 20-length(ru[now]) do write(' ');
                        end;
                    end;
if (h=#13) and (x=31) then
   begin
    gotoxy(x,y);
    textbackground(1);
    if iss[now]=true then textcolor(14)
                     else textcolor(13);
    write(ru[now]);
    for f:=1 to 20-length(ru[now]) do write(' ');
    for f:= 1 to 20 do if ru[now]=rus[f] then begin l:=f;f:=20 end;
    if english=l then
     begin
      gotoxy(50,1);
      write('Правильно!');
      point:=point+1;
      textcolor(12);
      gotoxy(68,3); write('           ');
      for f:=0 to point do begin gotoxy(68,3);write(f);sound(2000+f*10);nosound end;
      gotoxy(50,1);
      textcolor(12);
      write('          ');
      iss[now]:=false;
      is[english]:=false;
      all:=all+1;
      if all=20 then
          begin
            textbackground(0);
            clrscr;
            textcolor(10);
            gotoxy(20,8); write('Оценка за урок:  ');
            case oshibka of
               0: write('5+');
               1: write('5');
             2,3: write('5-');
       4,5,6,7,8: write('4');
         9,10,11: write('4-');
        12,13,14: write('3');
        15,16,17: write('3-');
        18,19,20: write('2')
            end;
            gotoxy(20,10);write('Время:           ',time);
            gotoxy(20,12);write('Очки:            ',point);
            gotoxy(20,14);write('Дополнительно:   ',time div 3,' очков');
            point:=point+time div 3;
            gotoxy(20,16);write('Всего очков:     ',point);
            repeat until keypressed;
            textbackground(1); clrscr;
            game:=game+1;z:=game*2;
            goto start
          end;
     end
                 else
     begin
      gotoxy(50,1);
      write('Неправильно!');
      point:=point-z;
      if point<0 then point:=0;
      textcolor(12);
      gotoxy(68,3); write(point);
      for f:=1 to 20 do begin sound(200-f*10);delay(f+25);nosound end;
      oshibka:=oshibka+1;
      gotoxy(68,5); write(oshibka);
      textcolor(14);
      gotoxy(50,1);
      write('            ');
     end;
      for f:=1 to 20 do begin if is[f]=true then textcolor(14)
                    else textcolor(13); gotoxy(10,1+f); writeln(eng[f]) end;
      for f:=1 to 20 do begin if iss[f]=true then textcolor(14)
                    else textcolor(13); gotoxy(31,1+f); write(ru[f]) end;
    textbackground(12);
    textcolor(14);
    x:=10;
    gotoxy(x,y);
    if is[now]=true then textcolor(14)
                    else textcolor(13);
    write(eng[now]);
repeat
g;
t:=t+1;
 if t=500 then
      begin
       t:=0;
       if time<>0 then time:=time-1;
       textcolor(12); gotoxy(68,7); write(time,'  ');
       textcolor(14)
      end;
until keypressed;
  end
        else
    if (h=#13) and (x=10) and (is[now]=true) then
   begin
    english:=now;
    gotoxy(x,y);
    x:=31;
    textbackground(1);
    write(eng[now]);
    textbackground(12);
    gotoxy(x,y);
    if iss[now]=true then textcolor(14)
                     else textcolor(13);
    write(ru[now]);
    for f:=1 to 20-length(ru[now]) do write(' ');
   end;
UNTIL H=#27
end.