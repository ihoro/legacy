{**********************************}
{                                  }
{ "Regime of Windows" Version 1.0  }
{  OIV Company Ltd.  April,1 2000  }
{                                  }
{**********************************}

Unit ROW;

Interface

Uses Drivers;

Var

   Mouse :TEvent;
   f     :Integer;
   What  :String;

StatusLineOptions:Array[1..20] of
    Record
     Name      :String;
     PressName :String;
     X         :Byte;
     OX        :Byte
    end;

Windows:
    Record
     Name  :String;
     X     :Byte;
     Y     :Byte;
     OX    :Byte;
     OY    :Byte
    end;

Buttons:Array[1..50] of
    Record
     Name :String;
     X    :Byte;
     Y    :Byte;
     OX   :Byte;
     OY   :Byte
    end;

InputLines:Array[1..50] of
    Record
     Name :String;
     Text :String;
     X    :Byte;
     Y    :Byte;
     OX   :Byte
    end;

    { StatusLine }

StatusLine_Y         :Byte;
StatusLineColor      :Byte;
StatusLineBKColor    :Byte;
StatusLinePressColor :Byte;
StatusLineAllOptions :Byte;

    { Window }

WindowOpen           :Boolean;
WindowCloseDelay     :Word;
WindowChar           :Char;
WindowCloseChar      :Char;
WindowColor          :Byte;
WindowBKColor        :Byte;
WindowLimitColor     :Byte;
WindowClose_X        :Byte;
WindowClose_Y        :Byte;
WindowCloseCharColor :Byte;
WindowShadowColor    :Byte;

    { Window Input Line }

WindowAllInputLines :Byte;
InputLineColor      :Byte;
InputLineTextColor  :Byte;
InputLineNameColor  :Byte;
InputLine           :Byte;
NILine              :String;

    { Window Text }

WindowTextColor :Byte;

    { Window Button }

WindowAllButtons      :Byte;
WindowButtonColor     :Byte;
WindowButtonNameColor :Byte;
PushButtonDelay       :Word;

    { Ground }

GroundChar    :Char;
GroundColor   :Byte;
GroundBKColor :Byte;
Ground_X      :Byte;
Ground_Y      :Byte;
Ground_OX     :Byte;
Ground_OY     :Byte;

    { Enter Options }

EnterOptionsColor :Byte;
EnterOptionsDelay :Byte;

    { Return Cursor }

ReturnChar        :Char;
Return_X          :Byte;
Return_Y          :Byte;
ReturnCharColor   :Byte;
ReturnCharBKColor :Byte;

    { Password }

EnterPassword :Boolean;

    { Mouse }

MouseOn :Boolean;

procedure A;
procedure OIVCompanyLtd_01_05_85_PopCorn;
procedure MessageError(Error:string);
procedure ReturnCursor;
procedure Mouse_On;
procedure Mouse_Off;
function  MouseX:byte;
function  MouseY:byte;
procedure SetGround;
procedure Window(Window_X, Window_Y, Window_OX, Window_OY:byte; NameWindow:string);
procedure WindowText(WX,WY:byte;T:string);
procedure WindowButton(B_X,B_Y,B_OX,B_OY:byte;BName:string);
procedure WindowInputLine(I_X,I_Y,I_OX:byte;IName:string;var per:string);
procedure InputLineOn(N:string);
procedure InputWhat(var per:string);
procedure CloseWindow;
procedure StatusLine(Status,SLine:string);
procedure EnterOptions(Name:string);
procedure PushButton(BName:string);
function  MousePush:string;
function  ButtonOptions:string;

Implementation

Uses Crt;

Const
     Version :String = '1.0';
     Symbols :String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'+
                       'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя'+
                       '1234567890~&@^{}\<>|[]()-/":,._?%!*; '+#8;

    { Procedures and Functions }

procedure A;
begin
EnterPassword:=true
end;

