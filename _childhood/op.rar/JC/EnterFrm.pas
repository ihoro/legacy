unit EnterFrm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons;

type
  TEnter = class(TForm)
    sgEnterX: TStringGrid;
    btnX: TButton;
    btnY: TButton;
    btnEnterOk: TButton;
    btnEnterCancel: TButton;
    sgEnterY: TStringGrid;
    btnClearRow: TButton;
    btnClearCol: TButton;
    btnClearAll: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnSave: TButton;
    btnLoad: TButton;
    sdJCP: TSaveDialog;
    odJCP: TOpenDialog;
    procedure sgEnterXGetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure sgEnterYGetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure btnYClick(Sender: TObject);
    procedure btnXClick(Sender: TObject);
    procedure btnEnterCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnClearRowClick(Sender: TObject);
    procedure btnClearColClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnEnterOkClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    Fmfx, Fmfy: Byte;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Enter: TEnter;

implementation

{$R *.DFM}

uses
  Main, GlobalVars, DecisionFrm;

procedure TEnter.sgEnterXGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  Value:='!99'
end;

procedure TEnter.sgEnterYGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  Value:='!99'
end;

procedure TEnter.btnYClick(Sender: TObject);
begin
  sgEnterX.SendToBack;
  btnY.Enabled:=false;
  btnX.Enabled:=true
end;

procedure TEnter.btnXClick(Sender: TObject);
begin
  sgEnterY.SendToBack;
  btnX.Enabled:=false;
  btnY.Enabled:=true
end;

procedure TEnter.btnEnterCancelClick(Sender: TObject);
begin
  Hide
end;

procedure TEnter.FormShow(Sender: TObject);
begin
  Decision.Hide;
  Form1.Enabled:=false;
  Fmfx:=MaxY div 2;
  if MaxY mod 2=1 then inc(Fmfx);
  Fmfy:=MaxX div 2;
  if MaxX mod 2=1 then inc(Fmfy);
  with sgEnterX do
    begin
      ColCount:=99;
      RowCount:=50
    end;
  with sgEnterY do
    begin
      RowCount:=99;
      ColCount:=50
    end;
  Label3.Caption:=IntToStr(MaxX+Fmfy-1)+' (149)';
  Label4.Caption:=IntToStr(MaxY+Fmfx-1)+' (149)'
end;

procedure TEnter.btnClearAllClick(Sender: TObject);
var
  f,l: Byte;
begin
  if btnX.Enabled then
    for l:=0 to 98 do
      for f:=0 to 49 do
        sgEnterY.Cells[f,l]:=''
                      else
    for l:=0 to 49 do
      for f:=0 to 98 do
        sgEnterX.Cells[f,l]:=''
end;

procedure TEnter.btnClearRowClick(Sender: TObject);
var
  f: Byte;
begin
  if btnX.Enabled then
    for f:=0 to 49 do
      sgEnterY.Cells[f,sgEnterY.Row]:=''
                      else
    for f:=0 to 98 do
      sgEnterX.Cells[f,sgEnterX.Row]:=''
end;

procedure TEnter.btnClearColClick(Sender: TObject);
var
  f: Byte;
begin
  if btnX.Enabled then
    for f:=0 to 98 do
      sgEnterY.Cells[sgEnterY.Col,f]:=''
                  else
    for f:=0 to 49 do
      sgEnterX.Cells[sgEnterX.Col,f]:=''
end;

procedure TEnter.FormHide(Sender: TObject);
begin
  Form1.Enabled:=true;
  Entering:=false
end;

procedure TEnter.btnEnterOkClick(Sender: TObject);
var
  f,l,last,t: Byte;
  s: string;
