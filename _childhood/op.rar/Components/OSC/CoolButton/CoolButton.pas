unit CoolButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, MMSystem, OpenGL;

type
  TAnimateStyle = (asHorizontalRotate,asVerticalRotate);

  TAnimate = class(TPersistent)
  private
    FWidthZ: Real;
    FVisible: Boolean;
    FAlways: Boolean;
    FStyle: TAnimateStyle;
    FBackgroundColor: TColor;
  published
    property WidthZ: Real read FWidthZ write FWidthZ;
    property Visible: Boolean read FVisible write FVisible;
    property Always: Boolean read FAlways write FAlways;
    property Style: TAnimateStyle read FStyle write FStyle;
    property BackgroundColor: TColor read FBackgroundColor
      write FBackgroundColor;
  end;

  TCoolButton = class(TButton)
  private
    FAnimate: TAnimate;
    FFont: TFont;
    FFontChanged: Boolean;
    Fdc: HDC;
    Fhrc: HGLRC;
    FAngle: GLFloat;
    FmColor: array[0..3] of GLFloat;
    //FuTimerID: uint;
    FTimer: TTimer;
    Fps: TPaintStruct;
    procedure Initial;
    procedure ChangeFont;
    procedure SetAnimate(Value: TAnimate);
    procedure SetFont(Value: TFont);
    procedure DoTimer(Sender: TObject);
    procedure WMPaint(var Msg: TMsg); message WM_Paint;
    procedure WMCreate(var Msg: TMsg); message WM_Create;
    procedure WMDestroy(var Msg: TMsg); message WM_Destroy;
    procedure WMSize(var Msg: TMsg); message WM_Size;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
    property Animate: TAnimate read FAnimate write SetAnimate;
    property Font: TFont read FFont write SetFont;
    { Published declarations }
  end;

const
  StartList = 1000;
  Factor = 0.41;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OSC', [TCoolButton]);
end;

{procedure FNTimeCallBack(uTimerID, uMessage: UINT;dwUser, dw1, dw2: DWORD) stdcall;
begin
end;}

{ TCoolButton }

procedure TCoolButton.ChangeFont;
var
  OldFont: HFont;
  agmf: array[0..255] of TGlyphMetricsFloat;
begin
  OldFont:=SelectObject(Fdc,FFont.Handle);
  wglUseFontOutlines(Fdc,0,255,StartList,0,FAnimate.WidthZ,
    WGL_Font_Polygons,@agmf);
  DeleteObject(SelectObject(Fdc,OldFont));
  FmColor[0]:=GetRValue(ColorToRGB(FFont.Color))/255;
  FmColor[1]:=GetGValue(ColorToRGB(FFont.Color))/255;
  FmColor[2]:=GetBValue(ColorToRGB(FFont.Color))/255;
  FmColor[3]:=1
end;

constructor TCoolButton.Create(AOwner: TComponent);
begin
  inherited;
  FAngle:=0;
  FAnimate:=TAnimate.Create;
  FAnimate.Visible:=true;
  FAnimate.WidthZ:=0.2;
  FAnimate.BackgroundColor:=clSilver;
  FFont:=TFont.Create;
  FFont.Color:=clGreen;
  FFont.Charset:=Default_Charset;
  FFont.Height:=-11;
  FFont.Name:='Arial';
  FFont.Pitch:=fpDefault;
  FFont.Size:=11;
  FFontChanged:=false
end;

procedure TCoolButton.Initial;
var
  PixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  Fdc:=GetDC(Handle);
  // PixelFormatDescriptor...
  FillChar(pfd,SizeOf(pfd),0);
  with pfd do
    begin
      nSize:=SizeOf(pfd);
      nVersion:=1;
      dwFlags:=PFD_DRAW_TO_WINDOW or
        PFD_SUPPORT_OPENGL or
        PFD_DOUBLEBUFFER;
      iPixelType:=PFD_TYPE_RGBA;
      cColorBits:=24;
      cDepthBits:=32;
      iLayerType:=PFD_MAIN_PLANE
    end;
  PixelFormat:=ChoosePixelFormat(Fdc,@pfd);
  SetPixelFormat(Fdc,PixelFormat,@pfd);
  // Rendering context...
  Fhrc:=wglCreateContext(Fdc);
  wglMakeCurrent(Fdc,Fhrc);
  // Font...
  ChangeFont;
  // Settings...
  glEnable(gl_Depth_Test);
  glEnable(gl_Lighting);
  glEnable(gl_Light0);
  // Timer...
  FTimer:=TTimer.Create(Self);
  FTimer.Interval:=1;
  FTimer.OnTimer:=DoTimer;
  FTimer.Enabled:=true
  {FuTimerID:=TimeSetEvent(1,0,@FNTimeCallBack,0,TIME_PERIODIC)}
end;

procedure TCoolButton.SetAnimate(Value: TAnimate);
begin
  FAnimate:=Value
end;

procedure TCoolButton.SetFont(Value: TFont);
begin
  FFont:=Value;
//  ChangeFont;
  FFontChanged:=true
end;

procedure TCoolButton.DoTimer(Sender: TObject);
begin
  if Animate.Visible then
    begin
      FAngle:=FAngle+10;
      if FAngle>=360 then FAngle:=0;
      InvalidateRect(Handle,nil,false)
    end
end;

procedure TCoolButton.WMCreate(var Msg: TMsg);
begin
  Initial
end;

procedure TCoolButton.WMSize(var Msg: TMsg);
begin
  glMatrixMode(gl_Projection);
  glLoadIdentity;
  gluPerspective(30,Width/Height,1,30);
  glViewport(0,0,Width,Height);
  glMatrixMode(gl_ModelView)
end;

procedure TCoolButton.WMPaint(var Msg: TMsg);
begin
  (*  if FFontChanged then
    begin
      {wglMakeCurrent(Fdc,0);
      wglDeleteContext(Fhrc);
      ReleaseDC(Handle,Fdc);}
      glDeleteLists(StartList,256);
      {FTimer.Free;
      Initial;}
      ChangeFont;
      FFontChanged:=false
    end;*)
  BeginPaint(Handle,Fps);
  glClearColor(
    GetRValue(ColorToRGB(FAnimate.BackgroundColor))/255,
    GetGValue(ColorToRGB(FAnimate.BackgroundColor))/255,
    GetBValue(ColorToRGB(FAnimate.BackgroundColor))/255,
    1.0);
  glClear(gl_Color_Buffer_Bit or gl_Depth_Buffer_Bit);
  glLoadIdentity;
  glTranslatef(0,0,FFont.Height/4);
  if FAnimate.Style=asVerticalRotate then
    glRotatef(FAngle,1,0,0);
  if FAnimate.Style=asHorizontalRotate then
    glRotatef(FAngle,0,1,0);
  glMaterialfv(gl_Front,gl_Ambient_and_Diffuse,@FmColor);
  // Out text...
  glListBase(StartList);
  glTranslatef(-Length(Caption)/2*Factor,-Factor,0);
  glCallLists(Length(Caption),gl_unsigned_byte,PChar(Caption));
  // End paint...
  SwapBuffers(Fdc);
  EndPaint(Handle,Fps)
end;

procedure TCoolButton.WMDestroy(var Msg: TMsg);
begin
  //  timeKillEvent(FuTimerID);
  FTimer.Enabled:=false;
  wglMakeCurrent(Fdc,0);
  wglDeleteContext(Fhrc);
  ReleaseDC(Handle,Fdc);
  glDeleteLists(StartList,256);
  FAnimate.Free;
  FFont.Free;
end;

end.
