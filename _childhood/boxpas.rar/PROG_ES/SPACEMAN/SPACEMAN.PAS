program Game_SpaceMan;
uses CGADrv, Graph, Crt;
const
     ManColor = 1;
     ManMove = 4;
     ManMoveUpDown = 2;
     ManJump = 12;
     SizeJump = 2;
     FireColor = 2;
     FireDelay = 1;
     BigGunDelay = 100;
     VragDelay = 37;
type
    MovesType = (Auto,Up,Down);
    JumpType = (Autos,Left,Rigth);
var
   Zone:array[1..99] of
     record
       Block:array[1..10,1..12] of 0..17;
       VragTotal:0..4;
       Vrag:array[1..4] of
         record
           X,Y:integer;
           Fazas,Gos:byte;
           X1,X2:integer
         end;
       Laser:boolean;
       LaserX,LaserY:integer;
       LaserSize:byte;
       LaserTime:word;
       BigGun:boolean;
       BigGunX,BigGunY:integer;
       BigGunEW:1..2;
       Computer:boolean;
       ComX,ComY:integer;
       ComMsg:string
     end;
   BigGunTime:word;
   VragN:byte;
   VragTime:word;
   Poi:array[0..240] of 0..3;
   TekZone:byte;
   ManX,ManY,F,L,D,Err,Driver,Mode,Faza,Go:Integer;
   Moves:MovesType;
   Jump:JumpType;
   H:Char;
   UpDown:byte;
   Point:array[1..23,1..68] of boolean;
   P:Pointer;
   fil:text;
   Size,SizeManSpace:Word;
   ManSpace:Pointer;
   PLand,PBoxes,PComputer,PCrystal,PGlaza,PNLO,
   PPlanet,PRaket,PShar,PTeleport,PZone,PBigGun,
   PPatroni,PEnergy,PPotolok,PStena,PCocon:Pointer;
   BLand,BBoxes,BComputer,BCrystal,BGlaza,BNLO,
   BPlanet,BRaket,BShar,BTeleport,BZone,BBigGun,
   BPatroni,BEnergy,BPotolok,BStena,BCocon:Boolean;
procedure vrag1(x,y,c,faz,goo:integer);
var col:byte;
begin
if c=1 then col:=1 else col:=0;
setcolor(col);
if goo=1 then begin
rectangle(x+2,y,x+4,y+1);
putpixel(x+5,y+1,col);
putpixel(x+3,y+2,col);
rectangle(x,y+3,x+2,y+4);
line(x+1,y+5,x+2,y+5);
line(x+3,y+4,x+5,y+4);
line(x+5,y+3,x+8,y+3);
putpixel(x+7,y+2,col);
if faz=1 then
        begin
         line(x+1,y+6,x+1,y+7);
         line(x+4,y+7,x+4,y+8);
         putpixel(x,y+8,col);
         putpixel(x+3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x+1,y+6,x+1,y+8);
         line(x+3,y+7,x+3,y+8);
         putpixel(x+2,y+6,col)
        end;
      if faz=3 then rectangle(x+1,y+6,x+2,y+8)
              end;
if goo=2 then begin
rectangle(x-2,y,x-4,y+1);
putpixel(x-5,y+1,col);
putpixel(x-3,y+2,col);
rectangle(x,y+3,x-2,y+4);
line(x-1,y+5,x-2,y+5);
line(x-3,y+4,x-5,y+4);
line(x-5,y+3,x-8,y+3);
putpixel(x-7,y+2,col);
if faz=1 then
        begin
         line(x-1,y+6,x-1,y+7);
         line(x-4,y+7,x-4,y+8);
         putpixel(x,y+8,col);
         putpixel(x-3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x-1,y+6,x-1,y+8);
         line(x-3,y+7,x-3,y+8);
         putpixel(x-2,y+6,col)
        end;
      if faz=3 then rectangle(x-1,y+6,x-2,y+8)
              end;
end;