begin
  OldXvar:=Crossword.CrosswordX;
  OldYvar:=Crossword.CrosswordY;
  for f:=0 to 98 do
    begin
      Last:=1;
      FigX.Total[f+1]:=0;
      for l:=49 downto 0 do
        begin
          s:=sgEnterX.Cells[f,l]+'  ';
          if (s[2]=' ') and (s[1]<>' ') then
            t:=StrToInt(sgEnterX.Cells[f,l][1]);
          if (s[2]<>' ') and (s[1]<>' ') then
            t:=StrToInt(sgEnterX.Cells[f,l]);
          if s='  ' then t:=0;
          if t<>0 then
            begin
              FigX.Fig[f+1,Last]:=t;
              inc(FigX.Total[f+1]);
              inc(Last)
            end
        end
    end;
  for l:=0 to 98 do
    begin
      Last:=1;
      FigY.Total[l+1]:=0;
      for f:=49 downto 0 do
        begin
          s:=sgEnterY.Cells[f,l]+'  ';
          if (s[2]=' ') and (s[1]<>' ') then
            t:=StrToInt(sgEnterY.Cells[f,l][1]);
          if (s[2]<>' ') and (s[1]<>' ') then
            t:=StrToInt(sgEnterY.Cells[f,l]);
          if s='  ' then t:=0;
          if t<>0 then
            begin
              FigY.Fig[l+1,Last]:=t;
              inc(FigY.Total[l+1]);
              inc(Last)
            end
        end
    end;
  for f:=99 downto 1 do
    if FigX.Total[f]<>0 then
      begin
        Crossword.CrosswordX:=f;
        Break
      end;
  for f:=99 downto 1 do
    if FigY.Total[f]<>0 then
      begin
        Crossword.CrosswordY:=f;
        Break
      end;
  for l:=1 to Crossword.CrosswordX do
    begin
      t:=0;
      for f:=1 to FigX.Total[l] do
        inc(t,FigX.Fig[l,f]);
      if FigX.Total[l]<>0 then inc(t,FigX.Total[l]-1);
      if t>99 then
        begin
          MessageDlg('Неверные данные!',mtWarning,[mbOK],0);
          Exit
        end
    end;
  for l:=1 to Crossword.CrosswordY do
    begin
      t:=0;
      for f:=1 to FigY.Total[l] do
        inc(t,FigY.Fig[l,f]);
      if FigY.Total[l]<>0 then inc(t,FigY.Total[l]-1);
      if t>99 then
        begin
          MessageDlg('Неверные данные!',mtWarning,[mbOK],0);
          Exit
        end
    end;
  Entering:=true;
  Form1.mmiDecision.OnClick(nil)
end;

procedure TEnter.btnSaveClick(Sender: TObject);
var
  f,l,d: Byte;
  jcp: TextFile;
begin
  if sdJCP.Execute then
    begin
      AssignFile(jcp,sdJCP.FileName);
      Rewrite(jcp);
      for f:=0 to 98 do
        for l:=0 to 49 do
          if l=49 then
            begin
              if Length(sgEnterX.Cells[f,l])<2 then
                begin
                  write(jcp,sgEnterX.Cells[f,l]);
                  for d:=Length(sgEnterX.Cells[f,l]) to 1 do
                    if d=1 then writeln(jcp,' ')
                           else write(jcp,' ')
                end
                                               else
                writeln(jcp,sgEnterX.Cells[f,l])
            end
                  else
            begin
              write(jcp,sgEnterX.Cells[f,l]);
              if Length(sgEnterX.Cells[f,l])<2 then
                for d:=Length(sgEnterX.Cells[f,l]) to 1 do
                  write(jcp,' ')
            end;
      for f:=0 to 98 do
        for l:=0 to 49 do
          if l=49 then
            begin
              if Length(sgEnterY.Cells[l,f])<2 then
                begin
                  write(jcp,sgEnterY.Cells[l,f]);
                  for d:=Length(sgEnterY.Cells[l,f]) to 1 do
                    if d=1 then writeln(jcp,' ')
                           else write(jcp,' ')
                end
                                               else
                writeln(jcp,sgEnterY.Cells[l,f])
            end
                  else
            begin
              write(jcp,sgEnterY.Cells[l,f]);
              if Length(sgEnterY.Cells[l,f])<2 then
                for d:=Length(sgEnterY.Cells[l,f]) to 1 do
                  write(jcp,' ')
            end;
      CloseFile(jcp)
    end
end;

procedure TEnter.btnLoadClick(Sender: TObject);
var
  f,l: Byte;
  jcp: TextFile;
  s: string[2];
begin
  if odJCP.Execute then
    begin
      AssignFile(jcp,odJCP.FileName);
      Reset(jcp);
      for f:=0 to 98 do
        for l:=0 to 49 do
          begin
            if l=49 then readln(jcp,s)
                    else read(jcp,s);
            if s='  ' then s:='';
            sgEnterX.Cells[f,l]:=s
          end;
      for f:=0 to 98 do
        for l:=0 to 49 do
          begin
            if l=49 then readln(jcp,s)
                    else read(jcp,s);
            if s='  ' then s:='';
            sgEnterY.Cells[l,f]:=s
          end;
      CloseFile(jcp)
    end
end;

end.
