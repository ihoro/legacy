unit DecisionFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, GlobalVars, Menus;

type
  TDecision = class(TForm)
    btnBegin: TButton;
    btnView: TButton;
    btnExit: TButton;
    gbStatus: TGroupBox;
    Label1: TLabel;
    lblTotal: TLabel;
    Label2: TLabel;
    lblType: TLabel;
    seR: TSpinEdit;
    btnDec: TButton;
    PopupMenu: TPopupMenu;
    mmiFull: TMenuItem;
    mmiPartial: TMenuItem;
    procedure btnBeginClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnDecClick(Sender: TObject);
    procedure mmiFullClick(Sender: TObject);
    procedure mmiPartialClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDoing = class(TThread)
  private
    Last: Byte;
    tp: Word;
    MainFig, SecondFig: TFigures;
    fi: array[1..100] of Byte;
    NeedX, NeedY: array[1..200] of Boolean;
    tot,d: Byte;
    Pos: array[1..100] of Byte;
    czero, cone, one, zero: array[1..200] of Boolean;
    ErrorCross: Boolean;
    function ManAnalysis: Boolean;
    function Analysis(xy: Boolean;num: Byte): Boolean;
    function DoMove(n: Byte): Boolean;
    function Right: Boolean;
    procedure FindNext;
    procedure ComeBack;
    procedure StartD;
    procedure EndD;
    procedure Savedef;
    procedure Loaddef;
    procedure Savedrc;
  protected
    procedure Execute; override;
  end;

var
  Decision: TDecision;

implementation

{$R *.DFM}

uses
  Main, EnterFrm, WritingFrm;

const
  defName = '$jc$.de$';
  drcName = '$jc$.rc$';

var
  Doing: TDoing;

  {Global variables for thread TDoing and this unit: }

  cc: Tcc;
  MainD, SecondD: Word;
  TotalP: Word;
  Found: array[0..40000] of
    record
      pX, pY: Byte
    end;
  TotalF, TotalR: Word;
  FWhat: Byte;
  Full: Boolean;
  {def and drc in GlobalVars unit!}

{ TDecision }

procedure TDecision.btnBeginClick(Sender: TObject);
begin
  if not Form1.HeCan then Exit;
  Doing:=TDoing.Create(false)
end;

procedure TDecision.btnViewClick(Sender: TObject);
var
  f,l: Byte;
begin
  if seR.Value=0 then Exit;
  Seek(drc,seR.Value-1);
  read(drc,cc);
  if Entering then
    begin
      if Form1.SavePic.Execute then
        begin
          if ErrorFile(Form1.SavePic.FileName) then
            if MessageDlg('Такой файл уже существует.Заменить его?',
              mtConfirmation,[mbYes,mbCancel],0)=mrCancel  then
              Exit;
          for l:=1 to SecondD do
            for f:=1 to MainD do
              case cc[f,l] of
                0: Crossword.CrosswordPicture[f,l]:=false;
                1: Crossword.CrosswordPicture[f,l]:=true
              end;
          SaveCrossword(Form1.SavePic.FileName,Crossword.CrosswordPicture)
        end;
      Exit
    end;
  for l:=1 to SecondD do
    for f:=1 to MainD do
      case cc[f,l] of
        0:Work[f,l]:=2;
        1:Work[f,l]:=1;
        2:Work[f,l]:=0
      end;
  PutAllPoint
end;

procedure TDecision.FormDestroy(Sender: TObject);
begin
  CloseFile(drc);
  CloseFile(def);
  Erase(drc);
  Erase(def)
end;

{ TDoing }

procedure TDoing.Execute;
var
  f,l: Byte;
  Second,hard: Boolean;
