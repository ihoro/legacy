unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ExtDlgs, Registry, ColorsFrm,
  GlobalVars, MPlayer, Printers, ComCtrls, ClipBrd;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Cross: TImage;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Timer1: TTimer;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    SavePic: TSaveDialog;
    LoadPic: TOpenDialog;
    N17: TMenuItem;
    N18: TMenuItem;
    SaveJCD: TSaveDialog;
    miScale: TMenuItem;
    LoadJCD: TOpenDialog;
    opdImportPic: TOpenPictureDialog;
    mmiImportPic: TMenuItem;
    imgImportPic: TImage;
    ImportImg: TImage;
    mmiOptions: TMenuItem;
    mmiColors: TMenuItem;
    mmiBakground: TMenuItem;
    mmiMusic: TMenuItem;
    odMusic2: TOpenDialog;
    MediaPlayer1: TMediaPlayer;
    mmiMusicFile: TMenuItem;
    mmiMusicOnOff: TMenuItem;
    tmrMusic: TTimer;
    opdBackground: TOpenPictureDialog;
    PrintDialog1: TPrintDialog;
    N19: TMenuItem;
    mmiPrint: TMenuItem;
    mmiPrintColor: TMenuItem;
    mmiPrintMon: TMenuItem;
    mmiHelp: TMenuItem;
    mmiDoHelp: TMenuItem;
    N20: TMenuItem;
    mmiAbout: TMenuItem;
    mmiDecision: TMenuItem;
    mmiEnter: TMenuItem;
    N22: TMenuItem;
    mmiBuffer: TMenuItem;
    N21: TMenuItem;
    mmiSaveAsBMP: TMenuItem;
    opdBuffer: TSavePictureDialog;
    mmiSpeed: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CrossMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CrossMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CrossMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N11Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure miScaleClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure mmiImportPicClick(Sender: TObject);
    procedure mmiColorsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmiBakgroundClick(Sender: TObject);
    procedure mmiMusicFileClick(Sender: TObject);
    procedure tmrMusicTimer(Sender: TObject);
    procedure mmiMusicOnOffClick(Sender: TObject);
    procedure LoadPicShow(Sender: TObject);
    procedure LoadJCDShow(Sender: TObject);
    procedure odMusic2Show(Sender: TObject);
    procedure opdImportPicShow(Sender: TObject);
    procedure opdBackgroundShow(Sender: TObject);
    procedure SaveJCDShow(Sender: TObject);
    procedure SavePicShow(Sender: TObject);
    procedure mmiPrintMonClick(Sender: TObject);
    procedure mmiPrintColorClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure mmiDoHelpClick(Sender: TObject);
    procedure mmiAboutClick(Sender: TObject);
    procedure mmiDecisionClick(Sender: TObject);
    procedure mmiEnterClick(Sender: TObject);
    procedure mmiBufferClick(Sender: TObject);
    procedure mmiSaveAsBMPClick(Sender: TObject);
    procedure mmiSpeedClick(Sender: TObject);
  private
    FParams: string;
    procedure PlayNext;
    { Private declarations }
  public
    FMusic: Integer;
//    function HeCan: Boolean; //TODO: Here!
    { Public declarations }
  end;

const
      Key = 15;
      MaxTemp = 10;
      X1pr: Byte = 3;
      X2pr: Byte = 1;
      Ypr: Byte = 1;
      OIVSoft: string = 'Copiright (C) 2001 by OIVSoft';
      StandartName = 'Кроссворд.jce';
      StandartJCDName = 'Запись.jcd';
      StandartMain = 'Японский кроссворд - ';
      StandartTemp = '$jc$';
      StandartExtTemp = '.ja$';
      StandartExtWorkTemp = '.wo$';
      PointSize: Byte = 10; {10x10}
      PointMaxTypeSize = 5;
      TypeSize: array[1..PointMaxTypeSize] of Byte =
        (10,12,14,17,21);
      TypeFontSize: array[1..PointMaxTypeSize] of Byte =
        (5,7,8,10,12);
      TypeX1Pr: array[1..PointMaxTypeSize] of Byte =
        (3,3,4,5,6);
      LimitSize = 5;
      LimitFonts = 3;
      ccLine = clBlack;
      ccTitle: TColor = $00D6D3D3;
      ccPoint: TColor = $00896632;
      ccFonFigures: TColor = clSilver;
      ccFigures: TColor = clBlack;
      ccClear: TColor = $00038BAD;
      ccFon2Figures: TColor = $006FB388;
      StandartTitle: TColor = $00D6D3D3;
      StandartPoint: TColor = $00896632;
      StandartFonFigures: TColor = clSilver;
      StandartFigures: TColor = clBlack;
      StandartClear: TColor = $00038BAD;
      StandartFon2Figures: TColor = $006FB388;

type
     TCrossFile = record
         CrosswordX: Word;
         CrosswordY: Word;
         CrosswordPicture: TCrossword
       end;
     TWork = array[-50..200,-50..200] of 0..2;
     TFiguresPole = array[1..200,1..100] of Boolean;
     TWorkFile = record
         CleanPole: TCrossFile;
         WorkPole: TWork;
         XFigPole,YFigPole: TFiguresPole
       end;
     TWorkTemp = record
         WorkP: TWork;
         XFigP,YFigP: TFiguresPole
       end;
     TJCD = record
         WorkArea: TWorkFile;
         ScaleSize: Byte;
         UserColors: TAColors
       end;

var
  Form1: TForm1;
  JaponTitle: TBitmap;
  BufferPic: TBitmap;
  TempC: TCrossword;
  Crossword: TCrossFile;
  RegSetup: TRegistry;
  JCD: file of TJCD;
  TempJCD: TJCD;
  cx,cy,tx,ty,MaxX,MaxY,MaxFX,MaxFY: Word;
  LastX,LastY,f,l,r,t: Integer;
  k,b:Real;
  Opened,Vert,First,
  DidntOpen,DidntSave,Saved: Boolean;
  MainMode, {true-play; false-edit}
  PenOn,SetDel,
  OnFirst,Lastly: Boolean;
  DelClear:0..2;
  TekDir,JapName,TempN: String;
  Jap: Text;
  TotalTemp: Word;
  JapTemp,JapRead: File of TCrossFile;
  WorkTemp,WorkRead:File of TWorkTemp;
  TekWork: TWorkTemp;
  TekCross: TCrossFile;
  FigX,FigY: TFigures;
  FigXP,FigYP: TFiguresPole;
  Work: TWork;
  CurrentPointSize: 1..PointMaxTypeSize;
  FileErrors: Byte;
  ImportPicOn: Boolean;
  orgX, orgY: Integer;
  ccLineBlack: TColor;
  TotalPoints, CurrentPoints: Integer;
  FirstCong: Boolean = true;
  TitleMusic: string;
  WriteError: Boolean = false;
  MusicOnOff: Boolean = false;
  OpenJAP, OpenJCD, OpenPicture,
  OpenMusic, OpenImport: string;
  OpenPictureFirst: Boolean = true;
  OpenMusicFirst: Boolean = true;
  OpenJAPFirst: Boolean = true;
  OpenJCDFirst: Boolean = true;
  OpenImportFirst: Boolean = true;
  Loading: Boolean = false;
  LoadingFlag: Boolean = false;
  Pass3: Boolean = false;
  OldName: string;
  AutoLoad: Boolean = false;
  AutoLoadFileName: string;

procedure PutWPoint(x,y:Integer;SetDel:Boolean);
function LengthPole(XY:Word):Word;
procedure MenuChange(MM: Boolean);
procedure DrawEdit;
procedure GetPoint(mx,my:Integer;var x,y:Integer);
procedure PutPoint(x,y:Integer;SetDel:Boolean);
procedure GetLine(x1,y1,x2,y2:Integer;var kk,kb:Real);
procedure PutAllPoint;
procedure SaveCrossword(FileName:String;Crossw:TCrossword);
function ToStr(Arg:Integer):String;
function BoToStr(Bo:Boolean):Char;
procedure NameChange;
function CutName(NamePath:String):String;
function CutPath(NamePath:String):String;
procedure N9Proc;
procedure NewCross;
function LoadCrossword(FileName:String;var cX,cY:Word;var Crosswor:TCrossword):Boolean;
procedure LoadC;
function ErrorFile(FileName:String):Boolean;
procedure SaveAs;
procedure SaveTemp;
procedure LoadTemp;
procedure ClearTemp;
procedure TempCreate;
procedure TempDestroy;
procedure TempOffset;
procedure ClearLeft;
procedure WhitePole;
procedure PutFigures;
procedure GetWPoint(mx,my:Integer;var x,y:Integer);
procedure GetFig;
procedure SetStandartPointSize;
function SizeError(Size: Byte): Boolean;
procedure SaveJCDFile(FileName: String);
function OpenJCDFile(FileName: String): Boolean;
procedure ReadSetup;
procedure WriteSetup;
function RealFile(FileName: string): Boolean;
procedure StartPlay;
procedure ForAllE;

implementation

uses
  PicSize, Coder, ScaleFrm,
  CongratulationsFrm, GamePasswordsFrm, WritingFrm, About, MusicListFrm,
  DecisionFrm, EnterFrm, ViewerFrm;

{$R *.DFM}

procedure StartPlay;
var
  NewName: string;
begin
  with Form1.MediaPlayer1 do
    begin
      if Mode=mpPlaying then Stop;
      FileName:=TitleMusic;
      NewName:=FileName;
      try
        Open;
      except
        FileName:=OldName;
        TitleMusic:=OldName;
        OpenMusic:=OldName;
        WriteSetup;
        if FileName='jc.wav' then
          begin
            MusicOnOff:=false;
            Form1.mmiMusicOnOff.Caption:='&Включить';
            Form1.mmiMusicOnOff.Enabled:=false;
            MessageDlg('Ошибка чтения файла '+ExtractFileName(NewName),
              mtError,[mbOK],0);
            Exit
          end;
        Open;
        Play;
        MessageDlg('Ошибка чтения файла '+ExtractFileName(NewName),
          mtError,[mbOK],0);
        Exit
      end;
      try
        Play
      except
        FileName:=OldName;
        TitleMusic:=OldName;
        OpenMusic:=OldName;
        WriteSetup;
        if FileName='jc.wav' then
          begin
            MusicOnOff:=false;
            Form1.mmiMusicOnOff.Caption:='&Включить';
            Form1.mmiMusicOnOff.Enabled:=false;
            MessageDlg('Ошибка воспроизведения файла '+ExtractFileName(NewName),
              mtError,[mbOK],0);
            Exit
          end;
        Open;
        Play;
        MessageDlg('Ошибка воспроизведения файла '+ExtractFileName(NewName),
          mtError,[mbOK],0)
      end
    end
end;

function RealFile(FileName: string): Boolean;
begin
  Result:=true;
  if not FileExists(FileName) then Result:=false
end;

procedure WriteSetup;
begin
  RegSetup.WriteInteger('Background',ColorToRGB(ccTitle));
  RegSetup.WriteInteger('Point',ColorToRGB(ccPoint));
  RegSetup.WriteInteger('BackgroundFigures',ColorToRGB(ccFonFigures));
  RegSetup.WriteInteger('Figures',ColorToRGB(ccFigures));
  RegSetup.WriteInteger('Clear',ColorToRGB(ccClear));
  RegSetup.WriteInteger('BackgroundFigures2',ColorToRGB(ccFon2Figures));

  RegSetup.WriteString('BackgroundFile',TitleFile);
  {RegSetup.WriteString('MainDirectory',TekDir);}
  RegSetup.WriteString('Import',OpenImport);
  RegSetup.WriteString('JCE',OpenJAP);
  RegSetup.WriteString('JCD',OpenJCD);
  RegSetup.WriteBool('MusicOnOff',MusicOnOff);
  RegSetup.WriteInteger('Count',MusicList.lbMusicList.Items.Count);
  with MusicList.lbMusicList do
    for f:=0 to Items.Count-1 do
      RegSetup.WriteString('Music'+IntToStr(f),Items[f])
end;

procedure ReadSetup;
var
  s: string;
