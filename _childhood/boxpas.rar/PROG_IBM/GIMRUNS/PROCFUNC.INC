procedure ButtonOn;
begin
HideMouse;
Button(230,247,30,30,'');
if BOn then PutImage(236,251,POn^,0)
       else
  begin
    BOn:=true;
    Image.Import('on.pfp',@Filter);
    Image.Draw(236,251,NormalPut);
    Image.Done;
    Size:=ImageSize(236,251,254,271);
    GetMem(POn,Size);
    GetImage(236,251,254,271,POn^)
  end;
ShowMouse;
Delay(PushButtonDelay)
end;

procedure PushButtonOn;
begin
HideMouse;
PushButton(230,247,30,30,'');
if BOn then PutImage(237,252,POn^,0)
       else
  begin
    BOn:=true;
    Image.Import('on.pfp',@Filter);
    Image.Draw(237,252,NormalPut);
    Image.Done;
    Size:=ImageSize(237,252,255,272);
    GetMem(POn,Size);
    GetImage(237,252,255,272,POn^)
  end;
ShowMouse;
Delay(PushButtonDelay)
end;

procedure ButtonOff;
begin
HideMouse;
Button(230,247,30,30,'');
if BOff then PutImage(236,252,POff^,0)
        else
  begin
    BOff:=true;
    Image.Import('off.pfp',@Filter);
    Image.Draw(236,252,NormalPut);
    Image.Done;
    Size:=ImageSize(236,252,254,272);
    GetMem(POff,Size);
    GetImage(236,252,254,272,POff^)
  end;
ShowMouse;
Delay(PushButtonDelay)
end;

procedure PushButtonOff;
begin
HideMouse;
PushButton(230,247,30,30,'');
if BOff then PutImage(237,253,POff^,0)
        else
  begin
    BOff:=true;
    Image.Import('off.pfp',@Filter);
    Image.Draw(237,253,NormalPut);
    Image.Done;
    Size:=ImageSize(237,253,255,273);
    GetMem(POff,Size);
    GetImage(237,253,255,273,POff^)
  end;
ShowMouse;
Delay(PushButtonDelay)
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

function rect(x,y:integer):byte;
{var R:TRect;}
begin
rect:=0;
{if (x>273) and (x<367) and (y>13) and (y<43) then rect:=Menshe;
if (x>273) and (x<367) and (y>43) and (y<73) then rect:=Bolshe;
if (x>273) and (x<367) and (y>73) and (y<103) then rect:=MenRavno;
if (x>273) and (x<367) and (y>103) and (y<133) then rect:=BolRavno;
if (x>273) and (x<367) and (y>133) and (y<163) then rect:=Ravno;}
if (x>13) and (x<247) and (y>13) and (y<43) then rect:=AXBYE;
if (x>13) and (x<247) and (y>43) and (y<73) then rect:=VKoren;
if (x>13) and (x<247) and (y>73) and (y<103) then rect:=VModul;
if (x>13) and (x<247) and (y>103) and (y<133) then rect:=VCos;
if (x>13) and (x<247) and (y>133) and (y<163) then rect:=VSin;
if (x>13) and (x<247) and (y>163) and (y<193) then rect:=VConst;
if (x>10) and (x<230) and (y>247) and (y<277) then rect:=PartSystem;
if (x>10) and (x<260) and (y>287) and (y<317) then rect:=LR;
if (x>10) and (x<133) and (y>210) and (y<234) then rect:=Options;
if (x>135) and (x<259) and (y>207) and (y<236) then rect:=Pravka;
{if (x>288) and (x<402) and (y>303) and (y<327) then rect:=Exits;
if (x>288) and (x<402) and (y>353) and (y<377) then rect:=Cancel;
if (x>285) and (x<404) and (y>200) and (y<229) then rect:=Graphic;}
if (x>475) and (x<575) and (y>337) and (y<367) then rect:=Znaki;
if (x>ScrollX) and (x<ScrollX+ScrollOX-2)
   and (y>ScrollY) and (y<ScrollY+ScrollOY-2) then rect:=ScrollBar;
if (x>12) and (x<31) and (y>420) and (y<439) then rect:=30;
if (x>378) and (x<397) and (y>420) and (y<439) then rect:=31;
if (x>230) and (x<259) and (y>247) and (y<276) then rect:=POnOff;
{if (x>285) and (x<404) and (y>100) and (y<129) then rect:=Save;}
if (x>208) and (x<289) and (y>238) and (y<256) then rect:=PWinCur;
if (x>320) and (x<439) and (y>260) and (y<289) then rect:=SaveExit;
if (x>320) and (x<439) and (y>210) and (y<239) then rect:=SaveSave;
{}{ OIV Button }{}
if (x>=579) and (x<=599) and (y>=12) and (y<=44) then rect:=OIVButt;
if (x>=570) and (x<=578) and (y>=16) and (y<=40) then rect:=OIVButt;
if (x>=600) and (x<=608) and (y>=16) and (y<=40) then rect:=OIVButt;
if (x>=609) and (x<=614) and (y>=23) and (y<=33) then rect:=OIVButt;
if (x>=564) and (x<=569) and (y>=23) and (y<=33) then rect:=OIVButt;
if (x>=566) and (x<=569) and (y>=34) and (y<=36) then rect:=OIVButt;
if (x>=566) and (x<=569) and (y>=20) and (y<=22) then rect:=OIVButt;
if (x>=568) and (x<=569) and (y>=37) and (y<=38) then rect:=OIVButt;
if (x>=568) and (x<=569) and (y>=18) and (y<=19) then rect:=OIVButt;
if (x=569) and (y=17) then rect:=OIVButt;
if (x=569) and (y=39) then rect:=OIVButt;
if (x=567) and (y=37) then rect:=OIVButt;
if (x=567) and (y=19) then rect:=OIVButt;
if (x>=565) and (x<=565) and (y>=21) and (y<=22) then rect:=OIVButt;
if (x>=565) and (x<=565) and (y>=34) and (y<=35) then rect:=OIVButt;
if (x>=609) and (x<=612) and (y>=20) and (y<=22) then rect:=OIVButt;
if (x>=609) and (x<=612) and (y>=34) and (y<=36) then rect:=OIVButt;
if (x>=609) and (x<=610) and (y>=18) and (y<=19) then rect:=OIVButt;
if (x>=609) and (x<=610) and (y>=37) and (y<=38) then rect:=OIVButt;
if (x=609) and (y=39) then rect:=OIVButt;
if (x=609) and (y=17) then rect:=OIVButt;
if (x=611) and (y=19) then rect:=OIVButt;
if (x=611) and (y=37) then rect:=OIVButt;
if (x>=613) and (x<=613) and (y>=34) and (y<=35) then rect:=OIVButt;
if (x>=613) and (x<=613) and (y>=21) and (y<=22) then rect:=OIVButt;
if (x>=615) and (x<=615) and (y>=25) and (y<=31) then rect:=OIVButt;
if (x>=563) and (x<=563) and (y>=25) and (y<=31) then rect:=OIVButt;
if (x>=572) and (x<=578) and (y=41) then rect:=OIVButt;
if (x>=572) and (x<=578) and (y=15) then rect:=OIVButt;
if (x>=574) and (x<=578) and (y=42) then rect:=OIVButt;
if (x>=574) and (x<=578) and (y=14) then rect:=OIVButt;
if (x>=576) and (x<=578) and (y=43) then rect:=OIVButt;
if (x>=576) and (x<=578) and (y=13) then rect:=OIVButt;
if (x>=600) and (x<=606) and (y=41) then rect:=OIVButt;
if (x>=600) and (x<=606) and (y=15) then rect:=OIVButt;
if (x>=600) and (x<=604) and (y=42) then rect:=OIVButt;
if (x>=600) and (x<=604) and (y=14) then rect:=OIVButt;
if (x>=600) and (x<=602) and (y=43) then rect:=OIVButt;
if (x>=600) and (x<=602) and (y=13) then rect:=OIVButt;
if (x>=583) and (x<=595) and (y=11) then rect:=OIVButt;
if (x>=583) and (x<=595) and (y=45) then rect:=OIVButt;
{}{}{}{}{}{}{}{}{}
end;

