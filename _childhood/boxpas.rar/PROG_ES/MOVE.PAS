{ 30720,0,65000}
uses Dos, Crt;
const
     ZoneMaxY = 20;
     ZoneMaxX = 30;
     ZoneSize = ZoneMaxY*ZoneMaxX;
     ZoneSpace = [0{земля},3{обломки},2{стена}];
type
    ZoneMassivType = array[1..ZoneMaxY,1..ZoneMaxX] of Byte;
    XType = 1..ZoneMaxX;
    YType = 1..ZoneMaxY;
    GoType = 0..4; {1 - up, 2 - right, 3 - down, 4 - left}
    RoadType = record
        TotalMoves:integer;
        X:array[1..ZoneSize] of XType;
        Y:array[1..ZoneSize] of YType;
      end;
var
   Point:ZoneMassivType;
   C:XType;
   L:YType;
   SuccGo:GoType;
   SuccSize:Word;
   Go:GoType;
   f:integer;
   lab:text;
   h:char;
   xx,cx:XType;
   yy,cy:YType;
   Mas:RoadType;
procedure ReadLabFile(name:string);
begin
Assign(lab,name+'.lab');
Reset(lab);
for f:=1 to 5 do readln(lab,h);
for l:=1 to ZoneMaxY do
  for f:=1 to ZoneMaxX do
    readln(lab,Point[l,f]);
Close(lab);
end;
procedure WriteLab;
begin
textbackground(0);
textcolor(10);
clrscr;
for l:=1 to ZoneMaxY do
  for f:=1 to ZoneMaxX do
    if Point[l,f]=1 then
      begin
        gotoxy(f*2-1,l);
        write('░░')
      end;
end;
procedure You;
begin
textcolor(9);
gotoxy(xx*2-1,yy);
write('▓▓')
end;

function RoadSize(M:ZoneMassivType;MoveX,MoveY,cx,cy,Go:Word):Word;
var MSize,R:Word;
begin
if SuccSize<>0 then
  begin
    RoadSize:=SuccSize;
    SuccSize:=0;
    exit
  end;
MSize:=0;
if Go=1 then
 begin
  for L:=MoveY-1 downto cy do
    if M[L,MoveX] in ZoneSpace then MSize:=MSize+1
                               else
    begin
      if (Random(2)+1) =1 then
        begin
          SuccGo:=4;
          R:=0;
          for C:=MoveX-1 downto 1 do
            if M[MoveY,C] in ZoneSpace then R:=R+1
                                       else C:=1;
          for C:=MoveX-1 downto MoveX-R do
            if M[MoveY+1,C] in ZoneSpace then
              begin
                SuccSize:=MoveX-C;
                C:=MoveX-R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end{Up}
                          else
        begin
          SuccGo:=2;
          R:=0;
          for C:=MoveX+1 to ZoneMaxX do
            if M[MoveY,C] in ZoneSpace then R:=R+1
                                       else C:=ZoneMaxX;
          for C:=MoveX+1 to MoveX+R do
            if M[MoveY+1,C] in ZoneSpace then
              begin
                SuccSize:=MoveX+C;
                C:=MoveX+R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end;{Down}
      break;
    end;
  RoadSize:=MSize;
  exit
 end;
if Go=3 then
 begin
  for L:=MoveY+1 to cy do
    if M[L,MoveX] in ZoneSpace then MSize:=MSize+1
                               else
    begin
      if (Random(2)+1) =1 then
        begin
          SuccGo:=4;
          R:=0;
          for C:=MoveX-1 downto 1 do
            if M[MoveY,C] in ZoneSpace then R:=R+1
                                       else C:=1;
          for C:=MoveX-1 downto MoveX-R do
            if M[MoveY-1,C] in ZoneSpace then
              begin
                SuccSize:=MoveX-C;
                C:=MoveX-R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end{Up}
                          else
        begin
          SuccGo:=2;
          R:=0;
          for C:=MoveX+1 to ZoneMaxX do
            if M[MoveY,C] in ZoneSpace then R:=R+1
                                       else C:=ZoneMaxX;
          for C:=MoveX+1 to MoveX+R do
            if M[MoveY-1,C] in ZoneSpace then
              begin
                SuccSize:=MoveX+C;
                C:=MoveX+R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end;{Down}
      break;
    end;
  RoadSize:=MSize;
  exit
 end;
if Go=2 then
 begin
  for C:=MoveX+1 to cx do
    if M[MoveY,C] in ZoneSpace then MSize:=MSize+1
                               else
    begin
      if (Random(2)+1) =1 then
        begin
          SuccGo:=1;
          R:=0;
          for L:=MoveY-1 downto 1 do
            if M[L,MoveX] in ZoneSpace then R:=R+1
                                       else L:=1;
          for L:=MoveY-1 downto MoveY-R do
            if M[L,MoveX+1] in ZoneSpace then
              begin
                SuccSize:=MoveY-L;
                L:=MoveY-R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end{Up}
                          else
        begin
          SuccGo:=3;
          R:=0;
          for L:=MoveY+1 to ZoneMaxY do
            if M[L,MoveX] in ZoneSpace then R:=R+1
                                       else L:=ZoneMaxY;
          for L:=MoveY+1 to MoveY+R do
            if M[L,MoveX+1] in ZoneSpace then
              begin
                SuccSize:=MoveY+L;
                L:=MoveY+R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end;{Down}
      break;
    end;
  RoadSize:=MSize;
  exit
 end;
