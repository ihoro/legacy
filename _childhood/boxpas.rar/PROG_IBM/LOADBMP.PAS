program LoadBMP;
uses Objects,Graph,GrDriver,Images,EventMan;
var
  Filter : TBmpFilter;
  Image : TImage;
  PicName, Sx, Sy: String;
  Ev: TEvent;
  R: TRect;
  f,Gm,Gd: Integer;
  p:pointer;

ColorPole,
ColorText,
ColorShadow,
ColorLigth,
ColorLabel,
ColorLabelText :byte;

Exit_X,
Exit_Y,
Exit_OX,
Exit_OY:word;

procedure ButtonExit(X,Y:word);
begin
Exit_X:=X; Exit_Y:=Y;
SetColor(ColorPole);
Rectangle(Exit_X+3,Exit_Y+3,Exit_X+Exit_OX-4,Exit_Y+Exit_OY-4);
SetFillStyle(1,ColorPole);
FloodFill(Exit_X+4,Exit_Y+4,ColorPole);
SetColor(ColorText);
Rectangle(Exit_X,Exit_Y,Exit_X+Exit_OX-1,Exit_Y+Exit_OY-1);
PutPixel(Exit_X,Exit_Y,ColorPole);
PutPixel(Exit_X+Exit_OX-1,Exit_Y,ColorPole);
PutPixel(Exit_X,Exit_Y+Exit_OY-1,ColorPole);
PutPixel(Exit_X+Exit_OX-1,Exit_Y+Exit_OY-1,ColorPole);
SetColor(ColorLigth);
Line(Exit_X+1,Exit_Y+1,Exit_X+Exit_OX-3,Exit_Y+1);
Line(Exit_X+1,Exit_Y+2,Exit_X+Exit_OX-4,Exit_Y+2);
Line(Exit_X+1,Exit_Y+2,Exit_X+1,Exit_Y+Exit_OY-3);
Line(Exit_X+2,Exit_Y+2,Exit_X+2,Exit_Y+Exit_OY-4);
SetColor(ColorShadow);
Line(Exit_X+Exit_OX-2,Exit_Y+1,Exit_X+Exit_OX-2,Exit_Y+Exit_OY-2);
Line(Exit_X+Exit_OX-3,Exit_Y+2,Exit_X+Exit_OX-3,Exit_Y+Exit_OY-2);
Line(Exit_X+Exit_OX-4,Exit_Y+Exit_OY-3,Exit_X+2,Exit_Y+Exit_OY-3);
Line(Exit_X+Exit_OX-4,Exit_Y+Exit_OY-2,Exit_X+1,Exit_Y+Exit_OY-2);
SetColor(ColorText);
Line(Exit_X+5,Exit_Y+5,Exit_X+Exit_OX-6,Exit_Y+Exit_OY-6);
Line(Exit_X+5,Exit_Y+Exit_OY-6,Exit_X+Exit_OX-6,Exit_Y+5)
end;

procedure PushButtonExit;
begin
SetColor(ColorPole);
Rectangle(Exit_X+3,Exit_Y+3,Exit_X+Exit_OX-4,Exit_Y+Exit_OY-4);
SetFillStyle(1,ColorPole);
FloodFill(Exit_X+4,Exit_Y+4,ColorPole);
SetColor(ColorText);
Rectangle(Exit_X,Exit_Y,Exit_X+Exit_OX-1,Exit_Y+Exit_OY-1);
PutPixel(Exit_X,Exit_Y,ColorPole);
PutPixel(Exit_X+Exit_OX-1,Exit_Y,ColorPole);
PutPixel(Exit_X,Exit_Y+Exit_OY-1,ColorPole);
PutPixel(Exit_X+Exit_OX-1,Exit_Y+Exit_OY-1,ColorPole);
SetColor(ColorShadow);
Line(Exit_X+1,Exit_Y+1,Exit_X+Exit_OX-3,Exit_Y+1);
Line(Exit_X+1,Exit_Y+2,Exit_X+Exit_OX-4,Exit_Y+2);
Line(Exit_X+1,Exit_Y+2,Exit_X+1,Exit_Y+Exit_OY-3);
Line(Exit_X+2,Exit_Y+2,Exit_X+2,Exit_Y+Exit_OY-4);
SetColor(ColorLigth);
Line(Exit_X+Exit_OX-2,Exit_Y+1,Exit_X+Exit_OX-2,Exit_Y+Exit_OY-2);
Line(Exit_X+Exit_OX-3,Exit_Y+2,Exit_X+Exit_OX-3,Exit_Y+Exit_OY-2);
Line(Exit_X+Exit_OX-4,Exit_Y+Exit_OY-3,Exit_X+2,Exit_Y+Exit_OY-3);
Line(Exit_X+Exit_OX-4,Exit_Y+Exit_OY-2,Exit_X+1,Exit_Y+Exit_OY-2);
SetColor(ColorText);
Line(Exit_X+5,Exit_Y+5,Exit_X+Exit_OX-6,Exit_Y+Exit_OY-6);
Line(Exit_X+5,Exit_Y+Exit_OY-6,Exit_X+Exit_OX-6,Exit_Y+5)
end;


