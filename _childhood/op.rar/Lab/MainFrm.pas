unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, OpenGL, MMSystem, ExtCtrls;

const
  MaxMap = 100;
  WallH = 1;
  StartColor = clYellow;
  FinishColor = clRed;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    New1: TMenuItem;
    mmiNew: TMenuItem;
    odMap: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure mmiNewClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    dc: HDC;
    hrc: HGLRC;
    TimerID: uint;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  ax = 0.4;
  dx = 0.4;

var
  MainForm: TMainForm;
  MapX: Word;
  MapY: Word;
  Map: array[1..MaxMap,1..MaxMap] of Integer;
  x,z: GLFloat;
  StartX, StartY,
  FinishX, FinishY: Word;
  Angle,Drive: GLFloat;

implementation

{$R *.DFM}

procedure OnTime(uTimerID,uMessage: uint;dwUser,dw1,dw2: DWORD); stdcall;
begin
{  with MainForm do
    begin
      InvalidateRect(Handle,nil,false)
    end}
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  pfd: TPixelFormatDescriptor;
  pf: Integer;
begin
  dc:=GetDC(Handle);
  FillChar(pfd,SizeOf(pfd),0);
  pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pf:=ChoosePixelFormat(dc,@pfd);
  SetPixelFormat(dc,pf,@pfd);
  hrc:=wglCreateContext(dc);
  wglMakeCurrent(dc,hrc);
  glEnable(gl_Depth_Test);
  glEnable(gl_Lighting);
  glEnable(gl_Color_Material);
  glEnable(gl_Light0);
  glClearColor(0,0,0,1);
  Angle:=0;
  Drive:=0;
  TimerID:=timeSetEvent(2,0,@OnTime,0,Time_Periodic);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  timeKillEvent(TimerID);
  wglMakeCurrent(0,0);
  wglDeleteContext(hrc);
  ReleaseDC(Handle,dc);
  DeleteDC(dc)
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  glMatrixMode(gl_Projection);
  glLoadIdentity;
  glViewPort(0,0,ClientWidth,ClientHeight);
  gluPerspective(70,ClientWidth/ClientHeight,1,20);
  glMatrixMode(gl_ModelView);
  glLoadIdentity;
  InvalidateRect(Handle,nil,false)
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  f,l,p11,p12,p21,p22,c1,c2: Integer;
  First1,First2: Boolean;
  pos: array[0..3] of GLFloat;
begin
//  glPushMatrix;
  glLoadIdentity;
  glClear(gl_Color_Buffer_Bit or gl_Depth_Buffer_Bit);
  pos[0]:=0;
  pos[1]:=0.5;
  pos[2]:=-0.5;
  pos[3]:=1;
  glLightfv(gl_Light0,gl_Position,@pos);
  glTranslatef(0,0,-10);
  glRotatef(20,1,0,0);
  glRotatef(5,0,1,0);
  glTranslatef(-Angle,2.5,-Drive);
//  glRotatef(Angle,0,1,0);
//  MapX:=10; MapY:=10;
  glBegin(gl_Quads);
    glColor3f(0,0,1);
    glNormal3f(0,1,0);
    glVertex3f(0,0,0);
    glVertex3f(MapX,0,0);
    glVertex3f(MapX,0,MapY);
    glVertex3f(0,0,MapY);
  glEnd;
 { x:=2; z:=3;
  gluLookAt(x,0.1,z,x,0.1,z-1,0,0,1);}
  for f:=1 to MapX do
    begin
      First1:=true; First2:=true;
      for l:=1 to MapY do
        begin
          // left...
          if (Map[f,l]<>clWhite) and ((f=1) or (Map[f-1,l]=clWhite)) then
            if First1 then
              begin
                First1:=false;
                c1:=Map[f,l];
                p11:=l
              end;
          if (Map[f,l]=clWhite) or ((Map[f,l]<>clWhite) and (f<>1) and (Map[f-1,l]<>clWhite))
            or (Map[f,l]<>c1) or (l=MapY) then
            if not First1 then
              begin
                First1:=true;
                p12:=l;
                if l=MapY then inc(p12);
//                c1:=clRed;
                glBegin(gl_Quads);
                  glColor3f(GetRValue(ColorToRGB(c1))/255,
                            GetGValue(ColorToRGB(c1))/255,
                            GetBValue(ColorToRGB(c1))/255);
                  glNormal3f(-1,0,0);
                  glVertex3f(f-1,0,p11-1);
                  glVertex3f(f-1,WallH,p11-1);
                  glVertex3f(f-1,WallH,p12-1);
                  glVertex3f(f-1,0,p12-1);
                glEnd
              end;
          // right...
          if (Map[f,l]<>clWhite) and ((f=MapX) or (Map[f+1,l]=clWhite)) then
            if First2 then
              begin
                First2:=false;
                c2:=Map[f,l];
                p21:=l
              end;
          if (Map[f,l]=clWhite) or ((Map[f,l]<>clWhite) and (f<>MapX) and (Map[f+1,l]<>clWhite))
            or (Map[f,l]<>c2) or (l=MapY) then
            if not First2 then
              begin
                First2:=true;
                p22:=l;
                if l=MapY then inc(p22);