begin
  if not RegSetup.OpenKey('\SOFTWARE\OIVSoft\Japanese Crossword',false) then
    begin
      RegSetup.OpenKey('\SOFTWARE\OIVSofСУanese Crossword',true);
      RegSetup.WriteInteger('Background',ColorToRGB(ccTitle));
      RegSetup.WriteInteger('Point',ColorToRGB(ccPoint));
      RegSetup.WriteInteger('BackgroundFigures',ColorToRGB(ccFonFigures));
      RegSetup.WriteInteger('Figures',ColorToRGB(ccFigures));
      RegSetup.WriteInteger('Clear',ColorToRGB(ccClear));
      RegSetup.WriteInteger('BackgroundFigures2',ColorToRGB(ccFon2Figures));

      RegSetup.WriteString('BackgroundFile',TitleFile);
      {RegSetup.WriteString('Music','jc.wav');}
      RegSetup.WriteString('Import',TekDir+'\'+StandartTitleFile);
      RegSetup.WriteString('JCE',TekDir);
      RegSetup.WriteString('JCD',TekDir);
      RegSetup.WriteBool('MusicOnOff',false);
      RegSetup.WriteInteger('Count',0);
      ReadSetup
    end
                                                                     else
    begin
      ccTitle:=TColor(RegSetup.ReadInteger('Background'));
      ccPoint:=TColor(RegSetup.ReadInteger('Point'));
      ccFonFigures:=TColor(RegSetup.ReadInteger('BackgroundFigures'));
      ccFigures:=TColor(RegSetup.ReadInteger('Figures'));
      ccClear:=TColor(RegSetup.ReadInteger('Clear'));
      ccFon2Figures:=TColor(RegSetup.ReadInteger('BackgroundFigures2'));

      TitleFile:=RegSetup.ReadString('BackgroundFile');
      TekDir:=RegSetup.ReadString('MainDirectory');
      OpenImport:=RegSetup.ReadString('Import');
      OpenJAP:=RegSetup.ReadString('JCE');
      OpenJCD:=RegSetup.ReadString('JCD');
      MusicOnOff:=RegSetup.ReadBool('MusicOnOff');
      l:=RegSetup.ReadInteger('Count');
      if l=0 then MusicOnOff:=false;
      if l<>0 then Form1.mmiMusicOnOff.Enabled:=true;
      for f:=0 to l-1 do
        begin
          s:=RegSetup.ReadString('Music'+IntToStr(f));
          MusicList.lbMusicList.Items.Add(s)
        end
    end;
  OpenPicture:=TitleFile;
  if not FileExists(OpenJAP) then
    begin
      OpenJAP:=TekDir;
      WriteSetup
    end;
  if not FileExists(OpenJCD) then
    begin
      OpenJCD:=TekDir;
      WriteSetup
    end;
  if not FileExists(OpenImport) then
    begin
      OpenImport:=TekDir+'\'+StandartTitleFile;
      WriteSetup
    end;
  if not FileExists(TitleFile) then
    begin
      TitleFile:=StandartTitleFile;
      WriteSetup
    end;
  {if not FileExists(TitleMusic) then
    begin
      TitleMusic:='jc.wav';
      MusicOnOff:=false;
      WriteSetup
    end}
end;

procedure GetFig;
begin
for l:=1 to 200 do
  begin
    FigX.Total[l]:=0;
    FigY.Total[l]:=0;
    for f:=1 to 100 do
      begin
        FigX.Fig[l,f]:=0;
        FigY.Fig[l,f]:=0
      end
  end;
Lastly:=false;
for f:=1 to Crossword.CrosswordX do
 begin
  Lastly:=false;
  for l:=Crossword.CrosswordY downto 1 do
    if Crossword.CrosswordPicture[f,l] then
      if not Lastly then
        begin
          inc(FigX.Total[f]);
          inc(FigX.Fig[f,FigX.Total[f]]);
          Lastly:=true
        end
                    else
        inc(FigX.Fig[f,FigX.Total[f]])
                                       else
      Lastly:=false;
 end;
for f:=1 to Crossword.CrosswordX do
  if FigX.Total[f]=0 then
    begin
      FigX.Total[f]:=1;
      FigX.Fig[f,1]:=0
    end;
Lastly:=false;
for f:=1 to Crossword.CrosswordY do
 begin
  Lastly:=false;
  for l:=Crossword.CrosswordX downto 1 do
    if Crossword.CrosswordPicture[l,f] then
      if not Lastly then
        begin
          inc(FigY.Total[f]);
          inc(FigY.Fig[f,FigY.Total[f]]);
          Lastly:=true
        end
                    else
        inc(FigY.Fig[f,FigY.Total[f]])
                                       else
      Lastly:=false;
 end;
for f:=1 to Crossword.CrosswordY do
  if FigY.Total[f]=0 then
    begin
      FigY.Total[f]:=1;
      FigY.Fig[f,1]:=0
    end;
MaxFX:=0;
for f:=1 to Crossword.CrosswordX do
  if FigX.Total[f]>MaxFX then MaxFX:=FigX.Total[f];
MaxFY:=0;
for l:=1 to Crossword.CrosswordY do
  if FigY.Total[l]>MaxFY then MaxFY:=FigY.Total[l]
end;

function SizeError(Size: Byte): Boolean;
begin
  Result:=false;
  if (Crossword.CrosswordX<=MaxX) and
       (Crossword.CrosswordY<=MaxY) and
         LoadingFlag then
    begin
      LoadingFlag:=false;
      Exit
    end;
  if (TypeSize[Size]*(Crossword.CrosswordY+MaxFX)>Form1.ClientHeight) or
       (TypeSize[Size]*(Crossword.CrosswordX+MaxFY)>Form1.ClientWidth) then
    Result:=true
end;

procedure SaveJCDFile(FileName: String);
begin
  Assign(JCD,FileName);
  Rewrite(JCD);
  with TempJCD do
    begin
      WorkArea.CleanPole:=Crossword;
      WorkArea.WorkPole:=Work;
      WorkArea.XFigPole:=FigXP;
      WorkArea.YFigPole:=FigYP;
      ScaleSize:=CurrentPointSize;
      UserColors[1]:=ccTitle;
      UserColors[2]:=ccPoint;
      UserColors[3]:=ccClear;
      UserColors[4]:=ccFonFigures;
      UserColors[5]:=ccFon2Figures;
      UserColors[6]:=ccFigures
    end;
  try
  write(JCD,TempJCD);
  except
  WriteError:=true;
  MessageDlg('Ошибка записи файла '+ExtractFileName(FileName),
    mtError,[mbOK],0);
  Close(JCD);
  Erase(JCD);
  Exit
  end;
  Close(JCD)
end;

function OpenJCDFile(FileName: String): Boolean;
var
  PCrossword: TCrossFile;
begin
  Result:=true;
  Assign(JCD,FileName);
  Reset(JCD);
  {$I-}
  read(JCD,TempJCD);
  if IOResult<>0 then
    begin
      FileErrors:=2;
      Result:=false;
      Exit
    end;
  {I+}
  with TempJCD do
    begin
      PCrossword:=Crossword;
      Crossword:=WorkArea.CleanPole;
      GetFig;
      LoadingFlag:=true;
      if SizeError(1) then
        begin
          Crossword:=PCrossword;
          GetFig;
          FileErrors:=1;
          Result:=false;
          Exit
        end;
      {Crossword:=WorkArea.CleanPole;}
      Work:=WorkArea.WorkPole;
      FigXP:=WorkArea.XFigPole;
      FigYP:=WorkArea.YFigPole;
      {GetFig;}
      CurrentPointSize:=ScaleSize;
      if SizeError(CurrentPointSize) then
        for f:=1 to PointMaxTypeSize do
         begin
          LoadingFlag:=true;
          if SizeError(f) then
            begin
              CurrentPointSize:=f-1;
              Break
            end;
         end;
      PointSize:=TypeSize[CurrentPointSize];
      Form1.Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
      if CurrentPointSize>=LimitFonts then
        Form1.Cross.Canvas.Font.Name:='MS Sans Serif'
                             else
        Form1.Cross.Canvas.Font.Name:='Small Fonts';
      X1pr:=TypeX1pr[CurrentPointSize];
      ccTitle:=UserColors[1];
      ccPoint:=UserColors[2];
      ccClear:=UserColors[3];
      ccFonFigures:=UserColors[4];
      ccFon2Figures:=UserColors[5];
      ccFigures:=UserColors[6]
    end;
  Close(JCD)
end;

procedure SetStandartPointSize;
begin
  CurrentPointSize:=1;
  PointSize:=TypeSize[CurrentPointSize];
  Form1.Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
  Form1.Cross.Canvas.Font.Name:='Small Fonts';
  X1pr:=TypeX1pr[CurrentpointSize]
end;

function LengthPole(XY:Word):Word;
var d,l:Word;
begin
l:=0;
if odd(XY) then d:=(XY-1) div 2+1
           else d:=XY div 2;
while d>1 do
  begin
    inc(l,d);
    if odd(d) then d:=d-(d-1) div 2-1
              else d:=d-d div 2;
    if odd(d) then d:=(d-1) div 2+1
              else d:=d div 2
  end;
LengthPole:=l
end;

procedure WhitePole;
begin
with Form1 do
begin
with Cross do
  Canvas.StretchDraw(Rect(0,0,Width,Height),JaponTitle);
{with Cross.Canvas do
  begin
    Brush.Color:=ccTitle;
    FillRect(Rect(0,0,Cross.Width-1,Cross.Height-1))
  end}
end
end;

function ErrorFile(FileName:String):Boolean;
var
  tf: Text;
begin
Assign(tf,FileName);
{$I-}
Reset(tf);
{$I+}
if IOResult<>0 then
  ErrorFile:=false
               else
  begin
    ErrorFile:=true;
    Close(tf)
  end
end;

procedure PutFigures;
var
  s: String;
begin
cx:=Form1.Cross.Width div 2-(Crossword.CrosswordX*PointSize+MaxFY*PointSize) div 2+MaxFY*PointSize;
cy:=Form1.Cross.Height div 2-(Crossword.CrosswordY*PointSize+MaxFX*PointSize) div 2+MaxFX*PointSize;
with Form1.Cross.Canvas do
begin
  Brush.Color:=ccTitle;
  FillRect(Rect(cx-MaxFY*PointSize,cy-MaxFX*PointSize,
                cx+Crossword.CrosswordX*PointSize,
                cy+Crossword.CrosswordY*PointSize));
  Pen.Color:=ccLine;
  Pen.Width:=1;
  for f:=1 to Crossword.CrosswordY+1 do
    begin
      MoveTo(cx,cy+f*PointSize-PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize{+1},cy+f*PointSize-PointSize)
    end;
  for f:=1 to Crossword.CrosswordX+1 do
    begin
      MoveTo(cx+f*PointSize-PointSize,cy);
      LineTo(cx+f*PointSize-PointSize,cy+Crossword.CrosswordY*PointSize{+1})
    end;
  Pen.Width:=2;
  MoveTo(cx+Crossword.CrosswordX*PointSize,cy+1);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy+Crossword.CrosswordY*PointSize-1);
  MoveTo(cx+1,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize-1,cy+Crossword.CrosswordY*PointSize-1);
  for f:=1 to Crossword.CrosswordX div 5 do
    begin
      MoveTo(cx+f*(LimitSize*PointSize),cy+1);
      LineTo(cx+f*(LimitSize*PointSize),cy-1+Crossword.CrosswordY*PointSize)
    end;
  for f:=1 to Crossword.CrosswordY div 5 do
    begin
      MoveTo(cx+1,cy+f*(LimitSize*PointSize));
      LineTo(cx-1+Crossword.CrosswordX*PointSize,cy+f*(LimitSize*PointSize))
    end;
  Pen.Width:=1;
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy);
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx-MaxFY*PointSize,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx,cy+Crossword.CrosswordY*PointSize);
  Brush.Color:=ccFonFigures;
  FloodFill(cx-5,cy-5,ccLine,fsBorder);
  for f:=1 to MaxFX do
    begin
      MoveTo(cx,cy-f*PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize,cy-f*PointSize)
    end;
  for f:=1 to MaxFY do
    begin
      MoveTo(cx-f*PointSize,cy);
      LineTo(cx-f*PointSize,cy+Crossword.CrosswordY*PointSize)
    end;
  for f:=0 to Crossword.CrosswordX-1 do
    begin
      MoveTo(cx+f*PointSize,cy);
      LineTo(cx+f*PointSize,cy-MaxFX*PointSize)
    end;
  for f:=0 to Crossword.CrosswordY-1 do
    begin
      MoveTo(cx,cy+f*PointSize);
      LineTo(cx-MaxFY*PointSize,cy+f*PointSize)
    end;
  Font.Color:=ccFigures;
  for f:=1 to Crossword.CrosswordX do
    for l:=1 to FigX.Total[f] do
      begin
        if FigXP[f,l] then
          begin
            Brush.Color:=ccFon2Figures;
            FloodFill(cx+(f-1)*PointSize+5,cy-l*PointSize+5,ccLine,fsBorder)
          end
                      else
          Brush.Color:=ccFonFigures;
        str(FigX.Fig[f,l],s);
        if FigX.Fig[f,l]<10 then
          TextOut(cx+(f-1)*PointSize+X1pr,cy-l*PointSize+Ypr,s)
                            else
          TextOut(cx+(f-1)*PointSize+X2pr,cy-l*PointSize+Ypr,s)
      end;
  for f:=1 to Crossword.CrosswordY do
    for l:=1 to FigY.Total[f] do
      begin
        if FigYP[f,l] then
          begin
            Brush.Color:=ccFon2Figures;
            FloodFill(cx-l*PointSize+5,cy+(f-1)*PointSize+5,ccLine,fsBorder)
          end
                      else
          Brush.Color:=ccFonFigures;
        str(FigY.Fig[f,l],s);
        if FigY.Fig[f,l]<10 then
          TextOut(cx-l*PointSize+X1pr,cy+(f-1)*PointSize+Ypr,s)
                            else
          TextOut(cx-l*PointSize+X2pr,cy+(f-1)*PointSize+Ypr,s)
      end
end
end;

function CutName(NamePath:String):String;
begin
Result:=NamePath;
for f:=Length(NamePath) downto 1 do
  if NamePath[f]='\' then
    begin
      CutName:=Copy(NamePath,f+1,Length(NamePath)-f);
      Exit
    end
end;

procedure ClearLeft;
begin
for l:=Crossword.CrosswordY+1 to MaxY do
  for f:=1 to MaxX do
    Crossword.CrosswordPicture[f,l]:=false;
