uses Graph, Crt;
const
     MoveY:Byte = 4;
     MoveX:Byte = 4;
     SuperMoveX:Byte = 16;
     SuperMoveY:Byte = 16;
     PictureSize = 64000;
type
    Pixel = 0..3;
var
   Picture:array[1..1{5}] of Pointer;
   Pic:^Pixel;
   F,L,D,Driver,Mode,Err:Integer;
   MX,MY:integer;
   Point:array[1..40,1..23,1..68] of Boolean;
   h:char;
   ColorPole,
   ColorText,
   ColorShadow,
   ColorLigth,
   ColorLabel,
   ColorWindow :Byte;
   Size:Word;
   Auto:Boolean;
   TekColor:0..3;
   { Mouse: }
   Vibor,TekMouse:byte;
   SizeMouseHand:Word;
   PSpace,
   PHand,
   PPen,
   PFill,
   PText,
   PLupa:Pointer;
   {}{}{}{}{}
procedure ReadFile(FileName:string;b:byte);
var f,l:byte;
    fil:text;
    ch:char;
    p:0..1;
begin
Assign(fil,FileName+'.stu');
Reset(fil);
for l:=1 to 23 do
  for f:=1 to 68 do
    begin
      read(fil,ch);
      if f=68 then readln(fil,ch)
              else read(fil,ch);
      Val(ch,p,Err);
      if p=1 then Point[b,l,f]:=true
             else Point[b,l,f]:=false
    end;
Close(fil)
end;
procedure WriteBlock(x,y:integer;Col:byte;b:byte);
var f,l:byte;
begin
for l:=1 to 20 do
  for f:=1 to 20 do
    if Point[b,l,f] then PutPixel(x+f-1,y+l-1,col);
