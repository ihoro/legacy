unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, ToolWin, Menus, Buttons, StdCtrls, ExtCtrls, Spin;

type
  TActionType = (atPoint,atLine,atRect,
    atEllipse,atRoundRect);

  TAction = record
    ActionType: TActionType;
    X1, Y1, X2, Y2,
    PenWidth: Integer;
    PutDel: Boolean
  end;

  TRegionPicture = record
    RealTotalActions: Integer;
    TotalActions: Integer;
    Width: Integer;
    Height: Integer
  end;

  TCurrentState = (csPen,csLine,csRect,
    csEllipse,csRoundRect);

  TMain = class(TForm)
    MainMenu1: TMainMenu;
    mmiFile: TMenuItem;
    mmiNew: TMenuItem;
    mmiOpen: TMenuItem;
    mmiSave: TMenuItem;
    mmiSaveAs: TMenuItem;
    N1: TMenuItem;
    mmiExit: TMenuItem;
    ilFile: TImageList;
    CoolBar1: TCoolBar;
    tbFile: TToolBar;
    tobNew: TToolButton;
    tobOpen: TToolButton;
    tobSave: TToolButton;
    tbUndo: TToolBar;
    ilUndo: TImageList;
    tobUndo: TToolButton;
    tobRedo: TToolButton;
    tbTools: TToolBar;
    ilTools: TImageList;
    tobPen: TToolButton;
    tobLine: TToolButton;
    tobRect: TToolButton;
    tobEllipse: TToolButton;
    tobRoundRect: TToolButton;
    mmiEdit: TMenuItem;
    mmiUndo: TMenuItem;
    mmiRedo: TMenuItem;
    N2: TMenuItem;
    mmiPen: TMenuItem;
    mmiLine: TMenuItem;
    mmiRect: TMenuItem;
    mmiRoundRect: TMenuItem;
    mmiEllipse: TMenuItem;
    sbHorizontal: TScrollBar;
    sbVertical: TScrollBar;
    StatusBar1: TStatusBar;
    mmiSaveCode: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ToolButton1: TToolButton;
    tobCode: TToolButton;
    N4: TMenuItem;
    N5: TMenuItem;
    mmiAbout: TMenuItem;
    SpinEdit1: TSpinEdit;
    procedure mmiPenClick(Sender: TObject);
    procedure mmiLineClick(Sender: TObject);
    procedure mmiRectClick(Sender: TObject);
    procedure mmiEllipseClick(Sender: TObject);
    procedure mmiRoundRectClick(Sender: TObject);
    procedure tobPenClick(Sender: TObject);
    procedure tobLineClick(Sender: TObject);
    procedure tobRectClick(Sender: TObject);
    procedure tobEllipseClick(Sender: TObject);
    procedure tobRoundRectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbHorizontalChange(Sender: TObject);
    procedure sbVerticalChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure CoolBar1Resize(Sender: TObject);
    procedure mmiSaveCodeClick(Sender: TObject);
    procedure tobUndoClick(Sender: TObject);
    procedure mmiUndoClick(Sender: TObject);
    procedure mmiRedoClick(Sender: TObject);
    procedure tobRedoClick(Sender: TObject);
    procedure tobSaveClick(Sender: TObject);
    procedure mmiSaveClick(Sender: TObject);
    procedure mmiSaveAsClick(Sender: TObject);
    procedure tobOpenClick(Sender: TObject);
    procedure mmiOpenClick(Sender: TObject);
    procedure tobNewClick(Sender: TObject);
    procedure mmiNewClick(Sender: TObject);
    procedure tobCodeClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure mmiAboutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmiExitClick(Sender: TObject);
  private
    FTempFile: File of TAction;
    FRegionPicture: TRegionPicture;
    FCenterX, FCenterY: Integer;
    FCurrentState: TCurrentState;
    FCurrentAction,
    FTempAction: TAction;
    FWriting: Boolean;
    FCurrentWidth: Integer;
    FTempPic,
    FTempPic2: TBitmap;
    FFileCode: Text;
    FItsFirst: Boolean;
    FSaved, FNew: Boolean;
    FFileName: string;
    procedure UnCheckAll;
    procedure UnDownAll;
    procedure ClearImage;
    procedure PutAction(aCanvas: TCanvas;Action: TAction);
    procedure SaveAction(Action: TAction);
    procedure ClearTempPic;
    procedure ClearTempPic2;
    procedure PutAll;
    procedure OpenCode;
    procedure CloseCode;
    procedure WriteAction(Action: TAction);
    procedure CombineActions(Action: TAction);
    procedure SaveRegion;
    procedure LoadRegion;
    procedure ChangeName;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  clMainColor = clGray;