procedure MessageError(Error :String);
begin
textbackground(0);
ClrScr;
textcolor(12);
if Error=' У вас нет доступа к программе "Regime of Windows" Version '+Version
  then Writeln('      Защита:')
  else Writeln('      Ошибка:');
textcolor(15);
Writeln(Error);
Halt
end;

procedure ReturnCursor;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
gotoxy(Return_X,Return_Y);
textcolor(ReturnCharColor);
textbackground(ReturnCharBKColor);
write(ReturnChar);
gotoxy(Return_X,Return_Y)
end;

procedure Mouse_On;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
InitEvents;HideMouse;
ShowMouse;
MouseOn:=true
end;

procedure Mouse_Off;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
DoneEvents;
MouseOn:=false
end;

procedure OIVCompanyLtd_01_05_85_PopCorn;
begin
EnterPassword:=true
end;

function MouseX :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if MouseOn=false then MessageError(' MouseX  -  Не включена мышка!');
GetMouseEvent(Mouse);
if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then MouseX:=Mouse.Where.X+1;
MouseX:=Mouse.Where.X+1
end;

function MouseY :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if MouseOn=false then MessageError(' MouseY  -  Не включена мышка!');
GetMouseEvent(Mouse);
if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then MouseY:=Mouse.Where.Y+1;
MouseY:=Mouse.Where.Y+1
end;

procedure SetGround;
var Ground_F :Byte;
    Ground_L :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
textbackground(GroundBKColor);
textcolor(GroundColor);
for Ground_F:=Ground_Y to Ground_Y+Ground_OY-1 do
 for Ground_L:=Ground_X to Ground_X+Ground_OX-1 do
 begin gotoxy(Ground_L,Ground_F);write(GroundChar) end;
if (Ground_Y+Ground_OY-1) <25 then
for f:=1 to 80 do begin gotoxy(f,Ground_Y+Ground_OY-1); write(' ') end
end;

procedure Window(Window_X, Window_Y, Window_OX, Window_OY :Byte; NameWindow :String);
var Window_F :Byte;
    Window_L :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if ((Window_X+Window_OX-1)>80) or ((Window_Y+Window_OY-1)>25) or (Window_X=0) or (Window_Y=0) then
  MessageError(' Window()  -  Окно вышло за границы экрана!');
textbackground(WindowBKColor);
textcolor(WindowColor);
for Window_F:=Window_Y to Window_Y+Window_OY-1 do
 for Window_L:=Window_X to Window_X+Window_OX-1 do
 begin gotoxy(Window_L,Window_F);write(WindowChar) end;
gotoxy(Window_X,Window_Y);
textcolor(WindowLimitColor);
textbackground(WindowColor);
write('╔');
gotoxy(Window_X,Window_Y+Window_OY-1);
write('╚');
for Window_F:=Window_X+1 to Window_X+Window_OX-2 do
begin
 gotoxy(Window_F,Window_Y);
 write('═');
 gotoxy(Window_F,Window_Y+Window_OY-1);
 write('═')
end;
write('╝');
gotoxy(Window_X+Window_OX-1,Window_Y);
write('╗');
for Window_L:=Window_Y+1 to Window_Y+Window_OY-2 do
begin
 gotoxy(Window_X,Window_L);
 write('║');
 gotoxy(Window_X+Window_OX-1,Window_L);
 write('║')
end;
gotoxy((Window_X+Window_OX-1) -Window_OX DIV 2 - Length(NameWindow) DIV 2 - 1,Window_Y);
write(' '+NameWindow+' ');
gotoxy(Window_X+2,Window_Y);
write('[');
textcolor(WindowCloseCharColor);
write('■');
textcolor(WindowLimitColor);
write(']');
WindowClose_X:=Window_X+3;
WindowClose_Y:=Window_Y;
textbackground(WindowShadowColor);
for Window_L:=Window_Y+1 to Window_Y+Window_OY do
begin
gotoxy(Window_X+Window_OX,Window_L);
write('  ')
end;
for Window_F:=Window_X+2 to Window_X+Window_OX+1 do
begin
gotoxy(Window_F,Window_Y+Window_OY);
write(' ')
end;
ReturnCursor;
WindowOpen:=true;
With Windows do
begin
 Name:=NameWindow;
 X:=Window_X;
 Y:=Window_Y;
 OX:=Window_OX;
 OY:=Window_OY
