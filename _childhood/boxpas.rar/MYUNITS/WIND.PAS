unit Wind;
Interface
const
      SizeMenu:Word = 20;
type
     MenuType = array[1..20] of string;
var
    ColorPole,
    ColorText,
    ColorShadow,
    ColorLigth,
    ColorWindowLabel :Byte;
procedure Pole(x,y,ox,oy:integer;c:byte);
procedure GraphWindow(BX,BY,BOX,BOY:Integer;BName:string);
procedure Button(BX,BY,BOX,BOY:Integer;BName:string);
procedure PushButton(BX,BY,BOX,BOY:Integer;BName:string);
function CMouseX:Integer;
function CMouseY:Integer;
function Menus(x,y,ox,oy:integer;m:MenuType;t:Byte):Byte;
Implementation
uses Graph, Eventman, GrDriver, Objects;
var
   MouseX,MouseY,mx,my,mox,moy:integer;
   vibo,totalm:Byte;
   mmm:MenuType;
   PSpace:Pointer;
   Size:Word;
procedure Pole(x,y,ox,oy:integer;c:byte);
var f:integer;
begin
SetColor(c);
for f:=y to y+oy do Line(x,f,x+ox-1,f)
end;
procedure GraphWindow(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorPole);
Bar(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorWindowLabel);
Bar(BX+4,BY+4,BX+BOX-5,BY+23);
SetColor(ColorLigth);
Line(BX+1,BY+1,BX+BOX-3,BY+1);
Line(BX+1,BY+2,BX+BOX-4,BY+2);
Line(BX+1,BY+2,BX+1,BY+BOY-3);
Line(BX+2,BY+2,BX+2,BY+BOY-4);
SetColor(ColorShadow);
Line(BX+BOX-2,BY+1,BX+BOX-2,BY+BOY-2);
Line(BX+BOX-3,BY+2,BX+BOX-3,BY+BOY-2);
Line(BX+BOX-4,BY+BOY-3,BX+2,BY+BOY-3);
Line(BX+BOX-4,BY+BOY-2,BX+1,BY+BOY-2);
SetColor(ColorLigth);
SetTextStyle(10,0,1);
OutTextXY(BX+7,BY+9,BName)
end;
procedure Button(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorPole);
Bar(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetColor(ColorLigth);
Line(BX+1,BY+1,BX+BOX-3,BY+1);
Line(BX+1,BY+2,BX+BOX-4,BY+2);
Line(BX+1,BY+2,BX+1,BY+BOY-3);
Line(BX+2,BY+2,BX+2,BY+BOY-4);
SetColor(ColorShadow);
Line(BX+BOX-2,BY+1,BX+BOX-2,BY+BOY-2);
Line(BX+BOX-3,BY+2,BX+BOX-3,BY+BOY-2);
Line(BX+BOX-4,BY+BOY-3,BX+2,BY+BOY-3);
Line(BX+BOX-4,BY+BOY-2,BX+1,BY+BOY-2);
SetColor(ColorText);
SetTextStyle(10,0,1);
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2,BY+BOY div 2-4,BName)
end;
procedure PushButton(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorPole);
Bar(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetColor(ColorShadow);
Line(BX+1,BY+1,BX+BOX-3,BY+1);
Line(BX+1,BY+2,BX+BOX-4,BY+2);
Line(BX+1,BY+2,BX+1,BY+BOY-3);
Line(BX+2,BY+2,BX+2,BY+BOY-4);
SetColor(ColorLigth);
Line(BX+BOX-2,BY+1,BX+BOX-2,BY+BOY-2);
Line(BX+BOX-3,BY+2,BX+BOX-3,BY+BOY-2);
Line(BX+BOX-4,BY+BOY-3,BX+2,BY+BOY-3);
Line(BX+BOX-4,BY+BOY-2,BX+1,BY+BOY-2);
SetColor(ColorShadow);
SetTextStyle(10,0,1);
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2,BY+BOY div 2-4,BName)
end;

function CMouseX:Integer;
begin
if (Ev.What=evMouseMove) or (Ev.What=evMouseAuto) then CMouseX:=Ev.Where.X;
CMouseX:=Ev.Where.X
end;

function CMouseY:Integer;
begin
if (Ev.What=evMouseMove) or (Ev.What=evMouseAuto) then CMouseY:=Ev.Where.Y;
CMouseY:=Ev.Where.Y
end;

procedure WriteBlock(v,c:Byte);
begin
if (v=0) or (v=100) then exit;
HideMouse;
Pole(mx+5,my+5+v*SizeMenu-SizeMenu,mox-10,SizeMenu,c);
if c=7 then SetColor(ColorText)
       else SetColor(ColorLigth);
OutTextXY(mx+mox div 2-4-(Length(mmm[v]) div 2)*8,my+5+v*SizeMenu-SizeMenu div 2-TextHeight(mmm[v]) div 2,mmm[v]);
ShowMouse
end;
function who(x,y:integer):Byte;
var R:TRect;
    f:Byte;
begin
R.Assign(mx,my,mx+mox-1,my+moy-1);
if not MouseInRect(R) then
  begin
    who:=0;
    exit
  end;
who:=0;
for f:=1 to totalm do
    begin
      R.Assign(mx+5,my+5+f*SizeMenu-SizeMenu,mx+mox-6,my+5+f*SizeMenu);
      if MouseInRect(R) then
        begin
          who:=f;
          f:=totalm
        end
    end
end;
function Menus(x,y,ox,oy:integer;m:MenuType;t:Byte):Byte;
var f,l:byte;
begin
mmm:=m;
vibo:=0;
mx:=x; my:=y; mox:=ox; moy:=oy;
totalm:=t;
HideMouse;
Size:=ImageSize(x,y,x+ox-1,y+oy-1);
GetMem(PSpace,Size);
GetImage(x,y,x+ox-1,y+oy-1,PSpace^);
Button(x,y,ox,oy,'');
for f:=1 to totalm do WriteBlock(f,7);
ShowMouse;
repeat
GetMouseEvent(Ev);
MouseX:=CMouseX;
MouseY:=CMouseY;
l:=Who(MouseX,MouseY);
if l<>Vibo then
  begin
    WriteBlock(vibo,7);
    vibo:=l;
    WriteBlock(vibo,1)
  end;
until (Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton);
HideMouse;
PutImage(x,y,PSpace^,0);
ShowMouse;
FreeMem(PSpace,Size)
end;
begin
ColorPole:=7;
ColorText:=0;
ColorShadow:=8;
ColorLigth:=15;
ColorWindowLabel:=1
end.