var
  Main: TMain;

implementation

uses AboutFrm;

{$R *.DFM}

procedure TMain.UnCheckAll;
begin
  mmiPen.Checked:=false;
  mmiLine.Checked:=false;
  mmiRect.Checked:=false;
  mmiEllipse.Checked:=false;
  mmiRoundRect.Checked:=false
end;

procedure TMain.mmiPenClick(Sender: TObject);
begin
  UnCheckAll;
  FCurrentState:=csPen;
  UnDownAll;
  tobPen.Down:=true;
  mmiPen.Checked:=true;
end;

procedure TMain.mmiLineClick(Sender: TObject);
begin
  UnCheckAll;
  FCurrentState:=csLine;
  UnDownAll;
  tobLine.Down:=true;
  mmiLine.Checked:=true;
end;

procedure TMain.mmiRectClick(Sender: TObject);
begin
  UnCheckAll;
  FCurrentState:=csRect;
  UnDownAll;
  tobRect.Down:=true;
  mmiRect.Checked:=true;
end;

procedure TMain.mmiEllipseClick(Sender: TObject);
begin
  UnCheckAll;
  FCurrentState:=csEllipse;
  UnDownAll;
  tobEllipse.Down:=true;
  mmiEllipse.Checked:=true;
end;

procedure TMain.mmiRoundRectClick(Sender: TObject);
begin
  UnCheckAll;
  FCurrentState:=csRoundRect;
  UnDownAll;
  tobRoundRect.Down:=true;
  mmiRoundRect.Checked:=true;
end;

procedure TMain.tobPenClick(Sender: TObject);
begin
  mmiPenClick(nil)
end;

procedure TMain.tobLineClick(Sender: TObject);
begin
  mmiLineClick(nil)
end;

procedure TMain.tobRectClick(Sender: TObject);
begin
  mmiRectClick(nil)
end;

procedure TMain.tobEllipseClick(Sender: TObject);
begin
  mmiEllipseClick(nil)
end;

procedure TMain.tobRoundRectClick(Sender: TObject);
begin
  mmiRoundRectClick(nil)
end;

procedure TMain.UnDownAll;
begin
  tobPen.Down:=false;
  tobLine.Down:=false;
  tobRect.Down:=false;
  tobEllipse.Down:=false;
  tobRoundRect.Down:=false
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  ClearImage;
  FFileName:='region.rgm';
  ChangeName;
  FSaved:=true;
  FNew:=true;
  FTempPic:=TBitmap.Create;
  FTempPic.Transparent:=false;
  FTempPic2:=TBitmap.Create;
  FTempPic2.Transparent:=false;
  AssignFile(FTempFile,'RegionsMaster.$t$');
  Rewrite(FTempFile);
  FWriting:=false;
  FCurrentWidth:=20;
  SpinEdit1.Value:=FCurrentWidth;
  FCurrentState:=csPen;
  FCenterX:=0;
  FCenterY:=0;
  with FRegionPicture do
    begin
      RealTotalActions:=0;
      TotalActions:=0;
      Width:=3000;
      Height:=3000
    end;
end;