end
end;

procedure WindowText(WX,WY :Byte;T :String);
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if WindowOpen=false then
  MessageError(' WindowText()  -  Нет открытого окна!');
if ((Windows.X+WX) < Windows.X) or ((Windows.X+WX) > (Windows.X+Windows.OX-1))
   or ((Windows.Y+WY) < Windows.Y) or ((Windows.Y+WY) > (Windows.Y+Windows.OY-1))
then
  MessageError(' WindowText()  -  Координаты текста не совпадают с координатами окна!');
if (Length(T)+WX+Windows.X) > (Windows.OX+Windows.X-1) then
  MessageError(' WindowText()  -  Текст не помещается в окне!');
if (WX=0) or (WY=0) or (Windows.Y+WY=Windows.Y+Windows.OY-1) then
  MessageError(' WindowText()  -  Текст залез на рамку окна!');
gotoxy(Windows.X+WX,Windows.Y+WY);
textcolor(WindowTextColor);
textbackground(WindowColor);
Write(T);
ReturnCursor
end;

procedure WindowButton(B_X,B_Y,B_OX,B_OY :Byte;BName :String);
var f :Byte;
    l :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if WindowOpen=false then
  MessageError(' WindowButton()  -  Нет открытого окна!');
if B_OX=0 then
  MessageError(' WindowButton(.., .., 0, .., ..)  -  Неправильные параметры!');
if B_OY=0 then
  MessageError(' WindowButton(.., .., .., 0, ..)  -  Неправильные параметры!');
if ((B_X+Windows.X)<(Windows.X+1)) or ((B_X+Windows.X)>(Windows.X+Windows.OX-3))
 or ((B_Y+Windows.Y)<(Windows.Y+1)) or ((B_Y+Windows.Y)>(Windows.Y+Windows.OY-2)) then
  MessageError(' WindowButton()  -  Координаты кнопки не совпадают с координатами окна!');
if ((Windows.X+B_X+B_OX-1)>(Windows.X+Windows.OX-3)) or ((Windows.Y+B_Y+B_OY-1)>(Windows.Y+Windows.OY-3)) then
  MessageError(' WindowButton()  -  Кнопка не помещается в окне!');
if B_OX<Length(BName) then MessageError('WindowButton()  -  Название кнопки больше ее длины!');
textbackground(WindowButtonColor);
if StatusLineAllOptions<>0 then
 for f:=1 to StatusLineAllOptions do
  if (BName=StatusLineOptions[f].PressName) or (BName=StatusLineOptions[f].Name) then
    MessageError('WindowButton()  -  Одинаковое имя у кнопки и опции!');
if WindowAllButtons<>0 then
 for f:=1 to WindowAllButtons do
  if BName=Buttons[f].Name then
    MessageError('WindowButton()  -  Одинаковое имя у кнопок!');
for l:=1 to B_OY do
begin
  gotoxy(Windows.X+B_X,Windows.Y+B_Y+l-1);
  for f:=1 to B_OX do write(' ')
end;
textcolor(WindowShadowColor);
textbackground(WindowColor);
gotoxy(Windows.X+B_X+B_OX,Windows.Y+B_Y);
write('▄');
for f:=1 to B_OY-1 do
begin
  gotoxy(Windows.X+B_X+B_OX,Windows.Y+B_Y+f);
  write('█')