begin
  SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS);
  Priority:=tpTimeCritical;
  Synchronize(StartD);
  MainFig:=FigX;
  SecondFig:=FigY;
  with Crossword do
    begin
      MainD:=CrosswordX;
      SecondD:=CrosswordY
    end;
  for l:=1 to SecondD do
    for f:=1 to MainD do
      cc[f,l]:=2;
  for f:=1 to MainD do
    NeedX[f]:=true;
  for l:=1 to SecondD do
    NeedY[l]:=true;
  TotalP:=0;
  TotalF:=0;
  TotalR:=0;
  Found[0].pX:=0;
  Found[0].pY:=1;
  for f:=1 to MainD do
    for l:=1 to MainFig.Total[f] do
      inc(TotalP,MainFig.Fig[f,l]);
  {DONE -cОшибки: Error Crossword!!!}
  Second:=false;
  hard:=false;
  if not ManAnalysis then
    begin
      if not Full then
        begin
          inc(TotalR);
          Savedrc
        end;
      if not ErrorCross and Full then
        begin
          FindNext;
          Second:=true
        end
                                 else
        hard:=true
    end
                     else
    begin
      inc(TotalR);
      Savedrc
    end;
  if TotalR=0 then FWhat:=0;
  if TotalR=1 then
    if Second then FWhat:=2
              else FWhat:=1;
  if TotalR>1 then FWhat:=3;
  if hard then FWhat:=2;
  Synchronize(EndD);
  SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS)
end;

function TDoing.ManAnalysis: Boolean;
var
  TotalA: Word;
  f,l: Byte;
begin
  tp:=0;
  for l:=1 to SecondD do
    for f:=1 to MainD do
      if cc[f,l]=1 then inc(tp);
  repeat
    TotalA:=0;
    for f:=1 to MainD do
      if NeedX[f] then
        begin
          NeedX[f]:=false;
          if Analysis(true,f) then
            inc(TotalA)
                              else
            if ErrorCross then
              begin
                Result:=false;
                Exit
              end
        end;
    for f:=1 to SecondD do
      if NeedY[f] then
        begin
          NeedY[f]:=false;
          if Analysis(false,f) then
            inc(TotalA)
                               else
            if ErrorCross then
              begin
                Result:=false;
                Exit
              end
        end
  until TotalA=0;
  if tp=TotalP then
    Result:=true
               else
    Result:=false
end;

function TDoing.Analysis(xy: Boolean;num: Byte): Boolean; //xy=true - x, xy=false - y
var
  f,l,k: Byte;