procedure man(x,y,c,faz,goo:integer);
var col:byte;
begin
 if c=1 then col:=ManColor else col:=0;
 setcolor(col);
 if goo=1 then
    begin
      rectangle(x+3,y,x+4,y+1);
      putpixel(x+5,y+1,col);
      putpixel(x+3,y+2,col);
      rectangle(x+1,y+3,x+2,y+5);
      line(x+3,y+4,x+4,y+4);
      line(x+5,y+5,x+5,y+3);
      line(x+6,y+3,x+8,y+3);
      if faz=1 then
        begin
         line(x+1,y+6,x+1,y+7);
         line(x+4,y+7,x+4,y+8);
         putpixel(x,y+8,col);
         putpixel(x+3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x+1,y+6,x+1,y+8);
         line(x+3,y+7,x+3,y+8);
         putpixel(x+2,y+6,col)
        end;
      if faz=3 then rectangle(x+1,y+6,x+2,y+8)
    end;
if goo=2 then
    begin
      rectangle(x-3,y,x-4,y+1);
      putpixel(x-5,y+1,col);
      putpixel(x-3,y+2,col);
      rectangle(x-1,y+3,x-2,y+5);
      line(x-3,y+4,x-4,y+4);
      line(x-5,y+5,x-5,y+3);
      line(x-6,y+3,x-8,y+3);
      if faz=1 then
        begin
         line(x-1,y+6,x-1,y+7);
         line(x-4,y+7,x-4,y+8);
         putpixel(x,y+8,col);
         putpixel(x-3,y+6,col)
        end;
      if (faz=2) or (faz=4) then
        begin
         line(x-1,y+6,x-1,y+8);
         line(x-3,y+7,x-3,y+8);
         putpixel(x-2,y+6,col)
        end;
      if faz=3 then rectangle(x-1,y+6,x-2,y+8)
    end;
end;
procedure JumpMan(x,y,c,goo:integer);
var col:byte;
begin
if c=1 then col:=ManColor else col:=0;
SetColor(col);
if goo=1 then
  begin
    Rectangle(x+4,y,x+5,y+1);
    PutPixel(x+6,y+1,col);
    PutPixel(x+4,y+2,col);
    Line(x,y+2,x,y+3);
    Rectangle(x+3,y+3,x+4,y+5);
    Line(x+1,y+4,x+2,y+4);
    Line(x+5,y+4,x+6,y+4);
    PutPixel(x+7,y+3,col);
    Line(x+3,y+6,x+3,y+7);
    PutPixel(x+2,y+8,col);
    PutPixel(x+5,y+6,col);
    Line(x+6,y+7,x+6,y+8)
  end;
if goo=2 then
  begin
    Rectangle(x-4,y,x-5,y+1);
    PutPixel(x-6,y+1,col);
    PutPixel(x-4,y+2,col);
    Line(x,y+2,x,y+3);
    Rectangle(x-3,y+3,x-4,y+5);
    Line(x-1,y+4,x-2,y+4);
    Line(x-5,y+4,x-6,y+4);
    PutPixel(x-7,y+3,col);
    Line(x-3,y+6,x-3,y+7);
    PutPixel(x-2,y+8,col);
    PutPixel(x-5,y+6,col);
    Line(x-6,y+7,x-6,y+8)
  end
end;
procedure FireSound;
var F:integer;
begin
for f:= 1 to 10 do
  begin
    sound(2000+f*4);
    delay(1);
    nosound
  end;
end;
procedure FireMan(x,y,c,goo:integer);
var col:byte;
begin
 if c=1 then col:=ManColor else col:=0;
 setcolor(col);
 if goo=1 then
  begin
   rectangle(x-2,y,x-1,y+1);
   putpixel(x,y+1,col);
   putpixel(x-2,y+2,col);
   rectangle(x-1,y+3,x,y+5);
   line(x+1,y+3,x+2,y+3);
   line(x+3,y+2,x+3,y+4);
   line(x+4,y+2,x+6,y+2);
   line(x-1,y+6,x+1,y+8);
   line(x+1,y+6,x+2,y+6);
   putpixel(x+3,y+7,col)
  end;
 if goo=2 then
  begin
   rectangle(x+2,y,x+1,y+1);
   putpixel(x,y+1,col);
   putpixel(x+2,y+2,col);
   rectangle(x+1,y+3,x,y+5);
   line(x-1,y+3,x-2,y+3);
   line(x-3,y+2,x-3,y+4);
   line(x-4,y+2,x-6,y+2);
   line(x+1,y+6,x-1,y+8);
   line(x-1,y+6,x-2,y+6);
   putpixel(x-3,y+7,col)
  end;
end;
procedure FileKorabl;
var
   fil:text;
   g:integer;
