uses Drivers, Crt;

var
   Mouse:TEvent;
   f,l:integer;

StatusLineOptions:array[1..20] of
    Record
     Name:string;
     PressName:string;
     X:byte;
     OX:byte
    end;

Windows:
    record
     Name:string;
     X:byte;
     Y:byte;
     OX:byte;
     OY:byte
    end;

WindowOpen:boolean;

WindowCloseDelay:word;

GroundChar,
WindowChar,
WindowCloseChar,
ReturnChar :char;

StatusLine_Y,
StatusLineColor,
StatusLineBKColor,
StatusLinePressColor,
StatusLineAllOptions,
GroundColor,
GroundBKColor,
Ground_X,
Ground_Y,
Ground_OX,
Ground_OY,
WindowColor,
WindowBKColor,
WindowLimitColor,
WindowClose_X,
WindowClose_Y,
WindowCloseCharColor,
WindowShadowColor,
WindowTextColor,
Return_X,
Return_Y,
ReturnCharColor,
ReturnCharBKColor,
EnterOptionsColor,
EnterOptionsDelay :Byte;

procedure ReturnCursor;
begin
gotoxy(Return_X,Return_Y);
textcolor(ReturnCharColor);
textbackground(ReturnCharBKColor);
write(ReturnChar);
gotoxy(Return_X,Return_Y)
end;

procedure Error;
begin
textcolor(12);
Writeln('      Ошибка:')
end;

procedure Mouse_On;
begin
InitEvents;HideMouse;
ShowMouse;
end;

procedure Mouse_Of;
begin
DoneEvents
end;

procedure SetGround;
var Ground_F, Ground_L:byte;
begin
textbackground(GroundBKColor);
textcolor(GroundColor);
for Ground_F:=Ground_Y to Ground_Y+Ground_OY-1 do
 for Ground_L:=Ground_X to Ground_X+Ground_OX-1 do
 begin gotoxy(Ground_L,Ground_F);write(GroundChar) end;
if (Ground_Y+Ground_OY-1) <25 then
for f:=1 to 80 do begin gotoxy(f,Ground_Y+Ground_OY-1); write(' ') end
end;

procedure Window(Window_X, Window_Y, Window_OX, Window_OY:byte; NameWindow:string);
var Window_F, Window_L:byte;
begin
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

procedure WindowText(WX,WY:byte;T:string);
begin
if WindowOpen=false then
 begin
  textbackground(0);
  ClrScr;
  Error;
  textcolor(15);
  Writeln(' WindowText()  -  Нет открытого окна!');
  Halt
 end;
if ((Windows.X+WX) < Windows.X) or ((Windows.X+WX) > (Windows.X+Windows.OX-1))
   or ((Windows.Y+WY) < Windows.Y) or ((Windows.Y+WY) > (Windows.Y+Windows.OY-1))
then
 begin
  textbackground(0);
  ClrScr;
  Error;
  textcolor(15);
  Writeln(' WindowText()  -  Координаты текста не совпадают с координатами окна!');
  Halt
 end;
if (Length(T)+WX+Windows.X) > (Windows.OX+Windows.X-1) then
 begin
  textbackground(0);
  ClrScr;
  Error;
  textcolor(15);
  Writeln(' WindowText()  -  Текст не помещается в окне!');
  Halt
 end;
if (WX=0) or (WY=0) or (Windows.Y+WY=Windows.Y+Windows.OY-1) then
 begin
  textbackground(0);
  ClrScr;
  Error;
  textcolor(15);
  Writeln(' WindowText()  -  Текст залез на рамку окна!');
  Halt
 end;
gotoxy(Windows.X+WX,Windows.Y+WY);
textcolor(WindowTextColor);
textbackground(WindowColor);
Write(T);
ReturnCursor
end;

procedure StatusLine(Status, SLine:string);
begin
if (StatusLine_Y+Length(Status)+Length(SLine)+1) >79 then
begin
 textbackground(0);
 ClrScr;
 Error;
 textcolor(15);
 Writeln(Status,' ',SLine,' - эта опция не помещается!');
 Halt
end;
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

function MouseCloseWindow:boolean;
var xxx,yyy,f:byte;
begin
if WindowOpen=false then
 begin
  textbackground(0);
  ClrScr;
  Error;
  textcolor(15);
  Writeln(' MouseCloseWindow  -  Нет открытого окна!');
  Halt
 end;
