unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, BMPButton, Menus, ImgList, StdCtrls, DXDraws, DXClass;

type
  TMoveSide = (msUp, msRight, msDown, msLeft, msNone);

  TKeys = array[1..4] of Word;

  TPlayer = record
    Life: Integer;
    X: Integer;
    Y: Integer;
    OffsetX: Integer;
    OffsetY: Integer;
    DisplayOffsetX: Integer;
    DisplayOffsetY: Integer;
    MoveSide: TMoveSide;
    OldSide: TMoveSide;
    {MoveType: Byte;
    MoveInc: ShortInt;}
    Keys: TKeys;
  end;

  TMap = array[1..800,1..800] of Byte;

  TDisplay2 = class(TThread)
  protected
    procedure PutDisplay;
    procedure Execute; override;
  end;

  TDoMove = class(TThread)
  protected
    procedure DoM;
    procedure Execute; override;
  end;

  TMain = class(TForm)
    imPlayer1: TImage;
    imPlayer2: TImage;
    Bevel1: TBevel;
    BMPButton1: TBMPButton;
    odMap: TOpenDialog;
    ilLand: TImageList;
    ilPlayer1: TImageList;
    ilPlayer2: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    tmrMain: TTimer;
    DXDraw: TDXDraw;
    DXTimer1: TDXTimer;
    iList: TDXImageList;
    procedure BMPButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrMainTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
  private
    FMapFile: string;
    FPlayer1,
    FPlayer2: TPlayer;
    FMap: TMap;
    FMapWidth,
    FMapHeight: Integer;
    FTemp,
    FTemp2,
    FBMP: TBitmap;
    procedure WriteToBMP;
    procedure UpDateTemp;
    procedure UpDateTemp2;
    procedure UpDateDisplays;
    procedure UpDateDisplay1;
    procedure MovePlayer(var Player: TPlayer;MS: TMoveSide);
    procedure MovePlayer2(var Player: TPlayer;MS: TMoveSide);
    function CheckPlayer1(aSide: TMoveSide): Boolean;
  end;

const
  MaxKeys = 4;
  MoveSpeed = 4;

var
  Main: TMain;
  Display2: TDisplay2;
  DoMove: TDoMove;
  f,l,d: Integer;
  Playing: Boolean;

implementation

{$R *.DFM}

{ TDisplay2 }

procedure TDisplay2.Execute;
begin
  Synchronize(PutDisplay)
end;

procedure TDisplay2.PutDisplay;
begin
  if not Main.DXDraw.CanDraw then Terminate;
  with Main.FPlayer2 do
    begin
      Main.UpDateTemp2;
      case MoveSide of
        msUp:d:=0;
        msRight:d:=1;
        msDown:d:=2;
        msLeft:d:=3;
        msNone:case OldSide of
                 msUp:d:=0;
                 msRight:d:=1;
                 msDown:d:=2;
                 msLeft:d:=3
               end
      end;
      {d:=d+MoveType;}
      Main.ilPlayer2.Draw(Main.FTemp2.Canvas,
        X*32-32+OffsetX-DisplayOffsetX,
        Y*32-32+OffsetY-DisplayOffsetY,
        d);
      case Main.FPlayer1.MoveSide of
        msUp:d:=0;
        msRight:d:=1;
        msDown:d:=2;
        msLeft:d:=3;
        msNone:case Main.FPlayer1.OldSide of
                 msUp:d:=0;
                 msRight:d:=1;
                 msDown:d:=2;
                 msLeft:d:=3
               end
      end;
      {d:=d+Main.FPlayer1.MoveType;}
      with Main.FPlayer1 do
      Main.ilPlayer1.Draw(Main.FTemp2.Canvas,
        X*32-32+OffsetX-Main.FPlayer2.DisplayOffsetX,
        Y*32-32+OffsetY-Main.FPlayer2.DisplayOffsetY,
        d);
      {Main.imgPlayer2.Canvas.Draw(0,0,Main.FTemp2)}
      {BitBlt(Main.imgPlayer2.Canvas.Handle,
        0,0,352,352,
        Main.FTemp2.Canvas.Handle,0,0,SrcCopy)}
      {BitBlt(Main.Canvas.Handle,
        360,56,352,352,
        Main.FTemp2.Canvas.Handle,0,0,SrcCopy);}
      with Main.DXDraw.Surface.Canvas do
        begin
          Draw(352,0,Main.FTemp2);
          Release
        end;
      Main.DXDraw.Flip
    end
