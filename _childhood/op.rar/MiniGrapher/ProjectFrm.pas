unit ProjectFrm;

interface

uses
  Windows, Forms, Grids, Classes, Controls,
  ExtCtrls, Graphics, Analyser, ComCtrls, Menus, ToolWin, StdActns,
  ActnList;

type
  TProjectForm = class(TForm)
    sgSystem: TStringGrid;
    tlbProject: TToolBar;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    ToolButton1: TToolButton;
    tbDeleteVir: TToolButton;
    tbAddVir: TToolButton;
    tbInsertVir: TToolButton;
    tbEditVir: TToolButton;
    mmProject: TMainMenu;
    mmiFile: TMenuItem;
    mmiNew: TMenuItem;
    mmiOpen: TMenuItem;
    mmiClose: TMenuItem;
    mmiSave: TMenuItem;
    mmiSaveAs: TMenuItem;
    N9: TMenuItem;
    mmiExitProg: TMenuItem;
    mmiVir: TMenuItem;
    mmiDeleteVir: TMenuItem;
    mmiAddVir: TMenuItem;
    mmiInsertVir: TMenuItem;
    mmiEditVir: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    tbSys1: TToolButton;
    tbSys2: TToolButton;
    tbSysDel: TToolButton;
    ToolButton9: TToolButton;
    N1: TMenuItem;
    mmiSys1: TMenuItem;
    mmiSys2: TMenuItem;
    mmiSysDel: TMenuItem;
    tbCons: TToolButton;
    ToolButton7: TToolButton;
    N2: TMenuItem;
    mmiCons: TMenuItem;
    tbGraph: TToolButton;
    mmiGraph: TMenuItem;
    StatusBar: TStatusBar;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbNewClick(Sender: TObject);
    procedure tbDeleteVirClick(Sender: TObject);
    procedure mmiDeleteVirClick(Sender: TObject);
    procedure tbAddVirClick(Sender: TObject);
    procedure mmiAddVirClick(Sender: TObject);
    procedure tbInsertVirClick(Sender: TObject);
    procedure mmiInsertVirClick(Sender: TObject);
    procedure tbEditVirClick(Sender: TObject);
    procedure mmiEditVirClick(Sender: TObject);
    procedure tbSys1Click(Sender: TObject);
    procedure tbSys2Click(Sender: TObject);
    procedure tbSysDelClick(Sender: TObject);
    procedure mmiSys1Click(Sender: TObject);
    procedure mmiSys2Click(Sender: TObject);
    procedure mmiSysDelClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgSystemTopLeftChanged(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure tbConsClick(Sender: TObject);
    procedure mmiConsClick(Sender: TObject);
    procedure tbGraphClick(Sender: TObject);
    procedure mmiGraphClick(Sender: TObject);
  private
    { Private declarations }
  public
    FConstants: TConstants;
    FTotalConst: 0..MaxConsts;
    FIdentity: TIdentity;
    FSystem: TSystem;
    FTotalSystem: 0..MaxSystem;
    FWhat: Byte; {0-none;1-sys1;2-sys2;3-sysdel}
    FDoIt: Boolean;
    procedure SetNewFont(aFont: TFont);
    procedure PaintSystems;
    procedure SetButtons(Down: Boolean);
    { Public declarations }
  end;

var
  ProjectForm: TProjectForm;

implementation

uses
  MainFrm, ClipBrd, EditFrm, ConsFrm;

{$R *.DFM}

{TODO: ѕроверка на ошибки расстановку знаков систем и совокупностей
  перед построением}

procedure TProjectForm.FormResize(Sender: TObject);
begin
  sgSystem.Width:=ClientWidth-109;
  sgSystem.Height:=ClientHeight-StatusBar.Height;
  sgSystem.DefaultColWidth:=sgSystem.ClientWidth;
  PaintSystems
end;

procedure TProjectForm.FormActivate(Sender: TObject);
begin
  MainForm.tlbMain.Visible:=false;
  tlbProject.Parent:=MainForm;
  tlbProject.Visible:=true;
  FormResize(nil)
end;

procedure TProjectForm.SetNewFont(aFont: TFont);
begin
  sgSystem.Font:=aFont;
  sgSystem.DefaultRowHeight:=-sgSystem.Font.Height-sgSystem.Font.Height div 2
end;

procedure TProjectForm.FormCreate(Sender: TObject);
begin
  FTotalConst:=0;
  FTotalSystem:=1;
  with FSystem[1] do
    begin
      Level:=1;
      First:=1;
      Second:=5;
      Style:=1
    end;
  FWhat:=0;
  FDoIt:=false;  
  mmiNew.OnClick:=MainForm.mmiNew.OnClick;
  SetNewFont(sgSystem.Font)
end;

procedure TProjectForm.FormDeactivate(Sender: TObject);
begin
  tlbProject.Visible:=false
end;

procedure TProjectForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
  tlbProject.Parent:=Self;
  if MainForm.MDIChildCount=1 then
    MainForm.tlbMain.Visible:=true
end;

procedure TProjectForm.tbNewClick(Sender: TObject);
begin
  MainForm.mmiNewClick(Self)
end;

procedure TProjectForm.tbDeleteVirClick(Sender: TObject);
begin
  mmiDeleteVirClick(Self)
end;

procedure TProjectForm.mmiDeleteVirClick(Sender: TObject);
begin
  Clipboard.AsText:=sgSystem.Cells[0,sgSystem.Row];
  sgSystem.Cells[0,sgSystem.Row]:=''
end;

procedure TProjectForm.tbAddVirClick(Sender: TObject);
begin
  mmiAddVirClick(Self)
end;

procedure TProjectForm.mmiAddVirClick(Sender: TObject);
begin
  Clipboard.AsText:=sgSystem.Cells[0,sgSystem.Row]
end;

procedure TProjectForm.tbInsertVirClick(Sender: TObject);
begin
  mmiInsertVirClick(Self)
end;

procedure TProjectForm.mmiInsertVirClick(Sender: TObject);
begin
  sgSystem.Cells[0,sgSystem.Row]:=Clipboard.AsText
end;

procedure TProjectForm.tbEditVirClick(Sender: TObject);
begin
  mmiEditVirClick(Self)
end;

procedure TProjectForm.mmiEditVirClick(Sender: TObject);
begin
  with EditForm do
    begin
      FTotalCons:=FTotalConst;
      FCons:=FConstants;
      edtVir.Text:=sgSystem.Cells[0,sgSystem.Row];
      ShowModal;
      sgSystem.Cells[0,sgSystem.Row]:=edtVir.Text
    end
end;

procedure TProjectForm.PaintSystems;
var
  f,x,y,h,t: Integer;
  tmp: TBitmap;
begin
  tmp:=TBitmap.Create;
  tmp.Width:=109;
  tmp.Height:=ClientHeight;
  with tmp.Canvas do
    begin
      Brush.Color:=clSysBackground;
      Brush.Style:=bsSolid;
      FillRect(Rect(0,0,109,ClientHeight));
      if FWhat<>0 then
        begin
          Pen.Color:=clSysLimits;
          Pen.Style:=psDot;
          for f:=1 to 9 do
            begin
              MoveTo(f*10+f-1,0);
              LineTo(f*10+f-1,ClientHeight)
            end
        end;
      Pen.Color:=clSysColor;
      Pen.Style:=psSolid;
      for f:=1 to FTotalSystem do
        with FSystem[f] do
          begin
            y:=-sgSystem.TopRow*sgSystem.DefaultRowHeight+
              First*sgSystem.DefaultRowHeight-sgSystem.DefaultRowHeight+
              First-sgSystem.TopRow;
            x:=109-Level*11+1;
            h:=(Second-First+1)*sgSystem.DefaultRowHeight+Second-First+2;
            t:=(h-6) div 2;
            case Style of
              1:begin
                MoveTo(x+8,y+1);
                LineTo(x+5,y+1);
                MoveTo(x+5,y+2);
                LineTo(x+3,y+2);
                MoveTo(x+8,y+h-2);
                LineTo(x+5,y+h-2);
                MoveTo(x+5,y+h-3);
                LineTo(x+3,y+h-3);
                MoveTo(x+3,y+3);
                LineTo(x+3,y+4+t);
                MoveTo(x+3,y+h-4);
                LineTo(x+3,y+h-4-t);
                MoveTo(x+3,y+2+t);
                LineTo(x,y+2+t)
              end;
              2:begin
                MoveTo(x+7,y+1);
                LineTo(x+1,y+1);
                MoveTo(x+7,y+h-2);
                LineTo(x+1,y+h-2);
                MoveTo(x+1,y+1);
                LineTo(x+1,y+h-1)
              end
            end
          end
    end;
  BitBlt(Canvas.Handle,0,0,tmp.Width,tmp.Height,
    tmp.Canvas.Handle,0,0,SRCCOPY);
  tmp.Free  
end;

procedure TProjectForm.tbSys1Click(Sender: TObject);
begin
  mmiSys1Click(Self)
end;

procedure TProjectForm.tbSys2Click(Sender: TObject);
begin
  mmiSys2Click(Self)
end;

procedure TProjectForm.tbSysDelClick(Sender: TObject);
begin
  mmiSysDelClick(Self)
end;

procedure TProjectForm.SetButtons(Down: Boolean);
begin
  if not Down then
    begin
      tbSys1.Down:=false;
      tbSys2.Down:=false;
      tbSysDel.Down:=false;
      mmiSys1.Checked:=false;
      mmiSys2.Checked:=false;
      mmiSysDel.Checked:=false;
      FWhat:=0
    end
              else
    case FWhat of
      1:begin
        tbSys1.Down:=true;
        mmiSys1.Checked:=true
      end;
      2:begin
        tbSys2.Down:=true;
        mmiSys2.Checked:=true
      end;
      3:begin
        tbSysDel.Down:=true;
        mmiSysDel.Checked:=true
      end
    end;
  PaintSystems  
end;

procedure TProjectForm.mmiSys1Click(Sender: TObject);
begin
  if FWhat=1 then
    begin
      SetButtons(false);
      Exit
    end;
  SetButtons(false);
  FWhat:=1;
  SetButtons(true)
end;

procedure TProjectForm.mmiSys2Click(Sender: TObject);
begin
  if FWhat=2 then
    begin
      SetButtons(false);
      Exit
    end;
  SetButtons(false);  
  FWhat:=2;
  SetButtons(true)
end;

procedure TProjectForm.mmiSysDelClick(Sender: TObject);
begin
  if FWhat=3 then
    begin
      SetButtons(false);
      Exit
    end;
  SetButtons(false);
  FWhat:=3;
  SetButtons(true)
end;

procedure TProjectForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  l,f,s,d: Integer;
begin
  if FWhat=0 then Exit;
  if tbSysDel.Down then
    begin
      l:=Round(X/10);
      if l=0 then l:=1;
      l:=11-l;
      s:=Round(Y/sgSystem.DefaultRowHeight);
      if s=0 then s:=1;
      inc(s,sgSystem.TopRow);
      f:=0;
      repeat
        inc(f);
        with FSystem[f] do
          if (Level=l) and (s>=First) and (s<=Second) then
            begin
              for d:=f to FTotalSystem-1 do
                FSystem[d]:=FSystem[d+1];
              dec(FTotalSystem)
            end
      until f>=FTotalSystem;
      PaintSystems;      
      Exit
    end;
  FDoIt:=true;
  inc(FTotalSystem);
  with FSystem[FTotalSystem] do
    begin
      Level:=Round(X/10);
      if Level=0 then Level:=1;
      Level:=11-Level;
      First:=Round(Y/sgSystem.DefaultRowHeight);
      if First=0 then First:=1;
      inc(First,sgSystem.TopRow);
      Second:=First;
      if tbSys1.Down then Style:=1;
      if tbSys2.Down then Style:=2;
      for f:=1 to FTotalSystem-1 do
        if FSystem[f].Level=Level then
          begin
            if (First>=FSystem[f].First) and
              (First<FSystem[f].Second) then
              begin
                FDoIt:=false;
                dec(FTotalSystem);
                Exit
              end;
            if (First=FSystem[f].Second) and
              (Style=FSystem[f].Style) then
              begin
                FSystem[FTotalSystem]:=FSystem[f];
                for d:=f to FTotalSystem-2 do
                  FSystem[d]:=FSystem[d+1];
                FSystem[FTotalSystem-1]:=FSystem[FTotalSystem];
                dec(FTotalSystem);
                Break
              end;
            if (First=FSystem[f].Second) and
              (Style<>FSystem[f].Style) then
              begin
                dec(FTotalSystem);
                FDoIt:=false;
                Break
              end
          end
    end;
  FormResize(Self)
end;

procedure TProjectForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not FDoIt then Exit;
  with FSystem[FTotalSystem] do
    begin
      Second:=Round(Y/sgSystem.DefaultRowHeight);
      if Second=0 then Second:=1;
      inc(Second,sgSystem.TopRow);
      if (Second<First) or (Second>MaxIdentity) then Second:=First
    end;
  PaintSystems
end;

procedure TProjectForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  n,f: Cardinal;
begin
  if FDoIt then
    begin
      FDoIt:=false;
      with FSystem[FTotalSystem] do
        if First=Second then
          begin
            dec(FTotalSystem);
            PaintSystems;
            Exit
          end;
      with FSystem[FTotalSystem] do    
      for f:=1 to FTotalSystem-1 do
        if (FSystem[f].Level=Level) and
          (First<FSystem[f].First) and 
          (Second>=FSystem[f].First) then
          begin
            dec(FTotalSystem);
            PaintSystems;
            Exit
          end;
      n:=0;    
      with FSystem[FTotalSystem] do
        if Level<>1 then
          begin
            for f:=1 to FTotalSystem-1 do
              if FSystem[f].Level=Level-1 then
                begin
                  if (FSystem[f].First>=First) and (FSystem[f].Second<=Second) then
                    inc(n);
                  if ((FSystem[f].First>=First) and (FSystem[f].First<=Second) and
                    (FSystem[f].Second>Second)) or
                    ((FSystem[f].Second>=First) and (FSystem[f].Second<=Second) and
                    (FSystem[f].First<First)) then
                    begin
                      n:=0;
                      Break
                    end
                end;
            if n=0 then
              begin
                FDoIt:=false;
                dec(FTotalSystem)
              end
          end;
      PaintSystems
    end
end;

procedure TProjectForm.sgSystemTopLeftChanged(Sender: TObject);
begin
  FormResize(Self)
end;

procedure TProjectForm.FormPaint(Sender: TObject);
begin
  PaintSystems
end;

procedure TProjectForm.tbConsClick(Sender: TObject);
begin
  mmiConsClick(Self)
end;

procedure TProjectForm.mmiConsClick(Sender: TObject);
var
  f: Integer;
begin
  with ConsForm do
    begin
      ShowModal;
      FTotalConst:=FTotalC;
      for f:=0 to FTotalC-1 do
        begin
          FConstants[f+1].Name:=sgCons.Cells[0,f];
          FConstants[f+1].Value:=sgCons.Cells[1,f]
        end
    end
end;

procedure TProjectForm.tbGraphClick(Sender: TObject);
begin
  mmiGraphClick(Self)
end;

procedure TProjectForm.mmiGraphClick(Sender: TObject);
begin
  Constants:=FConstants;
  TotalConsts:=FTotalConst;
end;

end.
