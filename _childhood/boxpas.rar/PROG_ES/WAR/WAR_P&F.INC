procedure ReadStu(FileName:string;b:byte);
var f,l:byte;
    fil:text;
    ch:char;
    p:0..3;
    err:integer;
begin
Assign(fil,FileName+'.stu');
Reset(fil);
for l:=1 to 23 do
  for f:=1 to 23 do
    begin
      read(fil,ch);
      if f=23 then readln(fil,ch)
              else read(fil,ch);
      Val(ch,p,err);
      Point[b,l,f]:=p
    end;
Close(fil)
end;
procedure WriteStu(x,y,MaxX,MaxY:integer;b:byte);
var f,l:byte;
begin
for l:=1 to MaxY do
  for f:=1 to MaxX do
    if Point[b,l,f]<>0 then PutPixel(x+f-1,y+l-1,Point[b,l,f])
end;
procedure Zast;
var f,l:integer;
begin
ReadStu('space',Space);
WriteStu(0,0,23,23,Space);
Size:=ImageSize(0,0,22,22);
GetMem(PSpace,Size);
GetImage(0,0,22,22,PSpace^);
for l:=1 to 9 do
  for f:=1 to 13 do
    PutImage(f*23-23,l*23-23,PSpace^,0);
SetColor(2);
SetTextStyle(7,0,6);
OutTextXY(60,20,'Война');
SetColor(3);
SetTextStyle(7,0,3);
OutTextXY(140,80,'за');
OutTextXY(50,120,'пространство');
SetTextStyle(3,1,3);
SetColor(1);
OutTextXY(290,50,'Loading...');
ReadStu('ship1',Ship1);
ReadStu('ship2',Ship2);
ReadStu('car1',Car1);
ReadStu('car2',Car2);
ReadStu('plita',Plita);
ReadStu('warhouse',WarHouse);
ReadStu('dira',Dira);
ReadStu('city',City);
ReadStu('kredit',Kredit);
ReadStu('enembaze',EnemBaze);
ReadStu('youbaze',YouBaze);
ReadStu('wall',Wall);
ReadStu('enemy',Enemy);
ReadStu('trenoid1',Trenoid1);
ReadStu('trenoid2',Trenoid2);
ReadStu('jon1',Jon1);
ReadStu('jon2',Jon2);
ReadStu('warship1',WarShip1);
ReadStu('warship2',WarShip2);
ReadStu('zt1',ZT1);
ReadStu('zt2',ZT2);
ReadStu('monstr1',Monstr1);
ReadStu('monstr2',Monstr2);
ReadStu('fimen1',Fimen1);
ReadStu('fimen2',Fimen2);
ReadStu('fighter1',Fighter1);
ReadStu('fighter2',Fighter2);
ReadStu('krouner1',Krouner1);
ReadStu('krouner2',Krouner2);
ReadStu('mirrius1',Mirrius1);
ReadStu('mirrius2',Mirrius2);
ReadStu('amans1',Amans1);
ReadStu('amans2',Amans2);
ReadStu('dragon1',Dragon1);
ReadStu('dragon2',Dragon2);
end;
procedure War;
begin
SetTextStyle(4,0,6);
SetColor(2);
OutTextXY(1,130,'WAR');
end;
procedure Wind;
begin
SetViewPort(115,0,319,199,ClipOn);
ClearViewPort;
SetViewPort(0,0,319,199,ClipOn);
War;
SetColor(3);
Line(0,115,114,115);
Rectangle(115,0,319,199);
Rectangle(117,2,317,197);
Rectangle(119,4,315,14);
Rectangle(119,16,315,26);
Rectangle(119,30,315,40);
Rectangle(119,42,315,52);
Rectangle(119,54,315,64);
Rectangle(119,66,315,76);
Rectangle(119,78,315,88);
Rectangle(119,90,315,110);
SetColor(1);
Rectangle(121,105,223,107);
SetColor(3);
Rectangle(119,121,315,195);
SetColor(2);
Line(119,28,315,28);
SetTextStyle(10,0,1);
SetColor(1);
OutTextXY(120,6,'Деньги: $');
OutTextXY(120,18,'Неделя:');
OutTextXY(120,32,'Лазер: ');
OutTextXY(120,44,'Нейтронная пушка: ');
OutTextXY(120,56,'Ракета: ');
OutTextXY(120,68,'Дыра в пространстве: ');
OutTextXY(120,80,'Телепорт: ');
OutTextXY(120,92,'Топливо:');
SetColor(2);
OutTextXY(120,112,'F1 - клавиши');
end;
procedure Status;
var s:string;
begin
SetFillStyle(1,0);
Bar(190,6,312,12);
Bar(180,18,312,24);
Bar(170,32,312,38);
Bar(260,44,312,50);
Bar(180,56,312,62);
Bar(280,68,312,74);
Bar(196,80,312,86);
SetColor(2);
Str(Kredits,s);
OutTextXY(192,6,s);
Str(nedely,s);
OutTextXY(182,18,s);
Str(Laser,s);
OutTextXY(172,32,s);
Str(NPushka,s);
OutTextXY(262,44,s);
Str(Raketa,s);
OutTextXY(182,56,s);
Str(DiraVP,s);
OutTextXY(282,68,s);
Str(Teleport,s);
OutTextXY(198,80,s);
end;
procedure StatusToplivo;
var s:string;
begin
SetFillStyle(1,0);
Bar(188,92,312,98);
SetColor(1);
Str(Toplivo,s);
OutTextXY(190,92,s+' %');
SetColor(0);
Line(122,106,222,106);
SetColor(2);
if Toplivo<>0 then Line(122,106,122+Toplivo,106);
end;
procedure YouVariables;
begin
Kredits:=400;
nedely:=1;
Laser:=0;
NPushka:=0;
Raketa:=0;
DiraVP:=0;
Teleport:=0;
Toplivo:=0;
YouX:=16;
YouY:=11;
Auto:=1;
Korabl:=false;
TekPlan:=1;
Go:=13;
Avtoritet:=10;
end;
procedure ReadPlans;
var zon:text;
    f,l:byte;
    d,g,h:integer;
    Ok:Boolean;
