uses CGADrv, Graph, Crt;
var
   Driver,Mode,Err:Integer;
   f:Byte;
   h:Char;
   s:string;
begin
Driver:=Detect;
InitGraph(Driver,Mode,'');
Err:=GraphResult;
if Err<>grOk then
  begin
    writeln(GraphErrorMsg(Err));
    Halt
  end;
if Driver<>CGA then
  begin
    writeln('Нужен CGA-монитор!');
    Halt
  end;
OutText('  Keys:');
OutTextXY(40,10,'0 - Mode=0');
OutTextXY(40,20,'1 - Mode=1');
OutTextXY(40,30,'2 - Mode=2');
OutTextXY(40,40,'3 - Mode=3');
OutTextXY(40,50,'4 - Mode=4');
OutTextXY(40,60,'ESC - Exit');
repeat
repeat
h:=ReadKey;
until (h='0') or (h='1') or (h='2') or (h='3') or (h='4') or (h=#27);
if h<>#27 then
  begin
    val(h,f,Err);
    SetGraphMode(f);
    SetColor(1);
    str(f,s);
    OutText('CGA Mode='+s+' Color=1  ');
    SetColor(2);
    OutText('Color=2  ');
    SetColor(3);
    OutText('Color=3');
    SetColor(1);
    str(GetMaxX+1,s);
    OutTextXY(20,30,'Max_X = '+s);
    str(GetMaxY+1,s);
    OutTextXY(20,60,'Max_Y = '+s)
  end;
until h=#27;
CloseGraph
end.