for f:=Crossword.CrosswordX+1 to MaxX do
  for l:=1 to MaxY do
    Crossword.CrosswordPicture[f,l]:=false
end;

function CutPath(NamePath:String):String;
begin
for f:=Length(NamePath) downto 1 do
  if NamePath[f]='\' then
    begin
      CutPath:=Copy(NamePath,1,f);
      Exit
    end
end;

procedure NameChange;
begin
Form1.Caption:=StandartMain+JapName
end;

procedure TempOffset;
var f:Word; 
begin
if MainMode then
  for f:=1 to MaxTemp-1 do
    begin
      Seek(WorkRead,f);
      read(WorkRead,TekWork);
      Seek(WorkTemp,f-1);
      write(WorkTemp,TekWork)
    end
            else
  for f:=1 to MaxTemp-1 do
    begin
      Seek(JapRead,f);
      read(JapRead,TekCross);
      Seek(JapTemp,f-1);
      write(JapTemp,TekCross)
    end
end;

procedure LoadTemp;
begin
if MainMode then
  begin
    Seek(WorkRead,TotalTemp-1);
    read(WorkRead,TekWork);
    FigXP:=TekWork.XFigP;
    FigYP:=TekWork.YFigP;
    Work:=TekWork.WorkP;
    CurrentPoints:=0;
    for f:=1 to Crossword.CrosswordX do
      for l:=1 to Crossword.CrosswordY do
        begin
          if (Work[f,l]=1) and Crossword.CrosswordPicture[f,l] then
            inc(CurrentPoints);
          if (Work[f,l]=1) and not Crossword.CrosswordPicture[f,l] then
            dec(CurrentPoints)
        end;
  end
            else
  begin
    Seek(JapRead,TotalTemp-1);
    read(JapRead,Crossword)
  end;
dec(TotalTemp);
if TotalTemp=0 then
  Form1.N17.Enabled:=false;
if MainMode then
  begin
    WhitePole;
    PutFigures;
    PutAllPoint
  end
            else
  begin
    DrawEdit;
    PutAllPoint
  end
end;

procedure SaveTemp;
begin
Form1.N17.Enabled:=true;
inc(TotalTemp);
if TotalTemp>MaxTemp then
  begin
    TempOffset;
    TotalTemp:=MaxTemp
  end;
if MainMode then
  begin
    Seek(WorkTemp,TotalTemp-1);
    TekWork.WorkP:=Work;
    TekWork.XFigP:=FigXP;
    TekWork.YFigP:=FigYP;
    write(WorkTemp,TekWork)
  end
            else
  begin
    Seek(JapTemp,TotalTemp-1);
    write(JapTemp,Crossword)
  end
end;

function BoToStr(Bo:Boolean):Char;
begin
if Bo then BoToStr:='1'
      else BoToStr:='0'
end;

function ToStr(Arg:Integer):String;
var
    s:String;
begin
str(Arg,s);
ToStr:=s
end;

procedure NewCross;
begin
for l:=1 to MaxY do
  for f:=1 to MaxX do
    Crossword.CrosswordPicture[f,l]:=false;
Crossword.CrosswordX:=MaxX;
Crossword.CrosswordY:=MaxY;
JapName:=StandartName;
NameChange;
DidntSave:=true;
Saved:=true;
ImportPicOn:=false;
DrawEdit
end;

function LoadCrossword(FileName:String;var cX,cY:Word;var Crosswor:TCrossword):Boolean;
var
  PCrossword: TCrossFile;
  c1,c2: Byte;
  f,l,b: Byte;
  Jap: file of Byte;
  s: string;
begin
if MainMode then PCrossword:=Crossword;
AssignFile(Jap,FileName);
Reset(Jap);
read(Jap,c1,c2);
if UpperCase(Chr(c1)+Chr(c2))<>'JE' then
  begin
    LoadCrossword:=false;
    FileErrors:=2;
    Exit
  end;
read(Jap,c1,c2);
cX:=c1;
cY:=c2;
l:=1;
f:=0;
  repeat
      read(Jap,c1);
      for b:=7 downto 0 do
        begin
          inc(f);
          if f>cX then
            begin
              inc(l);
              if l>cY then Break;
              f:=1
            end;
          if c1 and (00000001 shl b)<>0 then
            Crosswor[f,l]:=true
                                             else
            Crosswor[f,l]:=false
        end
  until l>cY;
CloseFile(Jap);
if MainMode then
  begin
    Crossword.CrosswordX:=cX;
    Crossword.CrosswordY:=cY;
    Crossword.CrosswordPicture:=Crosswor;
    GetFig
  end;
LoadingFlag:=true;
if SizeError(1) and MainMode then
  begin
    Result:=false;
    FileErrors:=1;
    Crossword:=PCrossword;
    GetFig;
    Exit
  end;
if not MainMode then
  if (cX>Form1.ClientWidth div TypeSize[1])
       or (cY>Form1.ClientHeight div TypeSize[1]) then
    begin
      Result:=false;
      FileErrors:=1;
      Exit
    end;
LoadCrossword:=true
end;

procedure SaveCrossword(FileName:String;Crossw:TCrossword);
var
  Bits,WByte: Byte;
  f,l: Byte;
begin
AssignFile(Jap,FileName);
try
  Rewrite(Jap);
  write(Jap,'JE',Chr(Crossword.CrosswordX),Chr(Crossword.CrosswordY));
  Bits:=8;
  WByte:=0;
  for l:=1 to Crossword.CrosswordY do
    for f:=1 to Crossword.CrosswordX do
      begin
        dec(Bits);
        if Crossw[f,l] then
          WByte:=WByte or (00000001 shl Bits);
        if Bits=0 then
          begin
            write(Jap,Chr(WByte));
            Bits:=8;
            WByte:=0
          end;
        if (f=Crossword.CrosswordX) and (l=Crossword.CrosswordY) then
          write(Jap,Chr(WByte))
      end
except
WriteError:=true;
MessageDlg('Ошибка записи файла '+ExtractFileName(FileName),mtError,[mbOK],0);
Close(Jap);
Erase(Jap);
Exit
end;
Close(Jap)
end;

procedure GetWPoint(mx,my:Integer;var x,y:Integer);
begin
x:=(mx-cx+1) div PointSize;
if (mx-cx+1) mod PointSize<>0 then
  if (mx-cx+1)<0 then dec(x)
                 else inc(x);
y:=(my-cy+1) div PointSize;
if (my-cy+1) mod PointSize<>0 then
  if (my-cy+1)<0 then dec(y)
                 else inc(y)
end;

procedure GetPoint(mx,my:Integer;var x,y:Integer);
begin
x:=(mx+1) div PointSize;
if (mx+1) mod PointSize<>0 then inc(x);
y:=(my+1) div PointSize;
if (my+1) mod PointSize<>0 then inc(y)
end;

procedure GetLine(x1,y1,x2,y2:Integer;var kk,kb:Real);
begin
if x2=x1 then
  begin
    Vert:=true;
    k:=x1;
    Exit
  end;
kk:=(y2-y1)/(x2-x1);
kb:=y1-kk*x1;
Vert:=false
end;

procedure PutWPoint(x,y:Integer;SetDel:Boolean);
var
  DelX, DelY: Byte;
begin
with Form1.Cross.Canvas do
begin
if Pass3 then
  begin
    if Crossword.CrosswordPicture[x,y] and (Work[x,y]<>1) then
      begin
        inc(CurrentPoints);
        FirstCong:=true
      end;
    if Crossword.CrosswordPicture[x,y] then
      begin
        Work[x,y]:=1;
        Brush.Color:=ccPoint
      end
                                        else
      begin
        Work[x,y]:=2;
        Brush.Color:=ccClear
      end
  end
         else
begin
if SetDel and Crossword.CrosswordPicture[x,y]
  and (Work[x,y]<>1) then
  begin
    inc(CurrentPoints);
    FirstCong:=true
  end;
if SetDel and not Crossword.CrosswordPicture[x,y]
  and (Work[x,y]<>1) then
  begin
    dec(CurrentPoints);
    FirstCong:=true
  end;
if not SetDel and Crossword.CrosswordPicture[x,y]
  and (Work[x,y]=1) then
  begin
    dec(CurrentPoints);
    FirstCong:=true
  end;
if not SetDel and not Crossword.CrosswordPicture[x,y]
  and (Work[x,y]=1) then
  begin
    inc(CurrentPoints);
    FirstCong:=true
  end;
if SetDel then
  begin
    Brush.Color:=ccPoint;
    Work[x,y]:=1
  end
          else
  if DelClear=0 then
    case Work[x,y] of
      0:begin
          Brush.Color:=ccClear;
          DelClear:=2;
          Work[x,y]:=2
        end;
      1,2:begin
          Brush.Color:=ccTitle;
          DelClear:=1;
          Work[x,y]:=0
        end
    end
                else
    case DelClear of
      2:begin
          Brush.Color:=ccClear;
          Work[x,y]:=2
        end;
      1:begin
          Brush.Color:=ccTitle;
          Work[x,y]:=0
        end
    end
end;
if x mod LimitSize=0 then DelX:=1
                     else DelX:=0;
if y mod LimitSize=0 then DelY:=1
                     else DelY:=0;
FillRect(Rect(cx+x*PointSize-PointSize+1,cy+y*PointSize-PointSize+1,
  cx+x*PointSize-DelX,cy+y*PointSize-DelY))
{FloodFill(cx+x*PointSize-3,cy+y*PointSize-3,ccLine,fsBorder)}
end;
if (CurrentPoints=TotalPoints) and FirstCong and not Loading then
  begin
    PenOn:=false;
    FirstCong:=false;
    Congratulations.ShowModal
  end
end;

procedure PutIPoint(x,y:Integer);
var
  DelX, DelY: Byte;
begin
with Form1.Cross.Canvas do
begin
  Brush.Color:=Form1.imgImportPic.Canvas.Pixels[x-1,y-1];
  {if Brush.Color=ccLine then Brush.Color:=ccLineBlack;}
  if Brush.Color=ccPoint then Crossword.CrosswordPicture[x,y]:=true;
  if x mod LimitSize=0 then DelX:=1
                       else DelX:=0;
  if y mod LimitSize=0 then DelY:=1
                       else DelY:=0;
  FillRect(Rect(x*PointSize-PointSize+1,y*PointSize-PointSize+1,
    x*PointSize-DelX,y*PointSize-DelY))
  {FloodFill(x*PointSize-3,y*PointSize-3,ccLine,fsBorder)}
end
end;

procedure PutPoint(x,y:Integer;SetDel:Boolean);
var
  DelX, DelY: Byte;
begin
with Form1.Cross.Canvas do
begin
if SetDel then
  begin
    Brush.Color:=ccPoint;
    Crossword.CrosswordPicture[x,y]:=true
  end
          else
  begin
    Brush.Color:=ccTitle;
    Crossword.CrosswordPicture[x,y]:=false
  end;
Brush.Style:=bsSolid;
if x mod LimitSize=0 then DelX:=1
                     else DelX:=0;
if y mod LimitSize=0 then DelY:=1
                     else DelY:=0;
FillRect(Rect(x*PointSize-PointSize+1,y*PointSize-PointSize+1,
  x*PointSize-DelX,y*PointSize-DelY))
{FloodFill(x*PointSize-3,y*PointSize-3,ccLine,fsBorder)}
end
end;

procedure PutAllPoint;
var
  c: Boolean;
begin
if ImportPicOn then
  begin
    WhitePole;
    DrawEdit;
    for f:=1 to Crossword.CrosswordX do
      for l:=1 to Crossword.CrosswordY do
        begin
          if (f<=Form1.imgImportPic.Width) and
               (l<=Form1.imgImportPic.Height) then
            begin
              if Crossword.CrosswordPicture[f,l] then
                PutPoint(f,l,true)
                                                 else
                PutIPoint(f,l)
            end
                                              else
            PutPoint(f,l,Crossword.CrosswordPicture[f,l])
        end;
    Exit
  end;
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY do
    if MainMode then
      begin
        if (f=Crossword.CrosswordX) and
             (l=Crossword.CrosswordY) then
          Loading:=false;
        case Work[f,l] of
          0,2:begin
                c:=false;
                if Work[f,l]=0 then DelClear:=1
                               else DelClear:=2
              end;
          1:begin
              c:=true;
              DelClear:=0
            end
        end;
        PutWPoint(f,l,c)
      end
                else
      PutPoint(f,l,Crossword.CrosswordPicture[f,l])
end;

procedure DrawEdit;
begin
with Form1 do
begin
with Cross.Canvas do
  begin
    WhitePole;
    Brush.Color:=ccTitle;
    {FillRect(Rect(0,0,Cross.Width-1,Cross.Height-1));}
    FillRect(Rect(0,0,Crossword.CrosswordX*PointSize,
                  Crossword.CrosswordY*PointSize));
    Pen.Color:=ccLine;
    Pen.Width:=1;
    for f:=1 to Crossword.CrosswordY+1 do
      begin
        MoveTo(0,f*PointSize-PointSize);
        LineTo(Crossword.CrosswordX*PointSize+1,f*PointSize-PointSize)
      end;
    for f:=1 to Crossword.CrosswordX+1 do
      begin
        MoveTo(f*PointSize-PointSize,0);
        LineTo(f*PointSize-PointSize,Crossword.CrosswordY*PointSize+1)
      end;
    Pen.Width:=2;
    MoveTo(Crossword.CrosswordX*PointSize,0);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    MoveTo(0,Crossword.CrosswordY*PointSize);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    for f:=0 to Crossword.CrosswordX div 5 do
      begin
        MoveTo(f*(LimitSize*PointSize),0);
        LineTo(f*(LimitSize*PointSize),Crossword.CrosswordY*PointSize)
      end;
    for f:=0 to Crossword.CrosswordY div 5 do
      begin
        MoveTo(0,f*(LimitSize*PointSize));
        LineTo(Crossword.CrosswordX*PointSize,f*(LimitSize*PointSize))
      end
  end
