unit main;

interface

Uses TMLiProf, 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ImgList, MPlayer, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    PaintBox1: TImage;
    Timer1: TTimer;
    Click: TMediaPlayer;
    Ding: TMediaPlayer;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Bud: TMediaPlayer;
    Secret1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Cx, Cy, f, x1, y1, x2, y2,
  MainR, ChasR, MinR, ChasS, MinS, SekS: Integer;
  Rolex: TBitmap;
  FixSek, DingDing, FixTime: Word;
  OnOff: Boolean;
  Secret, Mode: Byte;

const
      Clocks = 'clock.bmp';

procedure Cifer;
procedure GetXYOfAlpha(Alpha:Real;Radius:Integer;var X,Y:Integer);
procedure TimerGo;
procedure PaintS(Cx,Cy,X2,Y2: Integer);
procedure SColor(Color: TColor);

implementation

uses setup;

{$R *.DFM}

procedure GetXYOfAlpha(Alpha:Real;Radius:Integer;var X,Y:Integer);
begin
LProfiler.StartFunc(0); Try
Alpha:=Pi/180*Alpha;
X:=Round(cos(Alpha)*Radius);
Y:=Round(sin(Alpha)*Radius)
    Finally LProfiler.EndFunc(0); End;
end;

procedure Cifer;
begin
LProfiler.StartFunc(1); Try
if Mode=0 then Form1.PaintBox1.Picture.Bitmap:=Rolex
          else Form1.PaintBox1.Picture.Bitmap:=Form1.Secret1.Picture.Bitmap;
with Form1 do
 with PaintBox1 do
  with Canvas do
    begin
      Brush.Style:=bsClear;
      Pen.Color:=clYellow;
      Pen.Width:=4;
      Ellipse(Cx-MainR,Cy-MainR,Cx+MainR,Cy+MainR);
      Pen.Width:=3;
      f:=120;
      repeat
      f:=f-30;
      GetXYOfAlpha(f,ChasR,x1,y1);
      GetXYOfAlpha(f,MainR,x2,y2);
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      y1:=-y1; y2:=-y2;
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      x1:=-x1; x2:=-x2;
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      y1:=-y1; y2:=-y2;
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      until f=-30;
      Pen.Width:=1;
      f:=96;
      repeat
      f:=f-6;
      GetXYOfAlpha(f,MinR,x1,y1);
      GetXYOfAlpha(f,MainR,x2,y2);
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      y1:=-y1; y2:=-y2;
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      x1:=-x1; x2:=-x2;
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      y1:=-y1; y2:=-y2;
      MoveTo(Cx+x1,Cy+y1); LineTo(Cx+x2,Cy+y2);
      until f=-6;
    end
    Finally LProfiler.EndFunc(1); End;
end;

procedure SColor(Color: TColor);
begin
LProfiler.StartFunc(2); Try
Form1.PaintBox1.Canvas.Pen.Color:=Color
    Finally LProfiler.EndFunc(2); End;
end;

procedure PaintS(Cx,Cy,X2,Y2: Integer);
begin
LProfiler.StartFunc(3); Try
with Form1 do
 with PaintBox1 do
  with Canvas do
    begin
      MoveTo(Cx,Cy);
      LineTo(X2,Y2)
    end
    Finally LProfiler.EndFunc(3); End;
end;

procedure TimerGo;
var
    Pres: TDateTime;
    Chas, Min, Sek, Sot: Word;
    Alpha: Real;
begin
LProfiler.StartFunc(4); Try
Cifer;
Form1.PaintBox1.Canvas.Font.Name:='Lucida Handwriting';
Form1.PaintBox1.Canvas.Font.Color:=clYellow;
Form1.PaintBox1.Canvas.Font.Style:=[fsBold,fsItalic];
Form1.PaintBox1.Canvas.Font.Size:=12;
Form1.PaintBox1.Canvas.TextOut(Cx-14,Cy-MainR+7,'12');
Form1.PaintBox1.Canvas.TextOut(Cx+MainR-24,Cy-8,'3');
Form1.PaintBox1.Canvas.TextOut(Cx-5,Cy+MainR-24,'6');
Form1.PaintBox1.Canvas.TextOut(Cx-MainR+9,Cy-8,'9');
if SBud then
begin
Chas:=CChas;
if Chas>12 then Chas:=ABS(12-Chas);
Min:=MMin;
case Chas of
0..3:begin
       Alpha:=90-Chas*30;
       Alpha:=Alpha-Min*0.5;
       GetXYOfAlpha(Alpha,SekS,x1,y1);
       x1:=Cx+x1;
       y1:=Cy-y1
     end;
4..6:begin
       Alpha:=(Chas-3)*30;
       Alpha:=Alpha+Min*0.5;
       GetXYOfAlpha(Alpha,SekS,x1,y1);
       x1:=Cx+x1;
       y1:=Cy+y1
     end;
7..9:begin
       Alpha:=90-(Chas-6)*30;
       Alpha:=Alpha-Min*0.5;
       GetXYOfAlpha(Alpha,SekS,x1,y1);
       x1:=Cx-x1;
       y1:=Cy+y1
     end;
10..12:begin
        Alpha:=(Chas-9)*30;
        Alpha:=Alpha+Min*0.5;
        GetXYOfAlpha(Alpha,SekS,x1,y1);
        x1:=Cx-x1;
        y1:=Cy-y1
      end
end;
Form1.PaintBox1.Canvas.Pen.Width:=1;
SColor(clWhite);
PaintS(Cx,Cy,x1,y1)
end;
Pres:=Now;
DecodeTime(Pres,Chas,Min,Sek,Sot);
if SBud and (Chas=CChas) and (Min=MMin) and (Sek=0) then OnOff:=true;
if Min=MMin+1 then OnOff:=false;
if Chas>12 then Chas:=ABS(12-Chas);
case Sek of
0..14:begin
        Alpha:=90-Sek*6;
        GetXYOfAlpha(Alpha,SekS,x1,y1);
        x1:=Cx+x1;
        y1:=Cy-y1
      end;
