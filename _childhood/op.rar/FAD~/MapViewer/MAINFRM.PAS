unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ImgList;

type
  TMain = class(TForm)
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mmiOpen: TMenuItem;
    N3: TMenuItem;
    mmiExit: TMenuItem;
    OpenDialog1: TOpenDialog;
    ilLand: TImageList;
    Image1: TImage;
    procedure mmiOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure mmiExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFileName: string;
    FOpen: Boolean;
    FMapX,
    FMapY,
    FMapWidth,
    FMapHeight: Integer;
    FBMP: TBitmap;
    procedure DrawMap;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

procedure TMain.mmiOpenClick(Sender: TObject);
var
  Map: TextFile;
  s: string;
  h: Char;
  Err,f,l,d: Integer;
begin
  if OpenDialog1.Execute then
    begin
      FFileName:=OpenDialog1.FileName;
      FOpen:=true;
      FMapX:=0;
      FMapY:=0;
      AssignFile(Map,FFileName);
      Reset(Map);
      readln(Map,s);
      Val(s,FMapWidth,Err);
      readln(Map,s);
      Val(s,FMapHeight,Err);
      FBMP.Width:=FMapWidth*32;
      FBMP.Height:=FMapHeight*32;
      for l:=1 to FMapHeight do
        for f:=1 to FMapWidth do
          begin
            read(Map,h);
            Val(h,d,Err);
            if d>5 then d:=0;
            ilLand.Draw(FBMP.Canvas,f*32-32,l*32-32,d)
          end;
      CloseFile(Map);
      if FMapWidth*32>Image1.ClientWidth then
        with ScrollBar1 do
          begin
            Max:=FMapWidth*32;
            LargeChange:=Image1.ClientWidth;
            PageSize:=Image1.ClientWidth
          end;
      if FMapHeight*32>Image1.ClientHeight then
        with ScrollBar2 do
          begin
            Max:=FMapHeight*32;
            LargeChange:=Image1.ClientHeight;
            PageSize:=Image1.ClientHeight
          end;
      DrawMap
    end
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  FBMP:=TBitmap.Create
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  FBMP.Free
end;

procedure TMain.DrawMap;
begin
  Image1.Canvas.Draw(-FMapX,-FMapY,FBMP)
end;

procedure TMain.ScrollBar2Change(Sender: TObject);
begin
  FMapY:=ScrollBar2.Position;
  if FMapY>FMapHeight*32-Image1.ClientHeight then
    FMapY:=FMapHeight*32-Image1.ClientHeight;
  DrawMap
end;

procedure TMain.ScrollBar1Change(Sender: TObject);
begin
  FMapX:=ScrollBar1.Position;
  if FMapX>FMapWidth*32-Image1.ClientWidth then
    FMapX:=FMapWidth*32-Image1.ClientWidth;
  DrawMap
end;

procedure TMain.mmiExitClick(Sender: TObject);
begin
  Close
end;

procedure TMain.FormShow(Sender: TObject);
begin
  ScrollBar1.Align:=alBottom;
  ScrollBar2.Align:=alRight;
  Image1.Align:=alClient
end;

end.