end
end;

procedure MenuChange(MM: Boolean);
begin
with Form1 do
if MM then
  begin
    mmiSaveAsBMP.Enabled:=false;
    mmiBuffer.Enabled:=false;
    N1.Caption:='Кроссворд';
    N11.Caption:='Редактор';
    N2.ShortCut:=N7.ShortCut;
    N3.ShortCut:=N8.ShortCut;
    N4.ShortCut:=N9.ShortCut;
    N7.ShortCut:=0;
    N8.ShortCut:=0;
    N9.ShortCut:=0;
    N7.Enabled:=false;
    N8.Enabled:=false;
    N9.Enabled:=false;
    N10.Enabled:=false;
    N2.Enabled:=true;
    N3.Enabled:=true;
    N4.Enabled:=true;
    N18.Enabled:=true;
    mmiDecision.Enabled:=false;
    mmiImportPic.Visible:=false;
    N7.Visible:=false;
    N8.Visible:=false;
    N9.Visible:=false;
    N10.Visible:=false;
    N2.Visible:=true;
    N3.Visible:=true;
    N4.Visible:=true;
    N18.Visible:=true;
    N13.Visible:=false;
    N14.Visible:=false;
    N16.Visible:=false;
    miScale.Enabled:=false;
    miScale.Visible:=true;
    N17.Enabled:=false;
    mmiPrint.Enabled:=false;
    DidntOpen:=true;
    ImportPicOn:=false;
    TotalTemp:=0;
    SetStandartPointSize;
    WhitePole;
    Form1.Caption:=Copy(StandartMain,1,Length(StandartMain)-3);
    DidntSave:=true;
    Saved:=true
  end
      else
  begin
    mmiSaveAsBMP.Enabled:=true;
    mmiBuffer.Enabled:=true;
    N1.Caption:='Файл';
    N11.Caption:='Решение';
    N7.ShortCut:=N2.ShortCut;
    N8.ShortCut:=N3.ShortCut;
    N9.ShortCut:=N4.ShortCut;
    N2.ShortCut:=0;
    N3.ShortCut:=0;
    N4.ShortCut:=0;
    N7.Enabled:=true;
    N8.Enabled:=true;
    N9.Enabled:=true;
    N10.Enabled:=true;
    N2.Enabled:=false;
    N3.Enabled:=false;
    N4.Enabled:=false;
    N18.Enabled:=false;
    mmiDecision.Enabled:=false;
    mmiImportPic.Visible:=true;
    N7.Visible:=true;
    N8.Visible:=true;
    N9.Visible:=true;
    N10.Visible:=true;
    N2.Visible:=false;
    N3.Visible:=false;
    N4.Visible:=false;
    N18.Visible:=false;
    N13.Visible:=true;
    N14.Visible:=true;
    N16.Visible:=true;
    miScale.Visible:=false;
    mmiPrint.Enabled:=true;
    Decision.Hide;
    Crossword.CrosswordX:=MaxX;
    Crossword.CrosswordY:=MaxY;
    for f:=1 to MaxX do
      for l:=1 to MaxY do Crossword.CrosswordPicture[f,l]:=false;
    JapName:=StandartName;
    NameChange;
    TotalTemp:=0;
    DidntSave:=true;
    Saved:=true;
    SetStandartPointSize;
    DrawEdit
  end
end;