procedure OutVir;
begin
SetColor(ColorText);
if ScrStrOX>47 then for f:=1 to 47 do
  begin
    if ScrollStr[ScrStrX+f-1]<>'¤' then OutTextXY(12+f*8,383,ScrollStr[ScrStrX+f-1])
  end
               else for f:=1 to ScrStrOX do
  if ScrollStr[ScrStrX+f-1]<>'¤' then OutTextXY(12+f*8,383,ScrollStr[ScrStrX+f-1]);
KorenOn:=false;
for f:=1 to ScrStrX-1 do
  if ScrollStr[f]=' ' then
    if KorenOn then KorenOn:=false
               else KorenOn:=true;
if ScrStrOX>47 then ff:=47
               else ff:=ScrStrOX;
for f:=1 to ff do
  begin
    l:=0;
    if KorenOn and (ScrollStr[ScrStrX+f-1]<>' ') then KorenLine(12+f*8,383,0);
    if not KorenOn and (ScrollStr[ScrStrX+f-1]=' ')  then
      begin
        KorenBegin(12+f*8,383,0);
        KorenOn:=true;
        l:=1
      end;
    if KorenOn and (ScrollStr[ScrStrX+f-1]=' ') and (l=0) then
      begin
        KorenEnd(12+f*8,383,0);
        KorenOn:=false
      end
  end;
if SQROn then
  for f:=1 to ff do
    if ScrollStr[ScrStrX+f-1]='¤' then CharSQR(12+f*8,383,0)
end;

procedure Message(Mess:string);
var
    PSpacem:Pointer;
    OX:Integer;
begin
OX:=Length(mess)*8+70;
HideMouse;
Size:=ImageSize(320-OX div 2,190,320-OX div 2+OX,290);
GetMem(PSpacem,Size);
GetImage(320-OX div 2,190,320-OX div 2+OX,290,PSpacem^);
Button(320-OX div 2,190,OX,100,'');
if BFError then PutImage(320-OX div 2+15,205,PFError^,0)
           else
  begin
    BFError:=true;
    Image.Import('error.pfp',@Filter);
    Image.Draw(320-OX div 2+15,205,NormalPut);
    Image.Done;
    PFErrorOX:=OX;
    Size:=ImageSize(320-OX div 2+15,205,320-OX div 2+46,268);
    GetMem(PFError,Size);
    GetImage(320-OX div 2+15,205,320-OX div 2+46,268,PFError^)
  end;
OutTextXY(320-OX div 2+55,220,Mess);
Button(270,250,100,30,'Ok');
ButtonSelect(270,250,100,30);
ShowMouse;
Enter:=false;
repeat
GetMouseEvent(Ev);
MouseX:=CMouseX;
MouseY:=CMouseY;
if KeyPressed then
  begin
    h:=ReadKey;
    if h in [#13,#27] then Enter:=true;
    if h=#0 then h:=ReadKey;
  end;
until ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton) and
      (MouseX>=320-OX div 2+10) and (MouseX<=320-OX div 2+10+OX-21)
      and (MouseY>=250) and (MouseY<=280))
      or Enter;
HideMouse;
PushButton(270,250,100,30,'Ok');
ShowMouse;
Delay(PushButtonDelay);
HideMouse;
Button(270,250,100,30,'Ok');
ShowMouse;
Delay(2*PushButtonDelay);
HideMouse;
PutImage(320-OX div 2,190,PSpacem^,0);
Size:=ImageSize(320-OX div 2,190,320-OX div 2+OX,290);
FreeMem(PSpacem,Size);
ShowMouse;
Enter:=false
end;

procedure Vibors(V,Col:byte);
var Col1,Col2:byte;
begin
case Col of
0:begin
    Col1:=7;
    Col2:=ColorText
  end;
1:begin
    Col1:=1;
    Col2:=15
  end;
end;
HideMouse;
case V of
6:begin
    Pole(13,13,244,30,Col1);
    SetColor(Col2);
    OutTextXY(55,26,'квадратичная функция')
  end;
7:begin
    Pole(13,43,244,30,Col1);
    SetColor(Col2);
    OutTextXY(65,56,'линейная функция')
  end;
8:begin
    Pole(13,73,244,30,Col1);
    SetColor(Col2);
    OutTextXY(55,86,'уравнение окружности')
  end;
9:begin
    Pole(13,103,244,30,Col1);
    SetColor(Col2);
    OutTextXY(31,116,'тригонометрические функции')
  end;
10:begin
    Pole(13,133,244,30,Col1);
    SetColor(Col2);
    OutTextXY(95,146,'гипербола')
  end;
11:begin
    Pole(13,163,244,30,Col1);
    SetColor(Col2);
    OutTextXY(95,176,'константа')
  end;
end;
ShowMouse
end;

function VirName(typ:TypType):string;
begin
VirName:='';
case typ of
1:VirName:='ax¤';
2:VirName:='ay¤';
3:VirName:='ax¤+bx+c';
4:VirName:='ax¤+b';
5:VirName:='ay¤+b';
6:VirName:='ax¤+bx';
7:VirName:='ay¤+by';
8:VirName:='a';
9:VirName:='Pi';
10:VirName:='ax';
11:VirName:='ay';
12:VirName:='ax+by+c';
13:VirName:='ax+b';
14:VirName:='ay+b';
15:VirName:='(x-a)¤+(y-b)¤-c¤';
16:VirName:='x¤+y¤-a¤';
17:VirName:='cos(ax)';
18:VirName:='cos(ay)';
19:VirName:='cos(Pi)';
20:VirName:='cos(Pi/2)';
21:VirName:='sin(ax)';
22:VirName:='sin(ay)';
23:VirName:='sin(Pi)';
24:VirName:='sin(Pi/2)';
25:VirName:='tg(ax)';
26:VirName:='tg(ay)';
27:VirName:='tg(Pi)';
28:VirName:='tg(Pi/2)';
29:VirName:='a/x';
30:VirName:='a/y';
end
end;