//                c2:=clGreen;
                glBegin(gl_Quads);
                  glColor3f(GetRValue(ColorToRGB(c2))/255,
                            GetGValue(ColorToRGB(c2))/255,
                            GetBValue(ColorToRGB(c2))/255);
                  glNormal3f(1,0,0);
                  glVertex3f(f,0,p21-1);
                  glVertex3f(f,0,p22-1);
                  glVertex3f(f,WallH,p22-1);
                  glVertex3f(f,WallH,p21-1);
                glEnd
              end
        end
    end;
  for l:=1 to MapY do
    begin
      First1:=true; First2:=true;
      for f:=1 to MapX do
        begin
          // back...
          if (Map[f,l]<>clWhite) and ((l=1) or (Map[f,l-1]=clWhite)) then
            if First1 then
              begin
                First1:=false;
                c1:=Map[f,l];
                p11:=f
              end;
          if (Map[f,l]=clWhite) or ((Map[f,l]<>clWhite) and (l<>1) and (Map[f,l-1]<>clWhite))
            or (Map[f,l]<>c1) or (f=MapX) then
            if not First1 then
              begin
                First1:=true;
                p12:=f;
                if f=MapX then inc(p12);
//                c1:=clYellow;
                glBegin(gl_Quads);
                  glColor3f(GetRValue(ColorToRGB(c1))/255,
                            GetGValue(ColorToRGB(c1))/255,
                            GetBValue(ColorToRGB(c1))/255);
                  glNormal3f(0,0,-1);
                  glVertex3f(p11-1,0,l-1);
                  glVertex3f(p11-1,WallH,l-1);
                  glVertex3f(p12-1,WallH,l-1);
                  glVertex3f(p12-1,0,l-1);
                glEnd
              end;
          // front...
          if (Map[f,l]<>clWhite) and ((l=MapY) or (Map[f,l+1]=clWhite)) then
            if First2 then
              begin
                First2:=false;
                c2:=Map[f,l];
                p21:=f
              end;
          if (Map[f,l]=clWhite) or ((Map[f,l]<>clWhite) and (l<>MapY) and (Map[f,l+1]<>clWhite))
            or (Map[f,l]<>c2) or (f=MapX) then
            if not First2 then
              begin
                First2:=true;
                p22:=f;
                if f=MapX then inc(p22);
//                c2:=clWhite;
                glBegin(gl_Quads);
                  glColor3f(GetRValue(ColorToRGB(c2))/255,
                            GetGValue(ColorToRGB(c2))/255,
                            GetBValue(ColorToRGB(c2))/255);
                  glNormal3f(0,0,1);
                  glVertex3f(p21-1,0,l);
                  glVertex3f(p21-1,WallH,l);
                  glVertex3f(p22-1,WallH,l);
                  glVertex3f(p22-1,0,l);
                glEnd
              end
        end
    end;
//  gluLookAt(x,0.1,z,x,0.1,z-1,0,0,1);
//  glTranslatef(x,0,z);
  {glBegin(gl_Quads);
    glColor3f(0,1,0);
    glVertex3f(-1,-1,0);
    glVertex3f(-1,1,0);
    glVertex3f(1,1,0);
    glVertex3f(1,-1,0);
  glEnd;}
//  glPopMatrix;
  SwapBuffers(dc)
end;

procedure TMainForm.mmiNewClick(Sender: TObject);
var
  b: TBitmap;
  f,l: Integer;
begin
  if odMap.Execute then
    begin
      b:=TBitmap.Create;
      b.LoadFromFile(odMap.FileName);
      MapX:=b.Width;
      MapY:=b.Height;
      for l:=1 to b.Height do
        for f:=1 to b.Width do
          begin
            Map[f,l]:=b.Canvas.Pixels[f-1,l-1];
            case Map[f,l] of
              StartColor:begin
                Map[f,l]:=clWhite;
                StartX:=f;
                StartY:=l
              end;
              FinishColor:begin
                Map[f,l]:=clWhite;
                FinishX:=f;
                FinishY:=l
              end
            end
          end;
      b.Free
    end;
  x:=StartX-0.5;
  z:=-StartY+0.5
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    vk_Left:Angle:=Angle-ax;
    vk_Right:Angle:=Angle+ax;
    vk_Up:Drive:=Drive-dx;
    vk_Down:Drive:=Drive+dx
  end;
{  if Angle>=360 then Angle:=0;
  if Angle<=-360 then Angle:=0;}
  InvalidateRect(Handle,nil,false)
end;

end.