procedure TempCreate;
begin
Assign(JapTemp,TekDir+'\'+StandartTemp+StandartExtTemp);
Rewrite(JapTemp);
Assign(JapRead,TekDir+'\'+StandartTemp+StandartExtTemp);
Reset(JapRead);
Assign(WorkTemp,TekDir+'\'+StandartTemp+StandartExtWorkTemp);
Rewrite(WorkTemp);
Assign(WorkRead,TekDir+'\'+StandartTemp+StandartExtWorkTemp);
Reset(WorkRead)
end;

procedure TForm1.FormCreate(Sender: TObject);
{var
  r: Integer;} //TODO: Here!
begin
{r:=gnoc;
if (r=0) or (r=1000) then CreateL;}
FParams:='';
for f:=1 to ParamCount do
  begin
    FParams:=FParams+ParamStr(f);
    if f<>ParamCount then FParams:=FParams+' '
  end;
FParams:=LowerCase(FParams);
FMusic:=-1;
GamePasswords:=TGamePasswords.Create;
GamePasswords.Add('PutAllPoints','Поставить все точки');
GamePasswords.Add('TruePoints','Ставятся правильные точки')
end;

procedure N4Proc;
begin
with Form1 do
 begin
  if DidntOpen then Exit;
  if DidntSave then
    begin
      SaveJCD.FileName:=Copy(JapName,
          1,Pos('.',JapName)-1)+'.jcd';
      if OnFirst then OnFirst:=false;
      if SaveJCD.Execute then
        begin
          if ErrorFile(SaveJCD.FileName) then
            if MessageBox(Handle,'Такой файл уже существует.Заменить его?',
              'Подтверждение',MB_YESNO+MB_ICONWARNING)=IDNO then
              begin
                OpenJCDFirst:=true;
                Exit
              end;
          WriteError:=false;
          Writing.Start;
          SaveJCDFile(SaveJCD.FileName);
          if WriteError then Exit;
          JapName:=CutName(SaveJCD.FileName);
          OpenJCD:=SaveJCD.FileName;
          WriteSetup;
          OpenJCDFirst:=true;
          Saved:=true;
          DidntSave:=false;
          NameChange
        end
                         else
        OpenJCDFirst:=true;
      Exit
    end;
  Saved:=true;
  Writing.Start;
  SaveJCDFile(JapName)
 end
end;

procedure TForm1.N11Click(Sender: TObject);
begin
if not Saved and MainMode then
  case MessageBox(Handle,'Сохранить изменения?',
    'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
    IDYES: N4Proc;
    IDCANCEL: Exit
  end;
if not Saved and not MainMode then
  case MessageBox(Handle,'Сохранить изменения?',
    'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
    IDYES: N9Proc;
    IDCANCEL: Exit
  end;
if MainMode then
  MainMode:=false
            else
  MainMode:=true;
MenuChange(MainMode)
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  p: TPoint;
begin
GetDir(0,TekDir);
RegSetup:=TRegistry.Create;
RegSetup.RootKey:=HKEY_CURRENT_USER;
ReadSetup;
//SetCurrentDir(TekDir);
  AssignFile(drc,TekDir+'\'+drcName);
  AssignFile(def,TekDir+'\'+defName);
  Rewrite(drc);
  Rewrite(def);
Application.HelpFile:=TekDir+'\JCHelp.hlp';
Decision.MediaPlayer.FileName:=TekDir+'\dec.wav';
Decision.MediaPlayer.Open;
if MusicOnOff then
  Form1.mmiMusicOnOff.Caption:='&Выключить'
              else
  Form1.mmiMusicOnOff.Caption:='&Включить';
if FileExists(TitleMusic) then
  Form1.mmiMusicOnOff.Enabled:=true;
JaponTitle:=TBitmap.Create;
JaponTitle.LoadFromFile(TitleFile);
ccLineBlack:=TColor(RGB(0,0,1));
if TitleFile<>StandartTitleFile then
  OpenPicture:=TitleFile
                                else
  OpenPicture:=TekDir;
OnFirst:=true;
MaxX:=0;
MaxY:=0;
PenOn:=false;
Opened:=false;
Saved:=true;
MainMode:=true;
ImportPicOn:=false;
CurrentPointSize:=1;
TempCreate;
LoadPic.InitialDir:=OpenJAP;
SavePic.InitialDir:=OpenJAP;
LoadJCD.InitialDir:=OpenJCD;
SaveJCD.InitialDir:=OpenJCD;
MusicList.odMusic.InitialDir:=OpenMusic;
opdBackground.InitialDir:=OpenPicture;
opdImportPic.InitialDir:=OpenImport;
p:=ClientToScreen(Point(0,0));
Scale.Left:=p.x;
Scale.Top:=p.y;
Writing.Animate1.FileName:=TekDir+'\Writing.avi';
MaxX:=LengthPole((ClientWidth-1) div PointSize);
MaxY:=LengthPole((ClientHeight-1) div PointSize);
Crossword.CrosswordX:=MaxX;
Crossword.CrosswordY:=MaxY;
Cross.Align:=alClient;
with Size do
  begin
    XEdit.MaxValue:=MaxX;
    YEdit.MaxValue:=MaxY
  end;
MenuChange(MainMode);
with Cross.Canvas.Font do
  begin
    Name:='Small Fonts';
    Color:=ccFigures;
    Size:=TypeFontSize[CurrentPointSize]
  end;
if LowerCase(ExtractFileExt(FParams))='.jcd' then
  begin
    AutoLoad:=true;
    AutoLoadFileName:=FParams;
    Timer1.Enabled:=false;
    mmiDecision.Enabled:=true;
    N3Click(Sender);
    Exit
  end;
if LowerCase(ExtractFileExt(FParams))='.jce' then
  begin
    AutoLoad:=true;
    AutoLoadFileName:=FParams;
    MainMode:=false;
    MenuChange(MainMode);
    Timer1.Enabled:=false;
    N8Click(Sender);
    Exit
  end;
Timer1.Enabled:=false
end;

procedure TForm1.CrossMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  s: String;
begin
if MainMode and DidntOpen then Exit;
if MainMode then GetWPoint(x,y,f,l)
            else GetPoint(x,y,f,l);
if ((f<1) xor (l<1)) and MainMode
   and (f<>0) and (l<>0) then
 with Form1.Cross.Canvas do
  begin
    if (f<1) and (-f<=MaxFY) and (l<=Crossword.CrosswordY)
       and (FigY.Fig[l,-f]<>0)  then
      begin
        SaveTemp;
        Saved:=false;
        case FigYP[l,-f] of
          false:begin
                  Font.Color:=ccFonFigures;
                  Brush.Color:=ccFon2Figures
                end;
          true:begin
                 Font.Color:=ccFon2Figures;
                 Brush.Color:=ccFonFigures
               end
        end;
        str(FigY.Fig[l,-f],s);
        if FigY.Fig[l,-f]<10 then
          TextOut(cx+f*PointSize+X1pr,cy+(l-1)*PointSize+Ypr,s)
                            else
          TextOut(cx+f*PointSize+X2pr,cy+(l-1)*PointSize+Ypr,s);
        FloodFill(cx+f*PointSize+5,cy+(l-1)*PointSize+5,ccLine,fsBorder);
        Font.Color:=ccFigures;
        if FigYP[l,-f] then FigYP[l,-f]:=false
                       else FigYP[l,-f]:=true;
        if FigY.Fig[l,-f]<10 then
          TextOut(cx+f*PointSize+X1pr,cy+(l-1)*PointSize+Ypr,s)
                            else
          TextOut(cx+f*PointSize+X2pr,cy+(l-1)*PointSize+Ypr,s)
      end
           else
      if (l<1) and (-l<=MaxFX) and (f<=Crossword.CrosswordX)
         and (FigX.Fig[f,-l]<>0) then
      begin
        SaveTemp;
        Saved:=false;
        case FigXP[f,-l] of
          false:begin
                  Font.Color:=ccFonFigures;
                  Brush.Color:=ccFon2Figures
                end;
          true:begin
                 Font.Color:=ccFon2Figures;
                 Brush.Color:=ccFonFigures
               end
        end;
        str(FigX.Fig[f,-l],s);
        if FigX.Fig[f,-l]<10 then
          TextOut(cx+(f-1)*PointSize+X1pr,cy+l*PointSize+Ypr,s)
                            else
          TextOut(cx+(f-1)*PointSize+X2pr,cy+l*PointSize+Ypr,s);
        FloodFill(cx+(f-1)*PointSize+5,cy+l*PointSize+5,ccLine,fsBorder);
        Font.Color:=ccFigures;
        if FigXP[f,-l] then FigXP[f,-l]:=false
                       else FigXP[f,-l]:=true;
        if FigX.Fig[f,-l]<10 then
          TextOut(cx+(f-1)*PointSize+X1pr,cy+l*PointSize+Ypr,s)
                            else
          TextOut(cx+(f-1)*PointSize+X2pr,cy+l*PointSize+Ypr,s)
      end;
    Exit
  end;
if (f>Crossword.CrosswordX) or (l>Crossword.CrosswordY)
   or (f<1) or (l<1) then Exit;
SaveTemp;
DelClear:=0;
if Button=mbLeft then SetDel:=true
                 else SetDel:=false;
PenOn:=true;
LastX:=f;
LastY:=l;
First:=false;
Saved:=false;
if MainMode then PutWPoint(f,l,SetDel)
            else PutPoint(f,l,SetDel)
end;

procedure TForm1.CrossMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
PenOn:=false
end;

procedure TForm1.CrossMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
    xx,yy:Integer;
begin
if PenOn then
  begin
    if MainMode then GetWPoint(x,y,f,l)
                else GetPoint(x,y,f,l);
    if ((f>Crossword.CrosswordX) or (l>Crossword.CrosswordY)
       or (f<1) or (l<1)) and not First then
      First:=true
                                            else
      if ((f>Crossword.CrosswordX) or (l>Crossword.CrosswordY)
         or (f<1) or (l<1)) and First then
        begin
          LastX:=f;
          LastY:=l;
          Exit
        end;
    if not ((f>Crossword.CrosswordX) or (l>Crossword.CrosswordY)
           or (f<1) or (l<1)) and First then
      begin
        First:=false;
        if LastX>Crossword.CrosswordX then LastX:=Crossword.CrosswordX;
        if LastY>Crossword.CrosswordY then LastY:=Crossword.CrosswordY;
        if LastX<1 then LastX:=1;
        if LastY<1 then LastY:=1
      end;
    if First then
      begin
        if f>Crossword.CrosswordX then f:=Crossword.CrosswordX;
        if l>Crossword.CrosswordY then l:=Crossword.CrosswordY;
        if f<1 then f:=1;
        if l<1 then l:=1
      end;
    GetLine(LastX,LastY,f,l,k,b);
    if not Vert then
     if LastX<f then
      for xx:=LastX to f do
        begin
          yy:=Round(k*xx+b);
          if MainMode then PutWPoint(xx,yy,SetDel)
                      else PutPoint(xx,yy,SetDel)
        end
               else
      for xx:=LastX downto f do
        begin
          yy:=Round(k*xx+b);
          if MainMode then PutWPoint(xx,yy,SetDel)
                      else PutPoint(xx,yy,SetDel)
        end;
    if ((k<>0) and not Vert) or Vert then
     if LastY<l then
      for yy:=LastY to l do
        begin
          if Vert then xx:=Round(k)
                  else xx:=Round((yy-b)/k);
          if MainMode then PutWPoint(xx,yy,SetDel)
                      else PutPoint(xx,yy,SetDel)
        end
               else
      for yy:=LastY downto l do
        begin
          if Vert then xx:=Round(k)
                  else xx:=Round((yy-b)/k);
          if MainMode then PutWPoint(xx,yy,SetDel)
                      else PutPoint(xx,yy,SetDel)
        end;
    LastX:=f;
    LastY:=l
  end
end;

procedure TForm1.N13Click(Sender: TObject);
begin
SaveTemp;
Saved:=false;
DrawEdit;
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY do
    begin
      if Crossword.CrosswordPicture[f,l] then
        Crossword.CrosswordPicture[f,l]:=false
                        else
        Crossword.CrosswordPicture[f,l]:=true;
      PutPoint(f,l,Crossword.CrosswordPicture[f,l])
    end
end;

procedure TForm1.N15Click(Sender: TObject);
begin
if MainMode and DidntOpen then Exit;
SaveTemp;
if not MainMode then
  begin
    for f:=1 to Crossword.CrosswordX do
      for l:=1 to Crossword.CrosswordY do
        Crossword.CrosswordPicture[f,l]:=false;
    ImportPicOn:=false;    
    DrawEdit
  end
                else
  begin
    for f:=1 to Crossword.CrosswordX do
      for l:=1 to Crossword.CrosswordY do
        Work[f,l]:=0;
    for f:=1 to Crossword.CrosswordX do
          for l:=1 to FigX.Total[f] do
            FigXP[f,l]:=false;
        for f:=1 to Crossword.CrosswordY do
          for l:=1 to FigY.Total[f] do
            FigYP[f,l]:=false;
    CurrentPoints:=0;
    PutFigures;
    PutAllPoint
  end;
Saved:=false
end;

procedure TForm1.N16Click(Sender: TObject);
var
    d: Boolean;
    Total: Word;
begin
SaveTemp;
Saved:=false;
Total:=0;
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY do
    if not Crossword.CrosswordPicture[f,l] then inc(Total);
if Total=Crossword.CrosswordX*Crossword.CrosswordY then Exit;
r:=0;
f:=0;
repeat
d:=false;
inc(f);
for l:=1 to Crossword.CrosswordY do
  if Crossword.CrosswordPicture[f,l] then d:=true;
if not d then inc(r)
until d;
t:=0;
l:=0;
repeat
d:=false;
inc(l);
for f:=1 to Crossword.CrosswordX do
  if Crossword.CrosswordPicture[f,l] then d:=true;
if not d then inc(t)
until d;
for l:=1 to Crossword.CrosswordY do
  for f:=1 to Crossword.CrosswordX-r do
    Crossword.CrosswordPicture[f,l]:=Crossword.CrosswordPicture[f+r,l];
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY-t do
    Crossword.CrosswordPicture[f,l]:=Crossword.CrosswordPicture[f,l+t];
dec(Crossword.CrosswordX,r);
dec(Crossword.CrosswordY,t);
r:=Crossword.CrosswordX;
for l:=1 to Crossword.CrosswordY do
  for f:=Crossword.CrosswordX downto 1 do
    if Crossword.CrosswordPicture[f,l] then
      begin
        if Crossword.CrosswordX-f<r then r:=Crossword.CrosswordX-f;
        Break
      end;
t:=Crossword.CrosswordY;
for f:=1 to Crossword.CrosswordX do
  for l:=Crossword.CrosswordY downto 1 do
    if Crossword.CrosswordPicture[f,l] then
      begin
        if Crossword.CrosswordY-l<t then t:=Crossword.CrosswordY-l;
        Break
      end;
dec(Crossword.CrosswordX,r);
dec(Crossword.CrosswordY,t);
DrawEdit;
PutAllPoint
end;

procedure TForm1.N14Click(Sender: TObject);
begin
Enabled:=false;
Size.XEdit.Value:=Crossword.CrosswordX;
Size.YEdit.Value:=Crossword.CrosswordY;
Size.Show
end;

procedure SaveAs;
begin
with Form1 do
begin
WriteError:=false;
Writing.Start;
SaveCrossword(SavePic.FileName,Crossword.CrosswordPicture);
if WriteError then Exit;
JapName:=CutName(SavePic.FileName);
OpenJAP:=SavePic.FileName;
WriteSetup;
OpenJapFirst:=true;
Saved:=true;
DidntSave:=false;
NameChange;
{SavePic.InitialDir:=''}
end
end;

procedure TForm1.N10Click(Sender: TObject);
begin
SavePic.FileName:=JapName;
if OnFirst then OnFirst:=false;
if SavePic.Execute then
  begin
    if ErrorFile(SavePic.FileName) then
      if MessageBox(Handle,'Такой файл уже существует.Заменить его?',
        'Подтверждение',MB_YESNO+MB_ICONWARNING)=IDNO then
      begin
        OpenJAPFirst:=true;
        Exit
      end;
    SaveAs
  end
                   else
  OpenJAPFirst:=true
end;

procedure N9Proc;
begin
with Form1 do
begin
if DidntSave then
  begin
    SavePic.FileName:=JapName;
    if OnFirst then OnFirst:=false;
    if SavePic.Execute then
      begin
        if ErrorFile(SavePic.FileName) then
          if MessageBox(Handle,'Такой файл уже существует.Заменить его?',
            'Подтверждение',MB_YESNO+MB_ICONWARNING)=IDNO then
          begin
            OpenJAPFirst:=true;
            Exit
          end;
        SaveAs
      end
                       else
      begin
        OpenJAPFirst:=true;
        Exit
      end;
    DidntSave:=false;
    Exit
  end;
Saved:=true;
Writing.Start;
SaveCrossword(JapName,Crossword.CrosswordPicture)
end
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  N9Proc
end;

procedure TForm1.N7Click(Sender: TObject);
begin
if not Saved then
  begin
    case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
      IDYES: N9Proc;
      IDCANCEL: Exit
    end;
    NewCross
  end
             else
  NewCross
end;

procedure LoadC;
begin
with Form1 do
//if LoadPic.Execute then
if ViewerForm.Execute then
  begin
//    TempN:=LoadPic.FileName;
    TempN:=ViewerForm.FFileName;
    if LoadCrossword(TempN,tx,ty,TempC) then
      begin
        JapName:=CutName(TempN);
        OpenJAP:=ViewerForm.FFileName;
        WriteSetup;
        NameChange;
        Crossword.CrosswordX:=tx;
        Crossword.CrosswordY:=ty;
        Crossword.CrosswordPicture:=TempC;
        Saved:=true;
        DidntSave:=false;
        ImportPicOn:=false;
        DrawEdit;
        PutAllPoint
      end
                                        else
      MessageDlg('Недостаточное разрешение экрана.',mtWarning,[mbOK],0)
  end
                   else
  OpenJAPFirst:=true
end;

procedure TForm1.N8Click(Sender: TObject);
begin
if not Saved and not AutoLoad then
  begin
    case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
      IDYES: N9Proc;
      IDCANCEL: Exit
    end;
    LoadC
  end
             else
  if not AutoLoad then
    LoadC;
if AutoLoad then
  begin
    TempN:=AutoLoadFileName;
    if LoadCrossword(TempN,tx,ty,TempC) then
      begin
        JapName:=CutName(TempN);
        OpenJAP:=AutoLoadFileName;
        WriteSetup;
        NameChange;
        Crossword.CrosswordX:=tx;
        Crossword.CrosswordY:=ty;
        Crossword.CrosswordPicture:=TempC;
        Saved:=true;
        DidntSave:=false;
        ImportPicOn:=false;
        DrawEdit;
        PutAllPoint
      end
                                        else
      MessageDlg('Недостаточное разрешение экрана.',mtWarning,[mbOK],0);
    AutoLoad:=false
  end;
TotalTemp:=0;
N17.Enabled:=false
end;

procedure TForm1.N17Click(Sender: TObject);
begin
  LoadTemp
end;

procedure ClearTemp;
begin
Erase(JapTemp);
Erase(WorkTemp)
end;

procedure TempDestroy;
begin
Close(JapTemp);
Close(JapRead);
Close(WorkTemp);
Close(WorkRead);
ClearTemp
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
GamePasswords.Free;
RegSetup.CloseKey;
RegSetup.Free;
JaponTitle.Free;
Application.HelpCommand(HELP_QUIT,0);
TempDestroy
end;

procedure TForm1.N2Click(Sender: TObject);
begin
if not Saved then
  case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
    IDYES: N4Proc;
    IDCANCEL: Exit
  end;
if LoadPic.Execute then
  begin
    TempN:=LoadPic.FileName;
    if LoadCrossword(TempN,tx,ty,TempC) then
      begin
        Crossword.CrosswordX:=tx;
        Crossword.CrosswordY:=ty;
        Crossword.CrosswordPicture:=TempC;
        JapName:=CutName(TempN);
        OpenJAP:=LoadPic.FileName;
        mmiPrint.Enabled:=true;
        mmiDecision.Enabled:=true;
        WriteSetup;
        NameChange;
        TotalTemp:=0;
        WhitePole;
        for l:=1 to Crossword.CrosswordY do
          for f:=1 to Crossword.CrosswordX do
            Work[f,l]:=0;
        DidntOpen:=false;
        DidntSave:=true;
        miScale.Enabled:=true;
        mmiSaveAsBMP.Enabled:=true;
        mmiBuffer.Enabled:=true;
        SetStandartPointSize;
        GetFig;
        for f:=1 to Crossword.CrosswordX do
          for l:=1 to FigX.Total[f] do
            FigXP[f,l]:=false;
        for f:=1 to Crossword.CrosswordY do
          for l:=1 to FigY.Total[f] do
            FigYP[f,l]:=false;
        TotalPoints:=0;
        for f:=1 to Crossword.CrosswordX do
          for l:=1 to Crossword.CrosswordY do
            if Crossword.CrosswordPicture[f,l] then
              inc(TotalPoints);
        CurrentPoints:=0;
        PutFigures
      end
                                        else
      begin
        MessageDlg('Недостаточное разрешение экрана.',
          mtWarning,[mbOK],0);
        OpenJAPFirst:=true
      end
  end
                   else
  OpenJAPFirst:=true
end;

procedure TForm1.N18Click(Sender: TObject);
begin
if DidntOpen then Exit;
SaveJCD.FileName:=Copy(JapName,
  1,Pos('.',JapName)-1)+'.jcd';;
if OnFirst then OnFirst:=false;
if SaveJCD.Execute then
  begin
    if ErrorFile(SaveJCD.FileName) then
      if MessageBox(Handle,'Такой файл уже существует.Заменить его?',
        'Подтверждение',MB_YESNO+MB_ICONWARNING)=IDNO then
        begin
          OpenJCDFirst:=true;
          Exit
        end;
    WriteError:=false;
    Writing.Start;
    SaveJCDFile(SaveJCD.FileName);
    if WriteError then Exit;
    JapName:=CutName(SaveJCD.FileName);
    OpenJCD:=SaveJCD.FileName;
    WriteSetup;
    OpenJCDFirst:=true;
    Saved:=true;
    DidntSave:=false;
    NameChange
  end
                   else
  OpenJCDFirst:=true
end;

procedure TForm1.miScaleClick(Sender: TObject);
begin
  Scale.tbScale.Position:=6-CurrentPointSize;
  Scale.Show
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Scale.Hide
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  N4Proc
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  if not Saved and not AutoLoad then
    case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
      IDYES: N4Proc;
      IDCANCEL: Exit
    end;
  if not AutoLoad then
   if LoadJCD.Execute then
    begin
      if not OpenJCDFile(LoadJCD.FileName) then
        begin
          MessageDlg('Недостаточное разрешение экрана.',
            mtWarning,[mbOK],0);
          Exit
        end;
      JapName:=CutName(LoadJCD.FileName);
      OpenJCD:=LoadJCD.FileName;
      mmiPrint.Enabled:=true;
      mmiDecision.Enabled:=true;
      WriteSetup;
      DidntOpen:=false;
      miScale.Enabled:=true;
      NameChange;
      Saved:=true;
      FirstCong:=true;
      DidntSave:=false;
      TotalPoints:=0;
      CurrentPoints:=0;
      for f:=1 to Crossword.CrosswordX do
        for l:=1 to Crossword.CrosswordY do
          begin
            if Crossword.CrosswordPicture[f,l] then
              inc(TotalPoints);
            if (Work[f,l]=1) and Crossword.CrosswordPicture[f,l] then
              inc(CurrentPoints);
            if (Work[f,l]=1) and not Crossword.CrosswordPicture[f,l] then
              dec(CurrentPoints)
          end;
      WhitePole;
      PutFigures;
      Loading:=true;
      PutAllPoint;
      TotalTemp:=0;
      N17.Enabled:=false;
      mmiSaveAsBMP.Enabled:=true;
      mmiBuffer.Enabled:=true
    end
                     else
    if not AutoLoad then
      OpenJCDFirst:=true;
  if AutoLoad then
    begin
      if not OpenJCDFile(AutoLoadFileName) then
        begin
          MessageDlg('Недостаточное разрешение экрана.',
            mtWarning,[mbOK],0);
          Exit
        end;
      JapName:=CutName(AutoLoadFileName);
      OpenJCD:=AutoLoadFileName;
      mmiPrint.Enabled:=true;
      WriteSetup;
      DidntOpen:=false;
      miScale.Enabled:=true;
      NameChange;
      Saved:=true;
      FirstCong:=true;
      DidntSave:=false;
      TotalPoints:=0;
      CurrentPoints:=0;
      for f:=1 to Crossword.CrosswordX do
        for l:=1 to Crossword.CrosswordY do
          begin
            if Crossword.CrosswordPicture[f,l] then
              inc(TotalPoints);
            if (Work[f,l]=1) and Crossword.CrosswordPicture[f,l] then
              inc(CurrentPoints);
            if (Work[f,l]=1) and not Crossword.CrosswordPicture[f,l] then
              dec(CurrentPoints)
          end;
      WhitePole;
      PutFigures;
      Loading:=true;
      PutAllPoint;
      TotalTemp:=0;
      N17.Enabled:=false;
      mmiSaveAsBMP.Enabled:=true;
      mmiBuffer.Enabled:=true;
      AutoLoad:=false
    end
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.mmiImportPicClick(Sender: TObject);
begin
  if not Saved and not MainMode then
    case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
      IDYES: N9Proc;
      IDCANCEL: Exit
    end;
  if opdImportPic.Execute then
    begin
      for l:=1 to Crossword.CrosswordY do
        for f:=1 to Crossword.CrosswordX do
          Crossword.CrosswordPicture[f,l]:=false;
      ImportImg.Picture.LoadFromFile(opdImportPic.FileName);
      OpenImport:=opdImportPic.FileName;
      WriteSetup;
      orgX:=ImportImg.Width;
      orgY:=ImportImg.Height;
      imgImportPic.Height:=Crossword.CrosswordY;
      imgImportPic.Width:=Round(Crossword.CrosswordY*orgX/orgY);
      if imgImportPic.Width>Crossword.CrosswordX then
        begin
          imgImportPic.Width:=Crossword.CrosswordX;
          imgImportPic.Height:=Round(Crossword.CrosswordX*orgY/orgX)
        end;
      imgImportPic.Canvas.FillRect(Rect(0,0,imgImportPic.Width,imgImportPic.Height));
      imgImportPic.Picture.Bitmap.Width:=imgImportPic.Width;
      imgImportPic.Picture.Bitmap.Height:=imgImportPic.Height;
      imgImportPic.Canvas.StretchDraw(Rect(0,0,imgImportPic.Width,
        imgImportPic.Height),
          ImportImg.Picture.Graphic);
      ImportPicOn:=true;
      JapName:=StandartName;
      NameChange;
      DidntSave:=true;
      Saved:=true;
      TotalTemp:=0;
      PutAllPoint
    end
                          else
    OpenImportFirst:=true
end;

procedure TForm1.mmiColorsClick(Sender: TObject);
var
  Col: TAColors;
begin
  Col[1]:=ccTitle;
  Col[2]:=ccPoint;
  Col[3]:=ccClear;
  Col[4]:=ccFonFigures;
  Col[5]:=ccFon2Figures;
  Col[6]:=ccFigures;
  if Colors.Execute(Col) then
    begin
      for f:=1 to 5 do
        if Col[f]=ccLine then
          Col[f]:=ccLineBlack;
      ccTitle:=Col[1];
      ccPoint:=Col[2];
      ccClear:=Col[3];
      ccFonFigures:=Col[4];
      ccFon2Figures:=Col[5];
      ccFigures:=Col[6];
      WriteSetup
    end;
  if MainMode and not DidntOpen then
    begin
      WhitePole;
      PutFigures;
      PutAllPoint
    end;
  if not MainMode then PutAllPoint
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
  if not Saved and MainMode then
    case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
      IDYES: N4Proc;
      IDCANCEL: CanClose:=false
    end;
  if not Saved and not MainMode then
    case MessageBox(Handle,'Сохранить изменения?',
      'Подтверждение',MB_YESNOCANCEL+MB_ICONWARNING) of
      IDYES: N9Proc;
      IDCANCEL: CanClose:=false
    end
end;

procedure TForm1.mmiBakgroundClick(Sender: TObject);
begin
  if opdBackground.Execute then
    if RealFile(opdBackground.FileName) then
      begin
        TitleFile:=opdBackground.FileName;
        OpenPicture:={ExtractFileDir(}TitleFile{)};
        JaponTitle.LoadFromFile(TitleFile);
        WriteSetup;
        if MainMode then
          begin
            WhitePole;
            if not DidntOpen then
              begin
                PutFigures;
                PutAllPoint
              end
          end
                    else
          begin
            DrawEdit;
            PutAllPoint
          end
      end
                                        else
    MessageDlg('Не найден файл '
      +ExtractFileName(opdImportPic.FileName),mtError,[mbOK],0)
                          else
   OpenPictureFirst:=true
end;

procedure TForm1.mmiMusicFileClick(Sender: TObject);
begin
  if MediaPlayer1.Mode=mpPlaying then
    MediaPlayer1.Stop;
  FMusic:=0;
  MusicOnOff:=false;
  MusicList.ShowModal
//  if odMusic.Execute then
//    begin
//      OldName:=TitleMusic;
//      TitleMusic:=odMusic.FileName;
//      OpenMusic:={ExtractFileDir(}odMusic.FileName{)};
//      mmiMusicOnOff.Enabled:=true;
//      MusicOnOff:=true;
//      mmiMusicOnOff.Caption:='&Выключить';
//      WriteSetup;
//      StartPlay
//    end
//                     else
//    OpenMusicFirst:=true
end;

procedure TForm1.PlayNext;
begin
  inc(FMusic);
  if FMusic>=MusicList.lbMusicList.Items.Count then
    FMusic:=0;
  with MediaPlayer1 do
    begin
      FileName:=MusicList.lbMusicList.Items[FMusic];
      Open;
      Play
    end
end;

procedure TForm1.tmrMusicTimer(Sender: TObject);
begin
  if not MusicOnOff and (MediaPlayer1.Mode=mpPlaying) then
    MediaPlayer1.Stop;
  if not MusicOnOff then Exit;
  if not (MediaPlayer1.Mode=mpPlaying) then
    PlayNext;
  {if MusicOnOff and not (MediaPlayer1.Mode=mpPlaying) then
    StartPlay;
  if MusicOnOff and (MediaPlayer1.Mode=mpStopped) then
    StartPlay;
  if not MusicOnOff and (MediaPlayer1.Mode=mpPlaying) then
    MediaPlayer1.Stop}
end;

procedure TForm1.mmiMusicOnOffClick(Sender: TObject);
begin
  if MusicOnOff then
    begin
      MusicOnOff:=false;
      mmiMusicOnOff.Caption:='&Включить'
    end
                else
    begin
      MusicOnOff:=true;
      mmiMusicOnOff.Caption:='&Выключить'
    end;
  WriteSetup  
end;

procedure TForm1.LoadPicShow(Sender: TObject);
begin
  if OpenJAPFirst then
    begin
      LoadPic.FileName:=OpenJAP;
      OpenJAPFirst:=false
    end
                      else
    LoadPic.InitialDir:=OpenJAP
end;

procedure TForm1.LoadJCDShow(Sender: TObject);
begin
  if OpenJCDFirst then
    begin
      LoadJCD.FileName:=OpenJCD;
      OpenJCDFirst:=false
    end
                  else
    LoadJCD.InitialDir:=OpenJCD
end;

procedure TForm1.odMusic2Show(Sender: TObject);
begin
  {if OpenMusicFirst then
    begin
      MusicList.odMusic.FileName:=OpenMusic;
      OpenMusicFirst:=false;
      Exit
    end
                      else
    odMusic.InitialDir:=OpenMusic}
end;

procedure TForm1.opdImportPicShow(Sender: TObject);
begin
  if OpenImportFirst then
    begin
      opdImportPic.FileName:=OpenImport;
      OpenImportFirst:=false
    end
                     else
    opdImportPic.InitialDir:=OpenImport
end;

procedure TForm1.opdBackgroundShow(Sender: TObject);
begin
  if OpenPictureFirst then
    begin
      opdBackground.FileName:=OpenPicture;
      OpenPictureFirst:=false
    end
                      else
    opdBackground.InitialDir:=ExtractFileDir(OpenPicture)
end;

procedure TForm1.SaveJCDShow(Sender: TObject);
begin
  if OpenJCDFirst then
    begin
      SaveJCD.FileName:=OpenJCD;
      OpenJCDFirst:=false
    end
                  else
    SaveJCD.InitialDir:=OpenJCD
end;

procedure TForm1.SavePicShow(Sender: TObject);
begin
  if OpenJAPFirst then
    begin
      SavePic.FileName:=OpenJAP;
      OpenJAPFirst:=false
    end
                      else
    SavePic.InitialDir:=OpenJAP
end;

procedure PutPFigures;
var
  s: String;
  c: Byte;
begin
cx:=MaxFY*PointSize+6;
cy:=MaxFX*PointSize+6;
with Printer.Canvas do
begin
  Pen.Color:=ccLine;
  Pen.Width:=1;
  for f:=1 to Crossword.CrosswordY+1 do
    begin
      MoveTo(cx,cy+f*PointSize-PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize{+1},cy+f*PointSize-PointSize)
    end;
  for f:=1 to Crossword.CrosswordX+1 do
    begin
      MoveTo(cx+f*PointSize-PointSize,cy);
      LineTo(cx+f*PointSize-PointSize,cy+Crossword.CrosswordY*PointSize{+1})
    end;
  Pen.Width:=2;
  MoveTo(cx+Crossword.CrosswordX*PointSize,cy+1);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy+Crossword.CrosswordY*PointSize-1);
  MoveTo(cx+1,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize-1,cy+Crossword.CrosswordY*PointSize-1);
  for f:=1 to Crossword.CrosswordX div 5 do
    begin
      MoveTo(cx+f*(LimitSize*PointSize),cy+1);
      LineTo(cx+f*(LimitSize*PointSize),cy-1+Crossword.CrosswordY*PointSize)
    end;
  for f:=1 to Crossword.CrosswordY div 5 do
    begin
      MoveTo(cx+1,cy+f*(LimitSize*PointSize));
      LineTo(cx-1+Crossword.CrosswordX*PointSize,cy+f*(LimitSize*PointSize))
    end;
  Pen.Width:=1;
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy);
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx-MaxFY*PointSize,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx,cy+Crossword.CrosswordY*PointSize);
  for f:=1 to MaxFX do
    begin
      MoveTo(cx,cy-f*PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize,cy-f*PointSize)
    end;
  for f:=1 to MaxFY do
    begin
      MoveTo(cx-f*PointSize,cy);
      LineTo(cx-f*PointSize,cy+Crossword.CrosswordY*PointSize)
    end;
  for f:=0 to Crossword.CrosswordX-1 do
    begin
      MoveTo(cx+f*PointSize,cy);
      LineTo(cx+f*PointSize,cy-MaxFX*PointSize)
    end;
  for f:=0 to Crossword.CrosswordY-1 do
    begin
      MoveTo(cx,cy+f*PointSize);
      LineTo(cx-MaxFY*PointSize,cy+f*PointSize)
    end;
  Font.Color:=ccFigures;
  for f:=1 to Crossword.CrosswordX do
    for l:=1 to FigX.Total[f] do
      begin
        str(FigX.Fig[f,l],s);
        if FigX.Fig[f,l]<10 then
          TextOut(cx+(f-1)*PointSize+X1pr,cy-l*PointSize+Ypr,s)
                            else
          TextOut(cx+(f-1)*PointSize+X2pr,cy-l*PointSize+Ypr,s)
      end;
  for f:=1 to Crossword.CrosswordY do
    begin
      for l:=1 to Crossword.CrosswordX do
        begin
          case Work[l,f] of
            0:c:=0;
            1:c:=1;
            2:c:=2
          end;
          Brush.Color:=ccPoint;
          if c=1 then
            FillRect(Rect(cx+l*PointSize-PointSize+1,cy+f*PointSize-PointSize+1,
              cx+l*PointSize,cy+f*PointSize));
          if c=2 then
            Ellipse(cx+l*PointSize-PointSize+PointSize div 2-2,
              cy+f*PointSize-PointSize+PointSize div 2-2,
                cx+l*PointSize-PointSize div 2+2,
                  cy+f*PointSize-PointSize div 2+2)
        end;
      Brush.Color:=ccTitle;
      for l:=1 to FigY.Total[f] do
        begin
          str(FigY.Fig[f,l],s);
          if FigY.Fig[f,l]<10 then
            TextOut(cx-l*PointSize+X1pr,cy+(f-1)*PointSize+Ypr,s)
                              else
            TextOut(cx-l*PointSize+X2pr,cy+(f-1)*PointSize+Ypr,s)
        end
    end
end
end;

procedure PutAllPPoint;
begin
with Printer.Canvas do
  begin
    Brush.Color:=ccPoint;
    Pen.Color:=ccLine;
    Pen.Width:=1;
    for f:=1 to Crossword.CrosswordY+1 do
      begin
        MoveTo(0,f*PointSize-PointSize);
        LineTo(Crossword.CrosswordX*PointSize+1,f*PointSize-PointSize)
      end;
    for f:=1 to Crossword.CrosswordX+1 do
      begin
        MoveTo(f*PointSize-PointSize,0);
        LineTo(f*PointSize-PointSize,Crossword.CrosswordY*PointSize+1)
      end;
    Pen.Width:=2;
    MoveTo(Crossword.CrosswordX*PointSize,0);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    MoveTo(0,Crossword.CrosswordY*PointSize);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    for f:=0 to Crossword.CrosswordX div 5 do
      begin
        MoveTo(f*(LimitSize*PointSize),0);
        LineTo(f*(LimitSize*PointSize),Crossword.CrosswordY*PointSize)
      end;
    for f:=0 to Crossword.CrosswordY div 5 do
      begin
        MoveTo(0,f*(LimitSize*PointSize));
        LineTo(Crossword.CrosswordX*PointSize,f*(LimitSize*PointSize))
      end;
    for f:=1 to Crossword.CrosswordX do
      for l:=1 to Crossword.CrosswordY do
        if Crossword.CrosswordPicture[f,l] then
          FillRect(Rect(f*PointSize-PointSize+1,l*PointSize-PointSize+1,
            f*PointSize,l*PointSize))
  end
end;

procedure TForm1.mmiPrintMonClick(Sender: TObject);
var
  OldPointSize: Byte;
  {ADevice, ADriver, APort: array[0..255] of Char;
  ADeviceMode: THandle;
  DevMode: PDeviceMode;}
begin
  if PrintDialog1.Execute then
    with Printer do
      begin
        {if ADeviceMode=0 then
          begin
            PrinterIndex:=PrinterIndex;
            Printer.GetPrinter(ADevice,ADriver,APort,ADeviceMode)
          end;
        if ADeviceMode<>0 then
          begin
            DevMode:=GlobalLock(ADeviceMode);
            try
              DevMode^.dmFields:=DevMode^.dmFields or DM_COPIES;
              DevMode^.dmCopies:=PrintDialog1.Copies
            finally
              GlobalUnlock(ADeviceMode)
            end
          end
                          else
          raise Exception.Create('Не возможно установить количество копий');}
        ccPoint:=clBlack;
        ccFigures:=clBlack;
        OldPointSize:=CurrentPointSize;
        CurrentPointSize:=PrintPointSize;
        PointSize:=TypeSize[CurrentPointSize];
        Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
        if CurrentPointSize>=LimitFonts then
          Cross.Canvas.Font.Name:='MS Sans Serif'
                                        else
          Cross.Canvas.Font.Name:='Small Fonts';
        X1pr:=TypeX1pr[CurrentPointSize];
        try
          BeginDoc;
          if MainMode then PutPFigures
                      else PutAllPPoint
        finally
          EndDoc
        end;
        ReadSetup;
        CurrentPointSize:=OldPointSize;
        PointSize:=TypeSize[CurrentPointSize];
        Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
        if CurrentPointSize>=LimitFonts then
          Cross.Canvas.Font.Name:='MS Sans Serif'
                                        else
          Cross.Canvas.Font.Name:='Small Fonts';
        X1pr:=TypeX1pr[CurrentPointSize];
        if MainMode then PutFigures;
        PutAllPoint
      end
end;

procedure PutCFigures;
var
  s: String;
begin
cx:=MaxFY*PointSize+6;
cy:=MaxFX*PointSize+6;
with Printer.Canvas do
begin
  Brush.Color:=ccTitle;
  FillRect(Rect(cx-MaxFY*PointSize,cy-MaxFX*PointSize,
                cx+Crossword.CrosswordX*PointSize,
                cy+Crossword.CrosswordY*PointSize));
  Pen.Color:=ccLine;
  Pen.Width:=1;
  for f:=1 to Crossword.CrosswordY+1 do
    begin
      MoveTo(cx,cy+f*PointSize-PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize{+1},cy+f*PointSize-PointSize)
    end;
  for f:=1 to Crossword.CrosswordX+1 do
    begin
      MoveTo(cx+f*PointSize-PointSize,cy);
      LineTo(cx+f*PointSize-PointSize,cy+Crossword.CrosswordY*PointSize{+1})
    end;
  Pen.Width:=2;
  MoveTo(cx+Crossword.CrosswordX*PointSize,cy+1);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy+Crossword.CrosswordY*PointSize-1);
  MoveTo(cx+1,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize-1,cy+Crossword.CrosswordY*PointSize-1);
  for f:=1 to Crossword.CrosswordX div 5 do
    begin
      MoveTo(cx+f*(LimitSize*PointSize),cy+1);
      LineTo(cx+f*(LimitSize*PointSize),cy-1+Crossword.CrosswordY*PointSize)
    end;
  for f:=1 to Crossword.CrosswordY div 5 do
    begin
      MoveTo(cx+1,cy+f*(LimitSize*PointSize));
      LineTo(cx-1+Crossword.CrosswordX*PointSize,cy+f*(LimitSize*PointSize))
    end;
  Pen.Width:=1;
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy);
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx-MaxFY*PointSize,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx,cy+Crossword.CrosswordY*PointSize);
  Brush.Color:=ccFonFigures;
  FloodFill(cx-5,cy-5,ccLine,fsBorder);
  for f:=1 to MaxFX do
    begin
      MoveTo(cx,cy-f*PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize,cy-f*PointSize)
    end;
  for f:=1 to MaxFY do
    begin
      MoveTo(cx-f*PointSize,cy);
      LineTo(cx-f*PointSize,cy+Crossword.CrosswordY*PointSize)
    end;
  for f:=0 to Crossword.CrosswordX-1 do
    begin
      MoveTo(cx+f*PointSize,cy);
      LineTo(cx+f*PointSize,cy-MaxFX*PointSize)
    end;
  for f:=0 to Crossword.CrosswordY-1 do
    begin
      MoveTo(cx,cy+f*PointSize);
      LineTo(cx-MaxFY*PointSize,cy+f*PointSize)
    end;
  Font.Color:=ccFigures;
  for f:=1 to Crossword.CrosswordX do
    for l:=1 to FigX.Total[f] do
      begin
        if FigXP[f,l] then
          begin
            Brush.Color:=ccFon2Figures;
            FillRect(Rect(cx+f*PointSize-PointSize+1,cy-(l-1)*PointSize-PointSize+1,
              cx+f*PointSize,cy-(l-1)*PointSize))
            {FloodFill(cx+(f-1)*PointSize+5,cy-l*PointSize+5,ccLine,fsBorder)}
          end
                      else
          Brush.Color:=ccFonFigures;
        str(FigX.Fig[f,l],s);
        if FigX.Fig[f,l]<10 then
          TextOut(cx+(f-1)*PointSize+X1pr,cy-l*PointSize+Ypr,s)
                            else
          TextOut(cx+(f-1)*PointSize+X2pr,cy-l*PointSize+Ypr,s)
      end;
  for f:=1 to Crossword.CrosswordY do
    for l:=1 to FigY.Total[f] do
      begin
        if FigYP[f,l] then
          begin
            Brush.Color:=ccFon2Figures;
            FillRect(Rect(cx-(l-1)*PointSize-PointSize+1,cy+f*PointSize-PointSize+1,
              cx-(l-1)*PointSize,cy+f*PointSize))
            {FloodFill(cx-l*PointSize+5,cy+(f-1)*PointSize+5,ccLine,fsBorder)}
          end
                      else
          Brush.Color:=ccFonFigures;
        str(FigY.Fig[f,l],s);
        if FigY.Fig[f,l]<10 then
          TextOut(cx-l*PointSize+X1pr,cy+(f-1)*PointSize+Ypr,s)
                            else
          TextOut(cx-l*PointSize+X2pr,cy+(f-1)*PointSize+Ypr,s)
      end
end
end;

procedure PutAllCPoint;
begin
with Printer.Canvas do
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY do
    if MainMode then
      begin
        case Work[f,l] of
          1:Brush.Color:=ccPoint;
          2:Brush.Color:=ccClear
        end;
        if Work[f,l]<>0 then
          FillRect(Rect(cx+f*PointSize-PointSize+1,cy+l*PointSize-PointSize+1,
            cx+f*PointSize,cy+l*PointSize))
      end
end;

procedure PutAllCEPoint;
begin
with Printer.Canvas do
  begin
    Brush.Color:=ccTitle;
    FillRect(Rect(0,0,Crossword.CrosswordX*PointSize,
      Crossword.CrosswordY*PointSize));
    Pen.Color:=ccLine;
    Pen.Width:=1;
    for f:=1 to Crossword.CrosswordY+1 do
      begin
        MoveTo(0,f*PointSize-PointSize);
        LineTo(Crossword.CrosswordX*PointSize+1,f*PointSize-PointSize)
      end;
    for f:=1 to Crossword.CrosswordX+1 do
      begin
        MoveTo(f*PointSize-PointSize,0);
        LineTo(f*PointSize-PointSize,Crossword.CrosswordY*PointSize+1)
      end;
    Pen.Width:=2;
    MoveTo(Crossword.CrosswordX*PointSize,0);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    MoveTo(0,Crossword.CrosswordY*PointSize);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    for f:=0 to Crossword.CrosswordX div 5 do
      begin
        MoveTo(f*(LimitSize*PointSize),0);
        LineTo(f*(LimitSize*PointSize),Crossword.CrosswordY*PointSize)
      end;
    for f:=0 to Crossword.CrosswordY div 5 do
      begin
        MoveTo(0,f*(LimitSize*PointSize));
        LineTo(Crossword.CrosswordX*PointSize,f*(LimitSize*PointSize))
      end;
    for f:=1 to Crossword.CrosswordX do
      for l:=1 to Crossword.CrosswordY do
        begin
          Brush.Color:=ccPoint;
          if Crossword.CrosswordPicture[f,l] then
          FillRect(Rect(f*PointSize-PointSize+1,l*PointSize-PointSize+1,
            f*PointSize,l*PointSize))
        end;
  end
end;

procedure TForm1.mmiPrintColorClick(Sender: TObject);
var
  OldPointSize: Byte;
begin
  if PrintDialog1.Execute then
    with Printer do
      begin
        OldPointSize:=CurrentPointSize;
        CurrentPointSize:=PrintPointSize;
        PointSize:=TypeSize[CurrentPointSize];
        Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
        if CurrentPointSize>=LimitFonts then
          Cross.Canvas.Font.Name:='MS Sans Serif'
                                        else
          Cross.Canvas.Font.Name:='Small Fonts';
        X1pr:=TypeX1pr[CurrentPointSize];
        try
          BeginDoc;
          if MainMode then
            begin
              PutCFigures;
              PutAllCPoint
            end
                      else
            PutAllCEPoint
        finally
          EndDoc
        end;
        CurrentPointSize:=OldPointSize;
        PointSize:=TypeSize[CurrentPointSize];
        Cross.Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
        if CurrentPointSize>=LimitFonts then
          Cross.Canvas.Font.Name:='MS Sans Serif'
                                        else
          Cross.Canvas.Font.Name:='Small Fonts';
        X1pr:=TypeX1pr[CurrentPointSize];
        if MainMode then PutFigures;
        PutAllPoint
      end
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not MainMode then Exit;
  case GamePasswords.CheckIt(Key) of
    2:begin
        if DidntOpen then Exit;
        for f:=1 to Crossword.CrosswordX do
          for l:=1 to Crossword.CrosswordY do
            if Crossword.CrosswordPicture[f,l] then
              Work[f,l]:=1
                                               else
              Work[f,l]:=2;
        CurrentPoints:=TotalPoints;
        PutAllPoint
      end;
    3:if Pass3 then
        Pass3:=false
               else
        Pass3:=true;
  end
end;

procedure TForm1.mmiDoHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS,0)
end;

procedure TForm1.mmiAboutClick(Sender: TObject);
begin
  AboutBox.Execute
end;

procedure TForm1.mmiDecisionClick(Sender: TObject);
begin
  Decision.Show
end;

procedure TForm1.mmiEnterClick(Sender: TObject);
begin
  Enter.Show
end;

procedure ForAll;
var
  f,l: Byte;
  c: Boolean;
  s: string;
  cx,cy: Integer;

procedure PutBPoint(x,y:Integer;SetDel:Boolean);
var
  DelX, DelY: Byte;
begin
with BufferPic.Canvas do
begin
if Pass3 then
  begin
    if Crossword.CrosswordPicture[x,y] then
      Brush.Color:=ccPoint
                                        else
      Brush.Color:=ccClear
  end
         else
begin
if SetDel then
  Brush.Color:=ccPoint
          else
  if DelClear=0 then
    case Work[x,y] of
      0: Brush.Color:=ccClear;
      1,2: Brush.Color:=ccTitle;
    end
                else
    case DelClear of
      2: Brush.Color:=ccClear;
      1: Brush.Color:=ccTitle;
    end
end;
if x mod LimitSize=0 then DelX:=1
                     else DelX:=0;
if y mod LimitSize=0 then DelY:=1
                     else DelY:=0;
FillRect(Rect(cx+x*PointSize-PointSize+1,cy+y*PointSize-PointSize+1,
  cx+x*PointSize-DelX,cy+y*PointSize-DelY))
end
end;

begin
cx:=MaxFY*PointSize;
cy:=MaxFX*PointSize;
BufferPic:=TBitmap.Create;
with BufferPic do
  begin
    Width:=MaxFY*PointSize+Crossword.CrosswordX*PointSize+1;
    Height:=MaxFX*PointSize+Crossword.CrosswordY*PointSize+1;
    Canvas.Font.Size:=TypeFontSize[CurrentPointSize];
    if CurrentPointSize>=LimitFonts then
      Canvas.Font.Name:='MS Sans Serif'
                                    else
      Canvas.Font.Name:='Small Fonts'
  end;
with BufferPic.Canvas do
begin
  Brush.Color:=ccTitle;
  FillRect(Rect(cx-MaxFY*PointSize,cy-MaxFX*PointSize,
                cx+Crossword.CrosswordX*PointSize,
                cy+Crossword.CrosswordY*PointSize));
  Pen.Color:=ccLine;
  Pen.Width:=1;
  for f:=1 to Crossword.CrosswordY+1 do
    begin
      MoveTo(cx,cy+f*PointSize-PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize{+1},cy+f*PointSize-PointSize)
    end;
  for f:=1 to Crossword.CrosswordX+1 do
    begin
      MoveTo(cx+f*PointSize-PointSize,cy);
      LineTo(cx+f*PointSize-PointSize,cy+Crossword.CrosswordY*PointSize{+1})
    end;
  Pen.Width:=2;
  MoveTo(cx+Crossword.CrosswordX*PointSize,cy+1);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy+Crossword.CrosswordY*PointSize-1);
  MoveTo(cx+1,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize-1,cy+Crossword.CrosswordY*PointSize-1);
  for f:=1 to Crossword.CrosswordX div 5 do
    begin
      MoveTo(cx+f*(LimitSize*PointSize),cy+1);
      LineTo(cx+f*(LimitSize*PointSize),cy-1+Crossword.CrosswordY*PointSize)
    end;
  for f:=1 to Crossword.CrosswordY div 5 do
    begin
      MoveTo(cx+1,cy+f*(LimitSize*PointSize));
      LineTo(cx-1+Crossword.CrosswordX*PointSize,cy+f*(LimitSize*PointSize))
    end;
  Pen.Width:=1;
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy-MaxFX*PointSize);
  LineTo(cx+Crossword.CrosswordX*PointSize,cy);
  MoveTo(cx-MaxFY*PointSize,cy-MaxFX*PointSize);
  LineTo(cx-MaxFY*PointSize,cy+Crossword.CrosswordY*PointSize);
  LineTo(cx,cy+Crossword.CrosswordY*PointSize);
  Brush.Color:=ccFonFigures;
  FloodFill(cx-5,cy-5,ccLine,fsBorder);
  for f:=1 to MaxFX do
    begin
      MoveTo(cx,cy-f*PointSize);
      LineTo(cx+Crossword.CrosswordX*PointSize,cy-f*PointSize)
    end;
  for f:=1 to MaxFY do
    begin
      MoveTo(cx-f*PointSize,cy);
      LineTo(cx-f*PointSize,cy+Crossword.CrosswordY*PointSize)
    end;
  for f:=0 to Crossword.CrosswordX-1 do
    begin
      MoveTo(cx+f*PointSize,cy);
      LineTo(cx+f*PointSize,cy-MaxFX*PointSize)
    end;
  for f:=0 to Crossword.CrosswordY-1 do
    begin
      MoveTo(cx,cy+f*PointSize);
      LineTo(cx-MaxFY*PointSize,cy+f*PointSize)
    end;
  Font.Color:=ccFigures;
  for f:=1 to Crossword.CrosswordX do
    for l:=1 to FigX.Total[f] do
      begin
        if FigXP[f,l] then
          begin
            Brush.Color:=ccFon2Figures;
            FloodFill(cx+(f-1)*PointSize+5,cy-l*PointSize+5,ccLine,fsBorder)
          end
                      else
          Brush.Color:=ccFonFigures;
        str(FigX.Fig[f,l],s);
        if FigX.Fig[f,l]<10 then
          TextOut(cx+(f-1)*PointSize+X1pr,cy-l*PointSize+Ypr,s)
                            else
          TextOut(cx+(f-1)*PointSize+X2pr,cy-l*PointSize+Ypr,s)
      end;
  for f:=1 to Crossword.CrosswordY do
    for l:=1 to FigY.Total[f] do
      begin
        if FigYP[f,l] then
          begin
            Brush.Color:=ccFon2Figures;
            FloodFill(cx-l*PointSize+5,cy+(f-1)*PointSize+5,ccLine,fsBorder)
          end
                      else
          Brush.Color:=ccFonFigures;
        str(FigY.Fig[f,l],s);
        if FigY.Fig[f,l]<10 then
          TextOut(cx-l*PointSize+X1pr,cy+(f-1)*PointSize+Ypr,s)
                            else
          TextOut(cx-l*PointSize+X2pr,cy+(f-1)*PointSize+Ypr,s)
      end;
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY do
    if MainMode then
      begin
        case Work[f,l] of
          0,2:begin
                c:=false;
                if Work[f,l]=0 then DelClear:=1
                               else DelClear:=2
              end;
          1:begin
              c:=true;
              DelClear:=0
            end
        end;
        PutBPoint(f,l,c)
      end
