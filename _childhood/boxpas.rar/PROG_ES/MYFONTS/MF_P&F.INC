procedure PrintTitle;
var Title:BigTextType;
begin
ClearZone(1,1,80,25,0);
 Title[1]:='      11   11                                                                 ';
 Title[2]:='     1  1 1 1                                                                 ';
 Title[3]:='    1    1  1   1      1                                                      ';
 Title[4]:='   1        1   1      1                                                      ';
 Title[5]:='  1         1    1     1                                                      ';
 Title[6]:=' 1          1     111111                                                      ';
 Title[7]:='                       1                                                      ';
 Title[8]:='            11111111111                                                       ';
 Title[9]:='      111111                                                                  ';
Title[10]:='  1111                111111111111                          11                ';
Title[11]:='11                    111111111111                          11                ';
Title[12]:='                      11        11                          11                ';
Title[13]:='                      11        11                          11                ';
Title[14]:='                      11                                    11                ';
Title[15]:='                      11                                    11                ';
Title[16]:='                      111111       11111111   1111111    11111111    11111111 ';
Title[17]:='                      111111      11      11  11    111     11      11      11';
Title[18]:='                      11          11      11  11      11    11      11        ';
Title[19]:='                      11          11      11  11      11    11       11111111 ';
Title[20]:='                      11          11      11  11      11    11              11';
Title[21]:='                      11          11      11  11      11    11              11';
Title[22]:='                      11          11      11  11      11    11      11      11';
Title[23]:='                    111111         11111111   11      11     11111   11111111 ';
BigText(1,1,Title,78,23,'▀',0,2);
textcolor(9);gotoxy(30,25);
write('(C) OIV Company Ltd.');
SetCursor;
PressAnyKey;
ClearZone(1,1,80,25,0)
end;
function DeCoderSymbol(c:char):byte;
var s:byte;
begin
case c of
  'A':DeCoderSymbol:=10;
  'B':DeCoderSymbol:=11;
  'C':DeCoderSymbol:=12;
  'D':DeCoderSymbol:=13;
  'E':DeCoderSymbol:=14;
  'F':DeCoderSymbol:=15
       else
  begin
    val(c,s,Err);
    DeCoderSymbol:=s
  end
end
end;
function CoderSymbol(c:byte):char;
var s:string[1];
begin
case c of
  10:CoderSymbol:='A';
  11:CoderSymbol:='B';
  12:CoderSymbol:='C';
  13:CoderSymbol:='D';
  14:CoderSymbol:='E';
  15:CoderSymbol:='F'
       else
  begin
    str(c,s);
    CoderSymbol:=s[1]
  end
end
end;
procedure WorkWindow;
begin
WindowColor:=0;
LimitColor:=10;
NameColor:=12;
TextWindow(1,1,48,25,FileName);
textbackground(0);
for l:=0 to SizeY do
  for f:=0 to SizeX do
    begin
      p:=ptr(seg(PSymbol^),ofs(PSymbol^)+l*SizeMaxLine+f*SizeOf(Char));
      textcolor(DeCoderSymbol(p^));
      gotoxy(2+f*2,2+l);
      write('██')
    end;
SetCursor
end;
procedure SymbolWindow;
var s:string;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(49,1,32,5,'');
SetText(3,2,'Символ: '+Symbol[TekSymbol].Sym);
str(ord(Symbol[TekSymbol].Sym),s);
SetText(16,2,'ASCII код: '+s+'D');
SetText(3,4,Symbol[TekSymbol].Name)
end;
procedure OnOffWindow;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(49,6,14,3,'');
SetText(2,2,'Символ');
if OnOffSymbol[TekSymbol] then SetText(9,2,'вкл.')
                          else SetText(9,2,'выкл.')
end;
procedure XYWindow;
var s:string;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
NameColor:=10;
TextWindow(63,6,18,3,'Координаты');
str(YouX,s);
SetText(3,2,'X='+s);
str(YouY,s);
SetText(11,2,'Y='+s)
end;
procedure SetXY;
begin
textbackground(1);
textcolor(14);
gotoxy(67,7);write('      ');
gotoxy(67,7);write(YouX);
gotoxy(75,7);write('     ');
gotoxy(75,7);write(YouY);
SetCursor
end;
procedure ColorWindow;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
NameColor:=10;
TextWindow(49,9,14,3,'Цвет');
SetText(2,2,Colors[TekColor])
end;
procedure SetColor;
begin
textbackground(1);
textcolor(14);
gotoxy(50,10);
write('            ');
gotoxy(50,10);
write(Colors[TekColor]);
SetCursor
end;
procedure SizeWindow;
var s:string;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
NameColor:=10;
TextWindow(63,9,18,3,'Размер');
str(SizeX,s);
SetText(3,2,'X='+s);
str(SizeY,s);
SetText(11,2,'Y='+s)
end;
procedure MyFontsWindow;
var t:BigTextType;
begin
ClearZone(49,12,32,9,0);
textcolor(9);
textbackground(0);
gotoxy(50,12);
write('My');
SetCursor;
t[1]:='1111              1        ';
t[2]:='1  1              1        ';
t[3]:='1     111  1111  111   111 ';
t[4]:='1    1   1 1   1  1   1   1';
t[5]:='111  1   1 1   1  1   1    ';
t[6]:='1    1   1 1   1  1    111 ';
t[7]:='1    1   1 1   1  1       1';
t[8]:='1    1   1 1   1  1   1   1';
t[9]:='1     111  1   1   11  111 ';
BigText(52,12,t,27,9,'▀',0,9)
end;
procedure Help1Window;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(49,21,32,4,'');
SetText(3,2,'Курсор-движение  Enter-выбор');
end;
procedure Help2Window;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(49,21,32,4,'');
SetText(3,2,'F10-Меню');
end;
procedure VersionWindow;
begin
ClearZone(49,25,32,1,0);
textbackground(0);
textcolor(12);
gotoxy(49,25);
write('My Fonts  Version '+Version);
SetCursor
end;
procedure MainScreen;
begin
WorkWindow;
SymbolWindow;
OnOffWindow;
XYWindow;
ColorWindow;
SizeWindow;
MyFontsWindow;
Help2Window;
VersionWindow
end;
function MainMenu:byte;
var m:MenuType;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
NameColor:=10;
TextWindow(49,12,32,9,'Меню');
 m[1]:='Редактирование                ';{}
 m[2]:='Новый шрифт                   ';{}
 m[3]:='Открыть                F3     ';
 m[4]:='Сохранить              F2     ';
 m[5]:='Сохранить как...       Ctrl-F2';
 m[6]:='Изменить цвет          F8     ';{}
 m[7]:='Обмен данными          F5     ';
 m[8]:='Правка                 F4     ';
 m[9]:='Графика                F6     ';
