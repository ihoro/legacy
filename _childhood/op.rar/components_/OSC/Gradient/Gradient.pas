unit Gradient;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TGradientStyle = (gsVertical, gsHorizontal,
    gsRectangle, gsLeftToRightDiagonal,
    gsRightToLeftDiagonal, gsCircle);

  TGradient = class(TPanel)
  private
    FAlignment: TAlignment;
    FAnchors: TAnchors;
    FAutoSize: Boolean;
    FBevelInner: TBevelCut;
    FBevelOuter: TBevelCut;
    FBevelWidth: TBevelWidth;
    FBiDiMode: TBiDiMode;
    FBorderStyle: TBorderStyle;
    FBorderWidth: TBorderWidth;
    FCaption: TCaption;
    FColor: TColor;
    FConstraints: TSizeConstraints;
    FCtl3D: Boolean;
    FFont: TFont;
    FFullRepaint: Boolean;
    FLocked: Boolean;
    FOnResize: TNotifyEvent;
    FOnCanResize: TCanResizeEvent;
    FOnConstrainedResize: TConstrainedResizeEvent;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FOnGetSiteInfo: TGetSiteInfoEvent;
    FFirstColor: TColor;
    FSecondColor: TColor;
    FGradientStyle: TGradientStyle;
    FClick,
    FDblClick: TNotifyEvent;
    FDragDrop: TDragDropEvent;
    FDragOver: TDragOverEvent;
    FMouseDown: TMouseEvent;
    FMouseMove: TMouseMoveEvent;
    FMouseUp: TMouseEvent;
    FStartDrag: TStartDragEvent;
    procedure SetFirstColor(aValue: TColor);
    procedure SetSecondColor(aValue: TColor);
    procedure SetGradientStyle(aValue: TGradientStyle);
    { Private declarations }
  protected
    procedure Click; override;
    procedure DblClick; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    { Public declarations }
  published
    property OnClick: TNotifyEvent read FClick write FClick;
    property OnDblClick: TNotifyEvent read FDblClick write FDblClick;
    property OnDragDrop: TDragDropEvent read FDragDrop write FDragDrop;
    property OnDragOver: TDragOverEvent read FDragOver write FDragOver;
    property OnMouseDown: TMouseEvent read FMouseDown write FMouseDown;
    property OnMouseMove: TMouseMoveEvent read FMouseMove write FMouseMove;
    property OnMouseUp: TMouseEvent read FMouseUp write FMouseUp;
    property OnStartDrag: TStartDragEvent read FStartDrag write FStartDrag;
    property FirstColor: TColor read FFirstColor
      write SetFirstColor;
    property SecondColor: TColor read FSecondColor
      write SetSecondColor;
    property GradientStyle: TGradientStyle read FGradientStyle
      write SetGradientStyle;
    { Hidden properties }
    property Alignment: TAlignment read FAlignment;
    property Anchors: TAnchors read FAnchors;
    property AutoSize: Boolean read FAutoSize;
    property BevelInner: TBevelCut read FBevelInner;
    property BevelOuter: TBevelCut read FBevelOuter;
    property BevelWidth: TBevelWidth read FBevelWidth;
    property BiDiMode: TBiDiMode read FBiDiMode;
    property BorderStyle: TBorderStyle read FBorderStyle;
    property BorderWidth: TBorderWidth read FBorderWidth;
    property Caption: TCaption read FCaption;
    property Color: TColor read FColor;
    property Constraints: TSizeConstraints read FConstraints;
    property Ctl3D: Boolean read FCtl3D;
    property Font: TFont read FFont;
    property FullRepaint: Boolean read FFullRepaint;
    property Locked: Boolean read FLocked;
    property OnResize: TNotifyEvent read FOnResize;
    property OnCanResize: TCanResizeEvent read FOnCanResize;
    property OnConstrainedResize: TConstrainedResizeEvent read FOnConstrainedResize;
    property OnEnter: TNotifyEvent read FOnEnter;
    property OnExit: TNotifyEvent read FOnExit;
    property OnGetSiteInfo: TGetSiteInfoEvent read FOnGetSiteInfo;
    { Published declarations }
  end;

implementation

constructor TGradient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFirstColor:=clBlue;
  FSecondColor:=clYellow;
  FGradientStyle:=gsVertical
end;

procedure TGradient.Paint;
var
  R1, G1, B1,
  R2, G2, B2,
  IncR, IncG, IncB: Real;
  Loop, LoopEnd: Integer;