function VirABC(typ:TypType):Byte;
begin
VirABC:=0;
case typ of
1:VirABC:=1;
2:VirABC:=1;
3:VirABC:=3;
4:VirABC:=2;
5:VirABC:=2;
6:VirABC:=2;
7:VirABC:=2;
8:VirABC:=1;
9:VirABC:=0;
10:VirABC:=1;
11:VirABC:=1;
12:VirABC:=3;
13:VirABC:=2;
14:VirABC:=2;
15:VirABC:=3;
16:VirABC:=1;
17:VirABC:=1;
18:VirABC:=1;
19:VirABC:=0;
20:VirABC:=0;
21:VirABC:=1;
22:VirABC:=1;
23:VirABC:=0;
24:VirABC:=0;
25:VirABC:=1;
26:VirABC:=1;
27:VirABC:=0;
28:VirABC:=0;
29:VirABC:=1;
30:VirABC:=1;
end
end;

procedure SuccIf;
var SFile:File;
begin
{$I-}
Assign(SFile,'succ1'+ExtTemp);
Reset(SFile);
if IOResult=0 then
  begin
    Close(SFile);
    Erase(SFile)
  end;
for ff:=1 to TotalSucc do
  if SuccFunc^[ff].T=0 then
    begin
      str(ff+1,s);
      Assign(SFile,'succ'+s+ExtTemp);
      Reset(SFile);
      if IOResult=0 then
        begin
          Close(SFile);
          str(ff,s);
          Rename(SFile,'succ'+s+ExtTemp)
        end;
    end;
{$I+}
end;

procedure PredIf;
var PFile:File;
begin
{$I-}
Assign(PFile,'pred1'+ExtTemp);
Reset(PFile);
if IOResult=0 then
  begin
    Close(PFile);
    Erase(PFile)
  end;
Assign(PFile,'if1'+ExtTemp);
Reset(PFile);
if IOResult=0 then
  begin
    Close(PFile);
    Erase(PFile)
  end;
for ff:=1 to TotalPred do
    begin
      str(ff+1,s);
      Assign(PFile,'pred'+s+ExtTemp);
      Reset(PFile);
      if IOResult=0 then
        begin
          Close(PFile);
          str(ff,s);
          Rename(PFile,'pred'+s+ExtTemp)
        end;
      str(ff+1,s);
      Assign(PFile,'if'+s+ExtTemp);
      Reset(PFile);
      if IOResult=0 then
        begin
          Close(PFile);
          str(ff,s);
          Rename(PFile,'if'+s+ExtTemp)
        end
    end
{$I+}
end;

procedure WriteBlock(v,c:Byte);
begin
if (v=0) or (v=100) then exit;
HideMouse;
Pole(mx+5,my+5+v*SizeMenu-SizeMenu,mox-10,SizeMenu,c);
if c=7 then
  begin
    SetColor(ColorText);
    c:=0
  end
       else
  begin
    SetColor(ColorLigth);
    c:=15
  end;
OutTextXY(mx+mox div 2-4-(Length(mmm[v]) div 2)*8,my+5+v*SizeMenu-SizeMenu div 2-TextHeight(mmm[v]) div 2,mmm[v]);
if SQROn then
 for ff:=1 to Length(mmm[v]) do
  if mmm[v][ff]=' ' then
    CharSQR(mx+mox div 2-4-(Length(mmm[v]) div 2)*8+ff*8-8,
            my+5+v*SizeMenu-SizeMenu div 2-TextHeight(mmm[v]) div 2,c);
ShowMouse
end;

function who(x,y:integer):Byte;
var R:TRect;
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
var
    f:byte;
    PSpacen:Pointer;
begin
mmm:=m;
vibo:=1;
mx:=x; my:=y; mox:=ox; moy:=oy;
totalm:=t;
HideMouse;
Size:=ImageSize(x,y,x+ox-1,y+oy-1);
GetMem(PSpacen,Size);
GetImage(x,y,x+ox-1,y+oy-1,PSpacen^);
Button(x,y,ox,oy,'');
for f:=1 to totalm do WriteBlock(f,7);
WriteBlock(vibo,1);
ShowMouse;
Enter:=false;
repeat
GetMouseEvent(Ev);
MouseX:=CMouseX;
MouseY:=CMouseY;
if Ev.What=evMouseMove then
  begin
    l:=Who(MouseX,MouseY);
    if l<>Vibo then
      begin
      WriteBlock(vibo,7);
      vibo:=l;
      WriteBlock(vibo,1)
    end
  end;
if KeyPressed then
  begin
    h:=ReadKey;
    if h=#13 then Enter:=true;
    if h=#27 then
      begin
        Enter:=true;
        vibo:=0
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        if h=#80 then
          begin
            WriteBlock(vibo,7);
            if vibo=t then vibo:=1
                      else inc(vibo);
            WriteBlock(vibo,1)
          end;
        if h=#72 then
          begin
            WriteBlock(vibo,7);
            if vibo=1 then vibo:=t
                      else dec(vibo);
            WriteBlock(vibo,1)
          end
      end
  end;
if (Ev.What=evMouseDown) and (Ev.Buttons=mbRightButton) then
  begin
    vibo:=0;
    Enter:=true
  end;
until ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter;
HideMouse;
PutImage(x,y,PSpacen^,0);
ShowMouse;
Size:=ImageSize(x,y,x+ox-1,y+oy-1);
FreeMem(PSpacen,Size);
Menus:=Vibo;
Enter:=false
end;

procedure WorkWindow;
label Again;
var
    cc:string;
    Sym:array[1..2560] of Char;
    TotalSym,tv:Word;
    posn,posk:byte;
begin
Again:
{TotalSym:=0;}
str(TekPart,s);
HideMouse;
Button(10,247,220,30,'неравенство(уравнение) '+s);
ShowMouse;
if PartOnOff[TekPart] then ButtonOn
                      else ButtonOff;
HideMouse;
Button(10,287,250,30,LeftRigthText[LeftRigth]);
Button(5,327,400,120,'');
Button(415,327,220,120,'');
Button(475,337,100,30,'Знак');
ColorPole:=15;
PushButton(425,387,200,30,'левая ч. '+ZnakText[VirIf[TekPart]]+' правая ч.');
ColorPole:=7;
ColorPole:=15;
PushButton(10,332,390,110,'');
ColorPole:=7;
SetColor(ColorText);
ShowMouse;
{if Part[TekPart,LeftRigth].TotalVir<>0 then}
ff:=0;
for fd:=1 to 2 do
begin
TotalSym:=0;
for f:=1 to Part[TekPart,fd].TotalVir do
with Part[TekPart,fd].Vir[f] do
begin
s:=VirName(Typ);
if VirABC(Typ)>=1 then
  begin
    str(a,cc);
    if (Pos('a',s)>1) and (a<0) and (Typ<>16) then
      begin
        if s[Pos('a',s)-1]='+' then Delete(s,Pos('a',s)-1,1);
        if s[Pos('a',s)-1]='-' then
          begin
            Delete(s,Pos('a',s)-1,1);
            Insert('+',s,Pos('a',s));
            Delete(cc,1,1)
          end;
      end;
    if Typ=16 then str(SQR(a),cc);
    Insert(cc,s,Pos('a',s));
    if Typ=16 then Delete(s,Pos('a',s),2)
              else Delete(s,Pos('a',s),1)
  end;