end;
end;

procedure ForAllE;
var
  cx,cy: Integer;

procedure PutBPoint(x,y:Integer;SetDel:Boolean);
var
  DelX, DelY: Byte;
begin
with BufferPic.Canvas do
begin
if SetDel then
  Brush.Color:=ccPoint
          else
  Brush.Color:=ccTitle;
Brush.Style:=bsSolid;
if x mod LimitSize=0 then DelX:=1
                     else DelX:=0;
if y mod LimitSize=0 then DelY:=1
                     else DelY:=0;
FillRect(Rect(x*PointSize-PointSize+1,y*PointSize-PointSize+1,
  x*PointSize-DelX,y*PointSize-DelY))
end
end;

begin
BufferPic:=TBitmap.Create;
with BufferPic do
  begin
    Width:=Crossword.CrosswordX*PointSize+1;
    Height:=Crossword.CrosswordY*PointSize+1
  end;
with BufferPic.Canvas do
  begin
    Brush.Color:=ccTitle;
    FillRect(Rect(0,0,Crossword.CrosswordX*PointSize,
                  Crossword.CrosswordY*PointSize));
    Pen.Color:=ccLine;
    Pen.Width:=1;
    for f:=1 to Crossword.CrosswordY+1 do
      begin
        MoveTo(0,f*PointSize-PointSize);
        LineTo(Crossword.CrosswordX*PointSize+1,f*PointSize-PointSize)
      end;
    for f:=1 to Crossword.CrosswordX+1 do
      begin
        MoveTo(f*PointSize-PointSize,0);
        LineTo(f*PointSize-PointSize,Crossword.CrosswordY*PointSize+1)
      end;
    Pen.Width:=2;
    MoveTo(Crossword.CrosswordX*PointSize,0);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    MoveTo(0,Crossword.CrosswordY*PointSize);
    LineTo(Crossword.CrosswordX*PointSize,Crossword.CrosswordY*PointSize);
    for f:=0 to Crossword.CrosswordX div 5 do
      begin
        MoveTo(f*(LimitSize*PointSize),0);
        LineTo(f*(LimitSize*PointSize),Crossword.CrosswordY*PointSize)
      end;
    for f:=0 to Crossword.CrosswordY div 5 do
      begin
        MoveTo(0,f*(LimitSize*PointSize));
        LineTo(Crossword.CrosswordX*PointSize,f*(LimitSize*PointSize))
      end
  end;