begin
for l:=1 to 3 do
  for f:=1 to 40 do plans[1,f,l]:=1;
for l:=38 to 40 do
  for f:=1 to 40 do plans[1,f,l]:=1;
for l:=1 to 40 do
  for f:=1 to 3 do plans[1,f,l]:=1;
for l:=1 to 40 do
  for f:=38 to 40 do plans[1,f,l]:=1;
Assign(zon,'plan1.zon');
Reset(zon);
for l:=4 to 37 do
  for f:=4 to 37 do
    begin
      readln(zon,plans[1,f,l]);
      if (plans[1,f,l]>100) and (plans[1,f,l]<=123) then readln(zon,Citys[plans[1,f,l]]);
      if (plans[1,f,l]>200) and (plans[1,f,l]<=216) then readln(zon,WarHouses[plans[1,f,l]])
    end;
Close(zon);
d:=124;
g:=51;
for l:=4 to 37 do
  for f:=4 to 37 do
    begin
      if plans[1,f,l]=11 then
        begin
          plans[1,f,l]:=d;
          inc(d)
        end;
      if plans[1,f,l]=8 then
        begin
          plans[1,f,l]:=g;
          inc(g)
        end;
    end;
for f:=124 to 146 do
  begin
    h:=Random(4)+2;
    with Enemys[f] do
      begin
        Total:=h;
        for l:=1 to Total do
          begin
            repeat
            h:=Random(5)+1;
            Ok:=true;
            for g:=1 to l-1 do if h=Voin[g].Typ then Ok:=false;
            until Ok;
            Voin[l].Typ:=h;
            h:=Random(3)+1;
            if h=1 then Voin[l].All:=Random(16)+5;{5-20}
            if h=2 then Voin[l].All:=Random(11)+20;{20-30}
            if h=3 then Voin[l].All:=Random(31)+30;{30-60}
          end;
      end;
  end;
for f:=51 to 56 do
  with Bazes[f] do
      for l:=1 to 5 do
          begin
            repeat
            h:=Random(7)+1;
            Ok:=true;
            for g:=1 to l-1 do if h=Voin[g].Typ then Ok:=false;
            until Ok;
            Voin[l].Typ:=h;
            h:=Random(3)+1;
            if h=1 then Voin[l].All:=Random(21)+10;{10-30}
            if h=2 then Voin[l].All:=Random(11)+30;{30-40}
            if h=3 then Voin[l].All:=Random(31)+40;{40-70}
          end;
end;
procedure WritePlan(pl,x,y,x2,y2:byte);
var Ok:boolean;
    f,l,v:byte;