if VirABC(Typ)>=2 then
  begin
    str(b,cc);
    if (Pos('b',s)>1) and (b<0) then
      begin
        if s[Pos('b',s)-1]='+' then Delete(s,Pos('b',s)-1,1);
        if s[Pos('b',s)-1]='-' then
          begin
            Delete(s,Pos('b',s)-1,1);
            Insert('+',s,Pos('b',s));
            Delete(cc,1,1)
          end;
      end;
    Insert(cc,s,Pos('b',s));
    Delete(s,Pos('b',s),1)
  end;
if VirABC(Typ)=3 then
  begin
    str(c,cc);
    if (Pos('c',s)>1) and (c<0) and (Typ<>15) then
      begin
        if s[Pos('c',s)-1]='+' then Delete(s,Pos('c',s)-1,1);
        if s[Pos('c',s)-1]='-' then
          begin
            Delete(s,Pos('c',s)-1,1);
            Insert('+',s,Pos('c',s));
            Delete(cc,1,1)
          end
      end;
    if Typ=15 then str(SQR(c),cc);
    Insert(cc,s,Pos('c',s));
    if Typ=15 then Delete(s,Pos('c',s),2)
              else Delete(s,Pos('c',s),1)
  end;
if (VirABC(Typ)>=1) and (a=1) then
  case Typ of
    1,3,4,6,10,12,13,17,21,25:Delete(s,pos('x',s)-1,1);
    2,5,7,11,14,18,22,26:Delete(s,pos('y',s)-1,1)
  end;
if (VirABC(Typ)>=2) and (b=1) then
  case Typ of
    3,6:begin
          Insert('y',s,pos('x',s));
          Delete(s,pos('x',s),1);
          Delete(s,pos('x',s)-1,1);
          Insert('x',s,pos('y',s));
          Delete(s,pos('y',s),1)
        end;
    7:begin
        Insert('x',s,pos('y',s));
        Delete(s,pos('y',s),1);
        Delete(s,pos('y',s)-1,1);
        Insert('y',s,pos('x',s));
        Delete(s,pos('x',s),1)
      end;
    12:Delete(s,pos('y',s)-1,1)
  end;
if First=kore then
  begin
    if modul then
      begin
        Insert('│',s,1);
        s:=s+'│'
      end;
    if koren then
      begin
        Insert(' ',s,1);
        s:=s+' '
      end
  end;
if First=modu then
  begin
    if koren then
      begin
        Insert(' ',s,1);
        s:=s+' '
      end;
    if modul then
      begin
        Insert('│',s,1);
        s:=s+'│'
      end
  end;
