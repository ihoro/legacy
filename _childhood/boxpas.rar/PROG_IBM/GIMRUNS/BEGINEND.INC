procedure Program_Begin;
var
    H:Char;
    {regs:Registers;
type Cursor=array[0..31] of word;
var
    Form:^Cursor;}
begin
  Assign(SetupFile,SetupNameFile);
  {$I-}
  Reset(SetupFile);
  readln(SetupFile,s);
  if (IOResult<>0) or (s<>#2+'Setup'+#2+'239') then
    begin
      PixelColor:=9;
      LineColor:=0;
      PixelBKColor:=7;
      PointsColor:=0;
      PointsBKColor:=7;
      Coor:=true;
      Points:=true;
      Rewrite(SetupFile);
      writeln(SetupFile,#2+'Setup'+#2+'239');
      writeln(SetupFile,PixelBKColor);
      writeln(SetupFile,PixelColor);
      writeln(SetupFile,PointsBKColor);
      writeln(SetupFile,PointsColor);
      writeln(SetupFile,LineColor);
      writeln(SetupFile,'1');
      writeln(SetupFile,'1');
      Close(SetupFile)
    end
                                        else
    begin
      readln(SetupFile,PixelBKColor);
      readln(SetupFile,PixelColor);
      readln(SetupFile,PointsBKColor);
      readln(SetupFile,PointsColor);
      readln(SetupFile,LineColor);
      readln(SetupFile,H);
      if H='1' then Coor:=true
               else Coor:=false;
      readln(SetupFile,H);
      if H='1' then Points:=true
               else Points:=false;
      Close(SetupFile)
    end;
  {$I+}
  {ColorPole:=7;
  ColorText:=0;
  ColorShadow:=8;
  ColorLigth:=15;
  ColorWindowLabel:=1;}
  BOption:=false;
  {BWriteDs:=false;
  BFileOpe:=false;
  BGraphi:=false;
  BMainMen:=false;
  BProgExi:=false;
  BCance:=false;
  BAXBY:=false;}
  BOn:=false;
  BOff:=false;
  BFError:=false;
  BOIVButtonSelect:=false;
  BOIVButton:=false;
  BOIVButtonPush:=false;
  Halts:=false;
  Error:=false;
  SQROn:=false;
  ScrStrOX:=0;
  ScrollX:=30;
  FixScrX:=30;
  ScrollY:=420;
  ScrollOX:=350;{350}
  ScrollOY:=20;
  TekFile:='';
  TotalPred:=0;
  TotalSucc:=0;
  New(ScrollData);
  New(BakPart);
  New(PredFunc);
  New(SuccFunc);
  New(Files);
  for f:=1 to 6 do
    with ScrollData^[f] do
      begin
        SX:=30;
        SY:=420;
        SOX:=350;
        SOY:=20;
        SStrOX:=0;
        SStrX:=1
      end;
  for f:=1 to 6 do
    begin
      Part[f,1].TotalVir:=0;
      Part[f,2].TotalVir:=0;
    end;
  for f:=1 to 6 do
    begin
      VirIf[f]:=1;
      PartOnOff[f]:=false
    end;
  TekPart:=1;
  LeftRigth:=1;
  ChisloA:=1;
  ChisloB:=1;
  ChisloC:=1;
  InitVideo;
  Gm:=Detect;
  InitGraph(Gm,Gd,'');
  Filter.Init;
  InitEvents;
  HideMouse;
  Image.Import('title.pfp',@Filter);
  Image.Draw(0,0,NormalPut);
  Size:=ImageSize(0,0,319,239);
  GetMem(PT1,Size);
  GetImage(0,0,319,239,PT1^);
  Size:=ImageSize(320,0,639,239);
  GetMem(PT2,Size);
  GetImage(320,0,639,239,PT2^);
  Size:=ImageSize(0,240,319,479);
  GetMem(PT3,Size);
  GetImage(0,240,319,479,PT3^);
  Size:=ImageSize(320,240,639,479);
  GetMem(PT4,Size);
  GetImage(320,240,639,479,PT4^);
  Image.Done;
  ButtonSelect(170,170,300,30);
  BeginButtons;
  ShowMouse
end;

procedure ExitNow;
begin
HideMouse;
PushButton(170,290,300,30,'Выход');
ShowMouse;
Delay(1900);
HideMouse;
Button(170,290,300,30,'Выход');
ShowMouse;
Delay(1000);
halts:=true
end;

procedure Program_End;
var
    DelFile:File;
begin
  Dispose(ScrollData);
  Dispose(BakPart);
  Dispose(PredFunc);
  Dispose(SuccFunc);
  Dispose(Files);
  Size:=ImageSize(236,251,254,271);
  if POn<>nil then FreeMem(POn,Size);
  Size:=ImageSize(236,252,254,272);
  if POff<>nil then FreeMem(POff,Size);
  Size:=ImageSize(0,0,319,239);
  FreeMem(PT1,Size);
  Size:=ImageSize(320,0,639,239);
  FreeMem(PT2,Size);
  Size:=ImageSize(0,240,319,479);
  FreeMem(PT3,Size);
  Size:=ImageSize(320,240,639,479);
  FreeMem(PT4,Size);
  Size:=ImageSize(320-PFErrorOX div 2+15,205,320-PFErrorOX div 2+46,268);
  if PFError<>nil then FreeMem(PFError,Size);
  Size:=ImageSize(221,91,418,388);
  if POptions<>nil then FreeMem(POptions,Size);
  Size:=ImageSize(559,8,623,53);
  if POIVButtonSelect<>nil then FreeMem(POIVButtonSelect,Size);
  Size:=ImageSize(559,8,623,53);
  if POIVButton<>nil then FreeMem(POIVButton,Size);
  Size:=ImageSize(559,8,623,53);
  if POIVButtonPush<>nil then FreeMem(POIVButtonPush,Size);
  Rewrite(SetupFile);
  writeln(SetupFile,#2+'Setup'+#2+'239');
  writeln(SetupFile,PixelBKColor);
  writeln(SetupFile,PixelColor);
  writeln(SetupFile,PointsBKColor);
  writeln(SetupFile,PointsColor);
  writeln(SetupFile,LineColor);
  if Coor then writeln(SetupFile,'1')
          else writeln(SetupFile,'0');
  if Points then writeln(SetupFile,'1')
            else writeln(SetupFile,'0');
  Close(SetupFile);
  DoneEvents;
  {Image.Done;}
  Filter.Done;
  CloseGraph;
  DoneVideo;
  {SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C ren screen.uni screen.exe');
  Exec(GetEnv('COMSPEC'),'/C screen.exe');
  Exec(GetEnv('COMSPEC'),'/C ren screen.exe screen.uni');
  SwapVectors}
end;