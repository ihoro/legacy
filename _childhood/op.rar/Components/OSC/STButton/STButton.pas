unit STButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TSTButton = class(TCustomControl)
  private
    FCaption: string;
    FFont: TFont;
    FAddLeft: Byte;
    FAddRight: Byte;
    FAddTop: Byte;
    FAddBottom: Byte;
    FFocusColor: TColor;
    FClickColor: TColor;
    FTimer: TTimer;
    FHere: Boolean;
    procedure DoTimer(Sender: TObject);
    procedure WriteCaption(Mode: Byte);
  protected
    procedure Paint; override;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property Caption: string read FCaption write FCaption;
    property Font: TFont read FFont write FFont;
    property AddLeft: Byte read FAddLeft write FAddLeft;
    property AddRight: Byte read FAddRight write FAddRight;
    property AddTop: Byte read FAddTop write FAddTop;
    property AddBottom: Byte read FAddBottom write FAddBottom;
    property FocusColor: TColor read FFocusColor write FFocusColor;
    property ClickColor: TColor read FClickColor write FClickColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OSC', [TSTButton]);
end;

{ TSTButton }

constructor TSTButton.Create(AOwner: TComponent);
begin
  inherited;
  FFont:=TFont.Create;
  FTimer:=TTimer.Create(Self);
  FTimer.Interval:=1;
  FTimer.OnTimer:=DoTimer;
  FAddLeft:=2;
  FAddRight:=2;
  FAddTop:=2;
  FAddBottom:=2;
  FFocusColor:=clOlive;
  FClickColor:=clRed
end;

destructor TSTButton.Destroy;
begin
  FTimer.Free;
  FFont.Free;
  inherited
end;

procedure TSTButton.DoTimer(Sender: TObject);
var
  cp, co: TPoint;
begin
  GetCursorPos(cp);
  co:=ClientOrigin;
  with cp do
    if (x>=co.x) and (x<=co.x+Width-1) and
      (y>=co.y) and (y<=co.y+Height-1) then FHere:=true
                                       else FHere:=false
end;

procedure TSTButton.Paint;
begin
  with Canvas do
    begin
      if (csLButtonDown in ControlState) and FHere then
        begin
          Pen.Color:=clBlack;
          MoveTo(0,0);
          LineTo(Width-1,0);
          MoveTo(0,0);
          LineTo(0,Height-1);
          Pen.Color:=clGray;
          MoveTo(1,1);
          LineTo(Width-2,1);
          MoveTo(1,1);
          LineTo(1,Height-2);
          Pen.Color:=cl3DLight;
          MoveTo(0,Height-1);
          LineTo(Width,Height-1);
          MoveTo(Width-1,0);
          LineTo(Width-1,Height-1);
          Pen.Color:=clWhite;
          MoveTo(1,Height-2);
          LineTo(Width-1,Height-2);
          MoveTo(Width-2,1);
          LineTo(Width-2,Height-1);
          Brush.Color:=clBtnFace;
          Brush.Style:=bsSolid;
          FillRect(Rect(2,2,Width-3,Height-3));
          WriteCaption(2)
        end
                                       else
        begin
          Pen.Color:=clWhite;
          MoveTo(0,0);
          LineTo(Width-1,0);
          MoveTo(0,0);
          LineTo(0,Height-1);
          Pen.Color:=cl3DLight;
          MoveTo(1,1);
          LineTo(Width-2,1);
          MoveTo(1,1);
          LineTo(1,Height-2);
          Pen.Color:=clBlack;
          MoveTo(0,Height-1);
          LineTo(Width,Height-1);
          MoveTo(Width-1,0);
          LineTo(Width-1,Height-1);
          Pen.Color:=clGray;
          MoveTo(1,Height-2);
          LineTo(Width-1,Height-2);
          MoveTo(Width-2,1);
          LineTo(Width-2,Height-1);
          Brush.Color:=clBtnFace;
          Brush.Style:=bsSolid;
          FillRect(Rect(2,2,Width-3,Height-3));
          if FHere then WriteCaption(1)
                   else WriteCaption(0)
        end
    end
end;

procedure TSTButton.WriteCaption(Mode: Byte);
var
  sx, sy: Integer;
begin
  with Canvas do
    begin
      Font:=FFont;
      sx:=Width div 2-TextWidth(FCaption) div 2;
      sy:=Height div 2-TextHeight(FCaption) div 2;
      case Mode of
        0:TextOut(sx,sy,FCaption)
      end
    end
end;

end.