end;

{ TDoMove }

procedure TDoMove.Execute;
begin
  Synchronize(DoM)
end;

procedure TDoMove.DoM;
begin
  with Main do
    if FPlayer2.MoveSide<>msNone then
      MovePlayer2(FPlayer2,FPlayer2.MoveSide)
                                 else
      Display2:=TDisplay2.Create(false)
end;

{ TMain }

procedure TMain.BMPButton1Click(Sender: TObject);
var
  MAP: TextFile;
  s: string;
  Err: Integer;
  h: Char;
begin
  if odMap.Execute then
    begin
      FMapFile:=odMap.FileName;
      AssignFile(MAP,FMapFile);
      Reset(MAP);
      readln(MAP,s);
      Val(s,FMapWidth,Err);
      readln(MAP,s);
      Val(s,FMapHeight,Err);
      for l:=1 to FMapHeight do
        for f:=1 to FMapWidth do
          begin
            read(MAP,h);
            Val(h,FMap[f,l],Err)
          end;
      WriteToBMP;
      with FPlayer1 do
        begin
          Life:=100;
          OffsetX:=0;
          OffsetY:=0;
          MoveSide:=msNone;
          OldSide:=msUp;
          {MoveType:=0;
          MoveInc:=1;}
          repeat
            f:=Random(FMapWidth)+1;
            l:=Random(FMapHeight)+1;
          until FMap[f,l]=0;
          X:=f;
          Y:=l;
          DisplayOffsetX:=(X-6)*32;
          DisplayOffsetY:=(Y-6)*32;
          if X<=6 then DisplayOffsetX:=0;
          if Y<=6 then DisplayOffsetY:=0;
          if X>=FMapWidth-5 then
            DisplayOffsetX:=(FMapWidth-11)*32;
          if Y>=FMapHeight-5 then
            DisplayOffsetY:=(FMapHeight-11)*32;
          Label1.Caption:=IntToStr(X);
          Label2.Caption:=IntToStr(Y);
          Label3.Caption:=IntToStr(DisplayOffsetX);
          Label4.Caption:=IntToStr(DisplayOffsetY);
        end;
      with FPlayer2 do
        begin
          Life:=100;
          OffsetX:=0;
          OffsetY:=0;
          MoveSide:=msNone;
          OldSide:=msUp;
          {MoveType:=0;
          MoveInc:=1;}
          repeat
            f:=Random(FMapWidth)+1;
            l:=Random(FMapHeight)+1;
          until (FMap[f,l]=0) and
            ((FPlayer1.X<>f) or
            (FPlayer1.Y<>l));
          X:=f;
          Y:=l;
          DisplayOffsetX:=(X-6)*32;
          DisplayOffsetY:=(Y-6)*32;
          if X<=6 then DisplayOffsetX:=0;
          if Y<=6 then DisplayOffsetY:=0;
          if X>=FMapWidth-5 then
            DisplayOffsetX:=(FMapWidth-11)*32;
          if Y>=FMapHeight-5 then
            DisplayOffsetY:=(FMapHeight-11)*32
        end;
      CloseFile(MAP);
      Playing:=true;
      UpDateDisplays
    end
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  FTemp:=TBitmap.Create;
  FTemp2:=TBitmap.Create;
  FBMP:=TBitmap.Create;
  with FPlayer1 do
    begin
      Keys[1]:=69;
      Keys[2]:=70;
      Keys[3]:=68;
      Keys[4]:=83
    end;
  with FPlayer2 do
    begin
      Keys[1]:=38;
      Keys[2]:=39;
      Keys[3]:=40;
      Keys[4]:=37
    end
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  FTemp.Free;
  FTemp2.Free;
  FBMP.Free
end;

procedure TMain.UpDateTemp;
begin
  FTemp.Width:=352;
  FTemp.Height:=352;
  with FPlayer1 do
    {FBMP.Canvas.CopyRect(Rect(0,0,351,351),FTemp.Canvas,
      Rect(DisplayOffsetX,DisplayOffsetY,
        DisplayOffsetX+351,DisplayOffsetY+351));}
    BitBlt(FTemp.Canvas.Handle,0,0,352,352,FBMP.Canvas.Handle,
      DisplayOffsetX,DisplayOffsetY,SrcCopy);
    {FTemp.Canvas.Draw(-DisplayOffsetX,
      -DisplayOffsetY,FBMP)}
