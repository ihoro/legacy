{$M 16384,0,400000}
uses EGAVGA,Graph,Eventman,Dos,Crt;
const
      HotColor = 13;
      PushButtonDelay = 2000;
      Bin:array[1..16] of Word = (1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768);
type
     CursorType = array[0..31] of word;
var
    Cursor:^CursorType;
    regs:Registers;
    mx,my,f,l,XP,YP,grD,grM:Integer;
    ColorPole,
    ColorText,
    ColorShadow,
    ColorLigth,
    ColorWindowLabel,
    r:Byte;
    Mouse:TEvent;
    mcu:text;
    FileName:string[12];
    Hot:Boolean;
    h:Char;

function rect(x,y:integer):Byte;
begin
rect:=0;
{if (x>=) and (x<=) and (y>=) and (y<=) then rect:=;}
if (x>=450) and (x<=599) and (y>=1) and (y<=29) then rect:=1;
if (x>=231) and (x<=407) and (y>=151) and (y<=327) then rect:=2;
if (x>=450) and (x<=599) and (y>=40) and (y<=70) then rect:=3;
if (x>=450) and (x<=599) and (y>=80) and (y<=110) then rect:=4;
if (x>=450) and (x<=599) and (y>=120) and (y<=150) then rect:=5;
if (x>=450) and (x<=599) and (y>=160) and (y<=190) then rect:=6;
if (x>=450) and (x<=599) and (y>=200) and (y<=230) then rect:=7;
if (x>=450) and (x<=599) and (y>=240) and (y<=270) then rect:=8;
end;

procedure Command(s:string);
begin
SwapVectors;
Exec(GetEnv('COMSPEC'),'/c '+s);
SwapVectors
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
OutTextXY(BX+BOX div 2-Length(BName)*8 div 2,BY+BOY div 2-4,BName)
end;

function CMouseX:Integer;
begin
if (Mouse.What=evMouseMove) or (Mouse.What=evMouseAuto) then CMouseX:=Mouse.Where.X;
CMouseX:=Mouse.Where.X
end;

function CMouseY:Integer;
begin
if (Mouse.What=evMouseMove) or (Mouse.What=evMouseAuto) then CMouseY:=Mouse.Where.Y;
CMouseY:=Mouse.Where.Y
end;

procedure Setka;
begin
SetColor(10);
for l:=1 to 17 do Line(231,140+l*11,407,140+l*11);
for f:=1 to 17 do Line(220+f*11,151,220+f*11,327);
end;

procedure PutName;
begin
SetColor(14);
HideMouse;
OutTextXY(260,2,FileName);
ShowMouse
end;

procedure SetMouseXY(x,y:word);
begin
with regs do
  begin
    AX:=$4;
    CX:=x;
    DX:=y;
    Intr($33,regs)
  end
end;

