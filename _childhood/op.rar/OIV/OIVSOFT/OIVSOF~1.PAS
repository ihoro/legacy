unit OIVSoftFrm;

interface

uses
  SysUtils, Graphics, Forms, ExtCtrls, Classes, Controls, MPlayer,
  WinTypes;

type
  TOIVSoft = class(TForm)
    imgLogo: TImage;
    tmrLogoTime: TTimer;
    imgFace1: TImage;
    imgFace2: TImage;
    mpSound: TMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure tmrLogoTimeTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure LogoCenter;
    procedure LogoDraw;
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowOIVSoft(AHandle: THandle): Byte; StdCall;

implementation

{$R *.DFM}

const
  DForX = 4;
  MaxD = 140;
  prD = 40; {Speed Zoom in}
  LogoStayTime = 20;
  FClickTime = 2;
  Interval = 10;
  SoundFile1 = 'OIVSoftSound1.wav';
  SoundFile2 = 'OIVSoftSound2.wav';

var
  OIVSoft: TOIVSoft;
  D: Integer;
  LogoWidth, LogoHeight: Integer;
  LogoStay,
  FClick : Integer;

procedure TOIVSoft.LogoDraw;
begin
  with imgLogo do
    OIVSoft.Canvas.StretchDraw(Rect(Left,Top,Left+Width-1,Top+Height-1),Picture.Bitmap)
end;

procedure TOIVSoft.LogoCenter;
begin
  imgLogo.Left:=ClientWidth div 2
    -imgLogo.Width div 2;
  imgLogo.Top:=ClientHeight div 2
    -imgLogo.Height div 2
end;

procedure TOIVSoft.FormCreate(Sender: TObject);
begin
  {SystemParametersInfo(SPI_SCREENSAVERRUNNING, 1, 0, 0);}
  mpSound.FileName:=SoundFile1;
  mpSound.Open;
  D:=MaxD;
  LogoStay:=0;
  FClick:=0;
  LogoWidth:=imgLogo.Width;
  LogoHeight:=imgLogo.Height;
  imgLogo.AutoSize:=false;
  imgLogo.Stretch:=true
end;

procedure TOIVSoft.tmrLogoTimeTimer(Sender: TObject);
begin
  if D>0 then
    begin
      if D=MaxD then mpSound.Play;
      dec(D,prD);
      imgLogo.Height:=LogoHeight-D;
      imgLogo.Width:=LogoWidth-D*DForX;
      LogoCenter;
      LogoDraw
    end
         else
    begin
      inc(FClick);
      imgLogo.Stretch:=false;
      if FClick=FClickTime*Interval then
        begin
          mpSound.Stop;
          mpSound.FileName:=SoundFile2;
          mpSound.Open
        end;
      if FClick>FClickTime*Interval then
        begin
          imgLogo.Picture.Bitmap:=imgFace2.Picture.Bitmap;
          LogoDraw;
          if (FClick mod FClickTime=0) and
                (FClick<=FClickTime*(Interval+6)) and
                   (FClick>FClickTime*(Interval+4)) then
            begin
              imgLogo.Picture.Bitmap:=imgFace1.Picture.Bitmap;
              LogoDraw;
              mpSound.Play
            end;
          if FClick>FClickTime*(Interval+6) then
            begin
              inc(LogoStay);
              if LogoStay=LogoStayTime then Close
            end
        end
    end
end;

procedure TOIVSoft.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, 0, 0)}
end;

function ShowOIVSoft(AHandle: THandle): Byte;
begin
  Result:=0;
  Application.Handle:=AHandle;
  OIVSoft:=TOIVSoft.Create(Application);
  try
    OIVSoft.ShowModal;
  finally
    OIVSoft.Free
  end
end;

end.
