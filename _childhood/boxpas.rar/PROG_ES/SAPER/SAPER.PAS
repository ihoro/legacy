uses TextWind, Crt, Dos;
label Start, Ends;
const
      cc = [1..9];
      Key = 4;
var
    b:ButtonsType;
    m:MenuType;
    tt:BigTextType;
    sap:text;
    re:real;
    play:array[1..20] of
      record
        name:string[10];
        mi:word;
        ti:word;
        speed:real
      end;
    mx,my,f,l,d,dd:integer;
    pk:array[1..836] of
        record
          xx,yy:byte
        end;
    Move,Tekpk,tpk,Chas,Cha,Min,Mi,Sek,Se,Sotki,Mines,Mine,Time,Tim,Open:Word;
    kx,ky,x,y,r,t,MaxX,MaxY:byte;
    s,ss:string;
    pole:array[1..40,1..24] of byte;
    screen:array[1..40,1..24] of byte;
    h:Char;
    oiv:byte;
    Stop:byte;
function Coder(s:string;keys:ShortInt):string;
var f:byte;
begin
for f:=1 to Length(s) do s[f]:=chr(ord(s[f])+Keys);
Coder:=s
end;
procedure IfMove;
begin
case Move of
1:begin
    mx:=-1;
    my:=0
  end;
2:begin
    mx:=-1;
    my:=-1
  end;
3:begin
    mx:=0;
    my:=-1
  end;
4:begin
    mx:=1;
    my:=-1
  end;
5:begin
    mx:=1;
    my:=0
  end;
6:begin
    mx:=1;
    my:=1
  end;
7:begin
    mx:=0;
    my:=1
  end;
8:begin
    mx:=-1;
    my:=1
  end
end
end;
procedure You;
var f:byte;
begin
if oiv=3 then f:=2
         else f:=Screen[r,t];
case f of
  0:begin
      textbackground(4);
      textcolor(14);
      gotoxy(x,y);write('  ')
    end;
  1:begin
      textbackground(4);
      textcolor(12);
      gotoxy(x,y);write('')
    end;
  2:begin
      textbackground(4);
      case Pole[r,t] of
        0:begin
            gotoxy(x,y);write('  ')
          end;
        1..8:begin
               textcolor(10);
               gotoxy(x,y);write('0',Pole[r,t]);
             end;
        9:if oiv=3 then
          begin
            textcolor(14);
            gotoxy(x,y);write('!!')
          end
      end
    end
end;
SetCursor
end;
procedure Data;
begin
ClearZone(1,25,78,1,0);
textbackground(0);
textcolor(13);
gotoxy(1,25);
write('Осталось открыть: ',Open,'    Количество мин: ',Mine,'    Время: ',Tim);
SetCursor
end;
procedure Kletka(x,y,f,l:byte);
begin
case Screen[f,l] of
  0:begin
      textbackground(1);
      textcolor(14);
      gotoxy(x,y);write('  ')
    end;
  1:begin
      textbackground(1);
      textcolor(12);
      gotoxy(x,y);write('')
    end;
  2:begin
      textbackground(0);
      case Pole[f,l] of
        0:begin
            gotoxy(x,y);write('  ')
          end;
        1..8:begin
               textcolor(10);
               gotoxy(x,y);write('0',Pole[f,l]);
             end
      end
    end
end;
SetCursor
end;
procedure WriteScreen;
begin
for l:=1 to MaxY do
  for f:=1 to MaxX do Kletka(f*2,l+1,f,l)
end;
procedure ReadScore;
var f,l:integer;
begin
Reset(sap);
for f:=1 to 20 do
  begin
    ss:='';
    for l:=1 to 10 do
      begin
        read(sap,h);
        ss:=ss+h
      end;
    play[f].name:=Coder(ss,-Key);
    ss:='';
    for l:=1 to 3 do
      begin
        read(sap,h);
        ss:=ss+h
      end;
    val(Coder(ss,-Key),play[f].mi,l);
    ss:='';
    for l:=1 to 3 do
      begin
        read(sap,h);
        ss:=ss+h
      end;
    val(Coder(ss,-Key),play[f].ti,l);
    ss:='';
    for l:=1 to 5 do
      begin
        if l=5 then readln(sap,h)
               else read(sap,h);
        ss:=ss+h
      end;
    val(Coder(ss,-Key),play[f].speed,l);
  end;
