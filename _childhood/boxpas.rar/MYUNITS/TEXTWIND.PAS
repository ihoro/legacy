unit TextWind;
Interface
const
      English:string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
      Russian:string = 'ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•Ò¶ß®©™´¨≠ÆØ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔ';
      Figures:string = '1234567890';
      Others:string = ' _!"#$%&''()*+,-./:;<=>?@[\]^{|}~';
      LeftChar:char = #17;
      RightChar:char = #16;
type MenuType = array[1..97] of string[80];
type ButtonsType = array[1..20] of string[40];
type BigTextType = array[1..25] of string[80];
var
    LimitColor,
    WindowColor,
    NameColor,
    TxtColor,
    MenuBKColor,
    MenuColor,
    InputLimitColor,
    InputColor,
    InputDataColor,
    ButtonColor,
    ActiveButtonColor,
    CursorX,
    CursorY,
    WindowX,
    WindowY,
    WindowOX,
    WindowOY,
    MenuY,
    FirstActive:byte;
    PushButtonDelay:word;
    si,Symbols:string;
procedure SetCursor;
procedure TextWindow(x,y,ox,oy:byte;name:string);
procedure SetText(x,y:byte;text:string);
function Menu(x,y:byte;m:MenuType;total:byte):byte;
function Ok(c:char):Boolean;
function InputData(x,y,Size:byte;s{§ÆØ„·‚®¨Î• ·®¨¢Æ´Î}:string):string;
function Buttons(x,y,Size,Space,verhor{0-£Æ‡®ßÆ≠‚†´Ï≠Æ,2-¢•‡‚®™†´Ï≠Æ}:byte;b:ButtonsType;total:byte;c1,c2:char):byte;
procedure ClearZone(x,y,ox,oy,c:byte);
procedure BigText(x,y:byte;t:BigTextType;ox,oy:byte;ch:char;Bkcol,col:byte);
procedure PressAnyKey;

Implementation
uses Crt;
var
    f,l,vibor,first:byte;
    h:char;
    Data,s:string;
    xx,yy,ffirst,vvibor,ttotal:byte;
    mm:MenuType;
procedure SetCursor;
begin
gotoxy(CursorX,CursorY);
end;
procedure TextWindow(x,y,ox,oy:byte;name:string);
begin
WindowX:=x;
WindowY:=y;
WindowOX:=ox;
WindowOY:=oy;
textbackground(WindowColor);
Window(x+1,y+1,x+ox-2,y+oy-2);
clrscr;
Window(1,1,80,25);
textcolor(LimitColor);
gotoxy(x,y);write('…');
for f:=1 to ox-2 do write('Õ');
write('ª');
for l:=y+1 to y+oy-2 do
  begin
    gotoxy(x,l);
    write('∫');
    gotoxy(x+ox-1,l);
    write('∫');
  end;
gotoxy(x,y+oy-1);write('»');
for f:=1 to ox-2 do write('Õ');
write('º');
if name<>'' then
  begin
    textcolor(NameColor);
    gotoxy(x+(ox div 2)-2-(Length(name) div 2),y);
    write(' '+name+' ')
  end;
SetCursor
end;
procedure SetText(x,y:byte;text:string);
begin
textbackground(WindowColor);
textcolor(TxtColor);
gotoxy(WindowX+x-1,WindowY+y-1);
write(text);
SetCursor
end;
procedure CaseMenu;
begin
textbackground(WindowColor);
textcolor(TxtColor);
for f:=1 to ttotal do
  begin
    gotoxy(xx,yy+f-1);
    write(mm[ffirst+f-1]);
    for l:=1 to 80 do if (xx+Length(mm[ffirst+f-1])-1+l)<>(WindowX+WindowOX-1) then
      write(' ')
                                                                            else
      l:=80;
    if (yy+f-1)=(WindowY+WindowOY-2) then break
  end;
textbackground(MenuBKColor);
textcolor(MenuColor);
for f:=1 to ttotal do
 if VVibor=ffirst+f-1 then
  begin
    gotoxy(xx,yy+f-1);
    write(mm[ffirst+f-1]);
    f:=ttotal
  end;