procedure TMain.sbHorizontalChange(Sender: TObject);
begin
  FCenterX:=sbHorizontal.Position;
  PutAll
end;

procedure TMain.sbVerticalChange(Sender: TObject);
begin
  FCenterY:=sbVertical.Position;
  PutAll
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  CloseFile(FTempFile);
  Erase(FTempFile);
  FTempPic.Free;
  FTempPic2.Free
end;

procedure TMain.ClearImage;
begin
  with Canvas do
    begin
      Pen.Color:=clGray;
      Brush.Color:=clWhite;
      FillRect(ClientRect)
    end
end;

procedure TMain.FormResize(Sender: TObject);
begin
  sbHorizontal.PageSize:=ClientWidth;
  sbHorizontal.LargeChange:=ClientWidth;
  sbVertical.PageSize:=ClientHeight-CoolBar1.Height;
  sbVertical.LargeChange:=ClientHeight-CoolBar1.Height;
  Repaint
end;

procedure TMain.PutAction(aCanvas: TCanvas;Action: TAction);
begin
  if Action.PutDel then
    aCanvas.Pen.Color:=clMainColor
                   else
    aCanvas.Pen.Color:=clWhite;
  with aCanvas do
    with Action do
      case Action.ActionType of
        atPoint:begin
          Pen.Width:=PenWidth;
          MoveTo(X1-FCenterX,Y1-FCenterY+CoolBar1.Height);
          LineTo(X1-FCenterX,Y1-FCenterY+CoolBar1.Height)
        end;
        atLine:begin
          Pen.Width:=PenWidth;
          MoveTo(X1-FCenterX,Y1-FCenterY+CoolBar1.Height);
          LineTo(X2-FCenterX,Y2-FCenterY+CoolBar1.Height)
        end;
        atRect:begin
          Pen.Width:=1;
          Brush.Color:=Pen.Color;
          Brush.Style:=bsSolid;
          Rectangle(X1-FCenterX,
            Y1-FCenterY+CoolBar1.Height,
            X2-FCenterX,
            Y2-FCenterY+CoolBar1.Height)
        end;
        atEllipse:begin
          Pen.Width:=1;
          Brush.Color:=Pen.Color;
          Brush.Style:=bsSolid;
          Ellipse(X1-FCenterX,
            Y1-FCenterY+CoolBar1.Height,
            X2-FCenterX,
            Y2-FCenterY+CoolBar1.Height)
        end;
        atRoundRect:begin
          Pen.Width:=1;
          Brush.Color:=Pen.Color;
          Brush.Style:=bsSolid;
          RoundRect(X1-FCenterX,
            Y1-FCenterY+CoolBar1.Height,
            X2-FCenterX,
            Y2-FCenterY+CoolBar1.Height,
            (X2-FCenterX-X1+FCenterX) div 2,
            (Y2-FCenterY-Y1+FCenterY) div 2)
        end
      end
end;

procedure TMain.SaveAction(Action: TAction);
begin
  inc(FRegionPicture.TotalActions);
  if not tobRedo.Enabled then
    inc(FRegionPicture.RealTotalActions);
  seek(FTempFile,FRegionPicture.TotalActions-1);
  write(FTempFile,Action)
end;

