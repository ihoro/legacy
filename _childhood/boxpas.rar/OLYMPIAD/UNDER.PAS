uses UnderTPU;
type
     CheckType = 1..10000;
var
    f,l,k:integer;
    E:array[1..10000] of
        record
          dx,dy:ShortInt;
          Z:Char
        end;
    TotalE:1..10000;
    tx,ty:ShortInt;
    OK:Boolean;
    dir:Char;
    myX,myY:1..100;
function Check:CheckType;
var
    Count,j:0..10000;
begin
Count:=0;
for l:=V-1 downto 2 do
  for f:=2 to U-1 do
    begin
      j:=0;
      for k:=1 to TotalE do
        with E[k] do
          begin
            if (f+dx>=1) and (f+dx<=U) and (l+dy>=1) and (l+dy<=V) then
              begin
                if Map[f+dx,l+dy]=Z then j:=j+1
              end
                                                                   else
              k:=TotalE
          end;
      if j=TotalE then
        begin
          Count:=Count+1;
          myX:=f;
          myY:=l
        end
    end;
Check:=Count
end;
begin
Start;
E[1].dx:=0;
E[1].dy:=0;
E[1].Z:='O';
tx:=0;
ty:=1;
TotalE:=1;
dir:='N';
repeat
OK:=true;
for f:=1 to TotalE do
  if (E[f].dx=tx) and (E[f].dy=ty) then
    begin
      OK:=false;
      f:=TotalE
    end;
if OK then
  begin
    TotalE:=TotalE+1;
    with E[TotalE] do
      begin
        dx:=tx;
        dy:=ty;
        Z:=Look(dir)
      end;
  end;
if E[TotalE].Z='W' then
  case dir of
    'N':begin tx:=tx-1;ty:=ty-1;dir:='W' end;
    'E':begin ty:=ty+1;tx:=tx-1;dir:='N' end;
    'S':begin tx:=tx+1;ty:=ty+1;dir:='E' end;
    'W':begin ty:=ty-1;tx:=tx+1;dir:='S' end
  end
                   else
  begin
    Move(dir);
    case dir of
      'N':begin tx:=tx-1;dir:='W' end;
      'E':begin ty:=ty+1;dir:='N' end;
      'S':begin tx:=tx+1;dir:='E' end;
      'W':begin ty:=ty-1;dir:='S' end
    end;
  end;
until Check=1;
Finish(myX,myY)
end.