begin
  Result:=false;
  ErrorCross:=false;
  if xy then
    begin
      d:=SecondD;
      tot:=MainFig.Total[num];
      for f:=1 to d do
        case cc[num,f] of
          0:begin
              czero[f]:=true;
              cone[f]:=false
            end;
          1:begin
              czero[f]:=false;
              cone[f]:=true
            end;
          2:begin
              czero[f]:=true;
              cone[f]:=true
            end
        end;
      for f:=tot downto 1 do
        fi[tot-f+1]:=MainFig.Fig[num,f]
    end
        else
    begin
      d:=MainD;
      tot:=SecondFig.Total[num];
      for f:=1 to d do
        case cc[f,num] of
          0:begin
              czero[f]:=true;
              cone[f]:=false
            end;
          1:begin
              czero[f]:=false;
              cone[f]:=true
            end;
          2:begin
              czero[f]:=true;
              cone[f]:=true
            end
        end;
      for f:=tot downto 1 do
        fi[tot-f+1]:=SecondFig.Fig[num,f]
    end;
  Pos[1]:=1;
  for f:=2 to tot do
    Pos[f]:=Pos[f-1]+fi[f-1]+1;
  Last:=1;
  if fi[1]=0 then tot:=0;
  if tot=0 then
    for f:=1 to d do
      begin
        one[f]:=false;
        zero[f]:=true
      end;
  if tot<>0 then
  {DONE 2 -cОшибки: Ошибка - неправильный кроссворд (input data)
   Если нет стартовой позиции для данной линии, то - ERROR!}
  while not Right do
    if not DoMove(Last) then
      begin
        {DONE 1 -cОшибки: Error! (см. выше)}
        ErrorCross:=true;
        Exit
      end;
  for f:=1 to Pos[1]-1 do
    begin
      zero[f]:=true;
      one[f]:=false
    end;
  for f:=1 to tot do
    begin
      for l:=Pos[f] to Pos[f]+fi[f]-1 do
        begin
          one[l]:=true;
          zero[l]:=false
        end;
      if f=tot then k:=d
               else k:=Pos[f+1]-1;
      for l:=Pos[f]+fi[f] to k do
        begin
          zero[l]:=true;
          one[l]:=false
        end
    end;
  if tot<>0 then
  while DoMove(Last) do
    if Right then
      begin
        for f:=1 to Pos[1]-1 do
          if one[f] and not zero[f] then
            zero[f]:=true;
        for f:=1 to tot do
          begin
            for l:=Pos[f] to Pos[f]+fi[f]-1 do
              if zero[l] and not one[l] then
                one[l]:=true;
            if f=tot then k:=d
                     else k:=Pos[f+1]-1;
            for l:=Pos[f]+fi[f] to k do
              if one[l] and not zero[l] then
                zero[l]:=true
          end
      end;
  {DONE 1 -cЛишнее: Убрать левое (cc[..]:=2)
   Зачем? Если уже cc[..]=2?}
  for f:=1 to d do
    begin
      if xy and one[f] and not zero[f] then
        cc[num,f]:=1;
      if xy and zero[f] and not one[f] then
        cc[num,f]:=0;
      {if xy and one[f] and zero[f] then
        cc[num,f]:=2;}
      if not xy and one[f] and not zero[f] then
        cc[f,num]:=1;
      if not xy and zero[f] and not one[f] then
        cc[f,num]:=0;
      {if not xy and one[f] and zero[f] then
        cc[f,num]:=2}
    end;
  for f:=1 to d do
    if (cone[f]<>one[f]) or (czero[f]<>zero[f]) then
      begin
        if one[f] and not zero[f] then
          inc(tp);
        Result:=true;
        if xy then NeedY[f]:=true
              else NeedX[f]:=true
      end
end;

function TDoing.DoMove(n: Byte): Boolean;
begin
  if (Pos[n]+fi[n]+1=Pos[n+1]) and (n<>tot) then
      begin
        if n<>1 then
          Pos[n]:=Pos[n-1]+fi[n-1]+1
                 else
          Pos[n]:=1;
        Result:=DoMove(n+1);
        Exit
      end;
  if (n=tot) and (Pos[n]+fi[n]-1=d) then
    begin
      Result:=false;
      Exit
    end;
  inc(Pos[n]);
  if n<>1 then Last:=n-1
          else Last:=n;
  Result:=true
end;

function TDoing.Right: Boolean;
var
  f,l,k: Byte;
begin
  Result:=true;
  for f:=1 to Pos[1]-1 do
    if cone[f] and not czero[f] then
      begin
        Result:=false;
        Exit
      end;
  for f:=1 to tot do
    begin
      for l:=Pos[f] to Pos[f]+fi[f]-1 do
        if czero[l] and not cone[l] then
          begin
            Result:=false;
            Exit
          end;
      if f=tot then k:=d
               else k:=Pos[f+1]-1;
      for l:=Pos[f]+fi[f] to k do
        if cone[l] and not czero[l] then
          begin
            Result:=false;
            Exit
          end
    end
end;

procedure TDoing.StartD;
begin
  with Decision do
    begin
      seR.Value:=0;
      seR.MinValue:=0;
      seR.MaxValue:=0;
      with btnBegin do
        begin
          Caption:='Анализ...';
          Enabled:=false
        end;
      btnView.Enabled:=false;
      btnExit.Enabled:=false;
      btnDec.Enabled:=false;
      if mmiFull.Checked then Full:=true
                         else Full:=false
    end
