type
    PlanType = 1..230;
var
   Driver,Mode:Integer;
   Point:array[1..50,1..23,1..23] of 0..3;
   Size:Word;
   { You variables}
   Nedely,
   Kredits,
   Avtoritet:LongInt;
   Laser,
   NPushka,
   Raketa,
   DiraVP,
   Teleport:Word;
   Toplivo:0..100;
   r,t,YouX,YouY:byte;
   Korabl:Boolean; {имеется или нет}
   Auto:1..2; {1 - машина, 2 - корабль (на чем двигаешься)}
   TekPlan:1..4;
   Go:12..13;{12 - вправо, 13 - влево}
   Timer:0..3;
   { Constructors }
   PSpace,
   PShip1,
   PShip2,
   PPlita,
   PWarHouse,
   PCity,
   PWall,
   PEnemBaze,
   PYouBaze,
   PKredit,
   PDira,
   PEnemy,
   PCar1,
   PCar2:Pointer;
   BShip1,
   BShip2,
   BPlita,
   BWarHouse,
   BCity,
   BWall,
   BEnemBaze,
   BYouBaze,
   BKredit,
   BDira,
   BEnemy,
   BCar1,
   BCar2:Boolean;
   {}{}{}{}{}{}{}{}
   Plans:array[1..4,1..40,1..40] of PlanType;
   Citys:array[101..123] of 1..6;
   WarHouses:array[201..216] of 1..11;
   Enemys:array[124..200] of
     record
       Total:1..5; {всего воинов}
       Voin:array[1..5] of
         record
           Typ:1..11; {вид воина}
           All:byte {количество}
         end;
     end;
   Bazes:array[51..80] of
     record
       Voin:array[1..5] of
         record
           Typ:1..11;
           All:byte
         end;
     end;
   h:Char;
   IsEnemy:word;
   f,l:integer;