procedure TMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbRight) and
    (FRegionPicture.TotalActions=0) then Exit;
  if Button=mbLeft then
    FCurrentAction.PutDel:=true
                   else
    FCurrentAction.PutDel:=false;
  Y:=Y-CoolBar1.Height;
  with Canvas do
    case FCurrentState of
      csPen:begin
        FWriting:=true;
        with FCurrentAction do
          begin
            ActionType:=atPoint;
            X1:=FCenterX+X;
            Y1:=FCenterY+Y;
            X2:=FCenterX+X;
            Y2:=FCenterY+Y;
            PenWidth:=FCurrentWidth
          end;
        SaveAction(FCurrentAction);
        PutAction(Canvas,FCurrentAction);
      end;
      csLine:begin
        FWriting:=true;
        with FCurrentAction do
          begin
            ActionType:=atLine;
            X1:=FCenterX+X;
            Y1:=FCenterY+Y;
            X2:=FCenterX+X;
            Y2:=FCenterY+Y;
            PenWidth:=FCurrentWidth
          end;
        Pen.Width:=FCurrentWidth;
        ClearTempPic;
        FTempPic.Canvas.CopyRect(
          Rect(0,0,FTempPic.Width-1,
          FTempPic.Height-1),
          Main.Canvas,
          Rect(0,0,
          ClientWidth-1,ClientHeight-1-CoolBar1.Height));
        MoveTo(X,Y+CoolBar1.Height);
        LineTo(X,Y+CoolBar1.Height)
      end;
      csRect:begin
        FWriting:=true;
        with FCurrentAction do
          begin
            ActionType:=atRect;
            X1:=FCenterX+X;
            Y1:=FCenterY+Y;
            X2:=FCenterX+X;
            Y2:=FCenterY+Y
          end;
        ClearTempPic;
        FTempPic.Canvas.CopyRect(
          Rect(0,0,FTempPic.Width-1,
          FTempPic.Height-1),
          Main.Canvas,
          Rect(0,0,
          ClientWidth-1,ClientHeight-1-CoolBar1.Height))
      end;
      csEllipse:begin
        FWriting:=true;
        with FCurrentAction do
          begin
            ActionType:=atEllipse;
            X1:=FCenterX+X;
            Y1:=FCenterY+Y;
            X2:=FCenterX+X;
            Y2:=FCenterY+Y
          end;
        ClearTempPic;
        FTempPic.Canvas.CopyRect(
          Rect(0,0,FTempPic.Width-1,
          FTempPic.Height-1),
          Main.Canvas,
          Rect(0,0,
          ClientWidth-1,ClientHeight-1-CoolBar1.Height))
      end;
      csRoundRect:begin
        FWriting:=true;
        with FCurrentAction do
          begin
            ActionType:=atRoundRect;
            X1:=FCenterX+X;
            Y1:=FCenterY+Y;
            X2:=FCenterX+X;
            Y2:=FCenterY+Y
          end;
        ClearTempPic;
        FTempPic.Canvas.CopyRect(
          Rect(0,0,FTempPic.Width-1,
          FTempPic.Height-1),
          Main.Canvas,
          Rect(0,0,
          ClientWidth-1,ClientHeight-1-CoolBar1.Height))
      end
    end
end;

procedure TMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Y:=Y-CoolBar1.Height;
  StatusBar1.Panels[0].Text:=' '+IntToStr(FCenterX+X)
    +': '+IntToStr(FCenterY+Y);
  if not FWriting then Exit;
  case FCurrentState of
    csPen:begin
      with FCurrentAction do
        begin
          ActionType:=atLine;
          X2:=FCenterX+X;
          Y2:=FCenterY+Y
        end;
      PutAction(Canvas,FCurrentAction);
      SaveAction(FCurrentAction);
      with FCurrentAction do
        begin
          X1:=FCenterX+X;
          Y1:=FCenterY+Y
        end
    end;
    csLine, csRect, csEllipse, csRoundRect:
    begin
      ClearTempPic2;
      FTempPic2.Assign(FTempPic);
      with FCurrentAction do
        begin
          X2:=FCenterX+X;
          Y2:=FCenterY+Y
        end;
      PutAction(FTempPic2.Canvas,FCurrentAction);
      Canvas.Draw(0,0,FTempPic2)
    end
  end
end;

procedure TMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  tobUndo.Enabled:=true;
  mmiUndo.Enabled:=true;
  FSaved:=false;
  case FCurrentState of
    csPen:FWriting:=false;
    csLine, csRect, csEllipse, csRoundRect:
    begin
      FWriting:=false;
      SaveAction(FCurrentAction)
    end
  end