begin
assign(fil,'korabl.stu');
reset(fil);
for f:=1 to 13 do
 for d:=1 to 68 do
  begin
   read(fil,h);read(fil,h);
   val(h,g,err);
   if g=1 then point[f,d]:=true
          else point[f,d]:=false;
   if d=68 then readln(fil)
  end;
close(fil)
end;
procedure FileCosmic;
var
   fil:text;
   g:integer;
begin
assign(fil,'cosmic.stu');
reset(fil);
for f:=1 to 23 do
 for d:=1 to 68 do
  begin
   read(fil,h);read(fil,h);
   val(h,g,err);
   if g=1 then point[f,d]:=true
          else point[f,d]:=false;
   if d=68 then readln(fil)
  end;
close(fil)
end;
procedure Cosmic(x,y,c:integer);
var col:byte;
begin
if c=1 then col:=1 else col:=0;
setcolor(col);
for f:=1 to 23 do
 for d:=1 to 68 do
   if point[f,d]=true then putpixel(d+x,y+f,col);
end;
procedure Kor(x,y,c:integer);
var
   g:integer;
   col:byte;
begin
 if c=1 then col:=1 else col:=0;
 setcolor(col);
 for g:=1 to 13 do
  for d:=1 to 68 do if point[g,d]=true then putpixel(x+d,y+g,col)
end;
procedure Cls(x,y:integer);
begin
setcolor(0);
for d:=1 to 14 do line(x,y-1+d,x+68,y-1+d)
end;
procedure ReadFile(FileName:string);
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
      if p=1 then Point[l,f]:=true
             else Point[l,f]:=false
    end;
Close(fil)
end;
procedure WriteBlock(x,y:integer;Col:byte);
var f,l:byte;
begin
for l:=1 to 20 do
  for f:=1 to 20 do
    if Point[l,f] then PutPixel(x+f-1,y+l-1,col)
end;
procedure WriteZone(Z:byte);
var F,L,FF,LL,Col:byte;
    Yes:Boolean;