end;
gotoxy(Windows.X+B_X+1,Windows.Y+B_Y+B_OY);
for f:=1 to B_OX do write('▀');
textcolor(WindowButtonNameColor);
textbackground(WindowButtonColor);
gotoxy(Windows.X+B_X+B_OX div 2-Length(BName) div 2,Windows.Y+B_Y+B_OY div 2);
write(BName);
WindowAllButtons:=WindowAllButtons+1;
With Buttons[WindowAllButtons] do
begin
 X:=B_X;
 Y:=B_Y;
 OX:=B_OX;
 OY:=B_OY;
 Name:=BName
end;
ReturnCursor
end;

procedure StatusLine(Status, SLine :String);
var f :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if (StatusLine_Y+Length(Status)+Length(SLine)+1) >79 then
 MessageError(Status+' '+SLine+' - эта опция не помещается!');
if StatusLineAllOptions<>0 then
 for f:=1 to StatusLineAllOptions do
  if (Status=StatusLineOptions[f].PressName) or (SLine=StatusLineOptions[f].Name) then
    MessageError('StatusLine()  -  Одинаковое имя у опций!');
if WindowAllButtons<>0 then
 for f:=1 to WindowAllButtons do
  if (Status=Buttons[f].Name) or (SLine=Buttons[f].Name) then
    MessageError('StatusLine()  -  Одинаковое имя у опции и кнопки!');
textbackground(StatusLineBKColor);
textcolor(StatusLinePressColor);
GotoXY(StatusLine_Y,Ground_Y+Ground_OY-1);
write(Status,' ');
textcolor(StatusLineColor);
write(SLine,' ');
StatusLineAllOptions:=StatusLineAllOptions+1;
With StatusLineOptions[StatusLineAllOptions] do
begin
Name:=Sline;
PressName:=Status;
X:=StatusLine_Y;
OX:=Length(Status)+Length(SLine)+1
end;
StatusLine_Y:=StatusLine_Y+length(Status)+length(SLine)+2;
end;

procedure CloseWindow;
var f   :Byte;
    l   :Byte;
    xx  :Byte;
    yy  :Byte;
    WX  :Byte;
    WY  :Byte;
    WOX :Byte;
    WOY :Byte;
    WN  :String;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if WindowOpen=false then
  MessageError(' CloseWindow  -  Нет открытого окна!');
DoneEvents;
for f:=1 to Windows.OY div 2-1 do
 begin
  textcolor(GroundColor);
  textbackground(GroundBKColor);
  gotoxy(Windows.X,Windows.Y+f-1);
  for l:=1 to Windows.OX do write(GroundChar);
  write(GroundChar,GroundChar);
  gotoxy(Windows.X+Windows.OX,Windows.Y+f);
  write(GroundChar,GroundChar);
  gotoxy(Windows.X,Windows.Y+Windows.OY-f);
  for l:=1 to Windows.OX do write(GroundChar);
  write(GroundChar,GroundChar);
  gotoxy(Windows.X+2,Windows.Y+Windows.OY-f+1);
  for l:=1 to Windows.OX do write(GroundChar);
  WX:=Windows.X;
  WY:=Windows.Y;
  WOX:=Windows.OX;
  WOY:=Windows.OY;
  WN:=Windows.Name;
  Window(Windows.X,Windows.Y+f,Windows.OX,Windows.OY-f*2,Windows.Name);
  Windows.X:=WX;
  Windows.Y:=WY;
  Windows.OX:=WOX;
  Windows.OY:=WOY;
  Windows.Name:=WN;
  Delay(WindowCloseDelay)
 end;
textcolor(GroundColor);
textbackground(GroundBKColor);
if Windows.OY mod 2 = 0 then
 begin
  gotoxy(Windows.X,Windows.Y+f);
  for l:=1 to Windows.OX do write(GroundChar);
  gotoxy(Windows.X,Windows.Y+f+1);
  for l:=1 to Windows.OX+2 do write(GroundChar);
  gotoxy(Windows.X+2,Windows.Y+f+2);
  for l:=1 to Windows.OX do write(GroundChar);
 end;
