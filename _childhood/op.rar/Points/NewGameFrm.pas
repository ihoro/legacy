unit NewGameFrm;

interface

uses
  MainFrm, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList, fcCombo, fctreecombo, Menus, Buttons, Spin;

type
  TNewGame = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    pmBalls: TPopupMenu;
    pmiColor1: TMenuItem;
    pmiColor2: TMenuItem;
    pmiColor3: TMenuItem;
    pmiColor4: TMenuItem;
    pmiColor5: TMenuItem;
    pmiColor6: TMenuItem;
    pmiColor7: TMenuItem;
    pmiColor8: TMenuItem;
    pmiColor9: TMenuItem;
    pmiColor10: TMenuItem;
    im: TImageList;
    GroupBox1: TGroupBox;
    imgEnemy: TImage;
    GroupBox2: TGroupBox;
    imgYou: TImage;
    GroupBox3: TGroupBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure imgEnemyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure pmiColor1Click(Sender: TObject);
    procedure pmiColor2Click(Sender: TObject);
    procedure pmiColor3Click(Sender: TObject);
    procedure pmiColor4Click(Sender: TObject);
    procedure pmiColor5Click(Sender: TObject);
    procedure pmiColor6Click(Sender: TObject);
    procedure pmiColor7Click(Sender: TObject);
    procedure pmiColor8Click(Sender: TObject);
    procedure pmiColor9Click(Sender: TObject);
    procedure pmiColor10Click(Sender: TObject);
    procedure imgYouMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    FOK: Boolean;
    procedure SetImage;
    { Public declarations }
  end;

var
  NewGame: TNewGame;
  Who: Boolean;

implementation

{$R *.DFM}

procedure TNewGame.imgEnemyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Who:=false;
  pmiColor1.Enabled:=true;
  pmiColor2.Enabled:=true;
  pmiColor3.Enabled:=true;
  pmiColor4.Enabled:=true;
  pmiColor5.Enabled:=true;
  pmiColor6.Enabled:=true;
  pmiColor7.Enabled:=true;
  pmiColor8.Enabled:=true;
  pmiColor9.Enabled:=true;
  pmiColor10.Enabled:=true;
  case You.Ball of
    0:pmiColor1.Enabled:=false;
    1:pmiColor2.Enabled:=false;
    2:pmiColor3.Enabled:=false;
    3:pmiColor4.Enabled:=false;
    4:pmiColor5.Enabled:=false;
    5:pmiColor6.Enabled:=false;
    6:pmiColor7.Enabled:=false;
    7:pmiColor8.Enabled:=false;
    8:pmiColor9.Enabled:=false;
    9:pmiColor10.Enabled:=false
  end;
  pmBalls.Popup(Left+GroupBox1.Left+X,
    Top+GroupBox1.Top+Y)
end;

procedure TNewGame.FormCreate(Sender: TObject);
begin
  You.Ball:=0;
  Enemy.Ball:=1;
  SetImage
end;

procedure TNewGame.SetImage;
begin
  with Main.ilBalls do
    begin
      Draw(imgEnemy.Canvas,0,0,Enemy.Ball);
      imgEnemy.Refresh;
      Draw(imgYou.Canvas,0,0,You.Ball);
      imgYou.Refresh
    end
end;

procedure TNewGame.pmiColor1Click(Sender: TObject);
begin
  if Who then You.Ball:=0
         else Enemy.Ball:=0;
  SetImage
end;

procedure TNewGame.pmiColor2Click(Sender: TObject);
begin
  if Who then You.Ball:=1
         else Enemy.Ball:=1;
  SetImage
end;

procedure TNewGame.pmiColor3Click(Sender: TObject);
begin
  if Who then You.Ball:=2
         else Enemy.Ball:=2;
  SetImage
end;

procedure TNewGame.pmiColor4Click(Sender: TObject);
begin
  if Who then You.Ball:=3
         else Enemy.Ball:=3;
  SetImage
end;

procedure TNewGame.pmiColor5Click(Sender: TObject);
begin
  if Who then You.Ball:=4
         else Enemy.Ball:=4;
  SetImage
end;

procedure TNewGame.pmiColor6Click(Sender: TObject);
begin
  if Who then You.Ball:=5
         else Enemy.Ball:=5;
  SetImage
end;

procedure TNewGame.pmiColor7Click(Sender: TObject);
begin
  if Who then You.Ball:=6
         else Enemy.Ball:=6;
  SetImage
end;

procedure TNewGame.pmiColor8Click(Sender: TObject);
begin
  if Who then You.Ball:=7
         else Enemy.Ball:=7;
  SetImage
end;

procedure TNewGame.pmiColor9Click(Sender: TObject);
begin
  if Who then You.Ball:=8
         else Enemy.Ball:=8;
  SetImage
end;

procedure TNewGame.pmiColor10Click(Sender: TObject);
begin
  if Who then You.Ball:=9
         else Enemy.Ball:=9;
  SetImage
end;

procedure TNewGame.imgYouMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Who:=true;
  pmiColor1.Enabled:=true;
  pmiColor2.Enabled:=true;
  pmiColor3.Enabled:=true;
  pmiColor4.Enabled:=true;
  pmiColor5.Enabled:=true;
  pmiColor6.Enabled:=true;
  pmiColor7.Enabled:=true;
  pmiColor8.Enabled:=true;
  pmiColor9.Enabled:=true;
  pmiColor10.Enabled:=true;
  case Enemy.Ball of
    0:pmiColor1.Enabled:=false;
    1:pmiColor2.Enabled:=false;
    2:pmiColor3.Enabled:=false;
    3:pmiColor4.Enabled:=false;
    4:pmiColor5.Enabled:=false;
    5:pmiColor6.Enabled:=false;
    6:pmiColor7.Enabled:=false;
    7:pmiColor8.Enabled:=false;
    8:pmiColor9.Enabled:=false;
    9:pmiColor10.Enabled:=false
  end;
  pmBalls.Popup(Left+GroupBox2.Left+X,
    Top+GroupBox2.Top+Y)
end;

procedure TNewGame.Button1Click(Sender: TObject);
begin
  MainField.Width:=SpinEdit1.Value;
  MainField.Height:=SpinEdit2.Value;
  if RadioButton1.Checked then
    WhoPlay:=true
                          else
    WhoPlay:=false;
  FOK:=true;
  OffsetX:=0;
  OffsetY:=0;
  Main.ChangeScrolls;
  Close
end;

procedure TNewGame.Button2Click(Sender: TObject);
begin
  FOK:=false;
  Close
end;

end.