Close(sap)
end;
begin
{$I-}
Assign(sap,'hiscore.sap');
Reset(sap);
if IOResult<>0 then
  begin
    Rewrite(sap);
    for f:=1 to 20 do writeln(sap,coder('Computer    0999    0',Key));
    Close(sap)
  end
               else
  Close(sap);
{$I+}
ReadScore;
Randomize;
textbackground(0); ClrScr;
 tt[1]:=' 111111      111111     11111111    11111111    1111111 ';
 tt[2]:='11    11    11    11    11    11    11          11    11';
 tt[3]:='11          11    11    11    11    11          11    11';
 tt[4]:='11          11    11    11    11    11          11    11';
 tt[5]:='11          11111111    11    11    111111      1111111 ';
 tt[6]:='11          11    11    11    11    11          11      ';
 tt[7]:='11          11    11    11    11    11          11      ';
 tt[8]:='11          11    11    11    11    11          11      ';
 tt[9]:='11    11    11    11    11    11    11          11      ';
tt[10]:=' 111111     11    11    11    11    11111111    11      ';
BigText(12,7,tt,56,10,'▀',0,10);
textcolor(13);gotoxy(1,25);
write('(C) OIV Company Ltd.                                                  2000');
SetCursor;
PressAnyKey;
MaxX:=38;MaxY:=22;Mines:=100;Time:=240;
WindowColor:=1;
LimitColor:=15;
NameColor:=10;
TxtColor:=14;
ButtonColor:=10;
Start:
FirstActive:=1;
MenuY:=2;
repeat
textbackground(0);
ClrScr;
 tt[1]:=' 111111      111111     11111111    11111111    1111111 ';
 tt[2]:='11    11    11    11    11    11    11          11    11';
 tt[3]:='11          11    11    11    11    11          11    11';
 tt[4]:='11          11    11    11    11    11          11    11';
 tt[5]:='11          11111111    11    11    111111      1111111 ';
 tt[6]:='11          11    11    11    11    11          11      ';
 tt[7]:='11          11    11    11    11    11          11      ';
 tt[8]:='11          11    11    11    11    11          11      ';
 tt[9]:='11    11    11    11    11    11    11          11      ';
tt[10]:=' 111111     11    11    11    11    11111111    11      ';
BigText(12,7,tt,56,10,'▀',0,10);
textbackground(0);textcolor(13);gotoxy(1,25);
write('(C) OIV Company Ltd.                                                  2000');
SetCursor;
TextWindow(35,9,11,6,'');
m[1]:='Игра';
m[2]:='Настройка';
m[3]:='Рекорды';
m[4]:='Выход';
d:=Menu(2,2,m,4);
case d of
2:begin
   repeat
    textbackground(0);
    ClrScr;
    TextWindow(20,2,40,20,'Настройка');
    SetText(14,3,'Установлено:');
    str(MaxX,s);str(MaxY,ss);
    SetText(10,4,'Размер поля: '+s+'x'+ss);
    str(Mines,s);
    SetText(10,5,'Количество мин: '+s);
    str(Time,s);
    SetText(10,6,'Время(сек.): '+s);
    b[1]:='Размер по X';
    b[2]:='Размер по Y';
    b[3]:='Мины';
    b[4]:='Время';
    b[5]:='Ok';
    dd:=Buttons(25,10,14,1,1,b,5,LeftChar,RightChar);
    case dd of
     1:begin
        repeat
         ss:=InputData(42,10,2,Figures);
         val(ss,l,f)
        until (l<=38) and (l>1);
        MaxX:=l
       end;
     2:begin
        repeat
         ss:=InputData(42,12,2,Figures);
         val(ss,l,f)
        until (l<=22) and (l>1);
        MaxY:=l
       end;
     3:begin
        repeat
         ss:=InputData(42,14,3,Figures);
         val(ss,l,f)
        until (l<=(MaxX*MaxY div 2)) and (l<>0);
        Mines:=l
       end;
     4:begin
        repeat
         ss:=InputData(42,16,3,Figures);
         val(ss,l,f)
        until l<>0;
        Time:=l
       end;
    end;
   until dd=5
  end;
3:begin
    ReadScore;
    textbackground(0);
    ClrScr;
    TextWindow(25,2,30,23,'Таблица рекордов');
    TxtColor:=12;
    SetText(2,2,'N    Сапер    Кол. мин Время');
    TxtColor:=14;
    for f:=1 to 20 do
      begin
        str(f,s);
        if f<10 then s:=' '+s;
        SetText(2,f+2,s);
        SetText(5,f+2,play[f].name);
        str(play[f].mi,s);
        if play[f].mi<10 then s:='  '+s
                         else if play[f].mi<100 then s:=' '+s;
        SetText(18,f+2,s);
        str(play[f].ti,s);
        if play[f].ti<10 then s:='  '+s
                         else if play[f].ti<100 then s:=' '+s;
        SetText(26,f+2,s)
      end;
    PressAnyKey
  end;