begin
ClearDevice;
for L:=1 to 10 do
  for F:=1 to 12 do
    begin
      Yes:=false;
      case Zone[Z].Block[L,F] of
        1:if not BLand then begin ReadFile('land');Col:=1;Yes:=true end;
        2:if not BBoxes then begin ReadFile('boxes');Col:=3;Yes:=true end;
        3:if not BComputer then begin ReadFile('computer');Col:=3;Yes:=true end;
        4:if not BCrystal then begin ReadFile('crystal');Col:=2;Yes:=true end;
        5:if not BGlaza then begin ReadFile('glaza');Col:=2;Yes:=true end;
        6:if not BNLO then begin ReadFile('nlo');Col:=3;Yes:=true end;
        7:if not BPlanet then begin ReadFile('planet');Col:=2;Yes:=true end;
        8:if not BRaket then begin ReadFile('raket');Col:=3;Yes:=true end;
        9:if not BShar then begin ReadFile('shar');Col:=2;Yes:=true end;
       10:if not BTeleport then begin ReadFile('teleport');Col:=3;Yes:=true end;
       11:if not BZone then begin ReadFile('zone');Col:=3;Yes:=true end;
       12:if not BBigGun then begin ReadFile('biggun');Col:=3;Yes:=true end;
       13:if not BPatroni then begin ReadFile('patroni');Col:=3;Yes:=true end;
       14:if not BEnergy then begin ReadFile('energy');Col:=3;Yes:=true end;
       15:if not BPotolok then begin ReadFile('potolok');Col:=1;Yes:=true end;
       16:if not BStena then begin ReadFile('stena');Col:=3;Yes:=true end;
       17:if not BCocon then begin ReadFile('cocon');Col:=2;Yes:=true end;
      end;
      if (Zone[Z].Block[L,F]<>0) and not Yes then
        case Zone[Z].Block[L,F] of
        1:PutImage(F*20-20,L*20-20,PLand^,0);
        2:PutImage(F*20-20,L*20-20,PBoxes^,0);
        3:PutImage(F*20-20,L*20-20,PComputer^,0);
        4:PutImage(F*20-20,L*20-20,PCrystal^,0);
        5:PutImage(F*20-20,L*20-20,PGlaza^,0);
        6:PutImage(F*20-20,L*20-20,PNLO^,0);
        7:PutImage(F*20-20,L*20-20,PPlanet^,0);
        8:PutImage(F*20-20,L*20-20,PRaket^,0);
        9:PutImage(F*20-20,L*20-20,PShar^,0);
        10:PutImage(F*20-20,L*20-20,PTeleport^,0);
        11:PutImage(F*20-20,L*20-20,PZone^,0);
        12:PutImage(F*20-20,L*20-20,PBigGun^,0);
        13:PutImage(F*20-20,L*20-20,PPatroni^,0);
        14:PutImage(F*20-20,L*20-20,PEnergy^,0);
        15:PutImage(F*20-20,L*20-20,PPotolok^,0);
        16:PutImage(F*20-20,L*20-20,PStena^,0);
        17:PutImage(F*20-20,L*20-20,PCocon^,0);
        end;
      if (Zone[Z].Block[L,F]<>0) and Yes then
      for LL:=1 to 20 do
        for FF:=1 to 20 do
            if Point[LL,FF] then PutPixel(F*20-20+FF,L*20-20+LL,Col);
      if Yes then
          case Zone[Z].Block[L,F] of
          1:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PLand,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PLand^);
              BLand:=true
            end;
          2:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PBoxes,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PBoxes^);
              BBoxes:=true
            end;
          3:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PComputer,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PComputer^);
              BComputer:=true
            end;
          4:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PCrystal,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PCrystal^);
              BCrystal:=true
            end;
          5:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PGlaza,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PGlaza^);
              BGlaza:=true
            end;
          6:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PNLO,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PNLO^);
              BNLO:=true
            end;
          7:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PPlanet,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PPlanet^);
              BPlanet:=true
            end;
          8:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PRaket,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PRaket^);
              BRaket:=true
            end;
          9:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PShar,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PShar^);
              BShar:=true
            end;
         10:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PTeleport,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PTeleport^);
              BTeleport:=true
            end;
         11:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PZone,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PZone^);
              BZone:=true
            end;
         12:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PBigGun,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PBigGun^);
              BBigGun:=true
            end;
         13:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PPatroni,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PPatroni^);
              BPatroni:=true
            end;
         14:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PEnergy,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PEnergy^);
              BEnergy:=true
            end;
         15:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PPotolok,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PPotolok^);
              BPotolok:=true
            end;
         16:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PStena,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PStena^);
              BStena:=true
            end;
         17:begin
              Size:=ImageSize(F*20-20,L*20-20,F*20,L*20);
              GetMem(PCocon,Size);
              GetImage(F*20-20,L*20-20,F*20,L*20,PCocon^);
              BCocon:=true
            end;
        end;
    end;
end;
procedure Tamojna;
begin
if (Go=1) and (GetPixel(ManX,ManY+9)=0) and (GetPixel(ManX+4,ManY+9)=0) then Moves:=Down;
if (Go=2) and (GetPixel(ManX,ManY+9)=0) and (GetPixel(ManX-4,ManY+9)=0) then Moves:=Down;
end;
procedure ReadManSpace;
begin
if Go=1 then GetImage(ManX-2,ManY,ManX+8,ManY+8,ManSpace^);
if Go=2 then GetImage(ManX-8,ManY,ManX+2,ManY+8,ManSpace^)
end;
procedure WriteManSpace;
begin
if (Moves=Auto) and (h=' ') then FireMan(ManX,ManY,0,Go);
if (Moves=Auto) and (h<>' ') then Man(ManX,ManY,0,Faza,Go);
if Moves<>Auto then JumpMan(ManX,ManY,0,Go);
if Go=1 then PutImage(ManX-2,ManY,ManSpace^,0);
if Go=2 then PutImage(ManX-8,ManY,ManSpace^,0)
end;
procedure ReadZone(NomerZone:byte);
var s:string;
begin
str(NomerZone,s);
if NomerZone<10 then s:='zone0'+s[1]+'.smc'
                else s:='zone'+s[1]+s[2]+'.smc';
Assign(fil,s);
Reset(fil);
Readln(fil,h);
for l:=1 to 10 do
  for f:=1 to 12 do readln(fil,Zone[NomerZone].Block[l,f]);