begin
  R1:=GetRValue(FFirstColor);
  G1:=GetGValue(FFirstColor);
  B1:=GetBValue(FFirstColor);
  R2:=GetRValue(FSecondColor);
  G2:=GetGValue(FSecondColor);
  B2:=GetBValue(FSecondColor);
  case FGradientStyle of
    gsVertical:begin
      IncR:=(R2-R1)/Height;
      IncG:=(G2-G1)/Height;
      IncB:=(B2-B1)/Height;
      LoopEnd:=Height
    end;
    gsHorizontal:begin
      IncR:=(R2-R1)/Width;
      IncG:=(G2-G1)/Width;
      IncB:=(B2-B1)/Width;
      LoopEnd:=Width
    end;
    gsRectangle:begin
      if Width>Height then
        Height:=Width
                      else
        Width:=Height;
      IncR:=(R2-R1)/(Width/2);
      IncG:=(G2-G1)/(Width/2);
      IncB:=(B2-B1)/(Width/2);
      LoopEnd:=Round(Width/2)
    end;
    gsLeftToRightDiagonal,gsRightToLeftDiagonal:
      begin
        if Width>Height then
          Height:=Width
                        else
          Width:=Height;
        LoopEnd:=Width*2;
        IncR:=(R2-R1)/LoopEnd;
        IncG:=(G2-G1)/LoopEnd;
        IncB:=(B2-B1)/LoopEnd
      end;
    gsCircle:begin
      if Width>Height then
        Height:=Width
                      else
        Width:=Height;
      LoopEnd:=Round(SQRT(2)*(Width/2));
      IncR:=(R2-R1)/LoopEnd;
      IncG:=(G2-G1)/LoopEnd;
      IncB:=(B2-B1)/LoopEnd
    end;
  end;
  with Canvas do
    for Loop:=0 to LoopEnd-1 do
      begin
        R1:=R1+IncR;
        G1:=G1+IncG;
        B1:=B1+IncB;
        Pen.Color:=TColor(RGB(Round(R1)
          ,Round(G1),Round(B1)));
        case FGradientStyle of
          gsVertical:begin
            MoveTo(0,Loop);
            LineTo(Width,Loop)
          end;
          gsHorizontal:begin
            MoveTo(Loop,0);
            LineTo(Loop,Height)
          end;
          gsRectangle:
            Rectangle(Loop,Loop,
              Width-1-Loop,
              Width-1-Loop);
          gsLeftToRightDiagonal:begin
            if Width>Loop then
              begin
                MoveTo(0,Loop);
                LineTo(Loop,0)
              end
                          else
              begin
                MoveTo(Loop-Width,Width);
                LineTo(Width,Loop-Width)
              end
          end;
          gsRightToLeftDiagonal:begin
            if Width>Loop then
              begin
                MoveTo(Width-1-Loop,Width);
                LineTo(Width,Width-1-Loop)
              end
                          else
              begin
                MoveTo(0,Width-Loop+Width);
                LineTo(Width-Loop+Width,0)
              end;
          end;
          gsCircle:begin
            Brush.Color:=Pen.Color;
            Ellipse(-LoopEnd+Round(Width/2)+Loop,
              -LoopEnd+Round(Width/2)+Loop,
              Width+LoopEnd-Round(Width/2)-Loop,
              Width+LoopEnd-Round(Width/2)-Loop)
          end
        end
      end
end;

procedure TGradient.SetFirstColor(aValue: TColor);
begin
  FFirstColor:=aValue;
  Repaint
end;

procedure TGradient.SetSecondColor(aValue: TColor);
begin
  FSecondColor:=aValue;
  Repaint
end;

procedure TGradient.SetGradientStyle(aValue: TGradientStyle);
begin
  FGradientStyle:=aValue;
  Repaint
end;

procedure TGradient.Click;
begin
  if Assigned(OnClick) then
    OnClick(Self)
end;

procedure TGradient.DblClick;
begin
  if Assigned(OnDblClick) then
    OnDblClick(Self)
end;

procedure TGradient.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Assigned(OnDragDrop) then
    OnDragDrop(Self,Source,X,Y)
end;

procedure TGradient.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(OnDragOver) then
    OnDragOver(Self,Source,X,Y,State,Accept)
end;

procedure TGradient.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(OnMouseDown) then
    OnMouseDown(Self,Button,Shift,X,Y)
end;

procedure TGradient.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnMouseMove) then
    OnMouseMove(Self,Shift,X,Y)
end;

procedure TGradient.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(OnMouseUp) then
    OnMouseUp(Self,Button,Shift,X,Y)
end;

procedure TGradient.DoStartDrag(var DragObject: TDragObject);
begin
  if Assigned(OnStartDrag) then
    OnStartDrag(Self,DragObject)
end;

end.
