uses Coder,TextWind,WinDos,Dos,Crt;
label Start;
const
      Key = 10;
      SizeOfLine = 92;
      MaxMessages = 300;
      Den:array[0..6] of string[11]
          =('Воскресенье','Понедельник','Вторник','Среда','Четверг','Пятница','Суббота');
      OnOff:array[0..1] of string[19]
            =('Сообщение выключено','Сообщение включено');
type
     LineType = string[92];
var
    PMessage:array[1..MaxMessages] of Pointer;
    P:^LineType;
    Size:LongInt;
    Msg:Text;
    f,l,d:LongInt;
    h:Char;
    NoFile,Del:Boolean;
    TotalMessages:Word;
    s,cc:string;
    xx,x,y,MenuActive,MenuFirst:Byte;
    Err:Integer;
procedure Mess(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(1,6);
write('┌');
for f:=1 to 78 do write('─');
write('┐');
gotoxy(1,7);write('│');
gotoxy(80,7);write('│');
gotoxy(1,8);write('└');
for f:=1 to 78 do write('─');
write('┘');
SetCursor
end;
procedure On(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(2,10);write('┌');for f:=1 to 25 do write('─');
write('┐');
gotoxy(2,11);write('│');
gotoxy(28,11);write('│');
gotoxy(2,12);write('└');for f:=1 to 25 do write('─');
write('┘');
SetCursor
end;
procedure Chis(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(31,10);write('┌');for f:=1 to 6 do write('─');
write('┐');
gotoxy(31,11);write('│');
gotoxy(38,11);write('│');
gotoxy(31,12);write('└');for f:=1 to 6 do write('─');
write('┘');
SetCursor
end;
procedure Mes(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(41,10);write('┌');for f:=1 to 6 do write('─');
write('┐');
gotoxy(41,11);write('│');
gotoxy(48,11);write('│');
gotoxy(41,12);write('└');for f:=1 to 6 do write('─');
write('┘');
SetCursor
end;
procedure God(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(51,10);write('┌');for f:=1 to 6 do write('─');
write('┐');
gotoxy(51,11);write('│');
gotoxy(58,11);write('│');
gotoxy(51,12);write('└');for f:=1 to 6 do write('─');
write('┘');
SetCursor
end;
procedure Den_Ned(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(61,10);write('┌');for f:=1 to 17 do write('─');
write('┐');
gotoxy(61,11);write('│');
gotoxy(79,11);write('│');
gotoxy(61,12);write('└');for f:=1 to 17 do write('─');
write('┘');
SetCursor
end;
procedure Vih(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(2,15);write('┌');for f:=1 to 55 do write('─');
write('┐');
gotoxy(2,16);write('│');
gotoxy(58,16);write('│');
gotoxy(2,17);write('└');for f:=1 to 55 do write('─');
write('┘');
SetCursor
end;
procedure Chas(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(61,15);write('┌');for f:=1 to 6 do write('─');
write('┐');
gotoxy(61,16);write('│');
gotoxy(68,16);write('│');
gotoxy(61,17);write('└');for f:=1 to 6 do write('─');
write('┘');
SetCursor
end;
procedure Min(c:byte);
begin
textbackground(3);
textcolor(c);
gotoxy(71,15);write('┌');for f:=1 to 7 do write('─');
write('┐');
gotoxy(71,16);write('│');
gotoxy(79,16);write('│');
gotoxy(71,17);write('└');for f:=1 to 7 do write('─');
write('┘');
SetCursor
end;
procedure CaseXY(c:byte);
begin
case y of
1:Mess(c);
2:case x of
    1:On(c);
    2:Chis(c);
    3:Mes(c);
    4:God(c);
    5:Den_Ned(c)
  end;
3:case x of
    1:Vih(c);
    2:Chas(c);
    3:Min(c)
  end
end
end;
procedure WriteMenu(first,active:word);
begin
if Del then
  begin
    ClearZone(2,2,78,22,1);
    Del:=false
  end;
if TotalMessages>22 then l:=22
                    else l:=TotalMessages-First+1;
textcolor(14);
for f:=1 to l do
  begin
    if (f+First-1)<>Active then textbackground(1)
                           else textbackground(4);
    gotoxy(2,f+1);
    P:=Ptr(seg(PMessage[f+First-1]^),ofs(PMessage[f+First-1]^));
    s:=P^;
    write(Copy(s,15,78))
  end;
SetCursor
end;
procedure MiniHelp;
begin
textbackground(0);textcolor(10);
gotoxy(1,25);
write('Esc-Выход  F1-Помощь  Enter-Редактирование  Ins-Новое  Del-Удалить');
SetCursor
end;
function UpStr(s:string):string;
begin
for f:=1 to Length(s) do
  s[f]:=UpCase(s[f]);
UpStr:=s
end;
begin
if ParamCount>0 then
  begin
    s:=ParamStr(1);
    if (UpStr(s)<>'/S') and (UpStr(s)<>'/H') then 
      begin
        writeln('Неправильный параметр!');
        writeln('/h - помощь');
        halt
      end;
    if UpStr(s)='/H' then
      begin
        writeln('Messages  V1.0   OIV Company Ltd. 2000');
        writeln('Параметры:');
        writeln(' /s - (Startup) проверка сообщений один раз в данный момент');
        writeln(' /h - данная помощь');
        halt
      end;
  end;
New(P);
NoFile:=false;
Del:=false;
InputColor:=3;
InputDataColor:=14;
Assign(Msg,'messages.msg');
{$I-}
Reset(msg);
if IOResult<>0 then
  begin
    Size:=SizeOfLine;
    NoFile:=true
  end
              else
  begin
    Size:=0;
    TotalMessages:=0;
    while not EOF(msg) do
      begin
        Readln(msg,s);
        s:=CoderStr(s,-Key);
        Size:=Size+SizeOfLine;
        TotalMessages:=TotalMessages+1;
        GetMem(PMessage[TotalMessages],SizeOfLine);
        P:=Ptr(seg(PMessage[TotalMessages]^),ofs(PMessage[TotalMessages]^));
        P^:=s
      end;
    Close(msg);
  end;
{$I+}
if NoFile then
  begin
    TotalMessages:=1;
    GetMem(PMessage[1],SizeOfLine);
    P:=Ptr(seg(PMessage[1]^),ofs(PMessage[1]^));
    P^:='             1Сообщение                                                                                   ';
  end;
MenuFirst:=1; MenuActive:=1;
Start:
textbackground(0);ClrScr;
TextWindow(1,1,80,24,'Выберите сообщение и нажмите Enter');
MiniHelp;
WriteMenu(MenuFirst,MenuActive);
repeat
h:=ReadKey;
if (h=#13) and (TotalMessages<>0) then
  begin
    ClearZone(1,6,80,3,3);
    WindowColor:=3;
    textbackground(3);
    gotoxy(2,7);textcolor(14);
    P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
    s:=P^;
    write(Copy(s,15,78));
    TextWindow(1,9,29,5,'');
    val(Copy(s,14,1),l,Err);
    textcolor(14);
    gotoxy(15-Length(OnOff[l]) div 2,11);write(OnOff[l]);
    TextWindow(30,9,10,5,'Число');
    textcolor(14);
    gotoxy(34,11);write(Copy(s,1,2));
    TextWindow(40,9,10,5,'Месяц');
    textcolor(14);
    gotoxy(44,11);write(Copy(s,3,2));
    TextWindow(50,9,10,5,'Год');
    textcolor(14);
    gotoxy(53,11);write(Copy(s,5,4));
    TextWindow(60,9,21,5,'День недели');
    val(Copy(s,9,1),l,Err);
    textcolor(14);
    gotoxy(70-Length(Den[l]) div 2,11);write(Den[l]);
    TextWindow(60,14,10,5,'Час');
    textcolor(14);
    gotoxy(64,16);write(Copy(s,10,2));
    TextWindow(70,14,11,5,'Мин');
    textcolor(14);
    gotoxy(74,16);write(Copy(s,12,2));
    TextWindow(1,14,59,5,'');
    textcolor(14);
    gotoxy(26,16);write('Выход');
    y:=1;x:=1;xx:=1;CaseXY(14);
    repeat
    h:=ReadKey;
    if (h=#13) and not ((y=3) and (x=1)) then
      begin
        case y of
          1:begin
              si:=Copy(s,15,78);
              for f:=78 downto 1 do
                if si[f]=' ' then si:=Copy(si,1,f-1);
              cc:=InputData(2,7,78,English+Russian+Figures+Others);
              for f:=1 to 78-Length(cc) do cc:=cc+' ';
              s:=Copy(s,1,14)+cc;
              P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
              P^:=s
            end;
          2:case x of
              1:begin
                  On(3);
                  repeat
                  cc:=InputData(13,11,2,Figures);
                  until (cc='0') or (cc='1');
                  s[14]:=cc[1];
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(1,9,29,5,'');
                  val(Copy(s,14,1),l,Err);
                  textcolor(14);
                  gotoxy(15-Length(OnOff[l]) div 2,11);write(OnOff[l]);
                  On(14)
                end;
              2:begin
                  Chis(3);
                  repeat
                  cc:=InputData(34,11,2,Figures);
                  val(cc,l,Err);
                  until (cc='') or ((l>=1) and (l<=31));
                  if cc='' then cc:='  ';
                  if Length(cc)=1 then
                    begin
                      s[1]:=' ';
                      s[2]:=cc[1]
                    end
                                  else
                    begin
                      s[1]:=cc[1];
                      s[2]:=cc[2]
                    end;
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(30,9,10,5,'Число');
                  textcolor(14);
                  gotoxy(34,11);write(Copy(s,1,2));
                  Chis(14)
                end;
              3:begin
                  Mes(3);
                  repeat
                  cc:=InputData(44,11,2,Figures);
                  val(cc,l,Err);
                  until (cc='') or ((l>=1) and (l<=12));
                  if cc='' then
                    s:='  ';
                  if Length(cc)=1 then
                    begin
                      s[3]:=' ';
                      s[4]:=cc[1]
                    end
                                  else
                    begin
                      s[3]:=cc[1];
                      s[4]:=cc[2]
                    end;
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(40,9,10,5,'Месяц');
                  textcolor(14);
                  gotoxy(44,11);write(Copy(s,3,2));
                  Mes(14)
                end;
              4:begin
                  God(3);
                  repeat
                  cc:=InputData(53,11,4,Figures);
                  val(cc,l,Err);
                  until (cc='') or (l>=1000);
                  if cc='' then
                    begin
                      s[5]:=' ';
                      s[6]:=' ';
                      s[7]:=' ';
                      s[8]:=' '
                    end;
                  s[5]:=cc[1];
                  s[6]:=cc[2];
                  s[7]:=cc[3];
                  s[8]:=cc[4];
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(50,9,10,5,'Год');
                  textcolor(14);
                  gotoxy(53,11);write(Copy(s,5,4));
                  God(14)
                end;
              5:begin
                  Den_Ned(3);
                  repeat
                  cc:=InputData(69,11,2,Figures);
                  val(cc,l,Err);
                  until (cc='') or ((l>=0) and (l<=6));
                  if cc='' then s[9]:=' ';
                  s[9]:=cc[1];
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(60,9,21,5,'День недели');
                  val(Copy(s,9,1),l,Err);
                  textcolor(14);
                  gotoxy(70-Length(Den[l]) div 2,11);write(Den[l]);
                  Den_Ned(14)
                end;
            end;
          3:case x of
              2:begin
                  Chas(3);
                  repeat
                  cc:=InputData(64,16,2,Figures);
                  val(cc,l,Err);
                  until (cc='') or ((l>=0) and (l<=23));
                  if cc='' then
                    begin
                      s[1]:=' ';
                      s[2]:=' '
                    end;
                  if Length(cc)=1 then
                    begin
                      s[10]:=' ';
                      s[11]:=cc[1]
                    end
                                  else
                    begin
                      s[10]:=cc[1];
                      s[11]:=cc[2]
                    end;
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(60,14,10,5,'Час');
                  textcolor(14);
                  gotoxy(64,16);write(Copy(s,10,2));
                  Chas(14)
                end;
              3:begin
                  Min(3);
                  repeat
                  cc:=InputData(74,16,2,Figures);
                  val(cc,l,Err);
                  until (cc='') or ((l>=0) and (l<=59));
                  if cc='' then
                    begin
                      s[1]:=' ';
                      s[2]:=' '
                    end;
                  if Length(cc)=1 then
                    begin
                      s[12]:=' ';
                      s[13]:=cc[1]
                    end
                                  else
                    begin
                      s[12]:=cc[1];
                      s[13]:=cc[2]
                    end;
                  P:=Ptr(seg(PMessage[MenuActive]^),ofs(PMessage[MenuActive]^));
                  P^:=s;
                  TextWindow(70,14,11,5,'Мин');
                  textcolor(14);
                  gotoxy(74,16);write(Copy(s,12,2));
                  Min(14)
                end;
            end;
        end;
      end;
    if h=#0 then h:=ReadKey;
    if (h=#72) and (y=2) then
      begin
        CaseXY(3);
        y:=1;
        xx:=x;
        CaseXY(14)
      end;
    if (h=#72) and (y=3) then
      begin
        CaseXY(3);
        y:=2;
        if x>1 then x:=5;
        if (x=1) and (xx=5) then x:=1;
        if (x=1) and (xx<>5) then x:=xx;
        CaseXY(14)
      end;
    if (h=#80) and (y=2) then
      begin
        CaseXY(3);
        y:=3;
        xx:=x;
        if x<5 then x:=1
               else x:=2;
        CaseXY(14)
      end;
    if (h=#80) and (y=1) then
      begin
        CaseXY(3);
        y:=2;
        x:=xx;
        CaseXY(14)
      end;
    if (h=#75) and (y=2) and (x>1) then
      begin
        CaseXY(3);
        x:=x-1;
        CaseXY(14)
      end;
    if (h=#77) and (y=2) and (x<5) then
      begin
        CaseXY(3);
        x:=x+1;
        CaseXY(14)
      end;
    if (h=#77) and (y=3) and (x<3) then
      begin
        CaseXY(3);
        x:=x+1;
        CaseXY(14)
      end;
    if (h=#75) and (y=3) and (x>1) then
      begin
        CaseXY(3);
        x:=x-1;
        CaseXY(14)
      end;
    until (h=#13) and (y=3) and (x=1);
    WindowColor:=1;
    goto Start
  end;
if h=#0 then
  begin
    h:=ReadKey;
    if (h=#82) and (TotalMessages<MaxMessages) then
      begin
        if TotalMessages=0 then
          begin
            MenuFirst:=1;
            MenuActive:=1
          end;
        TotalMessages:=TotalMessages+1;
        GetMem(PMessage[TotalMessages],SizeOfLine);
        P:=Ptr(seg(PMessage[TotalMessages]^),ofs(PMessage[TotalMessages]^));
        P^:='             1Сообщение                                                                                   ';
        WriteMenu(MenuFirst,MenuActive)
      end;
    if (h=#83) and (TotalMessages>0) then
      begin
        Del:=true;
        for f:=MenuActive to TotalMessages-1 do
          begin
            P:=Ptr(seg(PMessage[f+1]^),ofs(PMessage[f+1]^));
            s:=P^;
            P:=Ptr(seg(PMessage[f]^),ofs(PMessage[f]^));
            P^:=s
          end;
        FreeMem(PMessage[TotalMessages],SizeOFLine);
        TotalMessages:=TotalMessages-1;
        if MenuActive=TotalMessages+1 then MenuActive:=TotalMessages;
        if ((MenuFirst+21)=TotalMessages+1) and (TotalMessages>22) then MenuFirst:=MenuFirst-1;
        WriteMenu(MenuFirst,MenuActive)
      end;
    if (h=#81) and (MenuActive<>TotalMessages) then
      begin
        if (MenuActive+22)<TotalMessages then
          begin
            MenuActive:=MenuActive+22;
            MenuFirst:=MenuFirst+22
          end
                                          else
          begin
            MenuActive:=TotalMessages;
            if TotalMessages>=22 then MenuFirst:=TotalMessages-21
                                 else MenuFirst:=1
          end;
        WriteMenu(MenuFirst,MenuActive)
      end;
    if (h=#73) and (MenuActive<>1) then
      begin
        if (MenuActive-22)>=1 then
          begin
            MenuActive:=MenuActive-22;
            MenuFirst:=MenuActive
          end
                                          else
          begin
            MenuActive:=1;
            MenuFirst:=1
          end;
        WriteMenu(MenuFirst,MenuActive)
      end;
    if (h=#72) and (MenuActive<>1) then
      begin
        if MenuActive<>MenuFirst then
          begin
            MenuActive:=MenuActive-1;
            WriteMenu(MenuFirst,MenuActive)
          end
                             else
          begin
            MenuFirst:=MenuFirst-1;
            MenuActive:=MenuActive-1;
            WriteMenu(MenuFirst,MenuActive)
          end;
      end;
    if (h=#80) and (MenuActive<>TotalMessages) then
      begin
        if MenuActive<>(MenuFirst+21) then
          begin
            MenuActive:=MenuActive+1;
            WriteMenu(MenuFirst,MenuActive)
          end
                             else
          begin
            MenuFirst:=MenuFirst+1;
            MenuActive:=MenuActive+1;
            WriteMenu(MenuFirst,MenuActive)
          end;
      end;
  end;
until h=#27;
Rewrite(msg);
for f:=1 to TotalMessages do
  begin
    P:=Ptr(seg(PMessage[f]^),ofs(PMessage[f]^));
    writeln(msg,CoderStr(P^,Key))
  end;
Close(msg);
for f:=1 to TotalMessages do FreeMem(PMessage[f],SizeOfLine);
textbackground(0);
ClrScr
end.