end;

procedure TMain.UpDateDisplays;
begin
  Display2:=TDisplay2.Create(false);
  UpDateDisplay1
end;

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Label1.Caption:=IntToStr(Key);
  Label2.Caption:=IntToStr(FPlayer1.Keys[1]);
  for f:=1 to MaxKeys do
    begin
      if FPlayer1.Keys[f]=Key then
        case f of
          1:begin
              {if FPlayer1.MoveSide=msUp then
                MovePlayer(FPlayer1,msUp);}
              FPlayer1.MoveSide:=msUp
            end;
          2:begin
              {if FPlayer1.MoveSide=msRight then
                MovePlayer(FPlayer1,msRight);}
              FPlayer1.MoveSide:=msRight
            end;
          3:begin
              {if FPlayer1.MoveSide=msDown then
                MovePlayer(FPlayer1,msDown);}
              FPlayer1.MoveSide:=msDown
            end;
          4:begin
              {if FPlayer1.MoveSide=msLeft then
                MovePlayer(FPlayer1,msLeft);}
              FPlayer1.MoveSide:=msLeft
            end
        end;
      if FPlayer2.Keys[f]=Key then
        case f of
          1:begin
              {if FPlayer2.MoveSide=msUp then
                MovePlayer(FPlayer2,msUp);}
              FPlayer2.MoveSide:=msUp
            end;
          2:begin
              {if FPlayer2.MoveSide=msRight then
                MovePlayer(FPlayer2,msRight);}
              FPlayer2.MoveSide:=msRight
            end;
          3:begin
              {if FPlayer2.MoveSide=msDown then
                MovePlayer(FPlayer2,msDown);}
              FPlayer2.MoveSide:=msDown
            end;
          4:begin
              {if FPlayer2.MoveSide=msLeft then
                MovePlayer(FPlayer2,msLeft);}
              FPlayer2.MoveSide:=msLeft
            end
        end
    end
end;

procedure TMain.MovePlayer(var Player: TPlayer;MS: TMoveSide);
begin
  with Player do
    begin
      case MS of
        msUp:begin
               dec(OffsetY,MoveSpeed);
               if OffsetY<0 then
                 begin
                   OffsetY:=31;
                   dec(Y)
                 end;
               if not CheckPlayer1(msUp) then
                 begin
                   dec(DisplayOffsetY,MoveSpeed);
                   if DisplayOffsetY<0 then
                     DisplayOffsetY:=0;
                   if Y>=FMapHeight-5 then
                     DisplayOffsetY:=(FMapHeight-11)*32
                 end
             end;
        msRight:
             begin
               inc(OffsetX,MoveSpeed);
               if OffsetX>31 then
                 begin
                   OffsetX:=0;
                   inc(X)
                 end;
               if not CheckPlayer1(msRight) then
                 begin
                   inc(DisplayOffsetX,MoveSpeed);
                   if DisplayOffsetX>(FMapWidth-11)*32 then
                     DisplayOffsetX:=(FMapWidth-11)*32;
                   if X<=5 then
                     DisplayOffsetX:=0
                 end
             end;
        msDown:begin
               inc(OffsetY,MoveSpeed);
               if OffsetY>31 then
                 begin
                   OffsetY:=0;
                   inc(Y)
                 end;
               inc(DisplayOffsetY,MoveSpeed);
               if DisplayOffsetY>(FMapHeight-11)*32 then
                 DisplayOffsetY:=(FMapHeight-11)*32;
               if Y<=5 then
                 DisplayOffsetY:=0
             end;
        msLeft:
             begin
               dec(OffsetX,MoveSpeed);
               if OffsetX<0 then
                 begin
                   OffsetX:=31;
                   dec(X)
                 end;
               dec(DisplayOffsetX,MoveSpeed);
               if DisplayOffsetX<0 then
                 DisplayOffsetX:=0;
               if X>=FMapWidth-5 then
                 DisplayOffsetX:=(FMapWidth-11)*32
             end
      end
    end;
  UpDateDisplay1
end;

procedure TMain.tmrMainTimer(Sender: TObject);
begin
  {if not Playing then Exit;
  DoMove:=TDoMove.Create(false);
  if FPlayer1.MoveSide<>msNone then
    MovePlayer(FPlayer1,FPlayer1.MoveSide)
                               else
    UpDateDisplay1}