begin
SetViewPort(0,0,114,114,ClipOn);
ClearViewPort;
SetViewPort(0,0,319,199,ClipOn);
Ok:=false;
for l:=0 to 4 do
  for f:=0 to 4 do
    if plans[pl,x+f,y+l] in SetEnemys then begin Ok:=true;f:=4;l:=4 end;
if Ok then IsEnemy:=IsEnemy+1
      else IsEnemy:=0;
if IsEnemy>1 then
for l:=0 to 4 do
  for f:=0 to 4 do
if plans[pl,x+f,y+l] in SetEnemys then
        begin
          v:=plans[pl,x+f,y+l];
          if (f=0) and (l=0) and (plans[Pl,x+1,y+0]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+0]:=v
            end;
          if (f=1) and (l=0) and (plans[Pl,x+1,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+1]:=v
            end;
          if (f=2) and (l=0) and (plans[Pl,x+2,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+1]:=v
            end;
          if (f=3) and (l=0) and (plans[Pl,x+3,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+1]:=v
            end;
          if (f=4) and (l=0) and (plans[Pl,x+3,y+0]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+0]:=v
            end;
          if (f=0) and (l=1) and (plans[Pl,x+1,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+1]:=v
            end;
          if (f=1) and (l=1) and (plans[Pl,x+2,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+1]:=v
            end;
{fight -  if (f=2) and (l=1) and (plans[Pl,x+2,y+2]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+2]:=v
            end;}
          if (f=3) and (l=1) and (plans[Pl,x+2,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+1]:=v
            end;
          if (f=4) and (l=1) and (plans[Pl,x+3,y+1]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+1]:=v
            end;
          if (f=0) and (l=2) and (plans[Pl,x+1,y+2]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+2]:=v
            end;
{fight -  if (f=1) and (l=2) and (plans[Pl,x+2,y+2]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+2]:=v
            end;
          if (f=3) and (l=2) and (plans[Pl,x+2,y+2]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+2]:=v
            end;}
          if (f=4) and (l=2) and (plans[Pl,x+3,y+2]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+2]:=v
            end;
          if (f=0) and (l=3) and (plans[Pl,x+1,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+3]:=v
            end;
          if (f=1) and (l=3) and (plans[Pl,x+2,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+3]:=v
            end;
{fight -  if (f=2) and (l=3) and (plans[Pl,x+2,y+2]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+2]:=v
            end;}
          if (f=3) and (l=3) and (plans[Pl,x+2,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+3]:=v
            end;
          if (f=4) and (l=3) and (plans[Pl,x+3,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+3]:=v
            end;
          if (f=0) and (l=4) and (plans[Pl,x+1,y+4]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+4]:=v
            end;
          if (f=1) and (l=4) and (plans[Pl,x+1,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+1,y+3]:=v
            end;
          if (f=2) and (l=4) and (plans[Pl,x+2,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+2,y+3]:=v
            end;
          if (f=3) and (l=4) and (plans[Pl,x+3,y+3]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+3]:=v
            end;
          if (f=4) and (l=4) and (plans[Pl,x+3,y+4]=4) then
            begin
              plans[pl,x+f,y+l]:=4;
              plans[pl,x+3,y+4]:=v
            end;
        end;
for l:=0 to 4 do
  for f:=0 to 4 do
    begin
      Ok:=false;
      case plans[pl,x+f,y+l] of
        2:if not BShip1 then Ok:=true;
        3:if not BShip2 then Ok:=true;
        4:if not BPlita then Ok:=true;
        201..216:if not BWarHouse then Ok:=true;
        101..123:if not BCity then Ok:=true;
        7:if not BWall then Ok:=true;
        51..80:if not BEnemBaze then Ok:=true;
        9:if not BKredit then Ok:=true;
        221..230:if not BDira then Ok:=true;
        124..200:if not BEnemy then Ok:=true;
        12:if not BCar1 then Ok:=true;
        13:if not BCar2 then Ok:=true;
        14:if not BYouBaze then Ok:=true
      end;
      if Ok {and (plans[TekPlan,x+f,y+l]<>plans[TekPlan,x2+f,y2+l])} then
        case plans[pl,x+f,y+l] of
          2:begin WriteStu(f*23,l*23,23,23,Ship1);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);GetMem(PShip1,Size);
          GetImage(f*23,l*23,f*23+22,l*23+22,PShip1^);
          BShip1:=true end;
          3:begin WriteStu(f*23,l*23,23,23,Ship2);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);GetMem(PShip2,Size);
          GetImage(f*23,l*23,f*23+22,l*23+22,PShip2^);
          BShip2:=true end;
          4:begin WriteStu(f*23,l*23,23,23,Plita);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);GetMem(PPlita,Size);
          GetImage(f*23,l*23,f*23+22,l*23+22,PPlita^);
          BPlita:=true end;
          201..216:begin WriteStu(f*23,l*23,23,23,WarHouse);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PWarHouse,Size);GetImage(f*23,l*23,f*23+22,
          l*23+22,PWarHouse^);BWarHouse:=true end;
          101..123:begin WriteStu(f*23,l*23,23,23,City);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PCity,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PCity^);
          BCity:=true end;
          7:begin WriteStu(f*23,l*23,23,23,Wall);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PWall,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PWall^);
          BWall:=true end;
          51..80:begin WriteStu(f*23,l*23,23,23,EnemBaze);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PEnemBaze,Size);GetImage(f*23,l*23,f*23+22,l*23+22,
          PEnemBaze^);BEnemBaze:=true end;
          9:begin WriteStu(f*23,l*23,23,23,Kredit);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PKredit,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PKredit^);
          BKredit:=true end;
          221..230:begin WriteStu(f*23,l*23,23,23,Dira);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PDira,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PDira^);
          BDira:=true end;
          124..200:begin WriteStu(f*23,l*23,23,23,Enemy);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PEnemy,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PEnemy^);
          BEnemy:=true end;
          12:begin WriteStu(f*23,l*23,23,23,Car1);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PCar1,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PCar1^);
          BCar1:=true end;
          13:begin WriteStu(f*23,l*23,23,23,Car2);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PCar2,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PCar2^);
          BCar2:=true end;
          14:begin WriteStu(f*23,l*23,23,23,YouBaze);Size:=ImageSize(f*23,l*23,f*23+22,l*23+22);
          GetMem(PYouBaze,Size);GetImage(f*23,l*23,f*23+22,l*23+22,PYouBaze^);
          BYouBaze:=true end;
        end;
       if {(}not Ok{) and (plans[TekPlan,x+f,y+l]<>plans[TekPlan,x2+f,y2+l])} then
         case plans[pl,x+f,y+l] of
           1:PutImage(f*23,l*23,PSpace^,uu);
           2:PutImage(f*23,l*23,PShip1^,uu);
           3:PutImage(f*23,l*23,PShip2^,uu);
           4:PutImage(f*23,l*23,PPlita^,uu);
           201..216:PutImage(f*23,l*23,PWarHouse^,uu);
           101..123:PutImage(f*23,l*23,PCity^,uu);
           7:PutImage(f*23,l*23,PWall^,uu);
           51..80:PutImage(f*23,l*23,PEnemBaze^,uu);
           9:PutImage(f*23,l*23,PKredit^,uu);
           221..230:PutImage(f*23,l*23,PDira^,uu);
           124..200:PutImage(f*23,l*23,PEnemy^,uu);
           12:PutImage(f*23,l*23,PCar1^,uu);
           13:PutImage(f*23,l*23,PCar2^,uu);
           14:PutImage(f*23,l*23,PYouBaze^,uu)
         end;
    end;