Readln(fil,Zone[NomerZone].VragTotal);
for d:=1 to Zone[NomerZone].VragTotal do
  begin
    readln(fil,Zone[NomerZone].Vrag[d].X);
    readln(fil,Zone[NomerZone].Vrag[d].Y);
    readln(fil,Zone[NomerZone].Vrag[d].Fazas);
    readln(fil,Zone[NomerZone].Vrag[d].Gos);
    readln(fil,Zone[NomerZone].Vrag[d].X1);
    readln(fil,Zone[NomerZone].Vrag[d].X2)
  end;
readln(fil,h);
if h='1' then Zone[NomerZone].Laser:=true
         else Zone[NomerZone].Laser:=false;
if Zone[NomerZone].Laser then
  begin
    readln(fil,Zone[NomerZone].LaserX);
    readln(fil,Zone[NomerZone].LaserY);
    readln(fil,Zone[NomerZone].LaserSize);
    readln(fil,Zone[NomerZone].LaserTime)
  end;
readln(fil,h);
if h='1' then Zone[NomerZone].BigGun:=true
         else Zone[NomerZone].BigGun:=false;
if Zone[NomerZone].BigGun then
  begin
    readln(fil,Zone[NomerZone].BigGunX);
    readln(fil,Zone[NomerZone].BigGunY);
    readln(fil,Zone[NomerZone].BigGunEW)
  end;
readln(fil,h);
if h='1' then Zone[NomerZone].Computer:=true
         else Zone[NomerZone].Computer:=false;
if Zone[NomerZone].Computer then
  begin
    readln(fil,Zone[NomerZone].ComX);
    readln(fil,Zone[NomerZone].ComY);
    readln(fil,h);
    readln(fil,Zone[NomerZone].ComMsg)
  end;
Close(fil)
end;


begin
for ManX:=1 to 2 do ReadZone(ManX);
BLand:=false;
BBoxes:=false;
BComputer:=false;
BCrystal:=false;
BGlaza:=false;
BNLO:=false;
BPlanet:=false;
BRaket:=false;
BShar:=false;
BTeleport:=false;
BZone:=false;
BBigGun:=false;
BPatroni:=false;
BEnergy:=false;
BPotolok:=false;
BStena:=false;
BCocon:=false;

Driver:=Detect;
InitGraph(Driver,Mode,'');
Err:=GraphResult;
if Err<>grOk then
  begin
    Writeln(GraphErrorMsg(Err));
    Halt
  end;
SetGraphMode(1);
{}{}{}{}{}
ManX:=34;ManY:=72;Faza:=1;Go:=1;
BigGunTime:=0;
TekZone:=2;
SizeManSpace:=ImageSize(ManX-2,ManY,ManX+8,ManY+8);
GetMem(ManSpace,SizeManSpace);
ReadManSpace;
WriteZone(TekZone);
{}{}{}{}{}
FileKorabl;
kor(20,0,1);
Size:=ImageSize(20,0,88,13);
GetMem(p,Size);
GetImage(20,0,88,13,p^);
for f:=1 to 50 do
  begin
    Cls(20,f);
    PutImage(20,f,p^,1)
  end;
SetColor(1);
for f:=64 to 80 do begin line(27,f,47,f);delay(25) end;
for f:=80 downto 64 do
  begin
    SetColor(0);
    Line(27,f,47,f);
    SetColor(1);
    Man(ManX,ManY,1,Faza,Go);
    delay(25)
  end;