end;

procedure TMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  for f:=1 to MaxKeys do
    begin
      if FPlayer1.Keys[f]=Key then
        begin
          FPlayer1.OldSide:=FPlayer1.MoveSide;
          FPlayer1.MoveSide:=msNone
        end;
      if FPlayer2.Keys[f]=Key then
        begin
          FPlayer2.OldSide:=FPlayer2.MoveSide;
          FPlayer2.MoveSide:=msNone
        end
    end
end;

procedure TMain.UpDateTemp2;
begin
  FTemp2.Width:=352;
  FTemp2.Height:=352;
  with FPlayer2 do
    {FBMP.Canvas.CopyRect(Rect(0,0,351,351),FTemp2.Canvas,
      Rect(DisplayOffsetX,DisplayOffsetY,
        DisplayOffsetX+351,DisplayOffsetY+351));}
    BitBlt(FTemp2.Canvas.Handle,0,0,352,352,FBMP.Canvas.Handle,
      DisplayOffsetX,DisplayOffsetY,SrcCopy);
    {FTemp2.Canvas.Draw(-DisplayOffsetX,
      -DisplayOffsetY,FBMP)}
end;

procedure TMain.WriteToBMP;
begin
  FBMP.Width:=FMapWidth*32;
  FBMP.Height:=FMapHeight*32;
  for l:=1 to FMapHeight do
    for f:=1 to FMapWidth do
      begin
        d:=FMap[f,l];
        if d>4 then d:=0;
        ilLand.Draw(FBMP.Canvas,f*32-32,
          l*32-32,d)
      end
end;

procedure TMain.MovePlayer2(var Player: TPlayer;MS: TMoveSide);
begin
  with Player do
    begin
      {inc(MoveType,MoveInc);
      if MoveType>2 then
        begin
          MoveType:=1;
          MoveInc:=-1
        end;
      if MoveType<0 then
        begin
          MoveType:=1;
          MoveInc:=1
        end;}
      case MS of
        msUp:begin
               dec(OffsetY,MoveSpeed);
               if OffsetY<0 then
                 begin
                   OffsetY:=31;
                   dec(Y)
                 end;
               dec(DisplayOffsetY,MoveSpeed);
               if DisplayOffsetY<0 then
                 DisplayOffsetY:=0;
               if Y>=FMapHeight-5 then
                 DisplayOffsetY:=(FMapHeight-11)*32
             end;
        msRight:
             begin
               inc(OffsetX,MoveSpeed);
               if OffsetX>31 then
                 begin
                   OffsetX:=0;
                   inc(X)
                 end;
               inc(DisplayOffsetX,MoveSpeed);
               if DisplayOffsetX>(FMapWidth-11)*32 then
                 DisplayOffsetX:=(FMapWidth-11)*32;
               if X<=5 then
                 DisplayOffsetX:=0
             end;
        msDown:begin
               inc(OffsetY,MoveSpeed);
               if OffsetY>31 then
                 begin
                   OffsetY:=0;
                   inc(Y)
                 end;
               inc(DisplayOffsetY,MoveSpeed);
               if DisplayOffsetY>(FMapHeight-11)*32 then
                 DisplayOffsetY:=(FMapHeight-11)*32;
               if Y<=5 then
                 DisplayOffsetY:=0
             end;
        msLeft:
             begin
               dec(OffsetX,MoveSpeed);
               if OffsetX<0 then
                 begin
                   OffsetX:=31;
                   dec(X)
                 end;
               dec(DisplayOffsetX,MoveSpeed);
               if DisplayOffsetX<0 then
                 DisplayOffsetX:=0;
               if X>=FMapWidth-5 then
                 DisplayOffsetX:=(FMapWidth-11)*32
             end
      end
    end;
  {UpDateDisplay1}
  {Display2:=TDisplay2.Create(false)}
end;