if Go=4 then
 begin
  for C:=MoveX-1 downto cx do
    if M[MoveY,C] in ZoneSpace then MSize:=MSize+1
                               else
    begin
      if (Random(2)+1) =1 then
        begin
          SuccGo:=1;
          R:=0;
          for L:=MoveY-1 downto 1 do
            if M[L,MoveX] in ZoneSpace then R:=R+1
                                       else L:=1;
          for L:=MoveY-1 downto MoveY-R do
            if M[L,MoveX-1] in ZoneSpace then
              begin
                SuccSize:=MoveY-L;
                L:=MoveY-R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end{Up}
                          else
        begin
          SuccGo:=3;
          R:=0;
          for L:=MoveY+1 to ZoneMaxY do
            if M[L,MoveX] in ZoneSpace then R:=R+1
                                       else L:=ZoneMaxY;
          for L:=MoveY+1 to MoveY+R do
            if M[L,MoveX-1] in ZoneSpace then
              begin
                SuccSize:=MoveY+L;
                L:=MoveY+R
              end;
          if (R=0) or (SuccSize=0) then SuccGo:=0;
        end;{Down}
      break;
    end;
  RoadSize:=MSize;
  exit
 end
end;

function ViborGo(MoveX,MoveY,cx,cy:word):GoType;
var
   DX:Integer;
   DY:Integer;
begin
if SuccGo<>0 then
  begin
    ViborGo:=SuccGo;
    SuccGo:=0;
    exit
  end;
DX:=cx-MoveX;
DY:=cy-MoveY;
if ABS(DX) > ABS(DY) then
  begin
    if ABS(DX) = DX then ViborGo:=2
                    else ViborGo:=4;
    exit
  end;
if ABS(DY) > ABS(DX) then
  begin
    if ABS(DY) = DY then ViborGo:=3
                    else ViborGo:=1;
    exit
  end;
if ABS(DX) = ABS(DY) then
  if (Random(2)+1)=1 then
    if (Random(2)+1)=1 then ViborGo:=2
                       else ViborGo:=4
                     else
    if (Random(2)+1)=1 then ViborGo:=3
                       else ViborGo:=1
end;
procedure Move(var MoveX:XType;
               var MoveY:YType;
               Go:GoType;
               MS:Word;
               var Mas:RoadType);
begin
if Go=1 then
begin
  for L:=MoveY-1 downto MoveY-MS do
    begin
      with Mas do
        begin
          TotalMoves:=TotalMoves+1;
          X[TotalMoves]:=MoveX;
          Y[TotalMoves]:=L;
          MoveY:=MoveY-1
        end
    end;
exit
end;
if Go=3 then
begin
  for L:=MoveY+1 to MoveY+MS do
    begin
      with Mas do
        begin
          TotalMoves:=TotalMoves+1;
          X[TotalMoves]:=MoveX;
          Y[TotalMoves]:=L;
          MoveY:=MoveY+1
        end
    end;
exit
end;
if Go=2 then
begin
  for C:=MoveX+1 to MoveX+MS do
    begin
      with Mas do
        begin
          TotalMoves:=TotalMoves+1;
          X[TotalMoves]:=C;
          Y[TotalMoves]:=MoveY;
          MoveX:=MoveX+1
        end
    end;
exit
end;
if Go=4 then
begin
  for C:=MoveX-1 downto MoveX-MS do
    begin
      with Mas do
        begin
          TotalMoves:=TotalMoves+1;
          X[TotalMoves]:=C;
          Y[TotalMoves]:=MoveY;
          MoveX:=MoveX-1
        end
    end;
exit
end
end;

begin
SuccGo:=0; SuccSize:=0;
Randomize;
readlabfile('move');
writelab;
gotoxy(1,21);write('xx = ');read(xx);write('yy = ');read(yy);
write('cx = ');read(cx);write('cy = ');read(cy);
You;
textcolor(14);
gotoxy(cx*2-1,cy);
write('<>');
repeat
Go:=ViborGo(xx,yy,cx,cy);
Move(xx,yy,Go,RoadSize(Point,xx,yy,cx,cy,Go),Mas);
textcolor(9);
for f:=1 to Mas.TotalMoves do
  begin
    gotoxy(Mas.X[f]*2-1,Mas.Y[f]);
    write('▓▓');
    gotoxy(1,1);
    readln;
    gotoxy(Mas.X[f]*2-1,Mas.Y[f]);
    write('')
  end;
Mas.TotalMoves:=0;
until (xx=cx) and (yy=cy);
gotoxy(1,21);write('                              Конец!');
readln
end.