procedure Window(Window_X,Window_Y,Window_OX,Window_OY:word;WindowName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(Window_X+3,Window_Y+3,Window_X+Window_OX-4,Window_Y+Window_OY-4);
SetFillStyle(1,ColorPole);
FloodFill(Window_X+4,Window_Y+4,ColorPole);
SetColor(ColorText);
Rectangle(Window_X,Window_Y,Window_X+Window_OX,Window_Y+Window_OY);
PutPixel(Window_X,Window_Y,ColorPole);
PutPixel(Window_X+Window_OX-1,Window_Y,ColorPole);
PutPixel(Window_X,Window_Y+Window_OY-1,ColorPole);
PutPixel(Window_X+Window_OX-1,Window_Y+Window_OY-1,ColorPole);
SetColor(ColorLigth);
Line(Window_X+1,Window_Y+1,Window_X+Window_OX-3,Window_Y+1);
Line(Window_X+1,Window_Y+2,Window_X+Window_OX-4,Window_Y+2);
Line(Window_X+1,Window_Y+2,Window_X+1,Window_Y+Window_OY-3);
Line(Window_X+2,Window_Y+2,Window_X+2,Window_Y+Window_OY-4);
SetColor(ColorShadow);
Line(Window_X+Window_OX-2,Window_Y+1,Window_X+Window_OX-2,Window_Y+Window_OY-2);
Line(Window_X+Window_OX-3,Window_Y+2,Window_X+Window_OX-3,Window_Y+Window_OY-2);
Line(Window_X+Window_OX-4,Window_Y+Window_OY-3,Window_X+2,Window_Y+Window_OY-3);
Line(Window_X+Window_OX-4,Window_Y+Window_OY-2,Window_X+1,Window_Y+Window_OY-2);
SetColor(ColorLabel);
for f:=Window_X+6 to Window_X+Window_OX-7 do Line(f,Window_Y+6,f,Window_Y+23);
SetColor(ColorLabelText);
SetTextStyle(10,0,1);
OutTextXY(Window_X+70,Window_Y+13,WindowName)
end;

function MouseButton:string;
begin
MouseButton:='';
R.Assign(Exit_X,Exit_Y,Exit_X+Exit_OX-1,Exit_Y+Exit_OY-1);
GetMouseEvent (Ev);
if (Ev.What = evMouseDown) and (Ev.Buttons = mbLeftButton) then
 if MouseInRect(R) then MouseButton:='Exit';
end;

begin
ColorPole:=7;
ColorText:=0;
ColorShadow:=8;
ColorLigth:=15;
ColorLabel:=1;
ColorLabelText:=15;
Exit_OX:=15;
Exit_OY:=15;

Gm:=Detect;
InitGraph(Gm,Gd,'');

PicName :='workshop.bmp';

InitVideo;
InitEvents;

Filter.Init;
Image.Import (PicName,@Filter);
HideMouse;
Image.Draw (0,0,NormalPut);
ShowMouse;

R.Assign (0,0,Image.Size.X,Image.Size.Y);
SetTextJustify (CenterText, CenterText);
f := InstallUserFont ('trir.chr');
SetTextStyle (f, HorizDir, 8);

Window(20,20,500,300,'Windows 95');
ButtonExit(374,208);
SetColor (9);
{  Bar (0,400,639,479);
  OutTextXY (320, 425, PicName);}
SetTextStyle (f, HorizDir, 1);
SetTextJustify (LeftText, CenterText);
SetFillStyle (0,0);
repeat
 if MouseButton='Exit' then PushButtonExit;

{ GetMouseEvent (Ev);
 if (Ev.What = evMouseMove) or (Ev.What = evMouseAuto) then
 begin
  Bar (350, 0, 619, 80);
  Str (Ev.Where.X, Sx);
  Str (Ev.Where.Y, Sy);
  OutTextXY (350, 30, 'Мышка: X = '+Sx+', Y = '+Sy)
 end;
 if (Ev.What = evMouseDown) and (Ev.Buttons = mbLeftButton) then
  if MouseInRect (R) then
  begin
   Bar (350, 0, 619, 80);
   OutTextXY (350, 30, 'Вы щелкнули левой');
   OutTextXY (350, 45, 'кнопкой мышки');
   OutTextXY (350, 60, 'внутри картинки');
   repeat
    GetMouseEvent (Ev)
   until Ev.What = evMouseDown
  end
  else
  begin
   Bar (350, 0, 639, 80);
   OutTextXY (350, 30, 'Вы щелкнули левой');
   OutTextXY (350, 45, 'кнопкой мышки');
   OutTextXY (350, 60, 'вне картинки');
   repeat
    GetMouseEvent (Ev)
   until Ev.What = evMouseDown
  end}
until (Ev.What = evMouseDown) and (Ev.Buttons = mbRightButton);
CloseGraph;
Image.Done;
Filter.Done;
DoneEvents;
DoneVideo;
end.