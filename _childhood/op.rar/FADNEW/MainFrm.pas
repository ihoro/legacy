unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, BMPButton, DXSprite, DXInput, EsTile, EsGrad, 
  DXSounds, StdCtrls, Spin, ImgList, ExtCtrls, OvcBase, OvcMeter;

type
  TMap = array[1..400,1..400] of Byte;

  TPlayer = record
    Life: Integer;
    State: Byte;
    Gun: array[0..8] of Integer;
    PistolOn: Boolean;
    PistolTime: Byte;
    RocketOn: Boolean;
    RocketTime: Byte;
    LaserOn: Boolean;
    LaserTime: Byte;
    MineOn: Boolean;
    MineTime: Byte;
    PlasmaOn: Boolean;
    PlasmaTime: Byte;
    X: Double;
    Y: Double;
    Weapon: Byte;
    SelectTime: Byte;
  end;

  TMain = class(TForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    dxilLand: TDXImageList;
    odMap: TOpenDialog;
    DXSpriteEngine: TDXSpriteEngine;
    DXDraw2: TDXDraw;
    dxilPlayer1: TDXImageList;
    DXInput: TDXInput;
    EsTile1: TEsTile;
    Life: TOvcMeter;
    DXSound: TDXSound;
    DXWaveList: TDXWaveList;
    Life2: TOvcMeter;
    dxilPlayer2: TDXImageList;
    DXSpriteEngine2: TDXSpriteEngine;
    DXInput2: TDXInput;
    Image1: TImage;
    lblAbout: TLabel;
    imgWeapon1: TImage;
    imgWeapon2: TImage;
    ilWeapons: TImageList;
    lblWeaponCount1: TLabel;
    lblWeaponCount2: TLabel;
    dxilPistol: TDXImageList;
    dxilRocket: TDXImageList;
    dxilLaser: TDXImageList;
    dxilFire: TDXImageList;
    dxilPlasma: TDXImageList;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    FFileName: string;
    FMapWidth: Integer;
    FMapHeight: Integer;
    FMap: TMap;
    procedure LoadMap(FileName: string);
    {procedure BalanceNumbers(SE: TDXSpriteEngine;
      Start: Integer);}
    procedure CheckPlayer(Who: Boolean);
    procedure SetWeapon(Who: Boolean; Number: Byte);
    procedure SetWeaponCount(Who: Boolean; Number: Byte);
    procedure SetLife(Who: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

const
  crPurpose = 1;

  LandSize = 32;
  MoveSize = 0.1;
  MaxSelectTime = 3;
  MaxWeapons = 9;
  MaxPistolTime = 25;
  MaxRocketTime = 35;
  MaxLaserTime = 10;
  MaxMineTime = 4;
  MaxMineDisableTime = 10;
  MaxPlasmaTime = 15;

  LifeFromMine = 10;
  LifeFromPistol = 1;
  LifeFromRifle = 1;
  LifeFromRocket = 5;
  LifeFromLaser = 3;
  LifeFromPlasma = 6;
  LifeFromAidKit = 15;

  BoomSpeed = 0.01;
  PistolSpeed = 0.7;
  RocketSpeed = 0.4;
  RocketAnimSpeed = 0.1;
  LaserSpeed = 0.9;
  FireAnimSpeed = 0.08;
  PlasmaSpeed = 0.8;

  OffsetBoomX = 13;
  OffsetBoomY = 13;

  GunAdd: array[0..8] of Integer =
    (0,50,20,25,10,5,10,10,10);

  SpriteType: array[0..14] of string[30] =
    ('TPlayerSprite','TSecondPlayer',
     'TWallSprite','THiddenSprite',
     'TAidKitSprite','TEquipmentSprite',
     'TMineSprite','THiddenMineSprite',
     'TPistolSprite','TRifleSprite',
     'TRocketSprite','TBoomSprite',
     'TLaserSprite','TFireSprite',
     'TPlasmaSprite');

var
  Main: TMain;
  f,l,d,n: Integer;
  fd,ld: Double;
  fb: Boolean;
  Player1,
  Player2: TPlayer;
  WhoFire: Boolean;
  CurrentNumber: Integer = -1;

function GetNumber: Integer;
procedure DeleteSprite(Number: Integer);
function FindSprite(Engine: TSpriteEngine;
  Number: Integer): TSprite;

procedure UpDateList;

implementation

uses LoseFrm;

{$R *.DFM}

type
  TPlayerSprite = class(TImageSprite)
  private
    FOldX: Double;
    FOldY: Double;
    FWalled: Boolean;
    WhoPlayer: Boolean;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  public
    constructor Create(AParent: TSprite); override;
  end;

  TSecondPlayer = class(TImageSprite)
  private
    WhoPlayer: Boolean;
    FOldX: Double;
    FOldY: Double;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  end;

  TWallSprite = class(TImageSprite)
  public
    constructor Create(AParent: TSprite); override;
  end;

  THiddenWallSprite = class(TImageSprite)
  public
    constructor Create(AParent: TSprite); override;
  end;

  TAidKitSprite = class(TImageSprite)
  private
    FNumber: Integer;
  public
    constructor Create(AParent: TSprite); override;
  end;

  TEquipmentSprite = class(TImageSprite)
  private
    FNumber: Integer;
  public
    constructor Create(AParent: TSprite); override;
  end;

  TMineSprite = class(TImageSprite)
  private
    FLifeOff: Boolean;
    FNumber: Integer;
    FDisableTime: Byte;
  protected
    procedure DoMove(MoveCount: Integer); override;
  public
    constructor Create(AParent: TSprite); override;
  end;

  THiddenMineSprite = class(TImageSprite)
  private
    FLifeOff: Boolean;
    FNumber: Integer;
  protected
    procedure DoMove(MoveCount: Integer); override;
  public
    constructor Create(AParent: TSprite); override;
  end;

  TPistolSprite = class(TImageSprite)
  private
    FSide: Byte;
    FPower: Byte;
    WhoPlayer: Boolean;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  public
    DoIt: Boolean;
    constructor Create(AParent: TSprite); override;
  end;

  TRifleSprite = class(TImageSprite)
  private
    FSide: Byte;
    FPower: Byte;
    WhoPlayer: Boolean;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  public
    DoIt: Boolean;
    constructor Create(AParent: TSprite); override;
  end;

  TRocketSprite = class(TImageSprite)
  private
    FSide: Byte;
    FPower: Byte;
    FBoomed: Boolean;
    WhoPlayer: Boolean;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  public
    DoIt: Boolean;
    constructor Create(AParent: TSprite); override;
  end;

  TBoomSprite = class(TImageSprite)
  protected
    procedure DoMove(MoveCount: Integer); override;
  public
    constructor Create(AParent: TSprite); override;
  end;

  TLaserSprite = class(TImageSprite)
  private
    WhoPlayer: Boolean;
    FSide: Byte;
    FPower: Byte;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  public
    DoIt: Boolean;
    constructor Create(AParent: TSprite); override;
  end;

  TFireSprite = class(TImageSprite)
  private
    WhoPlayer: Boolean;
    procedure SetImage(MS: Byte);
  protected
    procedure DoMove(MoveCount: Integer); override;  
  public
    constructor Create(AParent: TSprite); override;
  end;

  TPlasmaSprite = class(TImageSprite)
  private
    WhoPlayer: Boolean;
    FSide: Byte;
    FPower: Byte;
    procedure SetImage(MS: Byte);
  protected
    procedure DoCollision(Sprite: TSprite;
      var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;  
  public
    DoIt: Boolean;
    constructor Create(AParent: TSprite); override;
  end;

{ TPlayerSprite }

procedure TPlayerSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  FOldX:=X;
  FOldY:=Y;
  if WhoPlayer then
    begin
      if Player1.SelectTime>0 then
        dec(Player1.SelectTime);
      if Player1.PistolTime>0 then
        dec(Player1.PistolTime)
                              else
        Player1.PistolOn:=false;
      if Player1.RocketTime>0 then
        dec(Player1.RocketTime)
                              else
        Player1.RocketOn:=false;
      if Player1.LaserTime>0 then
        dec(Player1.LaserTime)
                              else
        Player1.LaserOn:=false;
      if Player1.MineTime>0 then
        dec(Player1.MineTime)
                              else
        Player1.MineOn:=false;
      if Player1.PlasmaTime>0 then
        dec(Player1.PlasmaTime)
                              else
        Player1.PlasmaOn:=false;
      if isUp in Main.DXInput.States then
        begin
          Y:=Y-MoveSize*MoveCount;
          Player1.State:=1;
          FWalled:=false;
          SetImage(1)
        end;
      if isRight in Main.DXInput.States then
        begin
          X:=X+MoveSize*MoveCount;
          Player1.State:=2;
          FWalled:=false;
          SetImage(2)
        end;
      if isDown in Main.DXInput.States then
        begin
          Y:=Y+MoveSize*MoveCount;
          Player1.State:=3;
          FWalled:=false;
          SetImage(3)
        end;
      if isLeft in Main.DXInput.States then
        begin
          X:=X-MoveSize*MoveCount;
          Player1.State:=4;
          FWalled:=false;
          SetImage(4)
        end;
      if isButton1 in Main.DXInput.States then
        begin
          if (Player1.Weapon=0) and not Player1.PistolOn
            and not FWalled then
            begin
              WhoFire:=true;
              TPistolSprite.Create(Main.DXSpriteEngine.Engine);
              with TPistolSprite.Create(Main.DXSpriteEngine2.Engine) do
                DoIt:=false
            end;
          if (Player1.Weapon=1) and
            (Player1.Gun[1]>0) and not FWalled then
            begin
              dec(Player1.Gun[1]);
              Main.SetWeapon(true,Player1.Weapon);
              WhoFire:=true;
              TRifleSprite.Create(Main.DXSpriteEngine.Engine);
              with TRifleSprite.Create(Main.DXSpriteEngine2.Engine) do
                DoIt:=false
            end;
          if (Player1.Weapon=2) and
            (Player1.Gun[2]>0) and not FWalled and
            not Player1.RocketOn then
            begin
              dec(Player1.Gun[2]);
              Main.SetWeapon(true,Player1.Weapon);
              WhoFire:=true;
              TRocketSprite.Create(Main.DXSpriteEngine.Engine);
              with TRocketSprite.Create(Main.DXSpriteEngine2.Engine) do
                DoIt:=false
            end;
          if (Player1.Weapon=3) and
            (Player1.Gun[3]>0) and not FWalled and
            not Player1.LaserOn then
            begin
              dec(Player1.Gun[3]);
              Main.SetWeapon(true,Player1.Weapon);
              WhoFire:=true;
              TLaserSprite.Create(Main.DXSpriteEngine.Engine);
              with TLaserSprite.Create(Main.DXSpriteEngine2.Engine) do
                DoIt:=false
            end;
          if (Player1.Weapon=4) and
            (Player1.Gun[4]>0) and
            not Player1.MineOn then
            begin
              dec(Player1.Gun[4]);
              Main.SetWeapon(true,Player1.Weapon);
              WhoFire:=true;
              fd:=X;
              ld:=Y;
              n:=GetNumber;
              with TMineSprite.Create(Main.DXSpriteEngine.Engine) do
                begin
                  X:=fd;
                  Y:=ld;
                  FNumber:=n
                end;
              with TMineSprite.Create(Main.DXSpriteEngine2.Engine) do
                begin
                  X:=fd;
                  Y:=ld;
                  FNumber:=n
                end
            end;
          if (Player1.Weapon=5) and
            (Player1.Gun[5]>0) and
            not Player1.PlasmaOn then
            begin
              dec(Player1.Gun[5]);
              Main.SetWeapon(true,Player1.Weapon);
              WhoFire:=true;
              TPlasmaSprite.Create(Main.DXSpriteEngine.Engine);
              with TPlasmaSprite.Create(Main.DXSpriteEngine2.Engine) do
                DoIt:=false
            end;
          if Player1.Gun[Player1.Weapon]=0 then
            begin
              repeat
                inc(Player1.Weapon);
                if Player1.Weapon>MaxWeapons-1 then
                  Player1.Weapon:=0;
              until Player1.Gun[Player1.Weapon]>0;
              Main.SetWeapon(true,Player1.Weapon)
            end
        end;
      if (isButton2 in Main.DXInput.States)
        and (Player1.SelectTime=0) then
        begin
          repeat
            inc(Player1.Weapon);
            if Player1.Weapon>MaxWeapons-1 then
              Player1.Weapon:=0;
          until Player1.Gun[Player1.Weapon]>0;
          Main.SetWeapon(true,Player1.Weapon);
          Player1.SelectTime:=MaxSelectTime
        end
    end
               else
    begin
      if Player2.SelectTime>0 then
        dec(Player2.SelectTime);
      if Player2.PistolTime>0 then
        dec(Player2.PistolTime)
                              else
        Player2.PistolOn:=false;
      if Player2.RocketTime>0 then
        dec(Player2.RocketTime)
                              else
        Player2.RocketOn:=false;
      if Player2.LaserTime>0 then
        dec(Player2.LaserTime)
                              else
        Player2.LaserOn:=false;
      if Player2.MineTime>0 then
        dec(Player2.MineTime)
                              else
        Player2.MineOn:=false;
      if Player2.PlasmaTime>0 then
        dec(Player2.PlasmaTime)
                              else
        Player2.PlasmaOn:=false;
      if isUp in Main.DXInput2.States then
        begin
          Y:=Y-MoveSize*MoveCount;
          Player2.State:=1;
          FWalled:=false;
          SetImage(1)
        end;
      if isRight in Main.DXInput2.States then
        begin
          X:=X+MoveSize*MoveCount;
          Player2.State:=2;
          FWalled:=false;
          SetImage(2)
        end;
      if isDown in Main.DXInput2.States then
        begin
          Y:=Y+MoveSize*MoveCount;
          Player2.State:=3;
          FWalled:=false;
          SetImage(3)
        end;
      if isLeft in Main.DXInput2.States then
        begin
          X:=X-MoveSize*MoveCount;
          Player2.State:=4;
          FWalled:=false;
          SetImage(4)
        end;
      if isButton1 in Main.DXInput2.States then
        begin
          if (Player2.Weapon=0) and not Player2.PistolOn
            and not FWalled then
            begin
              WhoFire:=false;
              TPistolSprite.Create(Main.DXSpriteEngine2.Engine);
              with TPistolSprite.Create(Main.DXSpriteEngine.Engine) do
                DoIt:=false
            end;
          if (Player2.Weapon=1) and
            (Player2.Gun[1]>0) and not FWalled then
            begin
              dec(Player2.Gun[1]);
              Main.SetWeapon(false,Player2.Weapon);
              WhoFire:=false;
              TRifleSprite.Create(Main.DXSpriteEngine2.Engine);
              with TRifleSprite.Create(Main.DXSpriteEngine.Engine) do
                DoIt:=false
            end;
          if (Player2.Weapon=2) and
            (Player2.Gun[2]>0) and not FWalled and
            not Player2.RocketOn then
            begin
              dec(Player2.Gun[2]);
              Main.SetWeapon(false,Player2.Weapon);
              WhoFire:=false;
              TRocketSprite.Create(Main.DXSpriteEngine2.Engine);
              with TRocketSprite.Create(Main.DXSpriteEngine.Engine) do
                DoIt:=false
            end;
          if (Player2.Weapon=3) and
            (Player2.Gun[3]>0) and not FWalled and
            not Player2.LaserOn then
            begin
              dec(Player2.Gun[3]);
              Main.SetWeapon(false,Player2.Weapon);
              WhoFire:=false;
              TLaserSprite.Create(Main.DXSpriteEngine2.Engine);
              with TLaserSprite.Create(Main.DXSpriteEngine.Engine) do
                DoIt:=false
            end;
          if (Player2.Weapon=4) and
            (Player2.Gun[4]>0) and
            not Player2.MineOn then
            begin
              dec(Player2.Gun[4]);
              Main.SetWeapon(false,Player2.Weapon);
              WhoFire:=false;
              fd:=X;
              ld:=Y;
              n:=GetNumber;
              with TMineSprite.Create(Main.DXSpriteEngine.Engine) do
                begin
                  X:=fd;
                  Y:=ld;
                  FNumber:=n
                end;
              with TMineSprite.Create(Main.DXSpriteEngine2.Engine) do
                begin
                  X:=fd;
                  Y:=ld;
                  FNumber:=n
                end
            end;
          if (Player2.Weapon=5) and
            (Player2.Gun[5]>0) and
            not Player2.PlasmaOn then
            begin
              dec(Player2.Gun[5]);
              Main.SetWeapon(false,Player2.Weapon);
              WhoFire:=false;
              TPlasmaSprite.Create(Main.DXSpriteEngine2.Engine);
              with TPlasmaSprite.Create(Main.DXSpriteEngine.Engine) do
                DoIt:=false
            end;
          if Player2.Gun[Player2.Weapon]=0 then
            begin
              repeat
                inc(Player2.Weapon);
                if Player2.Weapon>MaxWeapons-1 then
                  Player2.Weapon:=0;
              until Player2.Gun[Player2.Weapon]>0;
              Main.SetWeapon(false,Player2.Weapon)
            end
        end;
      if (isButton2 in Main.DXInput2.States)
        and (Player2.SelectTime=0) then
        begin
          repeat
            inc(Player2.Weapon);
            if Player2.Weapon>MaxWeapons-1 then
              Player2.Weapon:=0;
          until Player2.Gun[Player2.Weapon]>0;
          Main.SetWeapon(false,Player2.Weapon);
          Player2.SelectTime:=MaxSelectTime
        end
    end;
  Collision;
  if WhoPlayer then
    begin
      Player1.X:=X;
      Player1.Y:=Y
    end
               else
    begin
      Player2.X:=X;
      Player2.Y:=Y
    end;
  Engine.X:=-X+Engine.Width div 2-Width div 2;
  Engine.Y:=-Y+Engine.Height div 2-Height div 2;
  if X<=5*LandSize then
    Engine.X:=-5*LandSize+Engine.Width div 2-Width div 2;
  if Y<=5*LandSize then
    Engine.Y:=-5*LandSize+Engine.Height div 2-Height div 2;
  if X>=(Main.FMapWidth-6)*LandSize then
    Engine.X:=-(Main.FMapWidth-6)*LandSize+Engine.Width div 2-Width div 2;
  if Y>=(Main.FMapHeight-6)*LandSize then
    Engine.Y:=-(Main.FMapHeight-6)*LandSize+Engine.Height div 2-Height div 2
end;

procedure TPlayerSprite.SetImage(MS: Byte);
begin
  if WhoPlayer then
    Image:=Main.dxilPlayer1.Items[MS-1]
               else
    Image:=Main.dxilPlayer2.Items[MS-1];
  Width:=Image.Width;
  Height:=Image.Height
end;

constructor TPlayerSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  SetImage(1);
  Z:=2
end;

procedure TPlayerSprite.DoCollision(Sprite: TSprite;
  var Done: Boolean);
begin
  if Sprite is TWallSprite then
    begin
      X:=FOldX;
      Y:=FOldY;
      FWalled:=true
    end;
  if Sprite is TMineSprite then
   if TMineSprite(Sprite).FDisableTime=0 then
    if not TMineSprite(Sprite).FLifeOff then
      begin
        Main.DXWaveList.Items.Find('Boom').Play(false);
        with TMineSprite(Sprite) do
          begin
            FLifeOff:=true;
            if WhoPlayer then
              Image:=Main.dxilPlayer1.Items.Find('Boom')
                         else
              Image:=Main.dxilPlayer2.Items.Find('Boom');
            AnimCount:=Image.PatternCount;
            AnimStart:=0;
            AnimLooped:=false;
            AnimSpeed:=BoomSpeed
          end;
        if WhoPlayer then
          with TMineSprite(FindSprite(Main.DXSpriteEngine2.Engine,
            TMineSprite(Sprite).FNumber)) do
            begin
              FLifeOff:=true;
              Image:=Main.dxilPlayer2.Items.Find('Boom');
              AnimCount:=Image.PatternCount;
              AnimStart:=0;
              AnimLooped:=false;
              AnimSpeed:=BoomSpeed
            end
                     else
          with TMineSprite(FindSprite(Main.DXSpriteEngine.Engine,
            TMineSprite(Sprite).FNumber)) do
            begin
              FLifeOff:=true;
              Image:=Main.dxilPlayer1.Items.Find('Boom');
              AnimCount:=Image.PatternCount;
              AnimStart:=0;
              AnimLooped:=false;
              AnimSpeed:=BoomSpeed
            end;
        if WhoPlayer then
          dec(Player1.Life,LifeFromMine)
                     else
          dec(Player2.Life,LifeFromMine);
        Main.SetLife(WhoPlayer);
        Main.CheckPlayer(WhoPlayer)
      end;
  if Sprite is THiddenMineSprite then
    if not THiddenMineSprite(Sprite).FLifeOff then
      begin
        Main.DXWaveList.Items.Find('Boom').Play(false);
        with THiddenMineSprite(Sprite) do
          begin
            FLifeOff:=true;
            if WhoPlayer then
              Image:=Main.dxilPlayer1.Items.Find('Boom')
                         else
              Image:=Main.dxilPlayer2.Items.Find('Boom');
            AnimCount:=Image.PatternCount;
            AnimStart:=0;
            AnimLooped:=false;
            AnimSpeed:=BoomSpeed
          end;
        if WhoPlayer then
          with THiddenMineSprite(FindSprite(Main.DXSpriteEngine2.Engine,
            THiddenMineSprite(Sprite).FNumber)) do
            begin
              FLifeOff:=true;
              Image:=Main.dxilPlayer2.Items.Find('Boom');
              AnimCount:=Image.PatternCount;
              AnimStart:=0;
              AnimLooped:=false;
              AnimSpeed:=BoomSpeed
            end
                     else
            with THiddenMineSprite(FindSprite(Main.DXSpriteEngine.Engine,
            THiddenMineSprite(Sprite).FNumber)) do
            begin
              FLifeOff:=true;
              Image:=Main.dxilPlayer1.Items.Find('Boom');
              AnimCount:=Image.PatternCount;
              AnimStart:=0;
              AnimLooped:=false;
              AnimSpeed:=BoomSpeed
            end;
        if WhoPlayer then
          dec(Player1.Life,LifeFromMine)
                     else
          dec(Player2.Life,LifeFromMine);
        Main.SetLife(WhoPlayer);
        Main.CheckPlayer(WhoPlayer)
      end;
  if Sprite is TAidKitSprite then
    begin
      Main.DXWaveList.Items.Find('Life').Play(false);
      l:=TAidKitSprite(Sprite).FNumber;
      DeleteSprite(l);
      if WhoPlayer then
        with Player1 do
          begin
            inc(Life,LifeFromAidKit);
            if Life>100 then Life:=100
          end
                   else
        with Player2 do
          begin
            inc(Life,LifeFromAidKit);
            if Life>100 then Life:=100
          end;
      Main.SetLife(WhoPlayer)
    end;
  if Sprite is TSecondPlayer then
    begin
      X:=FOldX;
      Y:=FOldY
    end;
  if Sprite is TEquipmentSprite then
    begin
      Main.DXWaveList.Items.Find('Equipment').Play(false);
      f:=Random(8)+1;
      if WhoPlayer then
        begin
          inc(Player1.Gun[f],GunAdd[f]);
          if Player1.Gun[f]>999 then
            Player1.Gun[f]:=999;
          Player1.Weapon:=f;
          Main.SetWeaponCount(true,f);
          Main.SetWeapon(true,f)
        end
                   else
        begin
          inc(Player2.Gun[f],GunAdd[f]);
          if Player2.Gun[f]>999 then
            Player2.Gun[f]:=999;
          Player2.Weapon:=f;
          Main.SetWeaponCount(false,f);
          Main.SetWeapon(false,f)
        end;
      DeleteSprite(TEquipmentSprite(Sprite).FNumber)
    end
end;

{ TSecondPlayer }

procedure TSecondPlayer.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  FOldX:=X;
  FOldY:=Y;
  if WhoPlayer then
    begin
      X:=Player1.X;
      Y:=Player1.Y;
      SetImage(Player1.State)
    end
               else
    begin
      X:=Player2.X;
      Y:=Player2.Y;
      SetImage(Player2.State)
    end;
  Collision
end;

procedure TSecondPlayer.DoCollision(Sprite: TSprite;
      var Done: Boolean);
begin
  if Sprite is TPlayerSprite then
    begin
      X:=FOldX;
      Y:=FOldY
    end
end;

procedure TSecondPlayer.SetImage(MS: Byte);
begin
  if WhoPlayer then
    Image:=Main.dxilPlayer1.Items[MS-1]
               else
    Image:=Main.dxilPlayer2.Items[MS-1];
  Width:=Image.Width;
  Height:=Image.Height  
end;

{ TWallSprite }

constructor TWallSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Image:=Main.dxilLand.Items.Find('Wall');
  Width:=Image.Width;
  Height:=Image.Height;
  Z:=2
end;

{ THiddenWallSprite }

constructor THiddenWallSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Image:=Main.dxilLand.Items.Find('Wall');
  Width:=Image.Width;
  Height:=Image.Height;
  Z:=2
end;

{ TAidKitSprite }

constructor TAidKitSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Image:=Main.dxilLand.Items.Find('AidKit');
  Width:=Image.Width;
  Height:=Image.Height;
  Z:=2
end;

{ TEquipmentSprite }

constructor TEquipmentSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Image:=Main.dxilLand.Items.Find('Equipment');
  Width:=Image.Width;
  Height:=Image.Height;
  Z:=2
end;

{ TMineSprite }

constructor TMineSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Image:=Main.dxilLand.Items.Find('Mine');
  Width:=Image.Width;
  Height:=Image.Height;
  if WhoFire then
    begin
      Player1.MineOn:=true;
      Player1.MineTime:=MaxMineTime
    end
               else
    begin
      Player2.MineOn:=true;
      Player2.MineTime:=MaxMineTime
    end;
  FDisableTime:=MaxMineDisableTime;  
  Z:=2
end;

procedure TMineSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  if FDisableTime>0 then
    dec(FDisableTime);
  if FLifeOff and (AnimPos=AnimCount-1) then
    DeleteSprite(FNumber)
end;

{ THiddenMineSprite }

constructor THiddenMineSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Image:=Main.dxilLand.Items.Find('Land');
  Width:=Image.Width;
  Height:=Image.Height;
  Z:=2
end;

procedure THiddenMineSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  if FLifeOff and (AnimPos=AnimCount-1) then
    DeleteSprite(FNumber)
end;

{ TPistolSprite }

procedure TPistolSprite.SetImage(MS: Byte);
begin
  Image:=Main.dxilPistol.Items[MS];
  Width:=Image.Width;
  Height:=Image.Height
end;

procedure TPistolSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  case FSide of
    1:Y:=Y-PistolSpeed*MoveCount;
    2:X:=X+PistolSpeed*MoveCount;
    3:Y:=Y+PistolSpeed*MoveCount;
    4:X:=X-PistolSpeed*MoveCount
  end;
  Collision
end;

procedure TPistolSprite.DoCollision(Sprite: TSprite;
  var Done: Boolean);
begin
  if Sprite is TWallSprite then
    Dead;
  if (Sprite is TPlayerSprite) and not DoIt then
    Dead;
  if (Sprite is TPlayerSprite) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TPlayerSprite(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      Dead
    end;
  if (Sprite is TSecondPlayer) and not DoIt then
    Dead;
  if (Sprite is TSecondPlayer) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TSecondPlayer(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      Dead
    end
end;

constructor TPistolSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  WhoPlayer:=WhoFire;
  TFireSprite.Create(Main.DXSpriteEngine.Engine);
  TFireSprite.Create(Main.DXSpriteEngine2.Engine);
  DoIt:=true;
  if WhoFire then
    begin
      Player1.PistolOn:=true;
      Player1.PistolTime:=MaxPistolTime
    end
             else
    begin
      Player2.PistolOn:=true;
      Player2.PistolTime:=MaxPistolTime
    end;
  if WhoFire then
    case Player1.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player1.X+12;
          Y:=Player1.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player1.X+28;
          Y:=Player1.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player1.X+15;
          Y:=Player1.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player1.X-Width;
          Y:=Player1.Y+15
        end
    end
             else
    case Player2.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player2.X+12;
          Y:=Player2.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player2.X+28;
          Y:=Player2.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player2.X+15;
          Y:=Player2.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player2.X-Width;
          Y:=Player2.Y+15
        end
    end;
  FPower:=LifeFromPistol;
  Z:=2
end;

{ TRifleSprite }

procedure TRifleSprite.SetImage(MS: Byte);
begin
  Image:=Main.dxilPistol.Items[MS];
  Width:=Image.Width;
  Height:=Image.Height
end;

procedure TRifleSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  case FSide of
    1:Y:=Y-PistolSpeed*MoveCount;
    2:X:=X+PistolSpeed*MoveCount;
    3:Y:=Y+PistolSpeed*MoveCount;
    4:X:=X-PistolSpeed*MoveCount
  end;
  Collision
end;

procedure TRifleSprite.DoCollision(Sprite: TSprite;
  var Done: Boolean);
begin
  if Sprite is TWallSprite then
    Dead;
  if (Sprite is TPlayerSprite) and not DoIt then
    Dead;
  if (Sprite is TPlayerSprite) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TPlayerSprite(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      Dead
    end;
  if (Sprite is TSecondPlayer) and not DoIt then
    Dead;
  if (Sprite is TSecondPlayer) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TSecondPlayer(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      Dead
    end
end;

constructor TRifleSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  DoIt:=true;
  WhoPlayer:=WhoFire;
  TFireSprite.Create(Main.DXSpriteEngine.Engine);
  TFireSprite.Create(Main.DXSpriteEngine2.Engine);
  if WhoFire then
    case Player1.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player1.X+12;
          Y:=Player1.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player1.X+28;
          Y:=Player1.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player1.X+15;
          Y:=Player1.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player1.X-Width;
          Y:=Player1.Y+15
        end
    end
             else
    case Player2.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player2.X+12;
          Y:=Player2.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player2.X+28;
          Y:=Player2.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player2.X+15;
          Y:=Player2.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player2.X-Width;
          Y:=Player2.Y+15
        end
    end;
  FPower:=LifeFromRifle;
  Z:=2
end;

{ TRocketSprite }

procedure TRocketSprite.SetImage(MS: Byte);
begin
  Image:=Main.dxilRocket.Items[MS];
  Width:=Image.Width;
  Height:=Image.Height;
  AnimCount:=Image.PatternCount;
  AnimStart:=0;
  AnimSpeed:=RocketAnimSpeed;
  AnimLooped:=true
end;

procedure TRocketSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  case FSide of
    1:Y:=Y-RocketSpeed*MoveCount;
    2:X:=X+RocketSpeed*MoveCount;
    3:Y:=Y+RocketSpeed*MoveCount;
    4:X:=X-RocketSpeed*MoveCount
  end;
  Collision
end;

procedure TRocketSprite.DoCollision(Sprite: TSprite;
  var Done: Boolean);
begin
  if (Sprite is TWallSprite)
    and not FBoomed then
    begin
      FBoomed:=true;
      fd:=X;
      ld:=Y;
      with TBoomSprite.Create(Main.DXSpriteEngine.Engine) do
        begin
          WhoPlayer:=true;
          X:=fd-OffsetBoomX;
          Y:=ld-OffsetBoomY
        end;
      with TBoomSprite.Create(Main.DXSpriteEngine2.Engine) do
        begin
          WhoPlayer:=false;
          X:=fd-OffsetBoomX;
          Y:=ld-OffsetBoomY
        end;
      Dead
    end;
  if (Sprite is TPlayerSprite) and not DoIt then
    Dead;
  if (Sprite is TPlayerSprite) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TPlayerSprite(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      fd:=X;
      ld:=Y;
      with TBoomSprite.Create(Main.DXSpriteEngine.Engine) do
        begin
          WhoPlayer:=true;
          X:=fd-OffsetBoomX;
          Y:=ld-OffsetBoomY
        end;
      with TBoomSprite.Create(Main.DXSpriteEngine2.Engine) do
        begin
          WhoPlayer:=false;
          X:=fd-OffsetBoomX;
          Y:=ld-OffsetBoomY
        end;
      Dead
    end;
  if (Sprite is TSecondPlayer) and not DoIt then
    Dead;
  if (Sprite is TSecondPlayer) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TSecondPlayer(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      fd:=X;
      ld:=Y;
      with TBoomSprite.Create(Main.DXSpriteEngine.Engine) do
        begin
          WhoPlayer:=true;
          X:=fd-OffsetBoomX;
          Y:=ld-OffsetBoomY
        end;
      with TBoomSprite.Create(Main.DXSpriteEngine2.Engine) do
        begin
          WhoPlayer:=false;
          X:=fd-OffsetBoomX;
          Y:=ld-OffsetBoomY
        end;
      Dead
    end
end;

constructor TRocketSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  WhoPlayer:=WhoFire;
  DoIt:=true;
  if WhoFire then
    begin
      Player1.RocketOn:=true;
      Player1.RocketTime:=MaxRocketTime
    end
             else
    begin
      Player2.RocketOn:=true;
      Player2.RocketTime:=MaxRocketTime
    end;
  if WhoFire then
    case Player1.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player1.X+12;
          Y:=Player1.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player1.X+28;
          Y:=Player1.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player1.X+15;
          Y:=Player1.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player1.X-Width;
          Y:=Player1.Y+15
        end
    end
             else
    case Player2.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player2.X+12;
          Y:=Player2.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player2.X+28;
          Y:=Player2.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player2.X+15;
          Y:=Player2.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player2.X-Width;
          Y:=Player2.Y+15
        end
    end;
  FPower:=LifeFromRocket;
  Z:=2
end;

{ TBoomSprite }

procedure TBoomSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  if AnimPos=AnimCount-1 then
    Dead
end;

constructor TBoomSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Main.DXWaveList.Items.Find('Boom').Play(false);
  Image:=Main.dxilPlayer1.Items.Find('Boom');
  Width:=Image.Width;
  Height:=Image.Height;
  AnimCount:=Image.PatternCount;
  AnimSpeed:=BoomSpeed;
  AnimLooped:=false;
  AnimStart:=0;
  Z:=3
end;

{ TLaserSprite }

procedure TLaserSprite.SetImage(MS: Byte);
begin
  Image:=Main.dxilLaser.Items[MS];
  Width:=Image.Width;
  Height:=Image.Height
end;

procedure TLaserSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  case FSide of
    1:Y:=Y-LaserSpeed*MoveCount;
    2:X:=X+LaserSpeed*MoveCount;
    3:Y:=Y+LaserSpeed*MoveCount;
    4:X:=X-LaserSpeed*MoveCount
  end;
  Collision
end;

procedure TLaserSprite.DoCollision(Sprite: TSprite;
  var Done: Boolean);
begin
  if Sprite is TWallSprite then
    Dead;
  if (Sprite is TPlayerSprite) and not DoIt then
    Dead;
  if (Sprite is TPlayerSprite) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TPlayerSprite(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      Dead
    end;
  if (Sprite is TSecondPlayer) and not DoIt then
    Dead;
  if (Sprite is TSecondPlayer) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TSecondPlayer(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end;
      Dead
    end
end;

constructor TLaserSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  WhoPlayer:=WhoFire;
  DoIt:=true;
  if WhoFire then
    begin
      Player1.LaserOn:=true;
      Player1.LaserTime:=MaxLaserTime
    end
             else
    begin
      Player2.LaserOn:=true;
      Player2.LaserTime:=MaxLaserTime
    end;
  if WhoFire then
    case Player1.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player1.X+12;
          Y:=Player1.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player1.X+28;
          Y:=Player1.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player1.X+15;
          Y:=Player1.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player1.X-Width;
          Y:=Player1.Y+15
        end
    end
             else
    case Player2.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player2.X+12;
          Y:=Player2.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player2.X+28;
          Y:=Player2.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player2.X+15;
          Y:=Player2.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player2.X-Width;
          Y:=Player2.Y+15
        end
    end;
  FPower:=LifeFromLaser;
  Z:=2
end;

{ TFireSprite }

procedure TFireSprite.SetImage(MS: Byte);
begin
  Image:=Main.dxilFire.Items[MS];
  Width:=Image.Width;
  Height:=Image.Height;
  AnimCount:=Image.PatternCount;
  AnimStart:=0;
  AnimLooped:=false;
  AnimSpeed:=FireAnimSpeed
end;

procedure TFireSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  if WhoPlayer then
    case Player1.State of
      1:begin
          X:=Player1.X+9;
          Y:=Player1.Y-Height
        end;
      2:begin
          X:=Player1.X+28;
          Y:=Player1.Y+9
        end;
      3:begin
          X:=Player1.X+12;
          Y:=Player1.Y+28
        end;
      4:begin
          X:=Player1.X-Width;
          Y:=Player1.Y+12
        end
    end
             else
    case Player2.State of
      1:begin
          X:=Player2.X+9;
          Y:=Player2.Y-Height
        end;
      2:begin
          X:=Player2.X+28;
          Y:=Player2.Y+9
        end;
      3:begin
          X:=Player2.X+12;
          Y:=Player2.Y+28
        end;
      4:begin
          X:=Player2.X-Width;
          Y:=Player2.Y+12
        end
    end;
  if AnimPos=AnimCount-1 then
    Dead
end;

constructor TFireSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  WhoPlayer:=WhoFire;
  Main.DXWaveList.Items.Find('Fire').Play(false);
  if WhoFire then
    case Player1.State of
      1:begin
          SetImage(0);
          X:=Player1.X+9;
          Y:=Player1.Y-Height
        end;
      2:begin
          SetImage(1);
          X:=Player1.X+28;
          Y:=Player1.Y+9
        end;
      3:begin
          SetImage(2);
          X:=Player1.X+12;
          Y:=Player1.Y+28
        end;
      4:begin
          SetImage(3);
          X:=Player1.X-Width;
          Y:=Player1.Y+12
        end
    end
             else
    case Player2.State of
      1:begin
          SetImage(0);
          X:=Player2.X+9;
          Y:=Player2.Y-Height
        end;
      2:begin
          SetImage(1);
          X:=Player2.X+28;
          Y:=Player2.Y+9
        end;
      3:begin
          SetImage(2);
          X:=Player2.X+12;
          Y:=Player2.Y+28
        end;
      4:begin
          SetImage(3);
          X:=Player2.X-Width;
          Y:=Player2.Y+12
        end
    end;
  Z:=2
end;

{ TPlasmaSprite }

procedure TPlasmaSprite.SetImage(MS: Byte);
begin
  Image:=Main.dxilPlasma.Items[MS];
  Width:=Image.Width;
  Height:=Image.Height
end;

procedure TPlasmaSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  case FSide of
    1:Y:=Y-PlasmaSpeed*MoveCount;
    2:X:=X+PlasmaSpeed*MoveCount;
    3:Y:=Y+PlasmaSpeed*MoveCount;
    4:X:=X-PlasmaSpeed*MoveCount
  end;
  if (X<0) or (Y<0) or (X>Main.FMapWidth*LandSize)
    or (Y>Main.FMapHeight*LandSize) then
    Dead;
  Collision
end;

procedure TPlasmaSprite.DoCollision(Sprite: TSprite;
  var Done: Boolean);
begin
  if (Sprite is TPlayerSprite) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TPlayerSprite(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end
    end;
  if (Sprite is TSecondPlayer) and DoIt then
    begin
      Main.DXWaveList.Items.Find('HitEnemy').Play(false);
      if TSecondPlayer(Sprite).WhoPlayer then
        begin
          dec(Player1.Life,FPower);
          Main.SetLife(true);
          Main.CheckPlayer(true)
        end
                                         else
        begin
          dec(Player2.Life,FPower);
          Main.SetLife(false);
          Main.CheckPlayer(false)
        end
    end
end;

constructor TPlasmaSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  WhoPlayer:=WhoFire;
  DoIt:=true;
  if WhoFire then
    begin
      Player1.PlasmaOn:=true;
      Player1.PlasmaTime:=MaxPlasmaTime
    end
             else
    begin
      Player2.PlasmaOn:=true;
      Player2.PlasmaTime:=MaxPlasmaTime
    end;
  if WhoFire then
    case Player1.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player1.X+12;
          Y:=Player1.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player1.X+28;
          Y:=Player1.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player1.X+15;
          Y:=Player1.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player1.X-Width;
          Y:=Player1.Y+15
        end
    end
             else
    case Player2.State of
      1:begin
          SetImage(0);
          FSide:=1;
          X:=Player2.X+12;
          Y:=Player2.Y-Height
        end;
      2:begin
          SetImage(1);
          FSide:=2;
          X:=Player2.X+28;
          Y:=Player2.Y+12
        end;
      3:begin
          SetImage(2);
          FSide:=3;
          X:=Player2.X+15;
          Y:=Player2.Y+28
        end;
      4:begin
          SetImage(3);
          FSide:=4;
          X:=Player2.X-Width;
          Y:=Player2.Y+15
        end
    end;
  FPower:=LifeFromPlasma;
  Z:=2
end;

function GetNumber: Integer;
begin
  inc(CurrentNumber);
  Result:=CurrentNumber
end;

procedure DeleteSprite(Number: Integer);
var
  ff: Integer;
begin
  with Main do
    begin
      for ff:=0 to DXSpriteEngine.Engine.Count-1 do
        begin
          if TAidKitSprite(DXSpriteEngine.Engine.Items[ff]).FNumber=Number then
            TAidKitSprite(DXSpriteEngine.Engine.Items[ff]).Dead;
          if TEquipmentSprite(DXSpriteEngine.Engine.Items[ff]).FNumber=Number then
            TEquipmentSprite(DXSpriteEngine.Engine.Items[ff]).Dead;
          if TMineSprite(DXSpriteEngine.Engine.Items[ff]).FNumber=Number then
            TMineSprite(DXSpriteEngine.Engine.Items[ff]).Dead;
          if THiddenMineSprite(DXSpriteEngine.Engine.Items[ff]).FNumber=Number then
            THiddenMineSprite(DXSpriteEngine.Engine.Items[ff]).Dead
        end;
      for ff:=0 to DXSpriteEngine2.Engine.Count-1 do
        begin
          if TAidKitSprite(DXSpriteEngine2.Engine.Items[ff]).FNumber=Number then
            TAidKitSprite(DXSpriteEngine2.Engine.Items[ff]).Dead;
          if TEquipmentSprite(DXSpriteEngine2.Engine.Items[ff]).FNumber=Number then
            TEquipmentSprite(DXSpriteEngine2.Engine.Items[ff]).Dead;
          if TMineSprite(DXSpriteEngine2.Engine.Items[ff]).FNumber=Number then
            TMineSprite(DXSpriteEngine2.Engine.Items[ff]).Dead;
          if THiddenMineSprite(DXSpriteEngine2.Engine.Items[ff]).FNumber=Number then
            THiddenMineSprite(DXSpriteEngine2.Engine.Items[ff]).Dead
        end
    end
end;

{ Numbers }

function FindSprite(Engine: TSpriteEngine;
  Number: Integer): TSprite;
var
  ff: Integer;
begin
  with Main do
    begin
      for ff:=0 to Engine.Count-1 do
        begin
          if TAidKitSprite(Engine.Items[ff]).FNumber=Number then
            begin
              Result:=TAidKitSprite(Engine.Items[ff]);
              Exit
            end;
          if TEquipmentSprite(Engine.Items[ff]).FNumber=Number then
            begin
              Result:=TEquipmentSprite(Engine.Items[ff]);
              Exit
            end;
          if TMineSprite(Engine.Items[ff]).FNumber=Number then
            begin
              Result:=TMineSprite(Engine.Items[ff]);
              Exit
            end;
          if THiddenMineSprite(Engine.Items[ff]).FNumber=Number then
            begin
              Result:=THiddenMineSprite(Engine.Items[ff]);
              Exit
            end
        end
    end
end;

procedure UpDateList;
var
  s: string;
begin
  with Main do
    begin
      for f:=0 to DXApriteEngine.Engine.Count-1 do
        begin
          if DXApriteEngine.Engine.Items[f] is TPlayerSprite then
            s:=SpriteType[0];
          if DXApriteEngine.Engine.Items[f] is TSecondPlayer then
            s:=SpriteType[1];
          if DXApriteEngine.Engine.Items[f] is TWallSprite then
            s:=SpriteType[2];
          if DXApriteEngine.Engine.Items[f] is THiddenWallSprite then
            s:=SpriteType[3];
          if DXApriteEngine.Engine.Items[f] is TAidKitSprite then
            begin
              s:=SpriteType[4];
              s:=s+IntToStr(TAidKitSpriteDXApriteEngine.Engine.Items[f])
            end;
          if DXApriteEngine.Engine.Items[f] is TEquipmentSprite then
            s:=SpriteType[5];
          if DXApriteEngine.Engine.Items[f] is TMineSprite then
            s:=SpriteType[6];
          if DXApriteEngine.Engine.Items[f] is THiddenMineSprite then
            s:=SpriteType[7];
          if DXApriteEngine.Engine.Items[f] is TPistolSprite then
            s:=SpriteType[8];
          if DXApriteEngine.Engine.Items[f] is TRifleSprite then
            s:=SpriteType[9];
          if DXApriteEngine.Engine.Items[f] is TRocketSprite then
            s:=SpriteType[10];
          if DXApriteEngine.Engine.Items[f] is TBoomSprite then
            s:=SpriteType[11];
          if DXApriteEngine.Engine.Items[f] is TLaserSprite then
            s:=SpriteType[12];
          if DXApriteEngine.Engine.Items[f] is TFireSprite then
            s:=SpriteType[13];
          if DXApriteEngine.Engine.Items[f] is TPlasmaSprite then
            s:=SpriteType[14];
        end;
    end
end;

{ TMain }

procedure TMain.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled:=false
end;

procedure TMain.LoadMap(FileName: string);
var
  Map: TextFile;
  s: string;
  h: Char;
  Err,f2,l2: Integer;
begin
  DXSpriteEngine.Dead;
  DXSpriteEngine.Engine.Clear;
  DXSpriteEngine2.Dead;
  DXSpriteEngine2.Engine.Clear;
  AssignFile(Map,FileName);
  Reset(Map);
  readln(Map,s);
  Val(s,FMapWidth,Err);
  readln(Map,s);
  Val(s,FMapHeight,Err);
  with TBackgroundSprite.Create(DXSpriteEngine.Engine) do
    begin
      SetMapSize(FMapWidth,FMapHeight);
      Image:=dxilLand.Items.Find('Land');
      Z:=-2;
      Tile:=true
    end;
  with TBackgroundSprite.Create(DXSpriteEngine2.Engine) do
    begin
      SetMapSize(FMapWidth,FMapHeight);
      Image:=dxilLand.Items.Find('Land');
      Z:=-2;
      Tile:=true
    end;
  for l:=1 to FMapHeight do
    for f:=1 to FMapWidth do
      begin
        read(Map,h);
        Val(h,d,Err);
        FMap[f,l]:=d;
        case d of
          1:begin
              with TWallSprite.Create(DXSpriteEngine.Engine) do
                begin
                  X:=(f-1)*LandSize;
                  Y:=(l-1)*LandSize
                end;
              with TWallSprite.Create(DXSpriteEngine2.Engine) do
                begin
                  X:=(f-1)*LandSize;
                  Y:=(l-1)*LandSize
                end
            end;
          2:begin
              with THiddenWallSprite.Create(DXSpriteEngine.Engine) do
                begin
                  X:=(f-1)*LandSize;
                  Y:=(l-1)*LandSize
                end;
              with THiddenWallSprite.Create(DXSpriteEngine2.Engine) do
                begin
                  X:=(f-1)*LandSize;
                  Y:=(l-1)*LandSize
                end
            end;
          3:begin
              n:=GetNumber;
              with TAidKitSprite.Create(DXSpriteEngine.Engine) do
                begin
                  FNumber:=n;
                  X:=(f-1)*LandSize+8;
                  Y:=(l-1)*LandSize+7
                end;
              with TAidKitSprite.Create(DXSpriteEngine2.Engine) do
                begin
                  FNumber:=n;
                  X:=(f-1)*LandSize+8;
                  Y:=(l-1)*LandSize+7
                end
            end;
          4:begin
              n:=GetNumber;
              with TEquipmentSprite.Create(DXSpriteEngine.Engine) do
                begin
                  FNumber:=n;
                  X:=(f-1)*LandSize+5;
                  Y:=(l-1)*LandSize+5
                end;
              with TEquipmentSprite.Create(DXSpriteEngine2.Engine) do
                begin
                  FNumber:=n;
                  X:=(f-1)*LandSize+5;
                  Y:=(l-1)*LandSize+5
                end
            end;
          5:begin
              n:=GetNumber;
              with TMineSprite.Create(DXSpriteEngine.Engine) do
                begin
                  FNumber:=n;
                  FDisableTime:=0;
                  X:=(f-1)*LandSize+5;
                  Y:=(l-1)*LandSize+5
                end;
              with TMineSprite.Create(DXSpriteEngine2.Engine) do
                begin
                  FNumber:=n;
                  FDisableTime:=0;
                  X:=(f-1)*LandSize+5;
                  Y:=(l-1)*LandSize+5
                end
            end;
          6:begin
              n:=GetNumber;
              with THiddenMineSprite.Create(DXSpriteEngine.Engine) do
                begin
                  FNumber:=n;
                  X:=(f-1)*LandSize;
                  Y:=(l-1)*LandSize
                end;
              with THiddenMineSprite.Create(DXSpriteEngine2.Engine) do
                begin
                  FNumber:=n;
                  X:=(f-1)*LandSize;
                  Y:=(l-1)*LandSize
                end
            end
        end
      end;
  CloseFile(Map);
  with TPlayerSprite.Create(DXSpriteEngine.Engine) do
    begin
      WhoPlayer:=true;
      SetImage(1);
      repeat
        f:=Random(FMapWidth)+1;
        l:=Random(FMapHeight)+1;
      until FMap[f,l]=0;
      X:=(f-1)*LandSize;
      Y:=(l-1)*LandSize
    end;
  with TPlayerSprite.Create(DXSpriteEngine2.Engine) do
    begin
      WhoPlayer:=false;
      SetImage(1);
      repeat
        f2:=Random(FMapWidth)+1;
        l2:=Random(FMapHeight)+1;
      until (FMap[f2,l2]=0) and
        (f2<>f) and (l2<>l);
      X:=(f2-1)*LandSize;
      Y:=(l2-1)*LandSize
    end;
  with TSecondPlayer.Create(DXSpriteEngine.Engine) do
    begin
      WhoPlayer:=false;
      SetImage(1);
      X:=(f2-1)*LandSize;
      Y:=(l2-1)*LandSize;
      Z:=2
    end;
  with TSecondPlayer.Create(DXSpriteEngine2.Engine) do
    begin
      WhoPlayer:=true;
      SetImage(1);
      X:=(f-1)*LandSize;
      Y:=(l-1)*LandSize;
      Z:=2
    end;
  with Player1 do
    begin
      Life:=100;
      X:=(f-1)*LandSize;
      Y:=(l-1)*LandSize;
      Gun[0]:=5;
      for f:=1 to 8 do Gun[f]:=0;
      PistolOn:=false;
      RocketOn:=false;
      LaserOn:=false;
      MineOn:=false;
      Weapon:=0;
      State:=1;
      SelectTime:=MaxSelectTime
    end;
  with Player2 do
    begin
      Life:=100;
      X:=(f2-1)*LandSize;
      Y:=(l2-1)*LandSize;
      Gun[0]:=5;
      for f:=1 to 8 do Gun[f]:=0;
      PistolOn:=false;
      RocketOn:=false;
      LaserOn:=false;
      MineOn:=false;
      Weapon:=0;
      State:=1;
      SelectTime:=MaxSelectTime
    end;
  SetWeapon(true,0);
  SetWeapon(false,0);
  Life.Percent:=100;
  Life2.Percent:=100;
  DXTimer.Enabled:=true

end;

procedure TMain.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then Exit;
  DXInput.UpDate;
  DXInput2.UpDate;
  DXSpriteEngine.Move(LagCount);
  DXSpriteEngine.Dead;
  DXSpriteEngine.Draw;
  DXDraw.Flip;
  DXSpriteEngine2.Move(LagCount);
  DXSpriteEngine2.Dead;
  DXSpriteEngine2.Draw;
  DXDraw2.Flip
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  Randomize;
  SetWeapon(true,0);
  SetWeapon(false,0);
  Screen.Cursors[crPurpose]:=LoadCursor(HInstance,'PURPOSE');
  Image1.Cursor:=crPurpose;
  with DXInput.Keyboard do
    begin
      KeyAssigns[isUp,0]:=0;
      KeyAssigns[isRight,0]:=0;
      KeyAssigns[isDown,0]:=0;
      KeyAssigns[isLeft,0]:=0;
      KeyAssigns[isButton1,0]:=0;
      KeyAssigns[isButton2,0]:=0;
      KeyAssigns[isUp,2]:=0;
      KeyAssigns[isRight,2]:=0;
      KeyAssigns[isDown,2]:=0;
      KeyAssigns[isLeft,2]:=0;
      KeyAssigns[isButton1,2]:=0;
      KeyAssigns[isButton2,2]:=0;
      KeyAssigns[isUp,1]:=69;
      KeyAssigns[isRight,1]:=70;
      KeyAssigns[isDown,1]:=68;
      KeyAssigns[isLeft,1]:=83;
      KeyAssigns[isButton1,1]:=65;
      KeyAssigns[isButton2,1]:=81
    end;
  with DXInput2.Keyboard do
    begin
      KeyAssigns[isUp,0]:=0;
      KeyAssigns[isRight,0]:=0;
      KeyAssigns[isDown,0]:=0;
      KeyAssigns[isLeft,0]:=0;
      KeyAssigns[isButton1,0]:=0;
      KeyAssigns[isButton2,0]:=0;
      KeyAssigns[isUp,2]:=0;
      KeyAssigns[isRight,2]:=0;
      KeyAssigns[isDown,2]:=0;
      KeyAssigns[isLeft,2]:=0;
      KeyAssigns[isButton1,2]:=0;
      KeyAssigns[isButton2,2]:=0;
      KeyAssigns[isButton1,1]:=13;
      KeyAssigns[isButton2,1]:=8
    end;
end;

{procedure TMain.BalanceNumbers(SE: TDXSpriteEngine;
      Start: Integer);
begin
  with SE.Engine do
    for f:=Start to Count-1 do
      begin
        if Items[f] is TAidKitSprite then
          dec(TAidKitSprite(Items[f]).FNumber);
        if Items[f] is TEquipmentSprite then
          dec(TEquipmentSprite(Items[f]).FNumber);
        if Items[f] is TMineSprite then
          dec(TMineSprite(Items[f]).FNumber);
        if Items[f] is THiddenMineSprite then
          dec(THiddenMineSprite(Items[f]).FNumber)
      end
end;}

procedure TMain.DXDrawInitialize(Sender: TObject);
begin
  DXWaveList.Items.Find('Music').Play(false)
end;

procedure TMain.CheckPlayer(Who: Boolean);
begin
  if Who and (Player1.Life<=0) then
    begin
      DXTimer.Enabled:=false;
      Lose.Label1.Visible:=true;
      Lose.Label2.Visible:=false;
      Lose.ShowModal
    end
                             else
   if not Who and (Player2.Life<=0) then
    begin
      DXTimer.Enabled:=false;
      Lose.Label1.Visible:=false;
      Lose.Label2.Visible:=true;
      Lose.ShowModal
    end
end;

procedure TMain.Image1Click(Sender: TObject);
begin
  if odMap.Execute then
    begin
      FFileName:=odMap.FileName;
      with Player1 do
        begin
          Life:=100;
        end;
      LoadMap(FFileName)
    end
end;

procedure TMain.SetWeapon(Who: Boolean;
  Number: Byte);
begin
  if Who then
    begin
      imgWeapon1.Canvas.FillRect(imgWeapon1.ClientRect);
      ilWeapons.Draw(imgWeapon1.Canvas,
        0,0,Number);
      SetWeaponCount(true,Number)
    end
         else
    begin
      imgWeapon2.Canvas.FillRect(imgWeapon2.ClientRect);
      ilWeapons.Draw(imgWeapon2.Canvas,
        0,0,Number);
      SetWeaponCount(false,Number)  
    end
end;

procedure TMain.SetWeaponCount(Who: Boolean; Number: Byte);
begin
  if Who then
    lblWeaponCount1.Caption:=IntToStr(Player1.Gun[Number])
         else
    lblWeaponCount2.Caption:=IntToStr(Player2.Gun[Number])
end;

procedure TMain.SetLife(Who: Boolean);
begin
  if Who then
    Life.Percent:=Player1.Life
               else
    Life2.Percent:=Player2.Life
end;

end.
