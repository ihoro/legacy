unit BMPButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TBMP = type string;

  TBMPButton = class(TCustomControl)
  private
    FTimer: TTimer;
    FBMP1: TImage;
    FBMP2: TImage;
    FBMP3: TImage;
    FFirst: Boolean;
    FSecond: Boolean;
    FThird: Boolean;
    FFocusing: Byte;
    FNormalBMP: TBMP;
    FFocusedBMP: TBMP;
    FPushedBMP: TBMP;
    FPushing: Boolean;
    FClick,
    FDblClick: TNotifyEvent;
    FDragDrop: TDragDropEvent;
    FDragOver: TDragOverEvent;
    FMouseDown: TMouseEvent;
    FMouseMove: TMouseMoveEvent;
    FMouseUp: TMouseEvent;
    FStartDrag: TStartDragEvent;
    procedure SetNormalBMP(aValue: TBMP);
    procedure SetFocusedBMP(aValue: TBMP);
    procedure SetPushedBMP(aValue: TBMP);
    procedure FTimerTimer(Sender: TObject);
    { Private declarations }
  protected
    procedure Paint; override;
    procedure Click; override;
    procedure DblClick; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState;
      X: Integer;Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton;Shift: TShiftState;
      X: Integer;Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;  
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;
    { Public declarations }
  published
    property NormalBMP: TBMP read FNormalBMP
      write SetNormalBMP;
    property FocusedBMP: TBMP read FFocusedBMP
      write SetFocusedBMP;
    property PushedBMP: TBMP read FPushedBMP
      write SetPushedBMP;
    property OnClick: TNotifyEvent read FClick
      write FClick;
    property OnDblClick: TNotifyEvent read FDblClick write FDblClick;
    property OnDragDrop: TDragDropEvent read FDragDrop write FDragDrop;
    property OnDragOver: TDragOverEvent read FDragOver write FDragOver;
    property OnMouseDown: TMouseEvent read FMouseDown write FMouseDown;
    property OnMouseMove: TMouseMoveEvent read FMouseMove write FMouseMove;
    property OnMouseUp: TMouseEvent read FMouseUp write FMouseUp;
    property OnStartDrag: TStartDragEvent read FStartDrag write FStartDrag;  
    { Published declarations }
  end;

implementation

constructor TBMPButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBMP1:=TImage.Create(Self);
  FBMP2:=TImage.Create(Self);
  FBMP3:=TImage.Create(Self);
  FBMP1.AutoSize:=true;
  FBMP2.AutoSize:=true;
  FBMP3.AutoSize:=true;
  FFirst:=false;
  FSecond:=false;
  FThird:=false;
  FPushing:=false;
  FFocusing:=0;
  FTimer:=TTimer.Create(Self);
  with FTimer do
    begin
      Interval:=10;
      OnTimer:=FTimerTimer
    end;
  if not (csDesigning in ComponentState) then
    begin
      Canvas.StretchDraw(ClientRect,FBMP1.Picture.Bitmap);
    end
end;

destructor TBMPButton.Destroy;
begin
  FBMP1.Free;
  FBMP2.Free;
  FBMP3.Free;
  FTimer.Free;
  inherited Destroy
end;

procedure TBMPButton.FTimerTimer(Sender: TObject);
var
  curPos: TPoint;
  objPos: TPoint;
begin
  if FPushing then Exit;
  GetCursorPos(curPos);
  objPos:=ClientToScreen(Point(0,0));
  if (curPos.X>=objPos.X) and (curPos.X<objPos.X+Width)
    and (curPos.Y>=objPos.Y) and (curPos.Y<objPos.Y+Height) then
      begin
        if FFocusing<>1 then
          begin
            FFocusing:=1;
            if FSecond then
              Canvas.StretchDraw(ClientRect,FBMP2.Picture.Bitmap)
          end
      end
                                                            else
      begin
        if FFocusing<>0 then
          begin
            FFocusing:=0;
            if FFirst then
              Canvas.StretchDraw(ClientRect,FBMP1.Picture.Bitmap)
          end
      end;
end;

procedure TBMPButton.SetNormalBMP(aValue: TBMP);
begin
  FFirst:=true;
  FBMP1.Picture.LoadFromFile(aValue);
  if FFocusing=0 then
    Canvas.StretchDraw(ClientRect,FBMP1.Picture.Bitmap);
  FNormalBMP:=aValue
end;

procedure TBMPButton.SetFocusedBMP(aValue: TBMP);
begin
  FSecond:=true;
  FBMP2.Picture.LoadFromFile(aValue);
  if FFocusing=1 then
    Canvas.StretchDraw(ClientRect,FBMP2.Picture.Bitmap);
  FFocusedBMP:=aValue
end;

procedure TBMPButton.SetPushedBMP(aValue: TBMP);
begin
  FThird:=true;
  FBMP3.Picture.LoadFromFile(aValue);
  FPushedBMP:=aValue
end;

procedure TBMPButton.Click;
begin
  if Assigned(FClick) then
    FClick(Self)
end;

procedure TBMPButton.DblClick;
begin
  if Assigned(OnDblClick) then
    OnDblClick(Self)
end;

procedure TBMPButton.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Assigned(OnDragDrop) then
    OnDragDrop(Self,Source,X,Y)
end;

procedure TBMPButton.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(OnDragOver) then
    OnDragOver(Self,Source,X,Y,State,Accept)
end;

procedure TBMPButton.MouseDown(Button: TMouseButton;Shift: TShiftState;
  X: Integer;Y: Integer);
begin
  if Assigned(OnMouseDown) then
    OnMouseDown(Self,Button,Shift,X,Y);
  FPushing:=true;
  if FThird then
    Canvas.StretchDraw(ClientRect,FBMP3.Picture.Bitmap);
  inherited MouseDown(Button,Shift,X,Y)
end;

procedure TBMPButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnMouseMove) then
    OnMouseMove(Self,Shift,X,Y)
end;

procedure TBMPButton.MouseUp(Button: TMouseButton;Shift: TShiftState;
  X: Integer;Y: Integer);
begin
  if Assigned(OnMouseUp) then
    OnMouseUp(Self,Button,Shift,X,Y);
  FPushing:=false;
  FTimerTimer(nil);
  if (FFocusing=0) and FFirst then
    Canvas.StretchDraw(ClientRect,FBMP1.Picture.Bitmap);
  if (FFocusing=1) and FSecond then
    Canvas.StretchDraw(ClientRect,FBMP2.Picture.Bitmap);
  inherited MouseUp(Button,Shift,X,Y)
end;

procedure TBMPButton.DoStartDrag(var DragObject: TDragObject);
begin
  if Assigned(OnStartDrag) then
    OnStartDrag(Self,DragObject)
end;

procedure TBMPButton.Paint;
begin
  case FFocusing of
    0:if FFirst then
        Canvas.StretchDraw(ClientRect,FBMP1.Picture.Bitmap);
    1:if FSecond then
        Canvas.StretchDraw(ClientRect,FBMP2.Picture.Bitmap)
  end
end;

end.
