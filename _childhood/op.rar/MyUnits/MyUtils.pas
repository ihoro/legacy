unit MyUtils;

interface

function sti(aStr: string): Integer;
function its(x: Integer): string;

implementation

function sti(aStr: string): Integer;
var
  f,t,r,st: Integer;
const
  sym: set of Char = ['-','0','1','2','3','4','5','6','7','8','9'];
begin
  r:=0;
  t:=Length(aStr);
  for f:=1 to Length(aStr) do
    if not (aStr[f] in sym) then
      begin
        t:=f-1;
        Break
      end;
  if aStr[1]='-' then st:=1
                 else st:=0;
  for f:=0 to t-1-st do
    case aStr[t-f] of
      '1':r:=r+trunc(exp(f*ln(10)));
      '2':r:=r+2*trunc(exp(f*ln(10)));
      '3':r:=r+3*trunc(exp(f*ln(10)));
      '4':r:=r+4*trunc(exp(f*ln(10)));
      '5':r:=r+5*trunc(exp(f*ln(10)));
      '6':r:=r+6*trunc(exp(f*ln(10)));
      '7':r:=r+7*trunc(exp(f*ln(10)));
      '8':r:=r+8*trunc(exp(f*ln(10)));
      '9':r:=r+9*trunc(exp(f*ln(10)))
    end;
  if st=1 then r:=-r;
  sti:=r
end;

function its(x: Integer): string;
var
  r: string;
  f,p: Integer;
begin
  if x=0 then
    begin
      Result:='0';
      Exit
    end;
  if x<0 then
    begin
      r:='-';
      x:=-x
    end
         else
    r:='';
  p:=0;
  for f:=9 downto 0 do
    begin
      if x div trunc(exp(f*ln(10)))<>0 then inc(p);
      case x div trunc(exp(f*ln(10))) of
        0:if p<>0 then r:=r+'0';
        1:r:=r+'1';
        2:r:=r+'2';
        3:r:=r+'3';
        4:r:=r+'4';
        5:r:=r+'5';
        6:r:=r+'6';
        7:r:=r+'7';
        8:r:=r+'8';
        9:r:=r+'9'
      end;
      x:=x-x div trunc(exp(f*ln(10)))*trunc(exp(f*ln(10)))
    end;
  its:=r
end;

end.
