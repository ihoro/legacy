uses EGAVGA,ReadPCX, Graph;
var F:TPicture;
    L:Pointer;
    Size:word;
    Err,Driver,Mode:Integer;
begin
Driver:=Detect;
InitGraph(Driver,Mode,'');
Err:=GraphResult;
if Err<>grOk then
  begin
    writeln(GraphErrorMsg(Err));
    Halt
  end;
ScreenWidth := 320; { размер экрана по горизонтали     }
ScreenHeight:= 200; { размер экрана по вертикали       }
SetLoGraphMode;
LoadPicture('ships.pcx',F);
DrawPicture(0,0,F,true);
{Size:=ImageSize(0,0,319,199);
GetMem(L,Size);
GetImage(0,0,319,199,L^);}
for Err:=1 to 10 do
  begin
    ClearScreen(0);
    readln;
    DrawPicture(0,0,F,true);
    readln
  end;
readln;
{UnLoadPicture(F);}
{Driver:=Detect;
InitGraph(Driver,Mode,'');
Err:=GraphResult;
if Err<>grOk then
  begin
    writeln(GraphErrorMsg(Err));
    Halt
  end;
outtext('graph');
readln;}
{ClearDevice;}
{ClearScreen(0);
outtext('oiv');
readln;
PutImage(20,20,L^,1);
readln;}
CloseGraph
end.