if Windows.OY mod 2 <> 0 then
 begin
  gotoxy(Windows.X,Windows.Y+f);
  for l:=1 to Windows.OX do write(GroundChar);
  gotoxy(Windows.X,Windows.Y+f+1);
  for l:=1 to Windows.OX+2 do write(GroundChar);
  gotoxy(Windows.X,Windows.Y+f+2);
  for l:=1 to Windows.OX+2 do write(GroundChar);
  gotoxy(Windows.X+2,Windows.Y+f+3);
  for l:=1 to Windows.OX do write(GroundChar);
 end;
WindowOpen:=false;
InitEvents;HideMouse;ShowMouse;
Mouse.Where.X:=WindowClose_X;
Mouse.Where.Y:=WindowClose_Y;
WindowAllButtons:=0;
WindowAllInputLines:=0;
InputLine:=0;
ReturnCursor
end;

function MousePush :String;
var fo  :Byte;
    xxx :Byte;
    yyy :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if MouseOn=false then MessageError(' MousePush  -  Не включена мышка!');
MousePush:='';
GetMouseEvent(Mouse);
if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then
 begin
  xxx:=Mouse.Where.X+1;
  yyy:=Mouse.Where.Y+1
 end;
  xxx:=Mouse.Where.X+1;
  yyy:=Mouse.Where.Y+1;
if (Mouse.What = EvMouseDown) and (Mouse.Buttons = mbLeftButton) then
begin
if StatusLineAllOptions<>0 then
 for f:=1 to StatusLineAllOptions do
   if (xxx >=StatusLineOptions[f].X)
    and (xxx <=(StatusLineOptions[f].X+StatusLineOptions[f].OX-1))
     and (yyy=(Ground_Y+Ground_OY-1)) then
  begin
    MousePush:=StatusLineOptions[f].Name;
    f:=StatusLineAllOptions
  end;
if (xxx = WindowClose_X) and (yyy=WindowClose_Y) then MousePush:='CloseWindow';
if WindowAllButtons<>0 then
 for f:=1 to WindowAllButtons do
 if (xxx>=(Windows.X+Buttons[f].X)) and (xxx<=(Windows.X+Buttons[f].X+Buttons[f].OX-1))
  and (yyy>=(Windows.Y+Buttons[f].Y)) and (yyy<=(Windows.Y+Buttons[f].Y+Buttons[f].OY-1)) then
   begin
     MousePush:=Buttons[f].Name;
     f:=WindowAllButtons
   end;
if WindowAllInputLines<>0 then
  for f:=1 to WindowAllInputLines do
   if ((xxx>=(InputLines[f].X+Windows.X)) and (xxx<=(InputLines[f].X+InputLines[f].OX+Windows.X-1))
      and (yyy=(InputLines[f].Y+Windows.Y))) OR
      ((xxx>=(InputLines[f].X+Windows.X)) and (xxx<=(InputLines[f].X+Windows.X+Length(InputLines[f].Name)-1))
       and (yyy=(InputLines[f].Y+Windows.Y-1)))
      then MousePush:=InputLines[f].Name;
end
end;

function ButtonOptions :String;
var fo :Byte;
    h  :Char;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
ButtonOptions:='';
if KeyPressed then
begin
h:=ReadKey;
if StatusLineAllOptions<>0 then
 for fo:=1 to StatusLineAllOptions do
  if UpCase(h)=UpCase(StatusLineOptions[fo].PressName[1]) then
   begin
     ButtonOptions:=StatusLineOptions[fo].Name;
     fo:=StatusLineAllOptions
   end;
end;
end;

procedure EnterOptions(name :String);
var f     :Byte;
    nomer :Byte;
    OkNo  :Boolean;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
OkNo:=false;
if StatusLineAllOptions<>0 then
begin
 for f:=1 to StatusLineAllOptions do
  if name=StatusLineOptions[f].Name then begin OkNo:=true;nomer:=f;f:=StatusLineAllOptions end;