4:begin
    textbackground(0);
    ClrScr;
    Halt
  end;
end;
until d=1;
d:=0;
for f:=1 to MaxX do
  for l:=1 to MaxY do Pole[f,l]:=0;
repeat
f:=Random(MaxX)+1;
l:=Random(MaxY)+1;
if Pole[f,l]=0 then
  begin
    Pole[f,l]:=9;
    d:=d+1
  end;
until d=Mines;
for f:=1 to MaxX do
  for l:=1 to MaxY do
   if Pole[f,l]=0 then
    begin
      d:=0;
      if (f>1) and (l>1) and (Pole[f-1,l-1]=9) then inc(d);
      if (l>1) and (Pole[f,l-1]=9) then inc(d);
      if (f<MaxX) and (l>1) and (Pole[f+1,l-1]=9) then inc(d);
      if (f<MaxX) and (Pole[f+1,l]=9) then inc(d);
      if (l<MaxY) and (f<MaxX) and (Pole[f+1,l+1]=9) then inc(d);
      if (l<MaxY) and (Pole[f,l+1]=9) then inc(d);
      if (l<MaxY) and (f>1) and (Pole[f-1,l+1]=9) then inc(d);
      if (f>1) and (Pole[f-1,l]=9) then inc(d);
      Pole[f,l]:=d
    end;
for f:=1 to MaxX do
  for l:=1 to MaxY do Screen[f,l]:=0;
Open:=0;
for f:=1 to MaxX do
  for l:=1 to MaxY do
    if Pole[f,l]<>9 then inc(Open);
Mine:=Mines; Tim:=Time;
textbackground(0);
ClrScr;
TextWindow(1,1,MaxX*2+2,MaxY+2,'Минное поле');
WriteScreen;
r:=MaxX div 2; t:=MaxY div 2;
x:=r*2; y:=t+1;
You;
GetTime(Chas,Min,Sek,Sotki);
Cha:=Chas;
Mi:=Min;
Se:=Sek;
oiv:=0;
stop:=0;
repeat
repeat
GetTime(Chas,Min,Sek,Sotki);
f:=(Chas*3600+Min*60+Sek)-(Cha*3600+Mi*60+Se);
if (f>0) and (stop<>4) then Tim:=Tim-f;
Cha:=Chas; Mi:=Min; Se:=Sek;
if Tim<0 then Tim:=0;
Data;
if Tim=0 then
  begin
    textbackground(0);
    textcolor(12);
    gotoxy(31,12);
    write('Закончилось время!');
    SetCursor;
    PressAnyKey;
    goto Start
  end;
until KeyPressed;
h:=ReadKey;
if (h=' ') and (Screen[r,t]<>2) then
  begin
    case Screen[r,t] of
      0:if Mine<>0 then
        begin
          Screen[r,t]:=1;
          Mine:=Mine-1;
          You;
          Data
        end;
      1:begin
          Screen[r,t]:=0;
          Mine:=Mine+1;
          You;
          Data
        end
    end;
  end;
