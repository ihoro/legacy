MoveX:=1;
MoveY:=1;
ReadPix;
MiniWindow(0,0,319,183,'Mini Windows Paint');
ReadMouseSpace;
WriteMouse;
REPEAT
repeat
until KeyPressed;
h:=ReadKey;
if h=#0 then
  begin
    h:=ReadKey;
    if h=#80 then
      begin
        WritePix(MX,MY);
        MY:=MY+MoveY;
        ReadPix;
        WriteMouse
      end;
    if h=#72 then
      begin
        WritePix(MX,MY);
        MY:=MY-MoveY;
        ReadPix;
        WriteMouse
      end;
    if h=#75 then
      begin
        WritePix(MX,MY);
        MX:=MX-MoveX;
        ReadPix;
        WriteMouse
      end;
    if h=#77 then
      begin
        WritePix(MX,MY);
        MX:=MX+MoveX;
        ReadPix;
        WriteMouse
      end;
     { Super Move: }
    if h=#81 then
      begin
        WritePix(MX,MY);
        MY:=MY+SuperMoveY;
        ReadPix;
        WriteMouse
      end;
    if h=#73 then
      begin
        WritePix(MX,MY);
        MY:=MY-SuperMoveY;
        ReadPix;
        WriteMouse
      end;
    if h=#71 then
      begin
        WritePix(MX,MY);
        MX:=MX-SuperMoveX;
        ReadPix;
        WriteMouse
      end;
    if h=#79 then
      begin
        WritePix(MX,MY);
        MX:=MX+SuperMoveX;
        ReadPix;
        WriteMouse
      end;
  end;{h=#0}
UNTIL h=#27;