end;
procedure ReadMouseSpace;
begin
GetImage(MX,MY,MX+16,MY+15,PSpace^);
end;
procedure WriteMouseSpace(x,y:integer);
begin
SetFillStyle(1,0);
Bar(MX,MY,MX+16,MY+15);
PutImage(x,y,PSpace^,0)
end;
procedure MiniWindow(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(BX,BY,BX+BOX-1,BY+BOY-1);
Rectangle(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorWindow);
Bar(BX+4,BY+4,BX+BOX-5,BY+BOY-5);
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
SetColor(ColorPole);
Line(BX,BY,BX+2,BY+2);
Line(BX+BOX-1,BY+BOY-1,BX+BOX-3,BY+BOY-3);
SetFillStyle(1,ColorLabel);
Bar(BX+3,BY+3,BX+BOX-4,BY+13);
SetColor(ColorText);
SetTextStyle(10,0,1);
OutTextXY(BX+26,BY+5,BName)
end;
procedure Button(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(BX,BY,BX+BOX-1,BY+BOY-1);
Rectangle(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorWindow);
Bar(BX+4,BY+4,BX+BOX-5,BY+BOY-5);
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
SetColor(ColorPole);
Line(BX,BY,BX+2,BY+2);
Line(BX+BOX-1,BY+BOY-1,BX+BOX-3,BY+BOY-3);
SetColor(ColorText);
SetTextStyle(10,0,1);
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2,BY+BOY div 2-4,BName)
end;
procedure PushButton(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetColor(ColorPole);
Rectangle(BX,BY,BX+BOX-1,BY+BOY-1);
Rectangle(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetFillStyle(1,ColorWindow);
Bar(BX+4,BY+4,BX+BOX-5,BY+BOY-5);
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
SetColor(ColorPole);
Line(BX,BY,BX+2,BY+2);
Line(BX+BOX-1,BY+BOY-1,BX+BOX-3,BY+BOY-3);
SetColor(ColorText);
SetTextStyle(10,0,1);
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2,BY+BOY div 2-4,BName)
end;
procedure WriteMouse(m:byte);
begin
case m of
  1:PutImage(MX,MY,PHand^,0);
  18:PutImage(MX,MY,PPen^,0);
  19:PutImage(MX,MY,PFill^,0);
  20:PutImage(MX,MY,PText^,0);
  21:PutImage(MX,MY,PLupa^,0);
end;
end;
procedure Butt(b:byte);
begin
case b of
3:begin Button(5,30,20,20,'');
WriteBlock(8,33,0,3) end;
4:begin Button(25,30,20,20,'');
WriteBlock(28,33,0,4) end;
5:begin Button(5,50,20,20,'');
WriteBlock(8,53,0,5) end;
6:begin Button(25,50,20,20,'');
WriteBlock(28,53,0,6) end;
7:begin Button(5,70,20,20,'');
WriteBlock(8,73,0,7) end;
8:begin Button(25,70,20,20,'');
WriteBlock(28,73,0,8) end;
9:begin Button(5,90,20,20,'');
WriteBlock(8,93,0,9) end;
10:begin Button(25,90,20,20,'');
WriteBlock(28,93,0,10) end;
11:begin Button(5,110,20,20,'');
WriteBlock(8,113,0,11) end;
end
end;
procedure PushButt(b:byte);
begin
case b of
3:begin PushButton(5,30,20,20,'');
WriteBlock(8,33,0,3) end;
4:begin PushButton(25,30,20,20,'');
WriteBlock(28,33,0,4) end;
5:begin PushButton(5,50,20,20,'');
WriteBlock(8,53,0,5) end;
6:begin PushButton(25,50,20,20,'');
WriteBlock(28,53,0,6) end;
7:begin PushButton(5,70,20,20,'');
WriteBlock(8,73,0,7) end;
8:begin PushButton(25,70,20,20,'');
WriteBlock(28,73,0,8) end;
9:begin PushButton(5,90,20,20,'');
WriteBlock(8,93,0,9) end;
10:begin PushButton(25,90,20,20,'');
WriteBlock(28,93,0,10) end;
11:begin PushButton(5,110,20,20,'');
WriteBlock(8,113,0,11) end;
end
end;
function MWPRect(x,y:integer):byte;
begin
MWPRect:=0;
if (x>=50) and (x<=309) and (y>=35) and (y<=152) then MWPRect:=1;
if (x>=7) and (x<=20) and (y>=33) and (y<=46) then MWPRect:=3;
if (x>=27) and (x<=40) and (y>=33) and (y<=46) then MWPRect:=4;
if (x>=7) and (x<=20) and (y>=53) and (y<=66) then MWPRect:=5;
if (x>=27) and (x<=40) and (y>=53) and (y<=66) then MWPRect:=6;
if (x>=7) and (x<=20) and (y>=73) and (y<=86) then MWPRect:=7;
if (x>=27) and (x<=40) and (y>=73) and (y<=86) then MWPRect:=8;
if (x>=7) and (x<=20) and (y>=93) and (y<=106) then MWPRect:=9;
if (x>=27) and (x<=40) and (y>=93) and (y<=106) then MWPRect:=10;
if (x>=7) and (x<=20) and (y>=113) and (y<=126) then MWPRect:=11;
if (x>=174) and (x<=187) and (y>=163) and (y<=176) then MWPRect:=100;
if (x>=194) and (x<=207) and (y>=163) and (y<=176) then MWPRect:=101;
if (x>=214) and (x<=227) and (y>=163) and (y<=176) then MWPRect:=102;
if (x>=234) and (x<=247) and (y>=163) and (y<=176) then MWPRect:=103;
end;
procedure MWPTamojna;
begin
if MWPRect(MX+4,MY)=1 then
  begin
    MoveX:=1;
    MoveY:=1;
    case Vibor of
      3:TekMouse:=1;
      4,7,8,9:TekMouse:=18;
      5:TekMouse:=19;
      6:TekMouse:=20;
      11:TekMouse:=21
    end
  end;
if MWPRect(MX+4,MY)=0 then begin TekMouse:=1;MoveX:=4;MoveY:=4 end;
end;
procedure MoveKeys;
begin
if h=#0 then
  begin
    h:=ReadKey;
    if h=#80 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MY:=MY+MoveY;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
    if h=#72 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MY:=MY-MoveY;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
    if h=#75 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MX:=MX-MoveX;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
    if h=#77 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MX:=MX+MoveX;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
     { Super Move: }
    if h=#81 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MY:=MY+SuperMoveY;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
    if h=#73 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MY:=MY-SuperMoveY;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
    if h=#71 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MX:=MX-SuperMoveX;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
    if h=#79 then
      begin
        WriteMouseSpace(MX,MY);
        MWPTamojna;
        MX:=MX+SuperMoveX;
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end;
  end;{h=#0}
end;

begin
ColorPole:=1;
ColorText:=0;
ColorShadow:=0;
ColorLigth:=3;
ColorLabel:=2;
ColorWindow:=1;
Driver:=Detect;
InitGraph(Driver,Mode,'');
Err:=GraphResult;
if Err<>grOk then
  begin
    writeln(GraphErrorMsg(Err));
    halt
  end;
SetGraphMode(1);
MX:=160;MY:=100;
ReadFile('mhand',1);
ReadFile('oivlabel',2);
ReadFile('obvod',3);
ReadFile('pencil',4);
ReadFile('fill',5);
ReadFile('bukva_a',6);
ReadFile('line',7);
ReadFile('circle',8);
ReadFile('rectangl',9);
ReadFile('auto',10);
ReadFile('lupa',11);
{ReadFile('',12);}
ReadFile('left',13);
ReadFile('right',14);
ReadFile('up',15);
ReadFile('down',16);
ReadFile('close_x',17);
ReadFile('mpen',18);
ReadFile('mfill',19);
ReadFile('mtext',20);
ReadFile('mlupa',21);
ReadFile('color',22);
ReadFile('color_1',23);
WriteBlock(MX,MY,3,1);
SizeMouseHand:=ImageSize(MX,MY,MX+16,MY+15);
GetMem(PSpace,SizeMouseHand);
GetMem(PHand,SizeMouseHand);
GetMem(PPen,SizeMouseHand);
GetMem(PFill,SizeMouseHand);
GetMem(PText,SizeMouseHand);
GetMem(PLupa,SizeMouseHand);
GetImage(MX,MY,MX+16,MY+15,PHand^);
ClearDevice;
WriteBlock(MX,MY,3,18);
GetImage(MX,MY,MX+16,MY+15,PPen^);
ClearDevice;
WriteBlock(MX,MY,3,19);
GetImage(MX,MY,MX+16,MY+15,PFill^);
ClearDevice;
WriteBlock(MX,MY,3,20);
GetImage(MX,MY,MX+16,MY+15,PText^);
ClearDevice;
WriteBlock(MX,MY,3,21);
GetImage(MX,MY,MX+16,MY+15,PLupa^);
ClearDevice;
{ Begin  MWPaint.pas }
for d:=1 to 1{5} do GetMem(Picture[d],PictureSize);
Pic:=Picture[1];
Pic^:=0;
Vibor:=0; Auto:=false; TekColor:=3;
for f:=1 to 319 do
  for l:=0 to 199 do
    begin
      Pic:=PTR(SEG(Pic),OFS(Pic)+1);
      Pic^:=0
    end;
MoveX:=1;
MoveY:=1;
MiniWindow(0,0,320,184,'Mini Windows Paint');
WriteBlock(5,3,1,2);
Button(300,2,12,12,'');
WriteBlock(303,5,0,17);
Button(10,15,70,14,'Файл');
Button(85,15,70,14,'Правка');
Button(160,15,70,14,'Рисунок');
Button(5,30,20,20,'');
WriteBlock(8,33,0,3);
Button(25,30,20,20,'');
WriteBlock(28,33,0,4);
Button(5,50,20,20,'');
WriteBlock(8,53,0,5);
Button(25,50,20,20,'');
WriteBlock(28,53,0,6);
Button(5,70,20,20,'');
WriteBlock(8,73,0,7);
Button(25,70,20,20,'');
WriteBlock(28,73,0,8);
Button(5,90,20,20,'');
WriteBlock(8,93,0,9);
Button(25,90,20,20,'');
WriteBlock(28,93,0,10);
Button(5,110,20,20,'');
WriteBlock(8,113,0,11);
Button(25,110,20,20,'');
WriteBlock(28,113,0,12);
ColorWindow:=0;
PushButton(47,30,266,126,'');
ColorWindow:=1;
Button(252,165,15,15,'');
WriteBlock(255,167,0,13);
Button(267,165,15,15,'');
WriteBlock(270,167,0,14);
Button(282,165,15,15,'');
WriteBlock(285,167,0,15);
Button(297,165,15,15,'');
WriteBlock(300,167,0,16);
Button(172,160,20,20,'');
WriteBlock(175,163,0,22);
Button(192,160,20,20,'');
WriteBlock(195,163,0,23);
Button(212,160,20,20,'');
WriteBlock(215,163,2,22);
Button(232,160,20,20,'');
WriteBlock(235,163,3,22);
ReadMouseSpace;
TekMouse:=18;
WriteMouse(TekMouse);
REPEAT
repeat
until KeyPressed;
h:=ReadKey;
if (h=#13) and (MWPRect(MX+4,MY)>=3) and (MWPRect(MX+4,MY)<=11) and (MWPRect(MX+4,MY)<>Vibor) then
  begin
    if (MWPRect(MX+4,MY)=10) and Auto then
      begin
        WriteMouseSpace(MX,MY);
        Butt(10);
        ReadMouseSpace;
        WriteMouse(TekMouse);
        Auto:=false
      end
                                      else
    if (MWPRect(MX+4,MY)=10) and not Auto and ((Vibor=4) or (Vibor=7)) then
      begin
        WriteMouseSpace(MX,MY);
        PushButt(10);
        ReadMouseSpace;
        WriteMouse(TekMouse);
        Auto:=true
      end;
    if MWPRect(MX+4,MY)<>10 then
      begin
        WriteMouseSpace(MX,MY);
        Butt(Vibor);
        Vibor:=MWPRect(MX+4,MY);
        if Auto and (MWPRect(MX+4,MY)<>4) and (MWPRect(MX+4,MY)<>7) then
          begin
            Butt(10);
            Auto:=false
          end;
        PushButt(Vibor);
        ReadMouseSpace;
        WriteMouse(TekMouse)
      end
end;
if (h=#13) and (MWPRect(MX+4,MY)>=100) and (MWPRect(MX+4,MY)<=103) then
  begin
  end;
MoveKeys;
UNTIL h=#27;
for d:=1 to 1{5} do FreeMem(Picture[d],PictureSize);
{ End    MWPaint.pas }
{Button(0,184,60,14,'Start');
MiniWindow(10,10,200,150,'Options');
ReadMouseSpace;
WriteMouse(TekMouse);
WriteMouseSpace(0,0);}
REPEAT
repeat
until KeyPressed;
h:=ReadKey;
MoveKeys;
UNTIL h=#27;
PushButton(0,184,60,14,'Start');
Delay(30);
CloseGraph
end.