m[10]:='Размер шрифта          F7     ';
m[11]:='Символы                F9     ';
m[12]:='Выход                  Alt-X  ';{}
MainMenu:=Menu(2,2,m,12)
end;
procedure Redakt;
var b:ButtonsType;
begin
if FileName='' then
  begin
    WindowColor:=1;
    LimitColor:=15;
    TxtColor:=14;
    TextWindow(30,8,20,7,'');
    SetText(3,3,'Не открыт шрифт!');
    b[1]:='Ok';
    l:=Buttons(35,12,10,1,0,b,1,LeftChar,RightChar);
    textbackground(0);
    ClrScr;
    WorkWindow;
    SymbolWindow;
    OnOffWindow;
    XYWindow;
    ColorWindow;
    SizeWindow;
    Help1Window;
    VersionWindow;
    Yes:=false
  end
end;
procedure NewFont;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(27,9,26,5,'');
SetText(3,3,'Создается новый шрифт!');
for l:=0 to SizeMaxLine-1 do
  for f:=0 to SizeMaxLine-1 do
    begin
      p:=ptr(seg(PSymbol^),ofs(PSymbol^)+l*SizeMaxLine+f*SizeOf(Char));
      p^:='0'
    end;
FileName:='noname.tpf';
TekSymbol:=1;
YouX:=0;
YouY:=0;
for f:=2 to TotalSymbols do OnOffSymbol[f]:=false;
OnOffSymbol[1]:=true;
textbackground(0);
ClrScr;
WorkWindow;
SymbolWindow;
OnOffWindow;
XYWindow;
ColorWindow;
SizeWindow;
Help1Window;
VersionWindow;
Yes:=false
end;
procedure SaveFont(m:boolean);
var ff:text;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
TextWindow(25,9,31,5,'');
SetText(3,3,'Идет запись символа на диск!');
Assign(ff,FileName);
Rewrite(ff);
writeln(ff,SizeX);
writeln(ff,SizeY);
if not OnOffSymbol[TekSymbol] then write(ff,#2)
                              else
   for d:=0 to SizeY do
     for f:=0 to SizeX do
       begin
         p:=ptr(seg(PSymbol^),ofs(PSymbol^)+d*SizeMaxLine+f*SizeOf(Char));
         write(ff,p^)
       end;
Close(ff);
end;
procedure ChangeColor;
begin
TekColor:=TekColor+1;
if TekColor=16 then TekColor:=0;
SetColor;
Yes:=false
end;
procedure ExitProgram(m:boolean);
var
    b:ButtonsType;
    f:byte;
begin
WindowColor:=1;
LimitColor:=15;
TxtColor:=14;
NameColor:=10;
TextWindow(28,8,24,7,'Выход');
SetText(7,3,'Вы уверены?');
b[1]:='Да';
b[2]:='Нет';
ButtonColor:=10;
ActiveButtonColor:=12;
f:=Buttons(30,12,8,4,0,b,2,LeftChar,RightChar);
if f=1 then
  begin
    textbackground(0);
    ClrScr;
    FreeMem(PSymbol,SQR(SizeMaxLine));
    Halt
  end;
if m then
begin
textbackground(0);
ClrScr;
WorkWindow;
SymbolWindow;
OnOffWindow;
XYWindow;
ColorWindow;
SizeWindow;
Help1Window;
VersionWindow;
Yes:=false;
exit
end;
textbackground(0);
ClrScr;
MainScreen
end;
procedure SetYou(col:byte;cls:boolean);
begin
if cls then
  begin
    textcolor(col);
    gotoxy(2+YouX*2,2+YouY);
    write('██');
    SetCursor;
    exit
  end;
textbackground(0);
textcolor(col);
if col=0 then textcolor(Random(15)+1);
gotoxy(2+YouX*2,2+YouY);
write('><');
SetCursor
end;