SetCursor
end;
function Menu(x,y:byte;m:MenuType;total:byte):byte;
begin
Vibor:=FirstActive;
first:=FirstActive;
for f:=MenuY-1 downto y do first:=first-1;
x:=WindowX+X-1;
y:=WindowY+Y-1;
xx:=x;
yy:=y;
ffirst:=first;
vvibor:=vibor;
ttotal:=total;
mm:=m;
CaseMenu;
repeat
h:=ReadKey;
if h=#0 then
  begin
    h:=ReadKey;
    if (h=#72) and (Vibor<>First) then
      begin
        MenuY:=MenuY-1;
        Vibor:=Vibor-1;
        vvibor:=vibor;
        CaseMenu;
        h:=' '
      end;
    if (h=#72) and (Vibor=First) and (First<>1) then
      begin
        Vibor:=Vibor-1;
        First:=First-1;
        ffirst:=first;
        vvibor:=vibor;
        CaseMenu;
        h:=' '
      end;
    if (h=#80) and ((y+Vibor-First)<>(WindowY+WindowOY-2)) and (Vibor<>Total) then
      begin
        MenuY:=MenuY+1;
        Vibor:=Vibor+1;
        vvibor:=vibor;
        CaseMenu;
        h:=' '
      end;
    if (h=#80) and ((y+Vibor-First)=(WindowY+WindowOY-2)) and (Vibor<>Total) then
      begin
        Vibor:=Vibor+1;
        First:=First+1;
        ffirst:=first;
        vvibor:=vibor;
        CaseMenu;
        h:=' '
      end;
  end;
until h=#13;
FirstActive:=Vibor;
Menu:=Vibor
end;
function Ok(c:char):Boolean;
begin
Ok:=false;
for f:=1 to Length(Symbols) do
  if c=Symbols[f] then
    begin
      Ok:=true;
      f:=Length(Symbols)
    end
end;
function InputData(x,y,Size:byte;s{§ÆØ„·‚®¨Î• ·®¨¢Æ´Î}:string):string;
var
   Cx,Cy:byte;
begin
Symbols:=s+#13+#8;
Data:=si;
Cx:=x+Length(si);
Cy:=y;
textbackground(InputColor);
textcolor(InputLimitColor);
Window(x-1,y-1,x+Size,y+1);
ClrScr;
Window(1,1,80,25);
gotoxy(x-1,y-1);
write('⁄');
for f:=1 to Size do write('ƒ');
write('ø');
gotoxy(x-1,y);write('≥');
gotoxy(x+Size,y);write('≥');
gotoxy(x-1,y+1);write('¿');
for f:=1 to Size do write('ƒ');
write('Ÿ');
gotoxy(x,Cy);
textcolor(InputDataColor);
write(Data);
repeat
h:=ReadKey;
if (h<>#13) and (h<>#8) and (Length(Data)<>Size) and Ok(h) then
  begin
    Data:=Data+h;
    gotoxy(Cx,Cy);
    write(h);
    Cx:=Cx+1
  end;
if (h=#8) and (Cx<>x) then
  begin
    if Cx=x+1 then Data:=''
              else Data:=Copy(Data,1,Length(Data)-1);
    gotoxy(Cx-1,Cy);
    write(' ');
    Cx:=Cx-1;
    gotoxy(Cx,Cy)
  end;
until h=#13;
InputData:=Data;
SetCursor;
si:=''
end;
procedure Button(x,y,Size,Space,verhor:byte;b:ButtonsType;nomer:byte;c1,c2:char;Active:Boolean);
begin
textbackground(WindowColor);
if Active then textcolor(ActiveButtonColor)
          else textcolor(ButtonColor);
if verhor=0 then
  begin
    gotoxy(x+(nomer-1)*Size+(nomer-1)*Space+(Size div 2)-Length(b[nomer]) div 2,y);
    write(b[nomer]);
    gotoxy(x+(nomer-1)*Size+(nomer-1)*Space,y);
    write(c1);
    gotoxy(x+(nomer-1)*Size+(nomer-1)*Space+Size-1,y);
    write(c2)
  end;
if verhor=1 then
  begin
    gotoxy(x+(Size div 2)-Length(b[nomer]) div 2,y+nomer-1+(nomer-1)*Space);
    write(b[nomer]);
    gotoxy(x,y+nomer-1+(nomer-1)*Space);
    write(c1);
    gotoxy(x+Size-1,y+nomer-1+(nomer-1)*Space);
    write(c2)
  end;
SetCursor
end;
function Buttons(x,y,Size,Space,verhor{0-£Æ‡®ßÆ≠‚†´Ï≠Æ,2-¢•‡‚®™†´Ï≠Æ}:byte;b:ButtonsType;total:byte;c1,c2:char):byte;
var
    ac,d:byte;
begin
ac:=1;
Button(x,y,Size,Space,verhor,b,1,c1,c2,true);
for f:=2 to total do Button(x,y,Size,Space,verhor,b,f,c1,c2,false);
repeat
h:=ReadKey;
if h=#0 then
  begin
    h:=ReadKey;
    if (h=#75) and (verhor=0) and (ac<>1) then
      begin
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,false);
        ac:=ac-1;
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,true)
      end;
    if (h=#77) and (verhor=0) and (ac<>total) then
      begin
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,false);
        ac:=ac+1;
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,true)
      end;
    if (h=#72) and (verhor=1) and (ac<>1) then
      begin
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,false);
        ac:=ac-1;
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,true)
      end;
    if (h=#80) and (verhor=1) and (ac<>total) then
      begin
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,false);
        ac:=ac+1;
        Button(x,y,Size,Space,verhor,b,ac,c1,c2,true)
      end;
  end;
until h=#13;
if verhor=0 then x:=x+(ac-1)*Size+(ac-1)*Space;
if verhor=1 then y:=y+ac-1+(ac-1)*Space;
textbackground(WindowColor);
textcolor(ActiveButtonColor);
s:='';
for f:=1 to Size div 2-Length(b[ac]) div 2 do s:=s+' ';
s:=s+b[ac]+'                                                      ';
s[1]:=c1;
s[Size]:=c2;
s:=Copy(s,1,Size);
if odd(Size) then d:=1
             else d:=0;
for f:=1 to Size div 2-1 do
  begin
    gotoxy(x+f,y);write(copy(s,f+1,Size-f*2));
    gotoxy(x+f-1,y);write(' '+c1);
    gotoxy(x+Size-f-1,y);write(c2+' ');
    SetCursor;
    Delay(PushButtonDelay)
  end;
Delay(PushButtonDelay*5);
for f:=1 to Size div 2 do
  begin
    gotoxy(x+Size div 2-f,y);write(copy(s,Size div 2-f+1,f*2+d));
    gotoxy(x+Size div 2-f,y);write(c1);
    gotoxy(x+Size div 2+f-1+d,y);write(c2);
    SetCursor;
    Delay(PushButtonDelay)
  end;
Delay(PushButtonDelay*5);
Buttons:=ac
end;
procedure ClearZone(x,y,ox,oy,c:byte);
begin
textbackground(c);
Window(x,y,x+ox-1,y+oy-1);
clrscr;
Window(1,1,80,25)
end;
procedure BigText(x,y:byte;t:BigTextType;ox,oy:byte;ch:char;Bkcol,col:byte);
begin
textbackground(BKCol);
textcolor(col);
for l:=1 to oy do
  for f:=1 to ox do
    if t[l][f]='1' then
      begin
        gotoxy(x+f-1,y+l-1);
        write(ch)
      end;
SetCursor
end;
procedure PressAnyKey;
begin
repeat
until KeyPressed;
h:=ReadKey;
if h=#0 then h:=ReadKey
end;

begin
WindowX:=0;
WindowY:=0;
WindowOX:=0;
WindowOY:=0;
LimitColor:=15;
WindowColor:=1;
NameColor:=10;
TxtColor:=14;
MenuBKColor:=4;
MenuColor:=15;
InputLimitColor:=14;
InputColor:=1;
InputDataColor:=13;
ButtonColor:=14;
ActiveButtonColor:=12;
PushButtonDelay:=30;
CursorX:=80;
CursorY:=25;
si:=''
end.