end
                           else OkNo:=false;
if OkNo=false then
 MessageError(name+' - такой опции не существует!')
              else
begin
 textbackground(EnterOptionsColor);
 textcolor(StatusLinePressColor);
 gotoxy(StatusLineOptions[nomer].X-1,Ground_Y+Ground_OY-1);
 write(' '+StatusLineOptions[nomer].PressName+' ');
 textcolor(StatusLineColor);
 write(StatusLineOptions[nomer].Name+' ');
 Delay(EnterOptionsDelay);
 textbackground(GroundBKColor);
 textcolor(StatusLinePressColor);
 gotoxy(StatusLineOptions[nomer].X-1,Ground_Y+Ground_OY-1);
 write(' '+StatusLineOptions[nomer].PressName+' ');
 textcolor(StatusLineColor);
 write(StatusLineOptions[nomer].Name+' ');
 ReturnCursor
end
end;

procedure PushButton(BName :String);
var f     :Byte;
    l     :Byte;
    xxx   :Byte;
    yyy   :Byte;
    nomer :Byte;
    OkNo  :Boolean;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
OkNo:=false;
if WindowAllButtons=0 then MessageError(' PushButton()  -  Нет ни одной кнопки!');
for f:=1 to WindowAllButtons do
 if BName=Buttons[f].Name then
   begin
     nomer:=f;
     OkNo:=true;
     f:=WindowAllButtons
   end;
if OkNo=false then MessageError(BName+'  -  Нет кнопки с таким названием!');
GetMouseEvent(Mouse);
if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then
 begin
  xxx:=Mouse.Where.X+1;
  yyy:=Mouse.Where.Y+1
 end;
xxx:=Mouse.Where.X+1;
yyy:=Mouse.Where.Y+1;
DoneEvents;
textbackground(WindowBKColor);
textcolor(WindowColor);
for l:=1 to Buttons[nomer].OY do
begin
  gotoxy(Windows.X+Buttons[nomer].X,Windows.Y+Buttons[nomer].Y+l-1);
  for f:=1 to Buttons[nomer].OX do write(WindowChar)
end;
gotoxy(Windows.X+Buttons[nomer].X+Buttons[nomer].OX,Windows.Y+Buttons[nomer].Y);
write(WindowChar);
for f:=1 to Buttons[nomer].OY-1 do
begin
  gotoxy(Windows.X+Buttons[nomer].X+Buttons[nomer].OX,Windows.Y+Buttons[nomer].Y+f);
  write(WindowChar)
end;
gotoxy(Windows.X+Buttons[nomer].X+1,Windows.Y+Buttons[nomer].Y+Buttons[nomer].OY);
for f:=1 to Buttons[nomer].OX do write(WindowChar);
textbackground(WindowButtonColor);
for l:=1 to Buttons[nomer].OY do
begin
  gotoxy(Windows.X+Buttons[nomer].X+1,Windows.Y+Buttons[nomer].Y+l-1);
  for f:=1 to Buttons[nomer].OX do write(' ')
end;
textcolor(WindowButtonNameColor);
textbackground(WindowButtonColor);
gotoxy(Windows.X+Buttons[nomer].X+1+Buttons[nomer].OX div 2-Length(BName) div 2,
  Windows.Y+Buttons[nomer].Y+Buttons[nomer].OY div 2);
write(BName);
Delay(PushButtonDelay);
textbackground(WindowButtonColor);
for l:=1 to Buttons[nomer].OY do
begin
  gotoxy(Windows.X+Buttons[nomer].X,Windows.Y+Buttons[nomer].Y+l-1);
  for f:=1 to Buttons[nomer].OX do write(' ')