MouseCloseWindow:=false;
GetMouseEvent(Mouse);
if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then
 begin
  xxx:=Mouse.Where.X+1;
  yyy:=Mouse.Where.Y+1
 end;
  xxx:=Mouse.Where.X+1;
  yyy:=Mouse.Where.Y+1;
if (Mouse.What = EvMouseDown) and (Mouse.Buttons = mbLeftButton) then
   if (xxx = WindowClose_X) and (yyy=WindowClose_Y) then MouseCloseWindow:=true;
end;

procedure CloseWindow;
var f,l,xx,yy,WX,WY,WOX,WOY:byte;
    WN:string;
begin
if WindowOpen=false then
 begin
  textbackground(0);
  ClrScr;
  Error;
  textcolor(15);
  Writeln(' CloseWindow  -  Нет открытого окна!');
  Halt
 end;
ShowMouse;
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
{repeat
GetMouseEvent(Mouse);
if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then
 begin
  xx:=Mouse.Where.X+1;
  yy:=Mouse.Where.Y+1
 end;
  xx:=Mouse.Where.X+1;
  yy:=Mouse.Where.Y+1;
until (xx<>WindowClose_X) or (yy<>WindowClose_Y);
gotoxy(WindowClose_X,WindowClose_Y);write(GroundChar);}
Mouse.Where.X:=WindowClose_X;
Mouse.Where.Y:=WindowClose_Y;
ReturnCursor
end;

function MouseOptions:string;
var fo,xxx,yyy:byte;
begin
if StatusLineAllOptions=0 then
begin
 textbackground(0);
 ClrScr;
 Error;
 textcolor(15);
 Writeln(' Отсутствуют опции!');
 Halt
end;
MouseOptions:='';
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
  for f:=1 to StatusLineAllOptions do
   if (xxx >=StatusLineOptions[f].X)
    and (xxx <=(StatusLineOptions[f].X+StatusLineOptions[f].OX-1))
     and (yyy=(Ground_Y+Ground_OY-1)) then
  begin
    MouseOptions:=StatusLineOptions[f].Name;
    f:=StatusLineAllOptions
  end;
 end;
end;

function ButtonOptions:string;
var fo:byte;
    h:char;
begin
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

procedure EnterOptions(name:string);
var f,nomer:byte;
    OkNo:boolean;
begin
OkNo:=false;
if StatusLineAllOptions<>0 then
begin
 for f:=1 to StatusLineAllOptions do
  if name=StatusLineOptions[f].Name then begin OkNo:=true;nomer:=f;f:=StatusLineAllOptions end;
end
                           else OkNo:=false;
if OkNo=false then
begin
 textbackground(0);
 ClrScr;
 Error;
 textcolor(15);
 Writeln(name,' - такой опции не существует!');
 Halt
end
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

begin
for f:=1 to 20 do
With StatusLineOptions[f] do
begin
 Name:='';
 PressName:='';
 X:=0;
 OX:=0
end;
StatusLineAllOptions:=0;
StatusLineColor:=0;
StatusLine_Y:=3;
StatusLineBKColor:=7;
StatusLinePressColor:=4;
GroundChar:='░';
GroundColor:=1;
GroundBKColor:=7;
Ground_X:=1;
Ground_Y:=1;
Ground_OX:=80;
Ground_OY:=25;
WindowColor:=7;
WindowBKColor:=1;
WindowLimitColor:=15;
WindowChar:='█';
WindowCloseChar:='■';
WindowCloseCharColor:=10;
WindowClose_X:=0;
WindowClose_Y:=0;
WindowCloseDelay:=2500;
WindowShadowColor:=0;
WindowTextColor:=0;
Return_X:=1;
Return_Y:=25;
ReturnChar:='Ў';
ReturnCharColor:=13;
ReturnCharBKColor:=7;
EnterOptionsColor:=10;
EnterOptionsDelay:=250;

SetGround;
StatusLine('X','Выход');
Window(25,5,30,11,'Данные');
WindowText(5,2,'Введите свои данные:');
Mouse_On;
repeat
 GetMouseEvent(Mouse);
 textcolor(1);
 gotoxy(3,3);
 if (Mouse.What=EvMouseMove) or (Mouse.What=EvMouseAuto) then write('X=',Mouse.Where.X,'Y=',Mouse.Where.Y);
 if ButtonOptions='Выход' then begin EnterOptions('Выход');halt end;
 if MouseOptions='Выход' then begin EnterOptions('Выход');halt end;
 if WindowOpen=true then if MouseCloseWindow then CloseWindow;
until (Mouse.What = EvMouseDown) and (Mouse.Buttons = mbRightButton);
Mouse_Of
end.