end;
procedure Message(x,y:integer;m:string;c:byte);
var ll:integer;
begin
SetTextStyle(10,0,1);
SetColor(c);
for ll:=1 to Length(m) do
  begin
    OutTextXY(x+ll*8-8,y,m[ll]);
    Sound(260);
    Delay(50);
    NoSound
  end
end;
procedure PrCity(gorod,x,y:byte);
label st;
var f:integer;
    s,c:string;
begin
st:
SetViewPort(116,1,318,198,ClipOn);
ClearViewPort;
SetViewPort(0,0,319,199,ClipOn);
SetColor(2);
SetTextStyle(10,0,1);
OutTextXY(200,5,'Город');
SetColor(1);
OutTextXY(121,25,'1 - спросить о базе');
OutTextXY(121,35,'2 - купить корабль($300)');
OutTextXY(121,45,'3 - купить топливо');
case Citys[gorod] of
  1:OutTextXY(121,55,'4 - лазер($700)');
  2:begin
      OutTextXY(121,55,'4 - карта($');
      case TekPlan of
        1:OutText('5000)');
        2:OutText('10000)');
        3:OutText('15000)')
      end;
    end;
  3:OutTextXY(121,55,'4 -телепорт($250)');
  4:OutTextXY(121,55,'4 - дыра в пр.($10000)');
  5:OutTextXY(121,55,'4 - нейтр. пушка($800)');
  6:OutTextXY(121,55,'4 - ракета($1000)')