end;

procedure TMain.FormPaint(Sender: TObject);
begin
  if FRegionPicture.TotalActions=0 then Exit;
  PutAll
end;

procedure TMain.CoolBar1Resize(Sender: TObject);
begin
  sbHorizontal.PageSize:=ClientWidth;
  sbHorizontal.LargeChange:=ClientWidth;
  sbVertical.PageSize:=ClientHeight-CoolBar1.Height;
  sbVertical.LargeChange:=ClientHeight-CoolBar1.Height;
  Repaint
end;

procedure TMain.ClearTempPic;
begin
  FTempPic.Width:=ClientWidth;
  FTempPic.Height:=ClientHeight-CoolBar1.Height;
  with FTempPic.Canvas do
    begin
      Brush.Color:=clWhite;
      Brush.Style:=bsSolid;
      FillRect(ClientRect)
    end
end;

procedure TMain.ClearTempPic2;
begin
  FTempPic2.Width:=ClientWidth;
  FTempPic2.Height:=ClientHeight-CoolBar1.Height;
  with FTempPic2.Canvas do
    begin
      Brush.Color:=clWhite;
      Brush.Style:=bsSolid;
      FillRect(ClientRect)
    end
end;

procedure TMain.mmiSaveCodeClick(Sender: TObject);
var
  FL: Integer;
begin
  if FRegionPicture.TotalActions=0 then Exit;
  with SaveDialog1 do
    begin
      Filter:='Delphi Source Files|*.pas';
      DefaultExt:='pas';
      FileName:=''
    end;
  if SaveDialog1.Execute then
    begin
      if FileExists(SaveDialog1.FileName) then
        if MessageDlg('Заменить существующий файл?',mtConfirmation,
          [mbYes,mbNo],0)=mrNo then Exit;
      AssignFile(FFileCode,SaveDialog1.FileName);
      OpenCode;
      for FL:=1 to FRegionPicture.TotalActions do
        begin
          seek(FTempFile,FL-1);
          read(FTempFile,FTempAction);
          if FL=1 then FItsFirst:=true
                  else FItsFirst:=false;
          WriteAction(FTempAction);
          if (FL>1) or (FTempAction.ActionType=atLine) then
            CombineActions(FTempAction)
        end;
      CloseCode
    end
end;

procedure TMain.PutAll;
var
  f: Integer;
begin
  ClearTempPic;
  for f:=1 to FRegionPicture.TotalActions do
    begin
      Seek(FTempFile,f-1);
      read(FTempFile,FTempAction);
      PutAction(FTempPic.Canvas,FTempAction)
    end;
  Canvas.Draw(0,0,FTempPic)
end;

procedure TMain.tobUndoClick(Sender: TObject);
begin
  mmiUndoClick(nil)
end;

procedure TMain.mmiUndoClick(Sender: TObject);
begin
  with FRegionPicture do
    begin
      if TotalActions=0 then Exit;
      dec(TotalActions);
      tobRedo.Enabled:=true;
      mmiRedo.Enabled:=true;
      if TotalActions=0 then
        begin
          tobUndo.Enabled:=false;
          mmiUndo.Enabled:=false
        end;
      PutAll
    end
end;

procedure TMain.mmiRedoClick(Sender: TObject);
begin
  with FRegionPicture do
    begin
      inc(TotalActions);
      tobUndo.Enabled:=true;
      mmiUndo.Enabled:=true;
      if TotalActions=RealTotalActions then
        begin
          tobRedo.Enabled:=false;
          mmiRedo.Enabled:=false
        end;
      PutAll
    end
end;

procedure TMain.tobRedoClick(Sender: TObject);
begin
  mmiRedoClick(nil)
end;