end;
textcolor(WindowShadowColor);
textbackground(WindowColor);
gotoxy(Windows.X+Buttons[nomer].X+Buttons[nomer].OX,Windows.Y+Buttons[nomer].Y);
write('▄');
for f:=1 to Buttons[nomer].OY-1 do
begin
  gotoxy(Windows.X+Buttons[nomer].X+Buttons[nomer].OX,Windows.Y+Buttons[nomer].Y+f);
  write('█')
end;
gotoxy(Windows.X+Buttons[nomer].X+1,Windows.Y+Buttons[nomer].Y+Buttons[nomer].OY);
for f:=1 to Buttons[nomer].OX do write('▀');
textcolor(WindowButtonNameColor);
textbackground(WindowButtonColor);
gotoxy(Windows.X+Buttons[nomer].X+Buttons[nomer].OX div 2-Length(BName) div 2,
  Windows.Y+Buttons[nomer].Y+Buttons[nomer].OY div 2);
write(BName);
InitEvents;
HideMouse;
ShowMouse;
Mouse.Where.X:=xxx;
Mouse.Where.Y:=yyy;
ReturnCursor
end;

procedure WindowInputLine(I_X,I_Y,I_OX :Byte;IName :String;var per :String);
var f :Byte;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if WindowOpen=false then MessageError(' WindowInputLine  -  Нет открытого окна!');
if ((Windows.X+I_X)<(Windows.X+1)) or ((Windows.X+I_X)>(Windows.X+Windows.OX-3))
   or ((Windows.Y+I_Y)<(Windows.Y+2)) or ((Windows.Y+I_Y)>(Windows.Y+Windows.OY-2))
    then MessageError(' WindowInputLine  -  Координаты строки ввода данных не совпадают с координатами окна!');
if ((Windows.X+I_X+I_OX-1)>(Windows.X+Windows.OX-1)) or ((Windows.Y+I_Y)>(Windows.Y+Windows.OY-1))
    then MessageError('WindowInputLine  -  Строка ввода данных не помещается в окне!');
if Length(IName)>I_OX then MessageError('WindowInputLine  -  Название строки ввода данных больше ее длины!');
if StatusLineAllOptions<>0 then
 for f:=1 to StatusLineAllOptions do
  if (IName=StatusLineOptions[f].PressName) or (IName=StatusLineOptions[f].Name) then
    MessageError(' WindowInputLine()  -  Одинаковое имя у строки ввода данных и опции!');
if WindowAllButtons<>0 then
 for f:=1 to WindowAllButtons do
  if IName=Buttons[f].Name then
    MessageError(' WindowInputLine()  -  Одинаковое имя у строки ввода данных и кнопки!');
if WindowAllInputLines<>0 then
 for f:=1 to WindowAllInputLines do
  if IName=InputLines[f].Name then
    MessageError(' WindowInputLine()  -  Одинаковое имя у строк ввода данных!');
per:='';
textbackground(InputLineColor);
gotoxy(Windows.X+I_X,Windows.Y+I_Y);
for f:=1 to I_OX do write(' ');
textbackground(WindowColor);
textcolor(InputLineNameColor);
gotoxy(Windows.X+I_X,Windows.Y+I_Y-1);
write(IName);
WindowAllInputLines:=WindowAllInputLines+1;
With InputLines[WindowAllInputLines] do
begin
 X:=I_X;
 Y:=I_Y;
 OX:=I_OX;
 Name:=IName;
 Text:=per
end;
ReturnCursor
end;

procedure InputLineOn(N :String);
var f     :Byte;
    nomer :Byte;
    OkNo  :Boolean;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if WindowOpen=false then MessageError(' InputLineOn  -  Нет открытого окна!');
if WindowAllInputLines=0 then MessageError(' InputLineOn  -  Нет ни одной строки ввода данных!');
OkNo:=false;
for f:=1 to WindowAllInputLines do
 if N=InputLines[f].Name then
   begin
    nomer:=f;
    OkNo:=true;
    f:=WindowAllInputLines
   end;
