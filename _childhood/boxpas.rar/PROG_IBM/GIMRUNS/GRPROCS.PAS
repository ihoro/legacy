unit GrProcs;

Interface
const
      ColorPole:Byte = 7;
      ColorText:Byte = 0;
      ColorShadow:Byte = 8;
      ColorLigth:Byte = 15;
      ColorWindowLabel:Byte = 1;
      Menshe = 1;
      Bolshe = 2;
      MenRavno = 3;
      BolRavno = 4;
      Ravno = 5;
      AXBYE = 6;
      VKoren = 7;
      VModul = 8;
      VCos = 9;
      VSin = 10;
      VConst = 11;
      PartSystem = 12;
      LR = 13;
      Options = 20;
      Save = 21;
      Open = 22;
      Graphic = 23;
      Menu = 24;
      Exits = 25;
      Cancel = 26;
      OIVButt = 27;
      Znaki = 28;
      ScrollBar = 29;
      POnOff = 32;
      PWinCur = 33;
      SaveExit = 34;
      SaveSave = 35;
      Pravka = 36;
      FilesPole = 37;
      LoadUp = 38;
      LoadDown =39;
      SQRBOn:Boolean =false;

function Tg(c:real):Real;
procedure Pole(x,y,ox,oy:integer;c:byte);
procedure GraphWindow(BX,BY,BOX,BOY:Integer;BName:string);
procedure Button(BX,BY,BOX,BOY:Integer;BName:string);
procedure PushButton(BX,BY,BOX,BOY:Integer;BName:string);
procedure ButtonSelect(BX,BY,BOX,BOY:Integer);
procedure ButtonDisable(BX,BY,BOX,BOY:Integer;BName:string);
function OptionsRect(x,y:integer):byte;
function LoadRect(x,y:integer):byte;
procedure KorenBegin(x,y:Integer;Color:Byte);
procedure KorenLine(x,y:Integer;Color:Byte);
procedure KorenEnd(x,y:Integer;Color:Byte);
procedure CharSQR(x,y:integer;c:Byte);
procedure CaseHelp(ch,Color:Byte);
procedure CaseBegin(cb,Color:Byte);
procedure CaseOptions(co,Color:Byte);
function CheckFile(Name:string):Boolean;
procedure BeginButtons;

Implementation
uses Graph, WinDos, Coder;
var Regs:TRegisters;

procedure MouseOn;
begin
regs.AX:=$1;
Intr($33,regs)
end;

procedure MouseOff;
begin
regs.AX:=$2;
Intr($33,regs)
end;

procedure CharSQR(x,y:integer;c:Byte);
begin
SetColor(c);
MouseOff;
Line(x,y+1,x+1,y);
Line(x+2,y,x+3,y+1);
Line(x+2,y+2,x,y+4);
Line(x+1,y+4,x+3,y+4);
MouseOn
end;

function Tg(c:real):Real;
begin
Tg:=sin(c)/cos(c)
end;

procedure Pole(x,y,ox,oy:integer;c:byte);
var f:integer;
begin
SetColor(c);
for f:=y to y+oy do Line(x,f,x+ox-1,f)
end;

procedure GraphWindow(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
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
if SQRBOn then
  for f:=1 to Length(BName) do
    if BName[f]='¤' then BName[f]:=' ';
OutTextXY(BX+7,BY+9,BName);
if SQRBOn then
  for f:=1 to Length(BName) do
    if BName[f]=' ' then CharSQR(BX-1+f*8,BY+9,15);
end;


procedure Button(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
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
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2+1,BY+BOY div 2-3,BName)
end;

procedure ButtonSelect(BX,BY,BOX,BOY:Integer);
begin
SetColor(ColorText);
SetLineStyle(4,43690,1);
MouseOff;
Line(BX+5,BY+5,BX+BOX-6,BY+5);
Line(BX+BOX-6,BY+5,BX+BOX-6,BY+BOY-6);
Line(BX+BOX-6,BY+BOY-6,BX+5,BY+BOY-6);
Line(BX+5,BY+BOY-6,BX+5,BY+5);
MouseOn;
SetLineStyle(0,0,1)
end;

procedure ButtonDisable(BX,BY,BOX,BOY:Integer;BName:string);
var f:word;
begin
SetFillStyle(1,ColorPole);
Bar(BX+3,BY+3,BX+BOX-4,BY+BOY-4);
SetColor(ColorPole);
Line(BX+1,BY+1,BX+BOX-3,BY+1);
Line(BX+1,BY+2,BX+BOX-4,BY+2);
Line(BX+1,BY+2,BX+1,BY+BOY-3);
Line(BX+2,BY+2,BX+2,BY+BOY-4);
SetColor(ColorPole);
Line(BX+BOX-2,BY+1,BX+BOX-2,BY+BOY-2);
Line(BX+BOX-3,BY+2,BX+BOX-3,BY+BOY-2);
Line(BX+BOX-4,BY+BOY-3,BX+2,BY+BOY-3);
Line(BX+BOX-4,BY+BOY-2,BX+1,BY+BOY-2);
SetColor(ColorText);
SetTextStyle(10,0,1);
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2,BY+BOY div 2-4,BName)
end;

