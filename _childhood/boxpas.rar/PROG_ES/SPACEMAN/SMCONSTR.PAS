uses Crt, Dos, CGADrv, Graph;
Label Start;
var
    Block:array[1..10,1..12] of 0..30;
    Point:array[1..23,1..68] of Boolean;
    Tek,Driver,Mode,Err,D,F,L:integer;
    PLand,PBoxes,PComputer,PCrystal,PGlaza,PNLO,
    PPlanet,PRaket,PShar,PTeleport,PZone,PBigGun,
    PPatroni,PEnergy,PPotolok,PStena,PCocon:Pointer;
    s:string;
    fil:text;
    Size:Word;
    VragTotal,Col,R,T:byte;
    Vrag:array[1..4] of record
        X,Y,X1,X2:integer;
        Fazas,Gos:byte;
      end;
    Laser:Boolean;
    LaserX,LaserY,LaserSize:integer;
    LaserTime:word;
    BigGun:Boolean;
    BigGunX,BigGunY:integer;
    BigGunEW:byte;
    Computer:Boolean;
    ComX,ComY:byte;
    ComMsg:string;
    H:Char;
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
procedure WriteBlock(x,y,b:integer);
begin
case b of
  1:PutImage(x,y,PLand^,0);
  2:PutImage(x,y,PBoxes^,0);
  3:PutImage(x,y,PComputer^,0);
  4:PutImage(x,y,PCrystal^,0);
  5:PutImage(x,y,PGlaza^,0);
  6:PutImage(x,y,PNLO^,0);
  7:PutImage(x,y,PPlanet^,0);
  8:PutImage(x,y,PRaket^,0);
  9:PutImage(x,y,PShar^,0);
  10:PutImage(x,y,PTeleport^,0);
  11:PutImage(x,y,PZone^,0);
  12:PutImage(x,y,PBigGun^,0);
  13:PutImage(x,y,PPatroni^,0);
  14:PutImage(x,y,PEnergy^,0);
  15:PutImage(x,y,PPotolok^,0);
  16:PutImage(x,y,PStena^,0);
  17:PutImage(x,y,PCocon^,0)
end
end;
procedure Window;
begin
SetColor(0);
for f:=0 to 199 do Line(240,f,319,f);
SetColor(2);
Rectangle(240,0,319,199);
WriteBlock(260,20,Tek);
SetColor(3);
case Tek of
  0:OutTextXY(245,50,'Space');
  1:OutTextXY(245,50,'Land');
  2:OutTextXY(245,50,'Boxes');
  3:OutTextXY(245,50,'Computer');
  4:OutTextXY(245,50,'Crystal');
  5:OutTextXY(245,50,'Glaza');
  6:OutTextXY(245,50,'NLO');
  7:OutTextXY(245,50,'Planet');
  8:OutTextXY(245,50,'Raket');
  9:OutTextXY(245,50,'Shar');
  10:OutTextXY(245,50,'Teleport');
  11:OutTextXY(245,50,'Zone');
  12:OutTextXY(245,50,'BigGun');
  13:OutTextXY(245,50,'Patroni');
  14:OutTextXY(245,50,'Energy');
  15:OutTextXY(245,50,'Potolok');
  16:OutTextXY(245,50,'Stena');
  17:OutTextXY(245,50,'Cocon')
end;
SetColor(1);
OutTextXY(245,80,'PgUp-ù');
OutTextXY(245,100,'PgDown-ø');
OutTextXY(245,120,'Esc-Exit');
OutTextXY(245,140,'F3-Load');
OutTextXY(245,160,'F2-Save');
OutTextXY(245,180,'F8-Clear');
end;

begin
Driver:=Detect;
InitGraph(Driver,Mode,'');
Err:=GraphResult;
if Err<>grOk then
  begin
    Writeln(GraphErrorMsg(Err));
    Halt
  end;
