unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ImgList, ExtCtrls;

type
  TMain = class(TForm)
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    sbX: TScrollBar;
    sbY: TScrollBar;
    StatusBar1: TStatusBar;
    ilBalls: TImageList;
    imgF: TImage;
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sbXChange(Sender: TObject);
    procedure sbYChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DrawField;
    procedure ChangeScrolls;
    { Public declarations }
  end;

const
  clField = clBlack;
  clLines = $00C1C1C1;
  kSize = 10;

type
  TPlayer = record
    Ball: 0..9;
  end;
  TFSize = 10..100;

var
  Main: TMain;
  WhoPlay: Boolean; {true-player;false-computer}
  You, Enemy: TPlayer;
  OffsetX,
  OffsetY: Word;
  DrawPic: TBitmap;
  MainField: record
    Width,
    Height: TFSize;
  end;

implementation

uses NewGameFrm;

{$R *.DFM}

procedure TMain.N2Click(Sender: TObject);
begin
  NewGame.ShowModal;
  {if NewGame.FOK then}
    DrawField
end;

procedure TMain.DrawField;
var
  x,y: Word;
  f,l: Integer;
begin
  if (MainField.Width-1)*kSize+12<imgF.Width then
    x:=(MainField.Width-1)*kSize+12
                                          else
    x:=imgF.Width;
  if (MainField.Height-1)*kSize+12<imgF.Height then
    y:=(MainField.Height-1)*kSize+12
                                          else
    y:=imgF.Height;
  with DrawPic.Canvas do
    begin
      Brush.Color:=clField;
      FillRect(Rect(0,0,DrawPic.Width,
        DrawPic.Height));
      Pen.Color:=clLines;
      Pen.Width:=1;
      l:=OffsetY-5-(OffsetY-5) div kSize*kSize+
        kSize-(OffsetY-5) mod kSize-10;
      f:=OffsetX-5-(OffsetX-5) div kSize*kSize+
        kSize-(OffsetX-5) mod kSize-10;
      if OffsetX=0 then f:=-5;
      if OffsetY=0 then l:=-5;
      repeat
        inc(l,10);
        MoveTo(0,l);
        LineTo(x,l)
      until l>=y-10;
      repeat
        inc(f,10);
        MoveTo(f,0);
        LineTo(f,y)
      until f>=x-10;
    end;
  {DrawPic.SaveToFile('c:\projects\temp.bmp');}
  BitBlt(imgF.Canvas.Handle,0,0,imgF.Width,
    imgF.Height,DrawPic.Canvas.Handle,0,0,SRCCOPY);
  imgF.Refresh  
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  DrawPic:=TBitmap.Create;
  DrawPic.Width:=Screen.Width;
  DrawPic.Height:=Screen.Height
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  DrawPic.Free
end;

procedure TMain.ChangeScrolls;
begin
  sbX.Max:=(MainField.Width-1)*kSize+11;
  sbX.PageSize:={imgF.Width-}1;
  sbX.LargeChange:={imgF.Width-}1;
  sbY.Max:=(MainField.Height-1)*kSize+11;
  sbY.PageSize:=imgF.Height-1;
  if (MainField.Width-1)*kSize+12<imgF.Width then
    sbX.Max:=0;
  if (MainField.Height-1)*kSize+12<imgF.Height then
    sbY.Max:=0
end;

procedure TMain.FormResize(Sender: TObject);
begin
  ChangeScrolls;
  DrawField
end;

procedure TMain.sbXChange(Sender: TObject);
begin
  OffsetX:=sbX.Position;
  DrawField
end;

procedure TMain.sbYChange(Sender: TObject);
begin
  OffsetY:=sbY.Position;
  DrawField
end;

end.