procedure TMain.OpenCode;
begin
  Rewrite(FFileCode);
  writeln(FFileCode,'procedure TForm1.FormCreate(Sender: TObject);');
  writeln(FFileCode,'var');
  writeln(FFileCode,'  ResultRegion: THandle;');
  writeln(FFileCode,'  Region: THandle;');
  writeln(FFileCode,'  Points: array[0..3] of TPoint;');
  writeln(FFileCode,'begin')
end;

procedure TMain.CloseCode;
begin
  writeln(FFileCode,'  SetWindowRgn(Handle,ResultRegion,false)');
  writeln(FFileCode,'end.');
  CloseFile(FFileCode)
end;

procedure TMain.WriteAction(Action: TAction);
var
  s, X1s, Y1s, X2s, Y2s,
  PenWidths,
  Xdiv2, Ydiv2: string;
  delX, delY: Integer;
  k: Real;
begin
  if FItsFirst then
    s:='ResultRegion'
                                   else
    s:='Region';
  with Action do
    begin
      X1s:=IntToStr(X1);
      Y1s:=IntToStr(Y1);
      X2s:=IntToStr(X2);
      Y2s:=IntToStr(Y2);
      PenWidths:=IntToStr(PenWidth);
      Xdiv2:=IntToStr(ABS(X2-X1) div 2);
      Ydiv2:=IntToStr(ABS(Y2-Y1) div 2)
    end;
  with Action do
    case ActionType of
      atPoint:begin
        X1s:=IntToStr(X1-(PenWidth div 2));
        Y1s:=IntToStr(Y1-(PenWidth div 2));
        X2s:=IntToStr(X1+(PenWidth div 2));
        Y2s:=IntToStr(Y1+(PenWidth div 2));
        writeln(FFileCode,'  '+s+
          ':=CreateEllipticRgn('+X1s+','
          +Y1s+','+X2s+','+Y2s+');')
      end;
      atLine:begin
        X1s:=IntToStr(X1-(PenWidth div 2));
        Y1s:=IntToStr(Y1-(PenWidth div 2));
        X2s:=IntToStr(X1+(PenWidth div 2));
        Y2s:=IntToStr(Y1+(PenWidth div 2));
        writeln(FFileCode,'  '+s+
          ':=CreateEllipticRgn('+X1s+','
          +Y1s+','+X2s+','+Y2s+');');
        FTempAction.PutDel:=PutDel;
        CombineActions(FTempAction);
        X1s:=IntToStr(X2-(PenWidth div 2));
        Y1s:=IntToStr(Y2-(PenWidth div 2));
        X2s:=IntToStr(X2+(PenWidth div 2));
        Y2s:=IntToStr(Y2+(PenWidth div 2));
        writeln(FFileCode,'  Region'+
          ':=CreateEllipticRgn('+X1s+','
          +Y1s+','+X2s+','+Y2s+');');
        FTempAction.PutDel:=PutDel;
        CombineActions(FTempAction);
        if (X1<>X2) and (Y1<>Y2) then
          k:=SQRT(SQR(PenWidth/2)/(SQR(X2-X1)+SQR(Y2-Y1)));
        delY:=Round(ABS(X2-X1)*k);
        delX:=Round(ABS(Y2-Y1)*k);
        if Y1=Y2 then
          begin
            delX:=0;
            delY:=Round(PenWidth/2)
          end;
        if X1=X2 then
          begin
            delX:=Round(PenWidth/2);
            delY:=0
          end;
        if (X1<X2) and (Y1>=Y2) then
          begin
            X1s:=IntToStr(X1-delX);
            Y1s:=IntToStr(Y1-delY);
            writeln(FFileCode,'  Points[0]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2-delX);
            Y1s:=IntToStr(Y2-delY);
            writeln(FFileCode,'  Points[1]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2+delX);
            Y1s:=IntToStr(Y2+delY);
            writeln(FFileCode,'  Points[2]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X1+delX);
            Y1s:=IntToStr(Y1+delY);
            writeln(FFileCode,'  Points[3]:=Point('+X1s+','
              +Y1s+');')
          end;
        if (X1>=X2) and (Y1>=Y2) then
          begin
            X1s:=IntToStr(X1-delX);
            Y1s:=IntToStr(Y1+delY);
            writeln(FFileCode,'  Points[0]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2-delX);
            Y1s:=IntToStr(Y2+delY);
            writeln(FFileCode,'  Points[1]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2+delX);
            Y1s:=IntToStr(Y2-delY);
            writeln(FFileCode,'  Points[2]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X1+delX);
            Y1s:=IntToStr(Y1-delY);
            writeln(FFileCode,'  Points[3]:=Point('+X1s+','
              +Y1s+');')
          end;
        if (X1>=X2) and (Y1<Y2) then
          begin
            X1s:=IntToStr(X1+delX);
            Y1s:=IntToStr(Y1+delY);
            writeln(FFileCode,'  Points[0]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2+delX);
            Y1s:=IntToStr(Y2+delY);
            writeln(FFileCode,'  Points[1]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2-delX);
            Y1s:=IntToStr(Y2-delY);
            writeln(FFileCode,'  Points[2]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X1-delX);
            Y1s:=IntToStr(Y1-delY);
            writeln(FFileCode,'  Points[3]:=Point('+X1s+','
              +Y1s+');')
          end;
        if (X1<X2) and (Y1<Y2) then
          begin
            X1s:=IntToStr(X1+delX);
            Y1s:=IntToStr(Y1-delY);
            writeln(FFileCode,'  Points[0]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2+delX);
            Y1s:=IntToStr(Y2-delY);
            writeln(FFileCode,'  Points[1]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X2-delX);
            Y1s:=IntToStr(Y2+delY);
            writeln(FFileCode,'  Points[2]:=Point('+X1s+','
              +Y1s+');');
            X1s:=IntToStr(X1-delX);
            Y1s:=IntToStr(Y1+delY);
            writeln(FFileCode,'  Points[3]:=Point('+X1s+','
              +Y1s+');')
          end;
        writeln(FFileCode,'  Region:='+
        'CreatePolygonRgn(Points,4,ALTERNATE);')
      end;
      atRect:writeln(FFileCode,'  '+s+':='+
        'CreateRectRgn('+X1s+','+Y1s+','+X2s+','+Y2s+');');
      atEllipse:writeln(FFileCode,'  '+s+':='+
        'CreateEllipticRgn('+X1s+','+Y1s+','+X2s+','+Y2s+');');
      atRoundRect:writeln(FFileCode,'  '+s+':='+
        'CreateRoundRectRgn('+X1s+','+Y1s+','+X2s+','+Y2s+','+
        Xdiv2+','+Ydiv2+');')
    end
end;

procedure TMain.CombineActions(Action: TAction);
begin
  if Action.PutDel then
    writeln(FFileCode,'  CombineRgn('+
      'ResultRegion,ResultRegion,Region,RGN_OR);')
                   else
    writeln(FFileCode,'  CombineRgn('+
      'ResultRegion,ResultRegion,Region,RGN_DIFF);')
end;

procedure TMain.tobSaveClick(Sender: TObject);
begin
  mmiSaveClick(nil)
end;

procedure TMain.mmiSaveClick(Sender: TObject);
begin
  if FNew then
    begin
      mmiSaveAsClick(nil);
      Exit
    end;
  SaveRegion;
  FSaved:=true
end;

procedure TMain.SaveRegion;
var
  RGM: file of TAction;
  f: Integer;
begin
  AssignFile(RGM,FFileName);
  Rewrite(RGM);
  FTempAction.X1:=FRegionPicture.TotalActions;
  write(RGM,FTempAction);
  for f:=1 to FRegionPicture.TotalActions do
    begin
      Seek(FTempFile,f-1);
      read(FTempFile,FTempAction);
      write(RGM,FTempAction)
    end;
  CloseFile(RGM)
end;

procedure TMain.mmiSaveAsClick(Sender: TObject);
begin
  with SaveDialog1 do
    begin
      Filter:='Regions|*.rgm';
      DefaultExt:='rgm';
      FileName:=FFileName
    end;
  if SaveDialog1.Execute then
    begin
      if FileExists(SaveDialog1.FileName) then
        if MessageDlg('Заменить существующий файл?',
          mtConfirmation,[mbYes,mbNo],0)=mrNo then
          Exit;
      FFileName:=SaveDialog1.FileName;
      ChangeName;
      SaveRegion;
      FNew:=false;
      FSaved:=true
    end
end;

procedure TMain.LoadRegion;
var
  RGM: file of TAction;
  f: Integer;
begin
  AssignFile(RGM,FFileName);
  Reset(RGM);
  read(RGM,FCurrentAction);
  FRegionPicture.TotalActions:=FCurrentAction.X1;
  FRegionPicture.RealTotalActions:=FRegionPicture.TotalActions;
  for f:=1 to FRegionPicture.TotalActions do
    begin
      Seek(RGM,f);
      read(RGM,FTempAction);
      Seek(FTempFile,f-1);
      write(FTempFile,FTempAction)
    end;
  CloseFile(RGM)
end;

procedure TMain.tobOpenClick(Sender: TObject);
begin
  mmiOpenClick(nil)
end;

procedure TMain.mmiOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      if not FSaved then
        case MessageDlg('Сохранить изменения?',mtConfirmation,
          [mbYes,mbNo,mbCancel],0) of
          mrCancel:Exit;
          mrYes:begin
            mmiSaveClick(nil);
            if not FSaved then Exit
          end
        end;
      FFileName:=OpenDialog1.FileName;
      ChangeName;
      LoadRegion;
      PutAll;
      FNew:=false;
      FSaved:=true;
      mmiUndo.Enabled:=true;
      mmiRedo.Enabled:=false;
      tobUndo.Enabled:=true;
      tobRedo.Enabled:=false
    end
end;

procedure TMain.tobNewClick(Sender: TObject);
begin
  mmiNewClick(nil)
end;

procedure TMain.mmiNewClick(Sender: TObject);
begin
  if not FSaved then
    case MessageDlg('Сохранить изменения?',mtConfirmation,
      [mbYes,mbNo,mbCancel],0) of
      mrCancel:Exit;
      mrYes:begin
        mmiSaveClick(nil);
        if not FSaved then Exit
      end
    end;
  FFileName:='region.rgm';
  ChangeName;
  FNew:=true;
  FSaved:=true;
  with FRegionPicture do
    begin
      RealTotalActions:=0;
      TotalActions:=0
    end;
  mmiUndo.Enabled:=false;
  mmiRedo.Enabled:=false;
  tobUndo.Enabled:=false;
  tobRedo.Enabled:=false;
  PutAll
end;

procedure TMain.tobCodeClick(Sender: TObject);
begin
  mmiSaveCodeClick(nil)
end;

procedure TMain.SpinEdit1Change(Sender: TObject);
begin
  with SpinEdit1 do
    begin
      if Text='' then
        Value:=MinValue;
      if Value>MaxValue then
        Value:=MaxValue;
      if Value<MinValue then
        Value:=MinValue;
      FCurrentWidth:=Value
    end;
end;

procedure TMain.mmiAboutClick(Sender: TObject);
begin
  AboutBox.Execute
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=false;
  if not FSaved then
    case MessageDlg('Сохранить изменения?',mtConfirmation,
      [mbYes,mbNo,mbCancel],0) of
      mrCancel:Exit;
      mrYes:begin
        mmiSaveClick(nil);
        if not FSaved then Exit
      end
    end;
  CanClose:=true
end;

procedure TMain.mmiExitClick(Sender: TObject);
begin
  Close
end;

procedure TMain.ChangeName;
begin
  Caption:='Regions Master - '+ExtractFileName(FFileName)
end;

end.