for f:=50 downto 0 do
  begin
    PutImage(20,f,p^,1);
    Cls(20,f)
  end;
{}{}{}{}{}{}{}{}{}{}
Moves:=Auto;
VragN:=1;
VragTime:=0;
{}{}{}{}{}{}{}{}{}{}
repeat
repeat
if Zone[TekZone].VragTotal<>0 then
  begin
    Vrag1(Zone[TekZone].Vrag[VragN].X,Zone[TekZone].Vrag[VragN].Y,0,Zone[TekZone].Vrag[VragN].Fazas,
          Zone[TekZone].Vrag[VragN].Gos);
    if Zone[TekZone].Vrag[VragN].Gos=1 then Zone[TekZone].Vrag[VragN].X:=Zone[TekZone].Vrag[VragN].X+1
                                       else Zone[TekZone].Vrag[VragN].X:=Zone[TekZone].Vrag[VragN].X-1;
    Zone[TekZone].Vrag[VragN].Fazas:=Zone[TekZone].Vrag[VragN].Fazas+1;
    if Zone[TekZone].Vrag[VragN].Fazas=5 then Zone[TekZone].Vrag[VragN].Fazas:=1;
    if (Zone[TekZone].Vrag[VragN].X=Zone[TekZone].Vrag[VragN].X1) or
       (Zone[TekZone].Vrag[VragN].X=Zone[TekZone].Vrag[VragN].X2) then
          if Zone[TekZone].Vrag[VragN].Gos=1 then Zone[TekZone].Vrag[VragN].Gos:=2
                                             else Zone[TekZone].Vrag[VragN].Gos:=1;
    Vrag1(Zone[TekZone].Vrag[VragN].X,Zone[TekZone].Vrag[VragN].Y,1,Zone[TekZone].Vrag[VragN].Fazas,
          Zone[TekZone].Vrag[VragN].Gos);
    VragN:=VragN+1;
    if VragN=Zone[TekZone].VragTotal+1 then VragN:=1;
    if (ManY=Zone[TekZone].Vrag[VragN].Y) then VragTime:=VragTime+1;
    if VragTime=VragDelay then
      begin
        Sound(2000);
        Delay(5);
        NoSound;
        VragTime:=0;
        if Zone[TekZone].Vrag[VragN].Gos=1 then
          begin
            f:=239;
            for d:=Zone[TekZone].Vrag[VragN].X+9 to 239 do
             begin
                l:=GetPixel(d,Zone[TekZone].Vrag[VragN].Y+3);
                poi[d]:=l;
                PutPixel(d,Zone[TekZone].Vrag[VragN].Y+3,2);
                if l=1 then begin f:=d;d:=239 end
              end;
              for d:=Zone[TekZone].Vrag[VragN].X+9 to f do PutPixel(d,Zone[TekZone].Vrag[VragN].Y+3,poi[d])
          end;
        if Zone[TekZone].Vrag[VragN].Gos=2 then
          begin
            f:=0;
            for d:=Zone[TekZone].Vrag[VragN].X-9 downto 0 do
             begin
                l:=GetPixel(d,Zone[TekZone].Vrag[VragN].Y+3);
                poi[d]:=l;
                PutPixel(d,Zone[TekZone].Vrag[VragN].Y+3,2);
                if l=1 then begin f:=d;d:=0 end
              end;
              for d:=Zone[TekZone].Vrag[VragN].X-9 downto f do PutPixel(d,Zone[TekZone].Vrag[VragN].Y+3,poi[d])
          end
      end
  end;
if Zone[TekZone].BigGun then
  begin
    BigGunTime:=BigGunTime+1;
    if BigGunTime=BigGunDelay then
      begin
        Sound(2000);
        Delay(5);
        NoSound;
        BigGunTime:=0;
        if Zone[TekZone].BigGunEW=2 then
          begin
            f:=0;
            for d:=Zone[TekZone].BigGunX downto 0 do
              begin
                l:=GetPixel(d,Zone[TekZone].BigGunY);
                poi[d]:=l;
                PutPixel(d,Zone[TekZone].BigGunY,2);
                if l=1 then begin f:=d;d:=0 end
              end;
            for d:=Zone[TekZone].BigGunX downto f do PutPixel(d,Zone[TekZone].BigGunY,poi[d]);
          end;
        if Zone[TekZone].BigGunEW=1 then
          begin
            f:=239;
            for d:=Zone[TekZone].BigGunX to 239 do
              begin
                l:=GetPixel(d,Zone[TekZone].BigGunY);
                poi[d]:=l;
                PutPixel(d,Zone[TekZone].BigGunY,2);
                if l=1 then begin f:=d;d:=239 end
              end;
            for d:=Zone[TekZone].BigGunX to f do PutPixel(d,Zone[TekZone].BigGunY,poi[d]);
          end;
      end;
  end;
if (Moves=Up) and (UpDown<>0) then
  begin
    if UpDown=ManJump then Man(ManX,ManY,0,Faza,Go);
    WriteManSpace;
    ManY:=ManY-SizeJump;
    case Jump of
      Left:if (GetPixel(ManX-7-ManMoveUpDown,ManY)<>1) and (GetPixel(ManX-7-ManMoveUpDown,ManY+8)<>1) then
       begin ManX:=ManX-ManMoveUpDown;Go:=2 end;
      Rigth:if (GetPixel(ManX+7+ManMoveUpDown,ManY)<>1) and (GetPixel(ManX+7+ManMoveUpDown,ManY+8)<>1) then
       begin ManX:=ManX+ManMoveUpDown;Go:=1 end
    end;
    ReadManSpace;
    JumpMan(ManX,ManY,1,Go);
    UpDown:=UpDown-1;
    if UpDown=0 then Moves:=Down;
  end;