SetGraphMode(1);
Size:=ImageSize(0,0,19,19);
for D:=1 to 17 do
  begin
    ClearDevice;
    outtext('        Space Man Constructor');
    case d of
      1:GetMem(PLand,Size);
      2:GetMem(PBoxes,Size);
      3:GetMem(PComputer,Size);
      4:GetMem(PCrystal,Size);
      5:GetMem(PGlaza,Size);
      6:GetMem(PNLO,Size);
      7:GetMem(PPlanet,Size);
      8:GetMem(PRaket,Size);
      9:GetMem(PShar,Size);
      10:GetMem(PTeleport,Size);
      11:GetMem(PZone,Size);
      12:GetMem(PBigGun,Size);
      13:GetMem(PPatroni,Size);
      14:GetMem(PEnergy,Size);
      15:GetMem(PPotolok,Size);
      16:GetMem(PStena,Size);
      17:GetMem(PCocon,Size);
    end;
    case d of
      1:begin ReadFile('land');Col:=1 end;
      2:begin ReadFile('boxes');Col:=3 end;
      3:begin ReadFile('computer');Col:=3 end;
      4:begin ReadFile('crystal');Col:=2 end;
      5:begin ReadFile('glaza');Col:=2 end;
      6:begin ReadFile('nlo');Col:=3 end;
      7:begin ReadFile('planet');Col:=2 end;
      8:begin ReadFile('raket');Col:=3 end;
      9:begin ReadFile('shar');Col:=2 end;
      10:begin ReadFile('teleport');Col:=3 end;
      11:begin ReadFile('zone');Col:=3 end;
      12:begin ReadFile('biggun');Col:=3 end;
      13:begin ReadFile('patroni');Col:=3 end;
      14:begin ReadFile('energy');Col:=3 end;
      15:begin ReadFile('potolok');Col:=1 end;
      16:begin ReadFile('stena');Col:=3 end;
      17:begin ReadFile('cocon');Col:=2 end;
    end;
    for L:=1 to 20 do
      for F:=1 to 20 do
        if Point[L,F] then PutPixel(150+F-1,90+L-1,col);
    case d of
    1:GetImage(150,90,169,109,PLand^);
    2:GetImage(150,90,169,109,PBoxes^);
    3:GetImage(150,90,169,109,PComputer^);
    4:GetImage(150,90,169,109,PCrystal^);
    5:GetImage(150,90,169,109,PGlaza^);
    6:GetImage(150,90,169,109,PNLO^);
    7:GetImage(150,90,169,109,PPlanet^);
    8:GetImage(150,90,169,109,PRaket^);
    9:GetImage(150,90,169,109,PShar^);
    10:GetImage(150,90,169,109,PTeleport^);
    11:GetImage(150,90,169,109,PZone^);
    12:GetImage(150,90,169,109,PBigGun^);
    13:GetImage(150,90,169,109,PPatroni^);
    14:GetImage(150,90,169,109,PEnergy^);
    15:GetImage(150,90,169,109,PPotolok^);
    16:GetImage(150,90,169,109,PStena^);
    17:GetImage(150,90,169,109,PCocon^)
    end
  end;
  Start:
R:=1;T:=1;D:=1;Tek:=1;
ClearDevice;
Window;
for L:=1 to 10 do
  for F:=1 to 12 do Block[L,F]:=0;