procedure TMain.UpDateDisplay1;
begin
  if not DXDraw.CanDraw then Exit;
  with FPlayer1 do
    begin
      {UpDateTemp;}
      DXDraw.Surface.Canvas.Draw(-DisplayOffsetX,-DisplayOffsetY,FBMP);
      case MoveSide of
        msUp:d:=0;
        msRight:d:=1;
        msDown:d:=2;
        msLeft:d:=3;
        msNone:case OldSide of
                 msUp:d:=0;
                 msRight:d:=1;
                 msDown:d:=2;
                 msLeft:d:=3
               end
      end;
      {d:=d+MoveType;}
      ilPlayer1.Draw(FTemp.Canvas,
        X*32-32+OffsetX-DisplayOffsetX,
        Y*32-32+OffsetY-DisplayOffsetY,
        d);
      {iList.Items[d].Draw(DXDraw.Surface,
        X*32-32+OffsetX-DisplayOffsetX,
        Y*32-32+OffsetY-DisplayOffsetY,0);}
      case FPlayer2.MoveSide of
        msUp:d:=0;
        msRight:d:=1;
        msDown:d:=2;
        msLeft:d:=3;
        msNone:case FPlayer2.OldSide of
                 msUp:d:=0;
                 msRight:d:=1;
                 msDown:d:=2;
                 msLeft:d:=3
               end;
      end;
      {d:=d+FPlayer2.MoveType;}
      ilPlayer2.Draw(FTemp.Canvas,
        FPlayer2.X*32-32+FPlayer2.OffsetX-DisplayOffsetX,
        FPlayer2.Y*32-32+FPlayer2.OffsetY-DisplayOffsetY,
        d);
      {imgPlayer1.Canvas.Draw(0,0,FTemp)}
      {BitBlt(imgPlayer1.Canvas.Handle,
        0,0,352,352,

        FTemp.Canvas.Handle,0,0,SrcCopy);}
      {BitBlt(Canvas.Handle,
        0,56,352,352,
        FTemp.Canvas.Handle,0,0,SrcCopy);}
      with DXDraw.Surface.Canvas do
        begin
          Draw(0,0,FTemp);
          Release
        end;
      DXDraw.Flip
      {imgPlayer1.Picture.Assign(FTemp)}
    end
end;

function  TMain.CheckPlayer1(aSide: TMoveSide): Boolean;
var
  f,l: Integer;
begin
  Result:=false;
  with FPlayer1 do
    begin
      case aSide of
        msUp:
          begin
            l:=Y*32-32+OffsetY;
            for f:=X*32-32+OffsetX to X*32-1+OffsetX do
              if FMap[f div 32+1,l div 32+1]=1 then
                begin
                  inc(OffsetY,MoveSpeed);
                  if OffsetY>31 then
                    begin
                      OffsetY:=0;
                      inc(Y)
                    end;
                  Result:=true;
                  Break
                end
          end;
        msRight:
          begin
            f:=X*32-1+OffsetX;
            for l:=Y*32-32+OffsetY to Y*32-1+OffsetY do
              if FMap[f div 32+1,l div 32+1]=1 then
                begin
                  dec(OffsetX,MoveSpeed);
                  if OffsetX<0 then
                    begin
                      OffsetX:=31;
                      dec(X)
                    end;
                  Result:=true;
                  Break
                end
          end;
        msDown:
          begin
            l:=Y*32-32+OffsetY;
            for f:=X*32-32+OffsetX to X*32-1+OffsetX do
              if FMap[f div 32+1,l div 32+1]=1 then
                begin
                  dec(OffsetY,MoveSpeed);
                  if OffsetY<0 then
                    begin
                      OffsetY:=31;
                      dec(Y)
                    end;
                  Result:=true;
                  Break
                end
          end;
        msLeft:
          begin
            f:=X*32-32+OffsetX;
            for l:=Y*32-32+OffsetY to Y*32-1+OffsetY do
              if FMap[f div 32+1,l div 32+1]=1 then
                begin
                  inc(OffsetX,MoveSpeed);
                  if OffsetX>31 then
                    begin
                      OffsetX:=0;
                      inc(X)
                    end;
                  Result:=true;
                  Break
                end
          end;
      end;
    end
end;

procedure TMain.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then Exit;
  if not Playing then Exit;
  {DoMove:=TDoMove.Create(false);}
  if FPlayer1.MoveSide<>msNone then
    MovePlayer(FPlayer1,FPlayer1.MoveSide)
                               else
    UpDateDisplay1
end;

procedure TMain.DXDrawFinalize(Sender: TObject);
begin
  DXTimer1.Enabled:=false
end;

procedure TMain.DXDrawInitialize(Sender: TObject);
begin
  DXTimer1.Enabled:=true
end;

end.