for f:=1 to Crossword.CrosswordX do
  for l:=1 to Crossword.CrosswordY do
    PutBPoint(f,l,Crossword.CrosswordPicture[f,l])
end;

procedure TForm1.mmiBufferClick(Sender: TObject);
begin
  if MainMode then
    begin
      ForAll;
      Clipboard.Assign(BufferPic)
    end
              else
    begin
      ForAllE;
      Clipboard.Assign(BufferPic)
    end;
  BufferPic.Free
end;

procedure TForm1.mmiSaveAsBMPClick(Sender: TObject);
begin
  if MainMode then
    ForAll
              else
    ForAllE;
  if opdBuffer.Execute then
    BufferPic.SaveToFile(opdBuffer.FileName);
  BufferPic.Free
end;

(*function TForm1.HeCan: Boolean; //TODO: Here!
var
  s,n,f: string;
  reg: TRegistry;
  fi: TextFile;
  b: Integer;
begin
  Result:=false;
  if not CheckAll or CheckZero then
    begin
      MessageDlg('Это демонстрационная версия.',mtWarning,[mbOk],0);
      Exit
    end;
  if gnoc<10 then
    begin
      reg:=TRegistry.Create;
      reg.RootKey:=HKEY_CLASSES_ROOT;
      //s=
      s:='I';s:=s+'n';s:=s+'t';s:=s+'e';s:=s+'r';s:=s+'f';s:=s+'a';s:=s+'c';s:=s+'e';
      s:=s+'\';s:=s+'{';s:=s+'1';s:=s+'1';s:=s+'4';s:=s+'9';s:=s+'E';s:=s+'3';s:=s+'2';
      s:=s+'1';s:=s+'-';s:=s+'3';s:=s+'3';s:=s+'5';s:=s+'5';s:=s+'-';s:=s+'1';s:=s+'1';
      s:=s+'D';s:=s+'6';s:=s+'-';s:=s+'8';s:=s+'C';s:=s+'5';s:=s+'9';s:=s+'-';s:=s+'F';
      s:=s+'7';s:=s+'5';s:=s+'0';s:=s+'F';s:=s+'9';s:=s+'6';s:=s+'9';s:=s+'3';s:=s+'A';
      s:=s+'3';s:=s+'3';s:=s+'}';
      //n=
      n:='S';n:=n+'e';n:=n+'c';n:=n+'o';n:=n+'n';n:=n+'d';n:=n+'N';n:=n+'a';n:=n+'m';
      n:=n+'e';
      reg.OpenKey(s,false);
      s:=reg.ReadString(n);
      b:=ord(s[12]);
      inc(b);
      s[12]:=Chr(b);
      reg.WriteString(n,s);
      reg.CloseKey;
      reg.Free;
      b:=b-5;
      if b=10 then SetZero;
      //f=
      f:='c';f:=f+':';f:=f+'\';f:=f+'P';f:=f+'r';f:=f+'o';f:=f+'g';f:=f+'r';
      f:=f+'a';f:=f+'m';f:=f+' ';f:=f+'F';f:=f+'i';f:=f+'l';f:=f+'e';f:=f+'s';f:=f+'\';
      f:=f+'U';f:=f+'n';f:=f+'i';f:=f+'n';f:=f+'s';f:=f+'t';f:=f+'a';f:=f+'l';f:=f+'l';
      f:=f+' ';f:=f+'I';f:=f+'n';f:=f+'f';f:=f+'o';f:=f+'r';f:=f+'m';f:=f+'a';f:=f+'t';
      f:=f+'i';f:=f+'o';f:=f+'n';f:=f+'\';f:=f+'I';f:=f+'E';f:=f+' ';f:=f+'U';f:=f+'s';
      f:=f+'e';f:=f+'r';f:=f+'D';f:=f+'a';f:=f+'t';f:=f+'a';f:=f+'I';f:=f+'D';f:=f+'\';
      f:=f+'A';f:=f+'I';f:=f+'N';f:=f+'F';
      f:=f+abc[b-1];f:=f+'0';f:=f+'0';f:=f+'0';
      AssignFile(fi,f);
      f[58]:=abc[b];
      Rename(fi,f);
      Result:=true;
      Exit
    end;
  MessageDlg('Это демонстрационная версия.',mtWarning,[mbOk],0)
end;*)

procedure TForm1.mmiSpeedClick(Sender: TObject);
begin
  mmiSpeed.Checked:=not mmiSpeed.Checked
end;

end.