tv:=Part[TekPart,fd].TotalVir;
if f<>1 then
  begin
    case Part[TekPart,fd].Znak[f-1] of
      1:if s[1]<>'-' then s:='+'+s;
      2:case Part[TekPart,fd].Vir[f].Typ of
          1..14,16,29..30:if Part[TekPart,fd].vir[tv].Koren or Part[TekPart,fd].vir[tv].Modul then
                            s:='-'+s
                                                                                              else
                            for l:=1 to Length(s) do
                              begin
                                posn:=1;
                                if (s[l]='+') and (posn=1) then
                                  begin
                                    Insert('-',s,l);
                                    posn:=0
                                  end;
                                if (s[l]='-') and (posn=1) then
                                  begin
                                    Insert('+',s,l);
                                    posn:=0
                                  end;
                                if (l=1) and (s[l]<>'+') and (s[l]<>'-') then Insert('-',s,1);
                                if posn=0 then Delete(s,l+1,1)
                              end;
          15:if Part[TekPart,fd].vir[tv].Koren or Part[TekPart,fd].vir[tv].Modul then
               s:='-'+s
                                                                                 else
               begin
                 Insert('-',s,1);
                 posn:=Pos(#253,s);
                 Insert('-',s,posn+1);
                 Delete(s,posn+2,1);
                 Delete(s,posn,1);
                 posk:=Pos(#253,s)+1;
                 if s[posk]='+' then
                   begin
                     Delete(s,posk,1);
                     Insert('-',s,posk)
                   end
                                else
                   if s[posk]='-' then
                     begin
                       Delete(s,posk,1);
                       Insert('+',s,posk)
                     end;
                 Insert(#253,s,posn)
               end;
          17..28:if Part[TekPart,fd].vir[tv].Koren or Part[TekPart,fd].vir[tv].Modul then
                   s:='-'+s
                                                                                     else
                   Insert('-',s,1)
        end;
      3:begin
          posn:=0;
          for l:=1 to TotalSym do
            if Sym[l] in ['-','+'] then posn:=posn+1;
          if posn>0 then
            begin
              for l:=TotalSym downto 1 do Sym[l+1]:=Sym[l];
              Sym[1]:='(';
              TotalSym:=TotalSym+2;
              Sym[TotalSym]:=')'
            end;
          Insert('/',s,1);
          posk:=0;
          for l:=1 to Length(s) do
            if s[l] in ['-','+'] then posk:=posk+1;
          if Part[TekPart,fd].Vir[f].Typ in [17..28] then posk:=0;
          if Part[TekPart,fd].Vir[f].Typ in [29,30] then posk:=posk+1;
          if (posk>0)
             and not (Part[TekPart,fd].Vir[f].koren
             or Part[TekPart,fd].Vir[f].modul) then
            begin
              Insert('(',s,2);
              s:=s+')'
            end;
        end;
      4:begin
          posn:=0;
          for l:=1 to TotalSym do
            if Sym[l] in ['-','+'] then posn:=posn+1;
          if posn>0 then
            begin
              for l:=TotalSym downto 1 do Sym[l+1]:=Sym[l];
              Sym[1]:='(';
              TotalSym:=TotalSym+2;
              Sym[TotalSym]:=')'
            end;
          Insert('*',s,1);
          posk:=0;
          for l:=1 to Length(s) do
            if s[l] in ['-','+'] then posk:=posk+1;
          if Part[TekPart,fd].Vir[f].Typ in [17..28] then posk:=0;
          if Part[TekPart,fd].Vir[f].Typ in [29,30] then posk:=posk+1;
          if (posk>0)
             and not (Part[TekPart,fd].Vir[f].koren
             or Part[TekPart,fd].Vir[f].modul) then
            begin
              Insert('(',s,2);
              s:=s+')'
            end
        end
    end
  end;
if TotalSym+Length(s)>MaxDlinaVir then
  begin
    Message('Длина выражения ограничена!');
    dec(Part[TekPart,fd].TotalVir);
    s:=''
  end;
for l:=1 to Length(s) do sym[TotalSym+l]:=s[l];
TotalSym:=TotalSym+Length(s)
end;
for l:=1 to TotalSym do ScrollData^[TekPart].SStr[l+ff]:=sym[l];
ff:=ff+TotalSym;
if fd=1 then
  begin
    for f:=1 to Length(ZnakText[VirIf[TekPart]]) do
      ScrollData^[TekPart].SStr[f+ff]:=ZnakText[VirIf[TekPart]][f];
    ff:=ff+Length(ZnakText[VirIf[TekPart]])
  end
end;
with ScrollData^[TekPart] do
  begin
    TotalSym:=ff;
    {for f:=1 to TotalSym do SStr[f]:=Sym[f];}
    SStrOX:=TotalSym;
    if TotalSym<=330 then if TotalSym>47 then SOX:=397-TotalSym
                                         else SOX:=350
                     else SOX:=20;
    if SStrX>TotalSym then
      if TotalSym>47 then SStrX:=TotalSym-46
                     else SStrX:=1;
    if (TotalSym<=330) and (TotalSym<>0) then SX:=30+SStrX-1
                                         else if TotalSym<>0 then SX:=29+Round(((350-SOX)*SStrX)/TotalSym)
                                                             else SX:=30;
    ScrollX:=SX;
    ScrollY:=SY;
    ScrollOX:=SOX;
    ScrollOY:=SOY;
    for f:=1 to TotalSym do ScrollStr[f]:=SStr[f];
    ScrStrOX:=SStrOX;
    ScrStrX:=SStrX;
    SQROn:=true;
    OutVir;
    SQROn:=false
  end;
HideMouse;
Button(ScrollX,ScrollY,ScrollOX,ScrollOY,'');
Button(12,420,20,20,#17);
Button(378,420,20,20,#16);
ShowMouse
end;

procedure ClearZone(x,y,ox,oy:integer;c:byte);
begin
SetFillStyle(1,c);
HideMouse;
Bar(x,y,x+ox-1,y+oy-1);
ShowMouse
end;

procedure SetCursor(cx,cy:integer;s:string;Clear:boolean);
begin
SetColor(0);
HideMouse;
if Clear then OutTextXY(cx,cy,s)
         else OutTextXY(cx,cy,s+'│');
ShowMouse
end;

procedure CasePV(cp,Color:Byte;var a,b,c:LongInt);
begin
ColorText:=Color;
case cp of
  1:if Color=7 then
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        val(chislo,a,Err);
        ChisloA:=a;
        ba:=false;
        SetCursor(cx,cy,chislo,true);
        ColorText:=0;
        ButtonDisable(230,180,30,20,'a=');
        ColorText:=Color
      end
               else
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        ba:=true;
        cx:=265;
        cy:=186;
        ClearZone(cx,cy,40,8,15);
        str(a,chislo);
        if Length(chislo)<5 then SetCursor(cx,cy,chislo,false)
                            else SetCursor(cx,cy,chislo,true);
        ButtonSelect(230,180,30,20)
      end;
  2:if Color=7 then
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        val(chislo,b,Err);
        ChisloB:=b;
        bb:=false;
        SetCursor(cx,cy,chislo,true);
        ColorText:=0;
        ButtonDisable(230,210,30,20,'b=');
        ColorText:=Color
      end
               else
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        bb:=true;
        cx:=265;
        cy:=216;
        ClearZone(cx,cy,40,8,15);
        str(b,chislo);
        if Length(chislo)<5 then SetCursor(cx,cy,chislo,false)
                            else SetCursor(cx,cy,chislo,true);
        ButtonSelect(230,210,30,20)
      end;
  3:if Color=7 then
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        val(chislo,c,Err);
        ChisloC:=c;
        bc:=false;
        SetCursor(cx,cy,chislo,true);
        ColorText:=0;
        ButtonDisable(230,240,30,20,'c=');
        ColorText:=Color
      end
               else
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        bc:=true;
        cx:=265;
        cy:=246;
        ClearZone(cx,cy,40,8,15);
        str(c,chislo);
        if Length(chislo)<5 then SetCursor(cx,cy,chislo,false)
                            else SetCursor(cx,cy,chislo,true);
        ButtonSelect(230,240,30,20)
      end;
  4:ButtonSelect(315,180,100,20);
  5:ButtonSelect(315,210,100,20);
  6:ButtonSelect(230,270,180,30);
  7:ButtonSelect(230,305,180,30)
end;
ColorText:=0
end;

procedure ParamVir(typs:TypType;var v:VirType);
label InTo;
begin
if Part[TekPart,LeftRigth].TotalVir+1>MaxVir then
  begin
    Message('Длина выражения ограничена!');
    exit
  end;
ba:=false;
bb:=false;
bc:=false;
cx:=265;
cy:=186;
HideMouse;
Size:=ImageSize(220,140,420,340);
GetMem(PSpaces,Size);
GetImage(220,140,420,340,PSpaces^);
Name:=VirName(Typs);
SQRBOn:=true;
GraphWindow(220,140,200,200,Name);
SQRBOn:=false;
v.a:=ChisloA;
v.b:=ChisloB;
v.c:=ChisloC;
if VirABC(typs)>=1 then
  begin
    ButtonDisable(230,180,30,20,'a=');
    ColorPole:=15;
    PushButton(260,180,50,20,'');
    str(ChisloA,chislo);
    SetCursor(265,186,chislo,true);
    ColorPole:=7
  end;
if VirABC(typs)>=2 then
  begin
    ButtonDisable(230,210,30,20,'b=');
    ColorPole:=15;
    PushButton(260,210,50,20,'');
    str(ChisloB,chislo);
    SetCursor(265,216,chislo,true);
    ColorPole:=7
  end;
if VirABC(typs)>=3 then
  begin
    ButtonDisable(230,240,30,20,'c=');
    ColorPole:=15;
    PushButton(260,240,50,20,'');
    str(ChisloC,chislo);
    SetCursor(265,246,chislo,true);
    ColorPole:=7
  end;
Button(315,180,100,20,'корень');
if VirABC(typs)<>0 then Button(315,210,100,20,'модуль');
Button(230,270,180,30,'вставить');
Button(230,305,180,30,'отмена');
ShowMouse;
with v do
begin
typ:=Typs;
koren:=false;
modul:=false;
first:=zero;
vib:=6;
CasePV(vib,0,a,b,c);
Enter:=false;
repeat
GetMouseEvent(Ev);
Ok:=true;
if KeyPressed and not (ba or bb or bc) then
  begin
    h:=ReadKey;
    if h=#13 then Enter:=true;
    if h=#27 then
      begin
        Enter:=true;
        vib:=7
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        Ok:=false;
        if h=#80 then
          begin
            CasePV(vib,7,a,b,c);
            if vib=7 then vib:=1
                     else inc(vib);
            if (vib=1) and (VirABC(typ)=0) then vib:=4;
            if (vib=5) and (VirABC(typ)=0) then vib:=6;
            CasePV(vib,0,a,b,c)
          end;
        if h=#72 then
          begin
            CasePV(vib,7,a,b,c);
            if vib=4 then vib:=7
                     else dec(vib);
            if (vib=5) and (VirABC(typ)=0) then vib:=4;
            CasePV(vib,0,a,b,c)
          end;
        if (h in [#75,#77]) and (vib in [4,5]) and (VirABC(typ)<>0) then
          begin
            CasePV(vib,7,a,b,c);
            vib:=1;
            CasePV(vib,0,a,b,c)
          end
      end
  end;
if KeyPressed and Ok and (ba or bb or bc) then
  begin
    h:=ReadKey;
    if h=#13 then
      begin
        Enter:=true;
        vib:=6
      end;
    if h=#27 then
      begin
        Enter:=true;
        vib:=7
      end;
    if (h=#13) and (ba or bb or bc) then
      begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        if h=#80 then
          begin
            CasePV(vib,7,a,b,c);
            if vib<>VirABC(typ) then inc(vib)
                                else vib:=6;
            CasePV(vib,0,a,b,c)
          end;
        if h=#72 then
          begin
            CasePV(vib,7,a,b,c);
            if vib<>1 then dec(vib)
                      else vib:=7;
            CasePV(vib,0,a,b,c)
          end;
        if h in [#75,#77] then
          begin
            CasePV(vib,7,a,b,c);
            vib:=4;
            CasePV(vib,0,a,b,c)
          end;
      end;
    if (h='-') and (chislo<>'') then h:='*';
    if (h in Figures) and (Length(chislo)<5) then
      begin
        ClearZone(cx,cy,40,8,15);
        Chislo:=Chislo+h;
        if Length(chislo)=5 then SetCursor(cx,cy,chislo,true)
                            else SetCursor(cx,cy,chislo,false)
      end;
    if (h=#8) and (Length(chislo)>=1) then
      begin
        ClearZone(cx,cy,40,8,15);
        if Length(chislo)=1 then chislo:=''
                            else chislo:=Copy(chislo,1,Length(chislo)-1);
        SetCursor(cx,cy,chislo,false)
      end;
  end;
if ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter then
  begin
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if ((MouseX>=260) and (MouseX<=310) and (MouseY>=180) and (MouseY<=200) and (VirABC(typs)>=1))
       or ((vib=1) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true)
        end;
        bb:=false;
        bc:=false;
        ba:=true;
        cx:=265;
        cy:=186;
        ClearZone(cx,cy,40,8,15);
        str(a,chislo);
        if Length(chislo)<5 then SetCursor(cx,cy,chislo,false)
                            else SetCursor(cx,cy,chislo,true);
        CasePV(vib,7,a,b,c);
        vib:=1;
        CasePV(vib,0,a,b,c);
        if Enter then goto InTo
      end;
    if ((MouseX>=260) and (MouseX<=310) and (MouseY>=210) and (MouseY<=230) and (VirABC(typs)>=2))
       or ((vib=2) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        end;
        bb:=true;
        bc:=false;
        ba:=false;
        cx:=265;
        cy:=216;
        ClearZone(cx,cy,40,8,15);
        str(b,chislo);
        if Length(chislo)<5 then SetCursor(cx,cy,chislo,false)
                            else SetCursor(cx,cy,chislo,true);
        CasePV(vib,7,a,b,c);
        vib:=2;
        CasePV(vib,0,a,b,c);
        if Enter then goto InTo
      end;
    if ((MouseX>=260) and (MouseX<=310) and (MouseY>=240) and (MouseY<=260) and (VirABC(typs)>=3))
       or ((vib=3) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        end;
        bb:=false;
        bc:=true;
        ba:=false;
        cx:=265;
        cy:=246;
        ClearZone(cx,cy,40,8,15);
        str(c,chislo);
        if Length(chislo)<5 then SetCursor(cx,cy,chislo,false)
                            else SetCursor(cx,cy,chislo,true);
        CasePV(vib,7,a,b,c);
        vib:=3;
        CasePV(vib,0,a,b,c);
        if Enter then goto InTo
      end;
    if ((MouseX>=315) and (MouseX<=415) and (MouseY>=210) and (MouseY<=230) and (VirABC(typs)<>0))
       or ((vib=5) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        end;
        if modul then
          begin
            HideMouse;
            Button(315,210,100,20,'модуль');
            ShowMouse;
            modul:=false;
            First:=kore
          end
                 else
          begin
            HideMouse;
            PushButton(315,210,100,20,'модуль');
            ShowMouse;
            modul:=true;
            First:=kore
          end;
        Enter:=false;
        CasePV(vib,7,a,b,c);
        vib:=5;
        CasePV(vib,0,a,b,c)
      end;
    if ((MouseX>=315) and (MouseX<=415) and (MouseY>=180) and (MouseY<=200))
       or ((vib=4) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        end;
        if Koren then
          begin
            HideMouse;
            Button(315,180,100,20,'корень');
            ShowMouse;
            koren:=false;
            First:=modu
          end
                 else
          begin
            HideMouse;
            PushButton(315,180,100,20,'корень');
            ShowMouse;
            koren:=true;
            First:=kore
          end;
        Enter:=false;
        CasePV(vib,7,a,b,c);
        vib:=4;
        CasePV(vib,0,a,b,c)
      end;
    if ((MouseX>=230) and (MouseX<=410) and (MouseY>=270) and (MouseY<=300))
       or ((vib=6) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        end;
InTo:
        HideMouse;
        PushButton(230,270,180,30,'вставить');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(230,270,180,30,'вставить');
        ShowMouse;
        Delay(2*PushButtonDelay);
        ShowMouse;
        m[1]:='прибавить';
        m[2]:='отнять';
        m[3]:='разделить';
        m[4]:='умножить';
        if Part[TekPart,LeftRigth].TotalVir>0 then
          f:=Menus(270,195,100,90,m,4)
                                               else
          f:=1;
        if f<>0 then
          begin
            inc(Part[TekPart,LeftRigth].TotalVir);
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].Typ:=Typ;
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].Modul:=modul;
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].Koren:=koren;
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].First:=first;
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].A:=a;
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].B:=b;
            Part[TekPart,LeftRigth].Vir[Part[TekPart,LeftRigth].TotalVir].C:=c;
            if Part[TekPart,LeftRigth].TotalVir>1 then
              Part[TekPart,LeftRigth].Znak[Part[TekPart,LeftRigth].TotalVir-1]:=f
          end;
        HideMouse;
        PutImage(220,140,PSpaces^,0);
        WorkWindow;
        ShowMouse;
        Size:=ImageSize(220,140,420,340);
        FreeMem(PSpaces,Size);
        if TotalPred=TotalBaks then
          begin
            for ff:=1 to TotalBaks-1 do PredFunc^[ff]:=PredFunc^[ff+1];
            dec(TotalPred);
            PredIf
          end;
        inc(TotalPred);
        with PredFunc^[TotalPred] do
          begin
            P:=TekPart;
            PLR:=LeftRigth;
            T:=0
          end;
        Enter:=false;
        Exit
      end;
    if ((MouseX>=230) and (MouseX<=410) and (MouseY>=305) and (MouseY<=335))
       or ((vib=7) and Enter) then
      begin
        if ba or bb or bc then
        begin
        ClearZone(cx,cy,40,8,15);
        if (chislo='-') or (chislo='-0') or (chislo='') then chislo:='0';
        if ba then
          begin
            val(chislo,a,Err);
            ChisloA:=a;
            ba:=false
          end;
        if bb then
          begin
            val(chislo,b,Err);
            ChisloB:=b;
            bb:=false
          end;
        if bc then
          begin
            val(chislo,c,Err);
            ChisloC:=c;
            bc:=false
          end;
        SetCursor(cx,cy,chislo,true);
        end;
        HideMouse;
        PushButton(230,305,180,30,'отмена');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(230,305,180,30,'отмена');
        ShowMouse;
        Delay(2*PushButtonDelay);
        HideMouse;
        PutImage(220,140,PSpaces^,0);
        ShowMouse;
        Size:=ImageSize(220,140,420,340);
        FreeMem(PSpaces,Size);
        Typ:=0
      end
  end
until typ=0;
Enter:=false
end
end;

function Result(x,y:Integer;v:VirType):Real;
var
    Res,ra,rb,rc,rx,ry:Real;
begin
Error:=false;
with v do
begin
ra:=a;
rb:=b;
rc:=c;
rx:=x;
ry:=y;
case Typ of
1:Res:=ra*SQR(rx);
2:Res:=ra*SQR(ry);
3:Res:=ra*SQR(rx)+rb*rx+rc;
4:Res:=ra*SQR(rx)+rb;
5:Res:=ra*SQR(ry)+rb;
6:Res:=ra*SQR(rx)+rb*rx;
7:Res:=ra*SQR(ry)+rb*ry;
8:Res:=ra;
9:Res:=Pi;
10:Res:=ra*rx;
11:Res:=ra*ry;
12:Res:=ra*rx+rb*ry+rc;
13:Res:=ra*rx+rb;
14:Res:=ra*ry+rb;
15:Res:=SQR(rx-ra)+SQR(ry-rb)-SQR(rc);
16:Res:=SQR(rx)+SQR(ry)-SQR(ra);
17:Res:=cos(ra*rx);
18:Res:=cos(ra*ry);
19:Res:=cos(Pi);
20:Res:=cos(Pi/2);
21:Res:=sin(ra*rx);
22:Res:=sin(ra*ry);
23:Res:=sin(Pi);
24:Res:=sin(Pi/2);
25:Res:=tg(ra*rx);
26:Res:=tg(ra*ry);
27:Res:=tg(Pi);
28:Res:=tg(Pi/2);
29:if rx=0 then
     begin
       Error:=true;
       Exit
     end
          else
     Res:=ra/rx;
30:if ry=0 then
     begin
       Error:=true;
       Exit
     end
          else
     Res:=ra/ry
end;
if first=kore then
  begin
    if modul then Res:=ABS(Res);
    if Res>=0 then
      begin
        if koren then Res:=SQRT(Res)
      end
              else
      begin
        Error:=true;
        Exit
      end
  end;
if first=modu then
  begin
    if modul then Res:=ABS(Res);
    if Res>=0 then
      begin
        if koren then Res:=SQRT(Res)
      end
              else
      begin
        Error:=true;
        Exit
      end
  end
end;
Result:=Res
end;

function PError:Boolean;
begin
PError:=Error
end;

procedure Colors(who:Byte);
var Col:Byte;
begin
case who of
1:begin Col:=FonGr;ColorText:=FonGr end;
2:begin Col:=TonGr;ColorText:=TonGr end;
3:begin Col:=FonPoi;ColorText:=FonPoi end;
4:begin Col:=TonPoi;ColorText:=TonPoi end;
5:begin Col:=TonCoor;ColorText:=TonCoor end;
end;
if ColorText=7 then ColorText:=8;
ColorLigth:=7;
ColorShadow:=7;
HideMouse;
case who of
1:begin Button(340,80,100,30,'');Button(340,80,100,30,ColorsText[Col]) end;
2:begin Button(340,120,100,30,'');Button(340,120,100,30,ColorsText[Col]) end;
3:begin Button(340,160,100,30,'');Button(340,160,100,30,ColorsText[Col]) end;
4:begin Button(340,200,100,30,'');Button(340,200,100,30,ColorsText[Col]) end;
5:begin Button(340,240,100,30,'');Button(340,240,100,30,ColorsText[Col]) end
end;
ShowMouse;
ColorText:=0;
ColorLigth:=15;
ColorShadow:=8
end;

procedure Primer(x,y:integer);
begin
HideMouse;
ColorPole:=FonGr;
PushButton(x,y,150,100,'');
ColorPole:=7;
SetColor(TonGr);
Circle(x+75,y+50,15);
SetFillStyle(1,TonGr);
FloodFill(x+75,y+50,TonGr);
SetColor(TonCoor);
Line(x+75,y+4,x+75,y+96);
Line(x+4,y+50,x+146,y+50);
Line(x+75,y+4,x+73,y+14);
Line(x+75,y+4,x+77,y+14);
Line(x+146,y+50,x+136,y+48);
Line(x+146,y+50,x+136,y+52);
OutTextXY(x+65,y+5,'y');
OutTextXY(x+136,y+40,'x');
ColorPole:=FonPoi;
ColorText:=TonPoi;
Button(x+108,y+82,40,16,'x,y');
ColorPole:=7;
ColorText:=0;
ShowMouse;
end;

procedure CaseSetup(cs,Color:Byte);
begin
ColorText:=Color;
case cs of
  1:ButtonSelect(130,80,200,30);
  2:ButtonSelect(130,120,200,30);
  3:ButtonSelect(130,160,200,30);
  4:ButtonSelect(130,200,200,30);
  5:ButtonSelect(130,240,200,30);
  6:ButtonSelect(130,280,200,30);
  7:ButtonSelect(130,320,200,30);
  8:ButtonSelect(130,360,200,30)
end;
ColorText:=0
end;

procedure Setup;
var
    PSpaceSetup:Pointer;
    F:Byte;
begin
FonGr:=PixelBKColor;
TonGr:=PixelColor;
FonPoi:=PointsBKColor;
TonPoi:=PointsColor;
TonCoor:=LineColor;
HideMouse;
Size:=ImageSize(120,75,520,395);
GetMem(PSpaceSetup,Size);
GetImage(120,75,520,395,PSpaceSetup^);
Button(120,75,400,320,'');
Button(130,80,200,30,'Фон (график)');
Button(130,120,200,30,'Тон (график)');
Button(130,160,200,30,'Фон (координаты)');
Button(130,200,200,30,'Тон (координаты)');
Button(130,240,200,30,'Тон (коорд. оси)');
Button(130,280,200,30,'Стандартные цвета');
Button(130,320,200,30,'Ok');
Button(130,360,200,30,'Отмена');
for f:=1 to 5 do Colors(f);
Primer(340,280);
ShowMouse;
SizeMenu:=20;
for f:=0 to 15 do m[f+1]:=ColorsText[f];
vib:=7;
CaseSetup(vib,0);
Enter:=false;
repeat
repeat
GetMouseEvent(Ev);
if KeyPressed then
  begin
    h:=ReadKey;
    if h=#13 then Enter:=true;
    if h=#27 then
      begin
        Enter:=true;
        vib:=8
      end;
    if h=#0 then
      begin
        h:=ReadKey;
        if h=#80 then
          begin
            CaseSetup(vib,7);
            if vib=8 then vib:=1
                     else inc(vib);
            CaseSetup(vib,0)
          end;
        if h=#72 then
          begin
            CaseSetup(vib,7);
            if vib=1 then vib:=8
                     else dec(vib);
            CaseSetup(vib,0)
          end;
      end;
  end;
until ((Ev.What=evMouseDown) and (Ev.Buttons=mbLeftButton)) or Enter;
    MouseX:=CMouseX;
    MouseY:=CMouseY;
    if ((MouseX>=130) and (MouseX<=330) and (MouseY>=80) and (MouseY<=110)) or ((vib=1) and Enter) then
      begin
        HideMouse;
        PushButton(130,80,200,30,'Фон (график)');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(130,80,200,30,'Фон (график)');
        ShowMouse;
        Delay(2*PushButtonDelay);
        f:=Menus(220,100,120,170,m,8);
        if f<>0 then FonGr:=f-1;
        MouseX:=0;
        Colors(1);
        Primer(340,280);
        CaseSetup(vib,0)
      end;
    if ((MouseX>=130) and (MouseX<=330) and (MouseY>=120) and (MouseY<=150)) or ((vib=2) and Enter) then
      begin
        HideMouse;
        PushButton(130,120,200,30,'Тон (график)');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(130,120,200,30,'Тон (график)');
        ShowMouse;
        Delay(2*PushButtonDelay);
        f:=Menus(220,100,120,330,m,16);
        if f<>0 then TonGr:=f-1;
        MouseX:=0;
        Colors(2);
        Primer(340,280);
        CaseSetup(vib,0)
      end;
    if ((MouseX>=130) and (MouseX<=330) and (MouseY>=160) and (MouseY<=190)) or ((vib=3) and Enter) then
      begin
        HideMouse;
        PushButton(130,160,200,30,'Фон (координаты)');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(130,160,200,30,'Фон (координаты)');
        ShowMouse;
        Delay(2*PushButtonDelay);
        f:=Menus(220,100,120,170,m,8);
        if f<>0 then FonPoi:=f-1;
        MouseX:=0;
        Colors(3);
        Primer(340,280);
        CaseSetup(vib,0)
      end;
    if ((MouseX>=130) and (MouseX<=330) and (MouseY>=200) and (MouseY<=230)) or ((vib=4) and Enter) then
      begin
        HideMouse;
        PushButton(130,200,200,30,'Тон (координаты)');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(130,200,200,30,'Тон (координаты)');
        ShowMouse;
        Delay(2*PushButtonDelay);
        f:=Menus(220,100,120,330,m,16);
        if f<>0 then TonPoi:=f-1;
        MouseX:=0;
        Colors(4);
        Primer(340,280);
        CaseSetup(vib,0)
      end;
    if ((MouseX>=130) and (MouseX<=330) and (MouseY>=240) and (MouseY<=270)) or ((vib=5) and Enter) then
      begin
        HideMouse;
        PushButton(130,240,200,30,'Тон (коорд. оси)');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(130,240,200,30,'Тон (коорд. оси)');
        ShowMouse;
        Delay(2*PushButtonDelay);
        f:=Menus(220,100,120,330,m,16);
        if f<>0 then TonCoor:=f-1;
        MouseX:=0;
        Colors(5);
        Primer(340,280);
        CaseSetup(vib,0)
      end;
    if ((MouseX>=130) and (MouseX<=330) and (MouseY>=280) and (MouseY<=310)) or ((vib=6) and Enter) then
      begin
        HideMouse;
        PushButton(130,280,200,30,'Стандартные цвета');
        ShowMouse;
        Delay(PushButtonDelay);
        HideMouse;
        Button(130,280,200,30,'Стандартные цвета');
        ShowMouse;
        Delay(2*PushButtonDelay);
        MouseX:=0;
        FonGr:=7;
        TonGr:=9;
        FonPoi:=7;
        TonPoi:=0;
        TonCoor:=0;
        for f:=1 to 5 do Colors(f);
        Primer(340,280);
        Enter:=false;
        CaseSetup(vib,0)
      end;
until (((MouseX>=130) and (MouseX<=330) and (MouseY>=320) and (MouseY<=350))
      OR ((MouseX>=130) and (MouseX<=330) and (MouseY>=360) and (MouseY<=390)))
      or ((vib in [7,8]) and Enter);
if ((MouseX>=130) and (MouseX<=330) and (MouseY>=320) and (MouseY<=350)) or ((vib=7) and Enter) then
  begin
    HideMouse;
    PushButton(130,320,200,30,'Ok');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(130,320,200,30,'Ok');
    ShowMouse;
    Delay(2*PushButtonDelay);
    PixelBKColor:=FonGr;
    PixelColor:=TonGr;
    PointsBKColor:=FonPoi;
    PointsColor:=TonPoi;
    LineColor:=TonCoor;
    Rewrite(SetupFile);
    writeln(SetupFile,#2+'Setup'+#2+'239');
    writeln(SetupFile,PixelBKColor);
    writeln(SetupFile,PixelColor);
    writeln(SetupFile,PointsBKColor);
    writeln(SetupFile,PointsColor);
    writeln(SetupFile,LineColor);
    if Coor then writeln(SetupFile,'1')
            else writeln(SetupFile,'0');
    if Points then writeln(SetupFile,'1')
              else writeln(SetupFile,'0');
    Close(SetupFile)
  end
                    else
  begin
    HideMouse;
    PushButton(130,360,200,30,'Отмена');
    ShowMouse;
    Delay(PushButtonDelay);
    HideMouse;
    Button(130,360,200,30,'Отмена');
    ShowMouse;
    Delay(2*PushButtonDelay)
  end;
HideMouse;
PutImage(120,75,PSpaceSetup^,0);
ShowMouse;
Size:=ImageSize(120,75,520,395);
FreeMem(PSpaceSetup,Size);
Enter:=false
end;

procedure CaseMain(cm,Color:Byte);
begin
if (cm in [1,2,3,4,5,6]) and (Color=7) then
  for ff:=6 to 11 do Vibors(ff,0);
ColorText:=Color;
case cm of
  1:if Color<>7 then
    begin
      ColorText:=0;
      Vibors(6,1)
    end;
  2:if Color<>7 then
    begin
      ColorText:=0;
      Vibors(7,1)
    end;
  3:if Color<>7 then
    begin
      ColorText:=0;
      Vibors(8,1)
    end;
  4:if Color<>7 then
    begin
      ColorText:=0;
      Vibors(9,1)
    end;
  5:if Color<>7 then
    begin
      ColorText:=0;
      Vibors(10,1)
    end;
  6:if Color<>7 then
    begin
      ColorText:=0;
      Vibors(11,1)
    end;
  7:ButtonSelect(10,207,125,30);
  8:ButtonSelect(135,207,125,30);
  9:ButtonSelect(10,247,220,30);
  10:if Color=7 then
       begin
         ButtonSelect(230,247,30,30);
         if PartOnOff[TekPart] then ButtonOn
                               else ButtonOff
       end
                else
       ButtonSelect(230,247,30,30);
  11:ButtonSelect(10,287,250,30);
  12:ButtonSelect(ScrollX,ScrollY,ScrollOX,ScrollOY);
  13:ButtonSelect(475,337,100,30)
end;
ColorText:=0
end;