if (h=#13) and (Screen[r,t]<>2) then
  begin
    Screen[r,t]:=2;
    if Pole[r,t]=9 then
      begin
        f:=0;
        repeat
          if f=0 then f:=4
                 else f:=0;
          textbackground(f);
          textcolor(12);
          ClrScr;
          gotoxy(38,12);
          write('Мина!');
          SetCursor;
          Delay(20)
        until KeyPressed;
        PressAnyKey;
        goto Start
      end;
    You;
    Open:=Open-1;
    if Pole[r,t]=0 then
      begin
        tpk:=1;
        pk[1].xx:=r;
        pk[1].yy:=t;
        kx:=r;ky:=t;
        Tekpk:=1;
        Move:=1;
        IfMove;
        repeat
        kx:=kx+mx; ky:=ky+my;
        if (kx=0) or (kx=MaxX+1) or (ky=0) or (ky=MaxY+1) then
          begin
            Move:=Move+1;
            if Move=9 then
              begin
                Tekpk:=Tekpk+1;
                Move:=1;
                if Tekpk=tpk+1 then goto ends
              end;
            kx:=pk[Tekpk].xx;
            ky:=pk[Tekpk].yy;
            IfMove
          end;
        if Screen[kx,ky]<>2 then
          begin
            Open:=Open-1;
            Screen[kx,ky]:=2;
            Kletka(kx*2,ky+1,kx,ky);
            if Pole[kx,ky]=0 then
              begin
                tpk:=tpk+1;
                pk[tpk].xx:=kx;
                pk[tpk].yy:=ky
              end;
          end;
        if (kx=0) or (kx=MaxX+1) or (ky=0) or (ky=MaxY+1) or (Pole[kx,ky] in cc) then
          begin
            Move:=Move+1;
            if Move=9 then
              begin
                Tekpk:=Tekpk+1;
                Move:=1;
                if Tekpk=tpk+1 then goto ends
              end;
            kx:=pk[Tekpk].xx;
            ky:=pk[Tekpk].yy;
            IfMove
          end
        until Tekpk>tpk
      end;
    Ends:
    Data
  end;
if (stop=4) and (h='П') then stop:=0;
if (stop=0) and (h='С') then stop:=stop+1;
if (stop=1) and (h='Т') then stop:=stop+1;
if (stop=2) and (h='О') then stop:=stop+1;
if (stop=3) and (h='П') then stop:=stop+1;
if (oiv=3) and (h='V') then oiv:=oiv-3; 
if (oiv=2) and (h='V') then oiv:=oiv+1;
if (oiv=1) and (h='I') then oiv:=oiv+1;
if (oiv=0) and (h='O') then oiv:=oiv+1;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#44 then
      begin
        for l:=t-3 to t+3 do
          for f:=r-3 to r+3 do
            if (l>0) and (l<=MaxY) and (f>0) and (f<=MaxX) then
                if (Pole[f,l]<>9) and (Pole[f,l]<>0) and (Screen[f,l]<>2) then
                  begin
                    Screen[f,l]:=2;
                    Open:=Open-1;
                    Kletka(f*2,l+1,f,l);
                    if (f=r) and (l=t) then You
                  end;
      end;
    if (h=#72) and (y<>2) then
      begin
        Kletka(x,y,r,t);
        y:=y-1;
        t:=t-1;
        You
      end;
    if (h=#80) and (y<>MaxY+1) then
      begin
        Kletka(x,y,r,t);
        y:=y+1;
        t:=t+1;
        You
      end;
    if (h=#75) and (x<>2) then
      begin
        Kletka(x,y,r,t);
        x:=x-2;
        r:=r-1;
        You
      end;
    if (h=#77) and (x<>MaxX*2) then
      begin
        Kletka(x,y,r,t);
        x:=x+2;
        r:=r+1;
        You
      end;
  end;
until (h=#27) or (Open=0);
if Open=0 then
  begin
    TextWindow(33,8,14,7,'');
    SetText(4,3,'Молодец!');
    b[1]:='Ok';
    f:=Buttons(35,12,10,1,0,b,1,LeftChar,RightChar);
    re:=trunc((Mines/(Time-Tim))*1000)/1000;
    if trunc(re)>0 then re:=trunc(re);
    if re>play[20].speed then
      begin
        TextWindow(32,7,16,9,'');
        SetText(5,3,'Ваше имя:');
        s:=InputData(35,12,10,English+Russian+Figures+' ');
        if s='' then s:=' ';
        play[20].name:=s;
        play[20].mi:=Mines;
        play[20].ti:=Time-Tim;
        play[20].speed:=re;
        d:=20;
        while (play[d].speed>play[d-1].speed) and (d<>1) do
          begin
            s:=play[d-1].name;
            play[d-1].name:=play[d].name;
            play[d].name:=s;
            Move:=play[d-1].mi;
            play[d-1].mi:=play[d].mi;
            play[d].mi:=Move;
            Move:=play[d-1].ti;
            play[d-1].ti:=play[d].ti;
            play[d].ti:=Move;
            re:=play[d-1].speed;
            play[d-1].speed:=play[d].speed;
            if trunc(re)>0 then play[d].speed:=trunc(re)
                           else play[d].speed:=re;
            d:=d-1
          end;
        Rewrite(sap);
        for f:=1 to 20 do
          begin
            write(sap,Coder(play[f].name,Key));
            for l:=1 to 10-Length(play[f].name) do write(sap,Coder(' ',Key));
            str(play[f].mi,s);
            if Length(s)=1 then s:='  '+s;
            if Length(s)=2 then s:=' '+s;
            write(sap,Coder(s,Key));
            str(play[f].ti,s);
            if Length(s)=1 then s:='  '+s;
            if Length(s)=2 then s:=' '+s;
            write(sap,Coder(s,Key));
            if (play[f].speed<1) and (play[f].speed<>0) then str(play[f].speed:5:3,s)
                                                        else str(play[f].speed:5:0,s);
            writeln(sap,Coder(s,Key))
          end;
        Close(sap)
      end
  end;
goto Start
end.