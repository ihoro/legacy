uses OIVCom,Graph, Crt;
{$I war_cons.inc}
{$I war_vari.inc}
{$I war_p&f.inc}
begin
Randomize;
BShip1:=false;
BShip2:=false;
BPlita:=false;
BWarHouse:=false;
BCity:=false;
BWall:=false;
BEnemBaze:=false;
BYouBaze:=false;
BKredit:=false;
BDira:=false;
BEnemy:=false;
BCar1:=false;
BCar2:=false;
Driver:=CGA;
Mode:=1;
InitGraph(Driver,Mode,'');
Zast;
YouVariables;
ReadPlans;
ClearDevice;
Wind;
Status;
StatusToplivo;
Plans[TekPlan,YouX,YouY]:=Go;
WritePlan(TekPlan,YouX-2,YouY-2,41,41);
IsEnemy:=0;
Timer:=0;
REPEAT
repeat
until KeyPressed;
h:=ReadKey;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#59 then
      begin
        SetViewPort(116,1,318,198,ClipOn);
        ClearViewPort;
        SetViewPort(0,0,319,199,ClipOn);
        SetColor(1);
        SetTextStyle(10,0,1);
        OutTextXY(121,5,'Курсор - движение');
        OutTextXY(121,15,'A - осмотр армии');
        OutTextXY(121,25,'J - гиппер прыжок');
        OutTextXY(121,35,'F2 - запись игры');
        OutTextXY(121,45,'F3 - загрузить игру');
        OutTextXY(121,55,'Esc - выход из игры');
        OutTextXY(121,65,'  В битве:');
        OutTextXY(121,75,'D - дополн. возможности');
        OutTextXY(121,85,'M - движение');
        OutTextXY(121,95,'F - лететь');
        OutTextXY(121,105,'S - стрелять');
        repeat
        h:=ReadKey;
        until h=#27;
        h:=' ';
        ClearDevice;
        Wind;
        Status;
        StatusToplivo;
        WritePlan(TekPlan,YouX-2,YouY-2,41,41)
      end;
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1] in SetDira) and (Auto=1) then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        if plans[TekPlan,YouX,YouY-1] = 220+TekPlan*2 then
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 219+TekPlan*2 then
                  begin
                    YouX:=f;
                    YouY:=l+1
                  end
          end
             else
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 220+TekPlan*2 then
                  begin
                    YouX:=f;
                    YouY:=l+1
                  end
          end;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-1);
        h:=' '
      end;
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1] in SetCitys) then PrCity(Plans[TekPlan,YouX,YouY-1],YouX,YouY-1);
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1]=1) and (Auto=2) and Up then
      begin
        Timer:=Timer+1;
        if Timer=2 then begin Toplivo:=Toplivo-1;Timer:=0;StatusToplivo end;
        Plans[TekPlan,YouX,YouY]:=1;
        YouY:=YouY-1;
        if Go=12 then Plans[TekPlan,YouX,YouY]:=2
                 else Plans[TekPlan,YouX,YouY]:=3;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-1);
        h:=' '
      end;
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1] in SetShips) and (Auto=1) then
      begin
        Auto:=2;
        Plans[TekPlan,YouX,YouY]:=4;
        YouY:=YouY-1;
        if Go=12 then Plans[TekPlan,YouX,YouY]:=2
                 else Plans[TekPlan,YouX,YouY]:=3;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-1);
      end;
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1] in SetMoves) and (Auto=1) and Up then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        YouY:=YouY-1;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-1);
      end;
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1] in SetGold) and (Auto=1) then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        YouY:=YouY-1;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-1);
      end;
    if (h=#72) and (Plans[TekPlan,YouX,YouY-1]=4) and (Auto=2) then
      begin
        Auto:=1;
        YouY:=YouY-1;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-1);
      end;
    if (h=#80) and (Plans[TekPlan,YouX,YouY+1] in SetDira) and (Auto=1) then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        if plans[TekPlan,YouX,YouY+1] = 220+TekPlan*2 then
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 219+TekPlan*2 then
                  begin
                    YouX:=f;
                    YouY:=l-1
                  end
          end
             else
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 220+TekPlan*2 then
                  begin
                    YouX:=f;
                    YouY:=l-1
                  end
          end;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-3);
        h:=' '
      end;
    if (h=#80) and (Plans[TekPlan,YouX,YouY+1] in SetCitys) then PrCity(Plans[TekPlan,YouX,YouY+1],YouX,YouY+1);
    if (h=#80) and (Plans[TekPlan,YouX,YouY+1]=1) and (Auto=2) and Down then
      begin
        Timer:=Timer+1;
        if Timer=2 then begin Toplivo:=Toplivo-1;Timer:=0;StatusToplivo end;
        Plans[TekPlan,YouX,YouY]:=1;
        YouY:=YouY+1;
        if Go=12 then Plans[TekPlan,YouX,YouY]:=2
                 else Plans[TekPlan,YouX,YouY]:=3;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-3);
        h:=' '
      end;
    if (h=#80) and (Plans[TekPlan,YouX,YouY+1] in SetShips) and (Auto=1) then
      begin
        Auto:=2;
        Plans[TekPlan,YouX,YouY]:=4;
        YouY:=YouY+1;
        if Go=12 then Plans[TekPlan,YouX,YouY]:=2
                 else Plans[TekPlan,YouX,YouY]:=3;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-3);
      end;
    if (h=#80) and (Plans[TekPlan,YouX,YouY+1] in SetMoves) and (Auto=1) and Down then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        YouY:=YouY+1;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-3);
      end;
    if (h=#80) and (Plans[TekPlan,YouX,YouY+1]=4) and (Auto=2) then
      begin
        Auto:=1;
        YouY:=YouY+1;
        Plans[TekPlan,YouX,YouY]:=Go;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-2,YouY-3);
      end;
    if (h=#75) and (Plans[TekPlan,YouX-1,YouY] in SetCitys) then PrCity(Plans[TekPlan,YouX-1,YouY],YouX-1,YouY);
    if (h=#75) and (Plans[TekPlan,YouX-1,YouY]=1) and (Auto=2) and Left then
      begin
        Timer:=Timer+1;
        if Timer=2 then begin Toplivo:=Toplivo-1;Timer:=0;StatusToplivo end;
        Plans[TekPlan,YouX,YouY]:=1;
        YouX:=YouX-1;
        Plans[TekPlan,YouX,YouY]:=3;
        Go:=13;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-1,YouY-2);
        h:=' '
      end;
    if (h=#75) and (Plans[TekPlan,YouX-1,YouY] in SetDira) and (Auto=1) then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        if plans[TekPlan,YouX-1,YouY] = 220+TekPlan*2 then
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 219+TekPlan*2 then
                  begin
                    YouX:=f+1;
                    YouY:=l
                  end
          end
             else
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 220+TekPlan*2 then
                  begin
                    YouX:=f+1;
                    YouY:=l
                  end
          end;
        Plans[TekPlan,YouX,YouY]:=13;
        Go:=13;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-1,YouY-2);
        h:=' '
      end;
    if (h=#75) and (Plans[TekPlan,YouX-1,YouY] in SetShips) and (Auto=1) then
      begin
        Auto:=2;
        Plans[TekPlan,YouX,YouY]:=4;
        YouX:=YouX-1;
        Plans[TekPlan,YouX,YouY]:=3;
        Go:=13;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-1,YouY-2);
      end;
    if (h=#75) and (Plans[TekPlan,YouX-1,YouY] in SetMoves) and (Auto=1) and Left then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        YouX:=YouX-1;
        Plans[TekPlan,YouX,YouY]:=13;
        Go:=13;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-1,YouY-2);
      end;
    if (h=#75) and (Plans[TekPlan,YouX-1,YouY]=4) and (Auto=2) then
      begin
        Auto:=1;
        YouX:=YouX-1;
        Plans[TekPlan,YouX,YouY]:=13;
        Go:=13;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-1,YouY-2);
      end;
    if (h=#77) and (Plans[TekPlan,YouX+1,YouY] in SetCitys) then PrCity(Plans[TekPlan,YouX+1,YouY],YouX+1,YouY);
    if (h=#77) and (Plans[TekPlan,YouX+1,YouY]=1) and (Auto=2) and Right then
      begin
        Timer:=Timer+1;
        if Timer=2 then begin Toplivo:=Toplivo-1;Timer:=0;StatusToplivo end;
        Plans[TekPlan,YouX,YouY]:=1;
        YouX:=YouX+1;
        Plans[TekPlan,YouX,YouY]:=2;
        Go:=12;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-3,YouY-2);
        h:=' '
      end;
    if (h=#77) and (Plans[TekPlan,YouX+1,YouY] in SetShips) and (Auto=1) then
      begin
        Auto:=2;
        Plans[TekPlan,YouX,YouY]:=4;
        YouX:=YouX+1;
        Plans[TekPlan,YouX,YouY]:=2;
        Go:=12;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-3,YouY-2);
      end;
    if (h=#77) and (Plans[TekPlan,YouX+1,YouY] in SetMoves) and (Auto=1) and Right then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        YouX:=YouX+1;
        Plans[TekPlan,YouX,YouY]:=12;
        Go:=12;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-3,YouY-2);
      end;
    if (h=#77) and (Plans[TekPlan,YouX+1,YouY] in SetDira) and (Auto=1) then
      begin
        Plans[TekPlan,YouX,YouY]:=4;
        if plans[TekPlan,YouX+1,YouY] = 220+TekPlan*2 then
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 219+TekPlan*2 then
                  begin
                    YouX:=f-1;
                    YouY:=l
                  end
          end
             else
          begin
            for l:=4 to 37 do
              for f:=4 to 37 do
                if plans[TekPlan,f,l] = 220+TekPlan*2 then
                  begin
                    YouX:=f-1;
                    YouY:=l
                  end
          end;
        Plans[TekPlan,YouX,YouY]:=12;
        Go:=12;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-3,YouY-2);
        h:=' '
      end;
    if (h=#77) and (Plans[TekPlan,YouX+1,YouY]=4) and (Auto=2) then
      begin
        Auto:=1;
        YouX:=YouX+1;
        Plans[TekPlan,YouX,YouY]:=12;
        Go:=12;
        WritePlan(TekPlan,YouX-2,YouY-2,YouX-3,YouY-2);
      end;
  end; {if h=#0}
if (Toplivo=0) and (Auto=2) then
  begin
    Message(121,140,'Закончилось топливо!',2);
    Message(121,160,'   Вас выбросило',1);
    Message(121,180,'   на планетоид!',1);
    Delay(1000);
    Korabl:=false;
    Auto:=1;
    Go:=12;
    repeat
      f:=Random(40)+1;
      l:=Random(40)+1;
    until plans[TekPlan,f,l]=4;
    plans[TekPlan,f,l]:=12;
    r:=YouX;
    t:=YouY;
    YouX:=f;
    YouY:=l;
    ClearDevice;
    Wind;
    Status;
    StatusToplivo;
    WritePlan(TekPlan,YouX-2,YouY-2,r,t);
  end;
UNTIL h=#27;
CloseGraph
end.