end;

procedure TDoing.EndD;
begin
  case FWhat of
    0:Decision.lblType.Caption:='Не имеет решения (ошибка данных).';
    1:Decision.lblType.Caption:='Обычный кроссворд.';
    2:Decision.lblType.Caption:='Сложный кроссворд.';
    3:Decision.lblType.Caption:='Не имеет одного решения.'
  end;
  if TotalR<>0 then
    with Decision.seR do
      begin
        Decision.lblTotal.Caption:=IntToStr(TotalR);
        if TotalR=1 then Enabled:=false
                    else Enabled:=true;
        Value:=1;
        MinValue:=1;
        MaxValue:=TotalR
      end
               else
      begin
        Decision.lblTotal.Caption:='0';
        Decision.seR.Value:=0;
        Decision.seR.Enabled:=false
      end;
  with Decision.btnBegin do
    begin
      Caption:='Начать';
      Enabled:=true
    end;
  Decision.btnView.Enabled:=true;
  Decision.btnExit.Enabled:=true;
  Decision.btnDec.Enabled:=true
end;

procedure TDoing.FindNext;
var
  f,l: Byte;
begin
  f:=Found[TotalF].pX;
  l:=Found[TotalF].pY;
  repeat
    inc(f);
    if f>MainD then
      begin
        f:=1;
        inc(l)
      end;
  until (l>SecondD) or (cc[f,l]=2);
  if l>SecondD then
    ComeBack;
  if l<=SecondD then
    if cc[f,l]=2 then
      begin
        Savedef;
        inc(TotalF);
        Found[TotalF].pX:=f;
        Found[TotalF].pY:=l;
        cc[f,l]:=0;
        NeedX[f]:=true;
        NeedY[l]:=true;
        if not ManAnalysis then
          if not ErrorCross then FindNext
                            else ComeBack
                           else
          begin
            inc(TotalR);
            Savedrc;
            ComeBack
          end
      end
end;

procedure TDoing.ComeBack;
begin
  if TotalF=0 then Exit;
  Loaddef;
  with Found[TotalF] do
    begin
      cc[pX,pY]:=1;
      NeedX[pX]:=true;
      NeedY[pY]:=true
    end;
  dec(TotalF);
  if not ManAnalysis then
    if not ErrorCross then FindNext
                      else ComeBack
                     else
    begin
      inc(TotalR);
      Savedrc;
      ComeBack
    end
end;

procedure TDoing.Savedef;
begin
  Seek(def,TotalF);
  write(def,cc)
end;

procedure TDoing.Loaddef;
begin
  Seek(def,TotalF-1);
  read(def,cc)
end;

procedure TDoing.Savedrc;
begin
  Seek(drc,TotalR-1);
  write(drc,cc)
end;

procedure TDecision.btnExitClick(Sender: TObject);
begin
  Hide
end;

procedure TDecision.FormShow(Sender: TObject);
begin
  if Entering then
    begin
      btnView.Caption:='Сохранить';
      Enter.Enabled:=false
    end
              else
    btnView.Caption:='Просмотр'
end;

procedure TDecision.FormHide(Sender: TObject);
begin
  if Entering then
    begin
      Crossword.CrosswordX:=OldXvar;
      Crossword.CrosswordY:=OldYvar;
      Enter.Enabled:=true;
      Enter.Hide
    end
end;

procedure TDecision.btnDecClick(Sender: TObject);
var
  c: TPoint;
begin
  GetCursorPos(c);
  PopupMenu.Popup(c.x,c.y)
end;

procedure TDecision.mmiFullClick(Sender: TObject);
begin
  btnDec.Caption:='1';
  mmiPartial.Checked:=false;
  mmiFull.Checked:=true
end;

procedure TDecision.mmiPartialClick(Sender: TObject);
begin
  btnDec.Caption:='2';
  mmiPartial.Checked:=true;
  mmiFull.Checked:=false
end;

end.