function OptionsRect(x,y:integer):byte;
begin
OptionsRect:=0;
if (x>288) and (x<402) and (y>303) and (y<327) then OptionsRect:=Exits;
if (x>288) and (x<402) and (y>353) and (y<377) then OptionsRect:=Cancel;
if (x>285) and (x<404) and (y>200) and (y<229) then OptionsRect:=Graphic;
if (x>285) and (x<404) and (y>100) and (y<129) then OptionsRect:=Save;
if (x>285) and (x<404) and (y>150) and (y<179) then OptionsRect:=Open;
if (x>285) and (x<404) and (y>250) and (y<279) then OptionsRect:=Menu
end;

function LoadRect(x,y:integer):byte;
begin
LoadRect:=0;
if (x>188) and (x<260) and (y>192) and (y<301) then LoadRect:=FilesPole;
if (x>270) and (x<289) and (y>194) and (y<213) then LoadRect:=LoadUp;
if (x>270) and (x<289) and (y>215) and (y<234) then LoadRect:=LoadDown
end;

procedure KorenBegin(x,y:Integer;Color:Byte);
begin
SetColor(Color);
Line(x+1,y+3,x+3,y+7);
Line(x+3,y+7,x+6,y-2);
PutPixel(x+7,y-2,Color)
end;

procedure KorenLine(x,y:Integer;Color:Byte);
begin
SetColor(Color);
Line(x,y-2,x+7,y-2)
end;

procedure KorenEnd(x,y:Integer;Color:Byte);
begin
SetColor(Color);
Line(x,y-2,x+3,y-2);
Line(x+3,y-2,x+3,y+2)
end;

procedure CaseHelp(ch,Color:Byte);
begin
ColorText:=Color;
case ch of
  1:ButtonSelect(43,401,164,30);
  2:ButtonSelect(237,401,164,30);
  3:ButtonSelect(429,401,164,30)
end;
ColorText:=0
end;

procedure CaseBegin(cb,Color:Byte);
begin
ColorText:=Color;
case cb of
  1:ButtonSelect(170,170,300,30);
  2:ButtonSelect(170,230,300,30);
  3:ButtonSelect(170,290,300,30)
end;
ColorText:=0
end;

procedure CaseOptions(co,Color:Byte);
begin
ColorText:=Color;
case co of
  1:ButtonSelect(285,100,120,30);
  2:ButtonSelect(285,150,120,30);
  3:ButtonSelect(285,200,120,30);
  4:ButtonSelect(285,250,120,30);
  5:ButtonSelect(285,300,120,30);
  6:ButtonSelect(285,350,120,30)
end;
ColorText:=0
end;

function CheckFile(Name:string):Boolean;
const
      TestText = '(C) 2000-2001 by OIV Company Ltd.';
      Key = 12;
var
    gim:text;
    s:string;
begin
CheckFile:=true;
Assign(gim,Name+'.gim');
Reset(gim);
readln(gim,s);
if CoderStr(s,-Key)<>TestText then CheckFile:=false;
while not EOF(gim) do readln(gim,s);
if CoderStr(s,-Key)<>TestText then CheckFile:=false;
Close(gim)
end;

procedure BeginButtons;
begin
Button(170,170,300,30,'Уравнения и неравенства');
Button(170,230,300,30,'Описание');
Button(170,290,300,30,'Выход')
end;

end.