15..29:begin
         Alpha:=(Sek-15)*6;
         GetXYOfAlpha(Alpha,SekS,x1,y1);
         x1:=Cx+x1;
         y1:=Cy+y1
       end;
30..44:begin
         Alpha:=90-(Sek-30)*6;
         GetXYOfAlpha(Alpha,SekS,x1,y1);
         x1:=Cx-x1;
         y1:=Cy+y1
       end;
45..59:begin
         Alpha:=(Sek-45)*6;
         GetXYOfAlpha(Alpha,SekS,x1,y1);
         x1:=Cx-x1;
         y1:=Cy-y1
       end
end;
SColor(clYellow);
PaintS(Cx,Cy,x1,y1);
case Min of
0..14:begin
        Alpha:=90-Min*6;
        Alpha:=Alpha-Sek*0.1;
        GetXYOfAlpha(Alpha,MinS,x1,y1);
        x1:=Cx+x1;
        y1:=Cy-y1
      end;
15..29:begin
         Alpha:=(Min-15)*6;
         Alpha:=Alpha+Sek*0.1;
         GetXYOfAlpha(Alpha,MinS,x1,y1);
         x1:=Cx+x1;
         y1:=Cy+y1
       end;
30..44:begin
         Alpha:=90-(Min-30)*6;
         Alpha:=Alpha-Sek*0.1;
         GetXYOfAlpha(Alpha,MinS,x1,y1);
         x1:=Cx-x1;
         y1:=Cy+y1
       end;
45..59:begin
         Alpha:=(Min-45)*6;
         Alpha:=Alpha+Sek*0.1;
         GetXYOfAlpha(Alpha,MinS,x1,y1);
         x1:=Cx-x1;
         y1:=Cy-y1
       end
end;
Form1.PaintBox1.Canvas.Pen.Width:=3;
PaintS(Cx,Cy,x1,y1);
case Chas of
0..3:begin
       Alpha:=90-Chas*30;
       Alpha:=Alpha-Min*0.5;
       GetXYOfAlpha(Alpha,ChasS,x1,y1);
       x1:=Cx+x1;
       y1:=Cy-y1
     end;
4..6:begin
       Alpha:=(Chas-3)*30;
       Alpha:=Alpha+Min*0.5;
       GetXYOfAlpha(Alpha,ChasS,x1,y1);
       x1:=Cx+x1;
       y1:=Cy+y1
     end;
7..9:begin
       Alpha:=90-(Chas-6)*30;
       Alpha:=Alpha-Min*0.5;
       GetXYOfAlpha(Alpha,ChasS,x1,y1);
       x1:=Cx-x1;
       y1:=Cy+y1
     end;
10..12:begin
        Alpha:=(Chas-9)*30;
        Alpha:=Alpha+Min*0.5;
        GetXYOfAlpha(Alpha,ChasS,x1,y1);
        x1:=Cx-x1;
        y1:=Cy-y1
      end
end;
PaintS(Cx,Cy,x1,y1);
if Sek<>FixSek then
  begin
    FixSek:=Sek;
    if SSek then Form1.Click.Play
  end;
if (FixTime<>Chas) and (Min=0) then
  begin
    DingDing:=Chas;
    FixTime:=Chas
  end;
if (DingDing>0) and (Form1.Ding.Mode=mpStopped) then
  begin
    dec(DingDing);
    if SChas then Form1.Ding.Play
  end;
if OnOff and (Form1.Bud.Mode=mpStopped) then Form1.Bud.Play
    Finally LProfiler.EndFunc(4); End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
LProfiler.StartFunc(5); Try
Secret:=0;
Mode:=0;
Rolex:=TBitmap.Create;
Rolex.LoadFromFile(Clocks);
Cx:=PaintBox1.Width div 2-3;
Cy:=PaintBox1.Height div 2;
if PaintBox1.Height>PaintBox1.Width then
  MainR:=Cx-10
                                    else
  MainR:=Cy-10;
ChasR:=MainR-6;
MinR:=MainR-6;
ChasS:=ChasR-30;
MinS:=MinR-10;
SekS:=MinR-5;
FixSek:=0;
DingDing:=0;
FixTime:=0;
SSek:=true;
SChas:=true;
SBud:=false;
OnOff:=false;
Cifer;
TimerGo
    Finally LProfiler.EndFunc(5); End;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
LProfiler.StartFunc(6); Try
TimerGo
    Finally LProfiler.EndFunc(6); End;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
LProfiler.StartFunc(7); Try
Rolex.Free
    Finally LProfiler.EndFunc(7); End;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
LProfiler.StartFunc(8); Try
Close
    Finally LProfiler.EndFunc(8); End;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
LProfiler.StartFunc(9); Try
Application.Minimize
    Finally LProfiler.EndFunc(9); End;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
LProfiler.StartFunc(10); Try
Form1.Enabled:=false;
Form2.Show
    Finally LProfiler.EndFunc(10); End;
end;

procedure TForm1.Button1KeyPress(Sender: TObject; var Key: Char);
begin
LProfiler.StartFunc(11); Try
case Secret of
0:begin
    if Key='o' then inc(Secret);
    if Key='s' then Mode:=0
  end;
1:if Key='I' then inc(Secret);
2:if Key='v' then
    begin
      Mode:=1;
      Secret:=0
    end
end;
Bud.Close
    Finally LProfiler.EndFunc(11); End;
end;

end.