if Moves=Down then
  begin
    Man(ManX,ManY,0,Faza,Go);
    WriteManSpace;
    ManY:=ManY+SizeJump;
    case Jump of
      Left:if (GetPixel(ManX-7-ManMoveUpDown,ManY)<>1) and (GetPixel(ManX-7-ManMoveUpDown,ManY+8)<>1) then
       begin ManX:=ManX-ManMoveUpDown;Go:=2 end
         else Jump:=Autos;
      Rigth:if (GetPixel(ManX+7+ManMoveUpDown,ManY)<>1) and (GetPixel(ManX+7+ManMoveUpDown,ManY+8)<>1) then
       begin ManX:=ManX+ManMoveUpDown;Go:=1 end
         else Jump:=Autos
    end;
    ReadManSpace;
    JumpMan(ManX,ManY,1,Go);
    if ((Go=1) and (GetPixel(ManX,ManY+9)=1) and (GetPixel(ManX+4,ManY+9)=1))
       or ((Go=2) and (GetPixel(ManX,ManY+9)=1) and (GetPixel(ManX-4,ManY+9)=1)){)} then
      begin
        WriteManSpace;
        Man(ManX,ManY,1,Faza,Go);
        Moves:=Auto;
        Jump:=Autos
      end
  end;
until KeyPressed;
h:=ReadKey;
if h=' ' then
  begin
    Man(ManX,ManY,0,Faza,Go);
    WriteManSpace;
    FireMan(ManX,ManY,1,Go);
    FireSound;
    if Go=1 then
    for F:=ManX+7 to ManX+107 do
      begin
        PutPixel(F,ManY+2,FireColor);
        Delay(FireDelay);
        PutPixel(F,ManY+2,0);
      end;
    if Go=2 then
    for F:=ManX-7 downto ManX-107 do
      begin
        PutPixel(F,ManY+2,FireColor);
        Delay(FireDelay);
        PutPixel(F,ManY+2,0);
      end;
    WriteManSpace;
    Man(ManX,ManY,1,Faza,Go)
  end;
if h=#0 then
  begin
    h:=ReadKey;
    if (h=#72) and (Moves=Auto) then
      begin
        Moves:=Up;
        UpDown:=ManJump;
        Jump:=Autos
      end;
    if (h=#77) and (Moves<>Auto) then Jump:=Rigth;
    if (h=#77) and (Moves=Auto)  then
      begin
       if ((Go=1) and (GetPixel(ManX+8+ManMove,ManY+3)<>1)) OR ((Go=2) and (GetPixel(ManX+ManMove,ManY+3)<>1)) then
       begin
        WriteManSpace;
        Faza:=Faza+1;
        if Faza=5 then Faza:=1;
        if Go=1 then ManX:=ManX+ManMove;
        Go:=1;
        if (ManX+8)>237 then
          begin
            TekZone:=TekZone+1;
            WriteZone(TekZone);
            ManX:=0;
            VragTime:=0;
            BigGunTime:=0;
            ReadManSpace
          end;
        ReadManSpace;
        Man(ManX,ManY,1,Faza,Go);
        Tamojna
       end
      end;
    if (h=#75) and (Moves<>Auto) then Jump:=Left;
    if (h=#75) and (Moves=Auto) then
      begin
       if ((Go=2) and (GetPixel(ManX-8-ManMove,ManY+3)<>1)) OR ((Go=1) and (GetPixel(ManX-ManMove,ManY+3)<>1)) then
       begin
        WriteManSpace;
        Faza:=Faza+1;
        if Faza=5 then Faza:=1;
        if Go=2 then ManX:=ManX-ManMove;
        Go:=2;
        if (ManX-8)<0 then
          begin
            TekZone:=TekZone-1;
            WriteZone(TekZone);
            ManX:=230;
            VragTime:=0;
            BigGunTime:=0;
            ReadManSpace
          end;
        ReadManSpace;
        Man(ManX,ManY,1,Faza,Go);
        Tamojna
       end
      end;
  end; {if h=#0}
until h=#27;
CloseGraph;
end.