end;
SetColor(3);
str(Kredits,s);
OutTextXY(121,75,'Деньги: $'+s);
repeat
repeat
until KeyPressed;
h:=ReadKey;
if h='1' then
  begin
    SetViewPort(116,1,318,198,ClipOn);
    ClearViewPort;
    SetViewPort(0,0,319,199,ClipOn);
    case gorod mod 100 of
      1:Message(150,20,'База Лория',2);
      2:Message(150,20,'База Мифис',2);
      3:Message(150,20,'База Ропос',2);
      4:Message(150,20,'База Митр',2);
      5:Message(150,20,'База Керпн',2);
      6:Message(150,20,'База Иф',2);
      7:Message(150,20,'База Неор',2);
      8:Message(150,20,'База Лост',2);
      9:Message(150,20,'База Дорф',2);
      10:Message(150,20,'База Тьма',2);
      11:Message(150,20,'База Гром',2);
      12:Message(150,20,'База Саим',2);
      13:Message(150,20,'База Литус',2);
      14:Message(150,20,'База Вампир',2);
      15:Message(150,20,'База Кроус',2);
      16:Message(150,20,'База Кирис',2);
      17:Message(150,20,'База Лорше',2);
      18:Message(150,20,'База Хорт',2);
      19:Message(150,20,'База Тивус',2);
      20:Message(150,20,'База Ночь',2);
      21:Message(150,20,'База Ватнер',2);
      22:Message(150,20,'База Тапрос',2);
      23:Message(150,20,'База Труперс',2);
      24:Message(150,20,'База Смерть',2)
    end;
    Message(121,30,'Войско:',1);
    for f:=1 to 5 do
      with Bazes[50+(gorod mod 100)].Voin[f] do
        begin
          case Typ of
            1:s:='Треноид:  ';
            2:s:='Джон:  ';
            3:s:='War Ship:  ';
            4:s:='ZT:  ';
            5:s:='Монстр:  ';
            6:s:='Фимен:  ';
            7:s:='Fighter:  ';
            8:s:='Кроунер:  ';
            9:s:='Мирриус:  ';
            10:s:='Amans:  ';
            11:s:='Дракон:  '
          end;
          str(All,c);
          s:=s+c;
          Message(121,30+f*10,s,1)
        end;
    repeat
    h:=ReadKey;
    until h=#27;
    h:=' ';
    goto st
  end;
if (h='2') and (Kredits>=300) and not Korabl then
  begin
    Korabl:=true;
    Kredits:=Kredits-300;
    Sound(15000);
    Delay(50);
    NoSound;
    Toplivo:=100;
    if plans[TekPlan,x-1,y]=1 then plans[TekPlan,x-1,y]:=2;
    if plans[TekPlan,x,y-1]=1 then plans[TekPlan,x,y-1]:=2;
    if plans[TekPlan,x+1,y]=1 then plans[TekPlan,x+1,y]:=2;
    if plans[TekPlan,x,y+1]=1 then plans[TekPlan,x,y+1]:=2;
    goto st
  end;
if (h='3') and Korabl then
  begin
    for f:=Toplivo to 100 do
      begin
        if Kredits<>0 then begin Kredits:=Kredits-1;Toplivo:=Toplivo+1 end;
        Sound(15000);
        Delay(50);
        NoSound;
        if (Kredits=0) or (Toplivo=100) then f:=100
      end;
    goto st
  end;
until h=#27;
h:=' ';
ClearDevice;
Wind;
Status;
StatusToplivo;
WritePlan(TekPlan,YouX-2,YouY-2,40,40)
end;
function Up:Boolean;
begin
if (YouY-1)<>2 then Up:=true
               else Up:=false;
end;
function Down:Boolean;
begin
if (YouY+1)<>39 then Down:=true
                else Down:=false;
end;
function Left:Boolean;
begin
if (YouX-1)<>2 then Left:=true
               else Left:=false;
end;
function Right:Boolean;
begin
if (YouX+1)<>39 then Right:=true
                else Right:=false;
end;