procedure HotPoint(c:Byte);
begin
SetColor(c);
HideMouse;
OutTextXY(233+XP*11,139,'');
OutTextXY(219,153+YP*11,#16);
ShowMouse
end;

procedure InMemory;
var
    c:byte;
    mAND,mXOR:word;
begin
HideMouse;
for l:=1 to 16 do
  begin
    mAND:=0;
    mXOR:=0;
    for f:=1 to 16 do
      begin
        c:=GetPixel(221+f*11,141+l*11);
        if c=15 then mXOR:=mXOR+Bin[17-f];
        if c=7 then mAND:=mAND+Bin[17-f]
      end;
    Cursor^[l-1]:=mAND;
    Cursor^[l+15]:=mXOR
  end;
ShowMouse;
end;

procedure SetCursorForm(xPointer,YPointer:ShortInt;Form:Pointer);
begin
HideMouse;
with regs do
  begin
    AX:=$9;
    BX:=xPointer;
    CX:=yPointer;
    ES:=seg(Form^);
    DX:=ofs(Form^);
    Intr($33,regs)
  end;
ShowMouse
end;

begin
FileName:='';
XP:=0;
YP:=0;
Hot:=false;
New(Cursor);
for f:=0 to 15 do Cursor^[f]:=65535;
for f:=16 to 31 do Cursor^[f]:=0;
ColorPole:=7;
ColorText:=0;
ColorShadow:=8;
ColorLigth:=15;
ColorWindowLabel:=1;
grD:=0;
InitGraph(grD,grM,'');
InitEvents;
HideMouse;
SetFillStyle(1,7);
Bar(231,151,407,327);
SetFillStyle(1,15);
Bar(1,1,40,40);
Setka;
Button(450,1,150,30,'Выход');
Button(450,40,150,30,'Записать');
Button(450,80,150,30,'Загрузить');
Button(450,120,150,30,'PAS-добавление');
Button(450,160,150,30,'Новый курсор');
Button(450,200,150,30,'Стандартный курсор');
Button(450,240,150,30,'Горячая точка');
ShowMouse;
PutName;
HotPoint(HotColor);
repeat
repeat
GetMouseEvent(Mouse);
until (Mouse.What=evMouseDown) and ((Mouse.Buttons=mbLeftButton) or (Mouse.Buttons=mbRightButton));
mx:=CMouseX;
my:=CMouseY;
r:=rect(mx,my);
if (r=2) and Hot then
  begin
    HotPoint(0);
    XP:=(mx-231) div 11;
    YP:=(my-151) div 11;
    HotPoint(HotColor)
  end;
if (r=2) and (GetPixel(mx,my)<>10) and not Hot then
  begin
    HideMouse;
    if GetPixel(mx,my)=7 then
      begin
        if Mouse.Buttons=mbLeftButton then
          begin
            SetFillStyle(1,15);
            FloodFill(mx,my,10);
          end
                                      else
          begin
            SetFillStyle(1,0);
            FloodFill(mx,my,10);
          end;
        Mouse.Buttons:=10
      end;
    if (GetPixel(mx,my)=0) and (Mouse.Buttons=mbRightButton) then
      begin
        SetFillStyle(1,7);
        FloodFill(mx,my,10);
        Mouse.Buttons:=10
      end;
    if (GetPixel(mx,my)=0) and (Mouse.Buttons=mbLeftButton) then
      begin
        SetFillStyle(1,15);
        FloodFill(mx,my,10);
        Mouse.Buttons:=10
      end;
    if (GetPixel(mx,my)=15) and (Mouse.Buttons=mbLeftButton) then
      begin
        SetFillStyle(1,7);
        FloodFill(mx,my,10);
        Mouse.Buttons:=10
      end;
    if (GetPixel(mx,my)=15) and (Mouse.Buttons=mbRightButton) then
      begin
        SetFillStyle(1,0);
        FloodFill(mx,my,10);
      end;
    InMemory;
    ShowMouse
  end;
if r=3 then
  begin
    HideMouse;
    PushButton(450,40,150,30,'Записать');
    Delay(PushButtonDelay);
    Button(450,40,150,30,'Записать');
    ShowMouse;
    FileName:='';
    HideMouse;
    SetFillStyle(1,0);
    Bar(260,2,357,11);
    for f:=1 to 8 do
      begin
        h:=ReadKey;
        if h=#13 then f:=8
                  else FileName:=Copy(FileName,1,f-1)+h+'.mcu';
        Bar(260,2,357,11);
        PutName
      end;
    Assign(mcu,FileName);
    Rewrite(mcu);
    for f:=0 to 31 do writeln(mcu,Cursor^[f]);
    writeln(mcu,XP);
    writeln(mcu,YP);
    Close(mcu);
    ShowMouse
  end;
if r=4 then
  begin
    HideMouse;
    PushButton(450,80,150,30,'Загрузить');
    Delay(PushButtonDelay);
    Button(450,80,150,30,'Загрузить');
    ShowMouse;
    FileName:='';
    HideMouse;
    SetFillStyle(1,0);
    Bar(260,2,357,11);
    for f:=1 to 8 do
      begin
        h:=ReadKey;
        if h=#13 then f:=8
                  else FileName:=Copy(FileName,1,f-1)+h+'.mcu';
        Bar(260,2,357,11);
        PutName
      end;
    Assign(mcu,FileName);
    Reset(mcu);
    for f:=0 to 31 do readln(mcu,Cursor^[f]);
    HotPoint(0);
    readln(mcu,XP);
    readln(mcu,YP);
    Close(mcu);
    ShowMouse;
    PutName;
    HotPoint(HotColor);
    SetCursorForm(XP,YP,Cursor);
    HideMouse;
    Setka;
    SetFillStyle(1,7);
    Bar(312,120,327,135);
    ShowMouse;
    for l:=1 to 16 do
      for f:=1 to 16 do
        begin
          SetMouseXY(312+XP,120+YP);
          r:=GetPixel(312+f-1,120+l-1);
          if r=0 then
            begin
              SetFillStyle(1,0);
              FloodFill(221+f*11,141+l*11,10)
            end;
          if r=15 then
            begin
              SetFillStyle(1,15);
              FloodFill(221+f*11,141+l*11,10)
            end
        end;
    HideMouse;
    SetFillStyle(1,0);
    Bar(312,120,327,135);
    ShowMouse;
    r:=0
  end;
if r=5 then
  begin
    HideMouse;
    PushButton(450,120,150,30,'PAS-добавление');
    Delay(PushButtonDelay);
    Button(450,120,150,30,'PAS-добавление');
    ShowMouse;
    Assign(mcu,Copy(FileName,1,Length(FileName)-4)+'.pas');
    Rewrite(mcu);
    writeln(mcu,'unit '+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'Interface');
    writeln(mcu,'procedure Init'+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'procedure Done'+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'procedure Set'+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'Implementation');
    writeln(mcu,'uses Mouse;');
    writeln(mcu,'type CursorType = array[0..31] of word; var Cursor:^CursorType;');
    writeln(mcu,'procedure Init'+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'begin New(Cursor); Cursor^[0]:=');
    writeln(mcu,Cursor^[0]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[1]:=');
    writeln(mcu,Cursor^[1]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[2]:=');
    writeln(mcu,Cursor^[2]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[3]:=');
    writeln(mcu,Cursor^[3]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[4]:=');
    writeln(mcu,Cursor^[4]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[5]:=');
    writeln(mcu,Cursor^[5]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[6]:=');
    writeln(mcu,Cursor^[6]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[7]:=');
    writeln(mcu,Cursor^[7]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[8]:=');
    writeln(mcu,Cursor^[8]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[9]:=');
    writeln(mcu,Cursor^[9]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[10]:=');
    writeln(mcu,Cursor^[10]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[11]:=');
    writeln(mcu,Cursor^[11]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[12]:=');
    writeln(mcu,Cursor^[12]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[13]:=');
    writeln(mcu,Cursor^[13]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[14]:=');
    writeln(mcu,Cursor^[14]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[15]:=');
    writeln(mcu,Cursor^[15]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[16]:=');
    writeln(mcu,Cursor^[16]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[17]:=');
    writeln(mcu,Cursor^[17]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[18]:=');
    writeln(mcu,Cursor^[18]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[19]:=');
    writeln(mcu,Cursor^[19]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[20]:=');
    writeln(mcu,Cursor^[20]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[21]:=');
    writeln(mcu,Cursor^[21]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[22]:=');
    writeln(mcu,Cursor^[22]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[23]:=');
    writeln(mcu,Cursor^[23]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[24]:=');
    writeln(mcu,Cursor^[24]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[25]:=');
    writeln(mcu,Cursor^[25]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[26]:=');
    writeln(mcu,Cursor^[26]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[27]:=');
    writeln(mcu,Cursor^[27]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[28]:=');
    writeln(mcu,Cursor^[28]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[29]:=');
    writeln(mcu,Cursor^[29]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[30]:=');
    writeln(mcu,Cursor^[30]);
    writeln(mcu,';');
    writeln(mcu,'Cursor^[31]:=');
    writeln(mcu,Cursor^[31]);
    writeln(mcu,'end;');
    writeln(mcu,'procedure Done'+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'begin Dispose(Cursor) end;');
    writeln(mcu,'procedure Set'+Copy(FileName,1,Length(FileName)-4)+';');
    writeln(mcu,'begin SetCursorForm(');
    writeln(mcu,XP);
    writeln(mcu,',');
    writeln(mcu,YP);
    writeln(mcu,',Cursor) end;');
    writeln(mcu,'end.');
    Close(mcu);
    textcolor(0);
    textbackground(0);
    gotoxy(1,22);
    command('ren compile.uni compile.exe');
    command('ren library.uni turbo.tpl');
    command('compile '+Copy(FileName,1,Length(FileName)-4)+'.pas');
    command('ren compile.exe compile.uni');
    command('ren turbo.tpl library.uni');
    command('del '+Copy(FileName,1,Length(FileName)-4)+'.pas')
  end;
if r=6 then
  begin
    HideMouse;
    PushButton(450,160,150,30,'Новый курсор');
    Delay(PushButtonDelay);
    Button(450,160,150,30,'Новый курсор');
    SetCursorForm(XP,YP,Cursor);
    ShowMouse
  end;
if r=7 then
  begin
    HideMouse;
    PushButton(450,200,150,30,'Стандартный курсор');
    Delay(PushButtonDelay);
    Button(450,200,150,30,'Стандартный курсор');
    ShowMouse;
    DoneEvents;
    InitEvents;
    HideMouse;
    SetMouseXY(mx,my);
    ShowMouse
  end;
if (r=8) and not Hot then
  begin
    HideMouse;
    PushButton(450,240,150,30,'Горячая точка');
    Delay(PushButtonDelay);
    ShowMouse;
    Hot:=true;
    r:=0
  end;
if (r=8) and Hot then
  begin
    HideMouse;
    Button(450,240,150,30,'Горячая точка');
    Delay(PushButtonDelay);
    ShowMouse;
    Hot:=false
  end;
until r=1;
HideMouse;
PushButton(450,1,150,30,'Выход');
Delay(PushButtonDelay);
Button(450,1,150,30,'Выход');
ShowMouse;
Delay(PushButtonDelay*4);
Dispose(Cursor);
DoneEvents;
CloseGraph
end.