repeat
repeat
D:=D+1;
if D=4 then D:=1;
SetColor(D);
Rectangle(R*20-20,T*20-20,R*20-1,T*20-1);
Delay(56);
until KeyPressed;
h:=ReadKey;
if h=' ' then
  begin
    Block[T,R]:=Tek;
    SetColor(0);
    for F:=T*20-20 to T*20-1 do Line(R*20-20,F,R*20-1,F);
    WriteBlock(R*20-20,T*20-20,Tek)
  end;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#66 then
      begin
        for L:=1 to 10 do
          for F:=1 to 12 do Block[L,F]:=0;
        ClearDevice;
        Window
      end;
    if h=#73 then
      begin
        Tek:=Tek+1;
        if Tek=18 then Tek:=0;
        Window
      end;
    if h=#81 then
      begin
        Tek:=Tek-1;
        if Tek=-1 then Tek:=17;
        Window
      end;
    if h=#60 then
      begin
        SetColor(0);
        for f:=0 to 199 do Line(240,f,319,f);
        SetColor(2);
        Rectangle(240,0,319,199);
        OutTextXY(245,2,'VragTotal');
        gotoxy(72,3);write('');
        Read(VragTotal);
        for f:=1 to VragTotal do
          begin
            SetColor(0);
            for l:=0 to 199 do Line(240,l,319,l);
            SetColor(2);
            Rectangle(240,0,319,199);
            Str(f,s);
            OutTextXY(245,2,'Vrag '+S);
            gotoxy(72,3);OutTextXY(245,17,'X=');
            Read(Vrag[f].X);
            gotoxy(72,5);OutTextXY(245,32,'Y=');
            Read(Vrag[f].Y);
            gotoxy(72,7);OutTextXY(245,47,'Faza=');
            Read(Vrag[f].Fazas);
            gotoxy(72,9);OutTextXY(245,62,'Go=');
            Read(Vrag[f].Gos);
            gotoxy(72,11);OutTextXY(245,77,'X1=');
            Read(Vrag[f].X1);
            gotoxy(72,13);OutTextXY(245,92,'X2=');
            Read(Vrag[f].X2);
          end;
        SetColor(0);
        for l:=0 to 199 do Line(240,l,319,l);
        SetColor(2);
        Rectangle(240,0,319,199);
        OutTextXY(245,2,'Laser:');
        gotoxy(72,3);OutTextXY(245,17,'?(0/1) ');
        Read(l);
        if l=1 then Laser:=true
               else Laser:=false;
        if Laser then
          begin
            SetColor(2);
            OutTextXY(245,32,'LasX=');
            gotoxy(72,5);read(LaserX);
            OutTextXY(245,47,'LasY=');
            gotoxy(72,7);read(LaserY);
            OutTextXY(245,62,'LSize=');
            gotoxy(72,9);read(LaserSize);
            OutTextXY(245,77,'LTime=');
            gotoxy(72,11);read(LaserTime);
          end;
        SetColor(0);
        for l:=0 to 199 do Line(240,l,319,l);
        SetColor(2);
        Rectangle(240,0,319,199);
        OutTextXY(245,2,'BigGun:');
        gotoxy(72,3);OutTextXY(245,17,'?(0/1) ');read(l);
        if l=1 then BigGun:=true
               else BigGun:=false;
        if BigGun then
          begin
            OutTextXY(245,32,'EW=');
            gotoxy(72,5);read(BigGunEW);
            for l:=1 to 10 do
              for f:=1 to 12 do
                if Block[l,f]=12 then
                  begin
                    BigGunY:=L*20-20+14;
                    if BigGunEW=1 then BigGunX:=R*20-1
                                  else BigGunX:=R*20-21;
                    f:=12;
                    l:=10
                  end;
          end;
        Computer:=false;
        for l:=1 to 10 do
          for f:=1 to 12 do
            if Block[l,f]=3 then
              begin
                Computer:=true;
                ComY:=l;
                ComX:=f;
                f:=12;
                l:=10;
              end;
        SetColor(0);
        for l:=0 to 199 do Line(240,l,319,l);
        SetColor(2);
        Rectangle(240,0,319,199);
        OutTextXY(245,2,'FileName:');
        gotoxy(72,3);
        OutTextXY(245,17,'zone');
        s:='zone';
        for l:=1 to 2 do
          begin
            h:=ReadKey;
            OutText(h);
            s:=s+h
          end;
        s:=s+'.smc';
        Assign(fil,s);
        Rewrite(fil);
        Writeln(fil,s);
        for l:=1 to 10 do
          for f:=1 to 12 do
            Writeln(fil,Block[l,f]);
        Writeln(fil,VragTotal);
        for d:=1 to VragTotal do
          begin
            Writeln(fil,Vrag[d].X);
            Writeln(fil,Vrag[d].Y);
            Writeln(fil,Vrag[d].Fazas);
            Writeln(fil,Vrag[d].Gos);
            Writeln(fil,Vrag[d].X1);
            Writeln(fil,Vrag[d].X2)
          end;
        if Laser then Writeln(fil,'1')
                 else Writeln(fil,'0');
        if Laser then
          begin
            Writeln(fil,LaserX);
            Writeln(fil,LaserY);
            Writeln(fil,LaserSize);
            Writeln(fil,LaserTime)
          end;
        if BigGun then Writeln(fil,'1')
                  else Writeln(fil,'0');
        if BigGun then
          begin
            Writeln(fil,BigGunX);
            Writeln(fil,BigGunY);
            Writeln(fil,BigGunEW)
          end;
        if Computer then Writeln(fil,'1')
                    else Writeln(fil,'0');
        if Computer then
          begin
            Writeln(fil,ComX);
            Writeln(fil,ComY);
            Writeln(fil,'Computer Message:')
          end;
        Close(fil);
        goto Start
      end;
    if h=#61 then
      begin
        SetColor(0);
        for l:=0 to 199 do Line(240,l,319,l);
        SetColor(2);
        Rectangle(240,0,319,199);
        OutTextXY(245,2,'FileName:');
        gotoxy(72,3);
        OutTextXY(245,17,'zone');
        s:='zone';
        for l:=1 to 2 do
          begin
            h:=ReadKey;
            OutText(h);
            s:=s+h
          end;
        s:=s+'.smc';
        Assign(fil,s);
        Reset(fil);
        Readln(fil,h);
        for l:=1 to 10 do
          for f:=1 to 12 do Readln(fil,Block[l,f]);
        Close(fil);
        for l:=1 to 10 do
          for f:=1 to 12 do WriteBlock(f*20-20,l*20-20,Block[l,f])
      end;
    if (h=#72) and (T<>1) then
      begin
        SetColor(0);
        Rectangle(R*20-20,T*20-20,R*20-1,T*20-1);
        WriteBlock(R*20-20,T*20-20,Block[T,R]);
        T:=T-1
      end;
    if (h=#80) and (T<>10) then
      begin
        SetColor(0);
        Rectangle(R*20-20,T*20-20,R*20-1,T*20-1);
        WriteBlock(R*20-20,T*20-20,Block[T,R]);
        T:=T+1
      end;
    if (h=#75) and (R<>1) then
      begin
        SetColor(0);
        Rectangle(R*20-20,T*20-20,R*20-1,T*20-1);
        WriteBlock(R*20-20,T*20-20,Block[T,R]);
        R:=R-1
      end;
    if (h=#77) and (R<>12) then
      begin
        SetColor(0);
        Rectangle(R*20-20,T*20-20,R*20-1,T*20-1);
        WriteBlock(R*20-20,T*20-20,Block[T,R]);
        R:=R+1
      end;
  end;{h=#0}
until h=#27;
CloseGraph
end.