if OkNo=false then MessageError(N+'  -  Нет строки ввода данных с таким названием!');
textcolor(InputLineTextColor);
textbackground(InputLineColor);
gotoxy(Windows.X+InputLines[nomer].X,Windows.Y+InputLines[nomer].Y);
write(InputLines[nomer].Text);
InputLine:=nomer;
NILine:=InputLines[nomer].Name
end;

procedure InputWhat(var per :String);
var f    :Byte;
    xxx  :Byte;
    yyy  :Byte;
    h    :Char;
    OkNo :Boolean;
begin
if EnterPassword=false then MessageError(' У вас нет доступа к программе "Regime of Windows" Version '+Version);
if InputLine<>0 then
  if KeyPressed then
   begin
     h:=ReadKey;
     OkNo:=false;
     for f:=1 to Length(Symbols) do
      if h=Symbols[f] then
         begin
           OkNo:=true;
           f:=Length(Symbols)
         end;
     if OkNo then
       begin
         if (h=#8) and (Length(per)=1) then per:='';
         if (h=#8) and (Length(per)>1) then per:=copy(per,1,Length(per)-1);
         if (h<>#8) and (Length(per)<(InputLines[InputLine].OX-1)) then per:=per+h;
         InputLines[InputLine].Text:=per;
         textcolor(InputLineTextColor);
         textbackground(InputLineColor);
         GetMouseEvent(Mouse);
         if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then
         begin
          xxx:=Mouse.Where.X+1;
          yyy:=Mouse.Where.Y+1
         end;
         xxx:=Mouse.Where.X+1;
         yyy:=Mouse.Where.Y+1;
         DoneEvents;
         if Length(per)<>0 then gotoxy(Windows.X+InputLines[InputLine].X+Length(per)-1,Windows.Y+InputLines[InputLine].Y)
                           else gotoxy(Windows.X+InputLines[InputLine].X+Length(per),Windows.Y+InputLines[InputLine].Y);
         for f:=1 to InputLines[InputLine].OX-Length(per) do write(' ');
         gotoxy(Windows.X+InputLines[InputLine].X,Windows.Y+InputLines[InputLine].Y);
         write(per);
         InitEvents;
         HideMouse;
         ShowMouse;
         Mouse.Where.X:=xxx;
         Mouse.Where.Y:=yyy
       end
   end
end;

Begin

    { Standart Variables }

For F:=1 to 20 do
With StatusLineOptions[f] do
Begin
 Name                 :='';
 PressName            :='';
 X                    :=0;
 OX                   :=0
End;
What                  :='';
EnterPassword         :=false;
MouseOn               :=false;
StatusLineAllOptions  :=0;
StatusLineColor       :=0;
StatusLine_Y          :=3;
StatusLineBKColor     :=7;
StatusLinePressColor  :=4;
GroundChar            :='░';
GroundColor           :=1;
GroundBKColor         :=7;
Ground_X              :=1;
Ground_Y              :=1;
Ground_OX             :=80;
Ground_OY             :=25;
WindowColor           :=7;
WindowBKColor         :=1;
WindowLimitColor      :=15;
WindowChar            :='█';
WindowCloseChar       :='■';
WindowCloseCharColor  :=10;
WindowClose_X         :=0;
WindowClose_Y         :=0;
WindowCloseDelay      :=1;
WindowShadowColor     :=0;
WindowTextColor       :=0;
WindowAllButtons      :=0;
WindowButtonColor     :=10;
WindowButtonNameColor :=14;
WindowAllInputLines   :=0;
InputLineColor        :=9;
InputLineTextColor    :=14;
InputLineNameColor    :=15;
InputLine             :=0;
NILine                :='';
PushButtonDelay       :=300;
Return_X              :=1 ;
Return_Y              :=25;
ReturnChar            :='Ў';
ReturnCharColor       :=13;
ReturnCharBKColor     :=7;
EnterOptionsColor     :=10;
EnterOptionsDelay     :=250

End.