unit TestFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TAsks = array[1..10] of Integer;

  TTestForm = class(TForm)
    lblTestTime: TLabel;
    gbQuestion: TGroupBox;
    pbTestTime: TProgressBar;
    lblTestName: TLabel;
    pbQuestionTime: TProgressBar;
    tmrTest: TTimer;
    tmrQuestion: TTimer;
    bvlTest: TBevel;
    lblQuestionTime: TLabel;
    memQuestion: TMemo;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    btnAsk: TButton;
    lblTime1: TLabel;
    lblTime2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure tmrTestTimer(Sender: TObject);
    procedure tmrQuestionTimer(Sender: TObject);
    procedure btnAskClick(Sender: TObject);
  private
  public
    FTestName: string;
    FTestTableName: string;
    FWorksTableName: string;
    FTestTime: Integer;
    FCurrentTestTime: Integer;
    FQuestionTime: Integer;
    FCurrentQuestionTime: Integer;
    FCurrentQuestion: Integer;
    FQuestionsCount: Integer;
    FAsksCount: Integer;
    FTrueAsks: TAsks;
    FTrueAsksCount: Integer;
    // p&f for properties:
    procedure SetCurrentQuestion(Value: Integer);
    // properties:
    property CurrentQuestion: Integer read FCurrentQuestion write SetCurrentquestion;
    // p&f:
    procedure ViewQuestion;
    procedure EndOfTest;
  end;

var
  TestForm: TTestForm;

function IsIn(Value: Integer; M: TAsks): Boolean;
function CheckAsk: Boolean;

implementation

{$R *.dfm}

uses
  MainFrm, global;

procedure TTestForm.FormShow(Sender: TObject);
begin
  FTrueAsksCount:=0;
  lblTime1.Caption:='00:00';
  lblTime2.Caption:='00:00';
  pbTestTime.Position:=100;
  pbQuestionTime.Position:=100;
  tmrTest.Enabled:=false;
  tmrQuestion.Enabled:=false;
  if not DoSQL(Format(sqlGetTestByName,[tnTests]),
    [FTestName
     ]) then
    {todo: EH!};
  FTestTime:=StrToInt(VarToStr(MainForm.ibq.FieldValues['tst_time']));
  FTestTableName:=VarToStr(MainForm.ibq.FieldValues['tst_table_name']);
  if not DoSQL(Format(sqlGetCountRowsInTable,['test_no',FTestTableName]),
    []) then
    {todo: EH!};
  FQuestionsCount:=StrToInt(VarToStr(MainForm.ibq.FieldValues['count']));
  CurrentQuestion:=1;
  ViewQuestion;
  FCurrentTestTime:=0;
  tmrTest.Enabled:=true
end;

procedure TTestForm.SetCurrentQuestion(Value: Integer);
begin
  FCurrentQuestion:=Value;
  gbQuestion.Caption:=txtDefaultQuestion+IntToStr(Value)+'/'+
    IntToStr(FQuestionsCount)
end;

procedure TTestForm.ViewQuestion;
var
  s: string;
  i,j: Integer;
begin
  if not DoSQL(Format(sqlViewQuestion,[FTestTableName]),
    [CurrentQuestion
     ]) then
    {todo: EH!};
  with MainForm.ibq do
    begin
      FQuestionTime:=StrToInt(VarToStr(FieldValues['test_time']));
      s:=VarToStr(FieldValues['test_question']);
      memQuestion.Lines.Clear;
      i:=Pos(txtDefaultQuestionSplitter,s);
      while i<>0 do
        begin
          memQuestion.Lines.Add(Copy(s,1,i-1));
          System.Delete(s,1,i+Length(txtDefaultQuestionSplitter)-1);
          i:=Pos(txtDefaultQuestionSplitter,s)
        end;
      for i:=1 to 10 do
        FTrueAsks[i]:=0;
      s:=VarToStr(FieldValues['test_true_asks']);
      i:=Pos(';',s);
      j:=1;
      while i<>0 do
        begin
          FTrueAsks[j]:=StrToInt(Copy(s,1,i-1));
          System.Delete(s,1,i+Length(';')-1);
          i:=Pos(';',s);
          inc(j)
        end;
      CheckBox1.Visible:=false;
      CheckBox2.Visible:=false;
      CheckBox3.Visible:=false;
      CheckBox4.Visible:=false;
      CheckBox5.Visible:=false;
      CheckBox6.Visible:=false;
      CheckBox7.Visible:=false;
      CheckBox8.Visible:=false;
      CheckBox9.Visible:=false;
      CheckBox10.Visible:=false;
      s:=VarToStr(FieldValues['test_asks']);
      i:=Pos(';',s);
      j:=1;
      while i<>0 do
        begin
          case j of
            1: begin
                 CheckBox1.Caption:=Copy(s,1,i-1);
                 CheckBox1.Visible:=true
               end;
            2: begin
                 CheckBox2.Caption:=Copy(s,1,i-1);
                 CheckBox2.Visible:=true
               end;
            3: begin
                 CheckBox3.Caption:=Copy(s,1,i-1);
                 CheckBox3.Visible:=true
               end;
            4: begin
                 CheckBox4.Caption:=Copy(s,1,i-1);
                 CheckBox4.Visible:=true
               end;
            5: begin
                 CheckBox5.Caption:=Copy(s,1,i-1);
                 CheckBox5.Visible:=true
               end;
            6: begin
                 CheckBox6.Caption:=Copy(s,1,i-1);
                 CheckBox6.Visible:=true
               end;
            7: begin
                 CheckBox7.Caption:=Copy(s,1,i-1);
                 CheckBox7.Visible:=true
               end;
            8: begin
                 CheckBox8.Caption:=Copy(s,1,i-1);
                 CheckBox8.Visible:=true
               end;
            9: begin
                 CheckBox9.Caption:=Copy(s,1,i-1);
                 CheckBox9.Visible:=true
               end;
            10: begin
                  CheckBox10.Caption:=Copy(s,1,i-1);
                  CheckBox10.Visible:=true
                end;
          end;
          System.Delete(s,1,i+Length(';')-1);
          i:=Pos(';',s);
          if i<>0 then
            inc(j)
        end;
      FAsksCount:=j
    end;
  FCurrentQuestionTime:=0;
  tmrQuestion.Enabled:=true
end;

procedure TTestForm.tmrTestTimer(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  inc(FCurrentTestTime);
  pbTestTime.Position:=100-Round((FCurrentTestTime/(FTestTime*60))*100);
  i:=FTestTime*60-FCurrentTestTime;
  s:=IntToStr(Trunc(i/60));
  i:=i-Trunc(i/60)*60;
  s:=s+':'+IntToStr(i);
  lblTime1.Caption:=s;
  if FCurrentTestTime=FTestTime*60 then
    EndOfTest
end;

procedure TTestForm.tmrQuestionTimer(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  inc(FCurrentQuestionTime);
  pbQuestionTime.Position:=100-Round((FCurrentQuestionTime/(FQuestionTime*60))*100);
  i:=FQuestionTime*60-FCurrentQuestionTime;
  s:=IntToStr(Trunc(i/60));
  i:=i-Trunc(i/60)*60;
  s:=s+':'+IntToStr(i);
  lblTime2.Caption:=s;
  if FCurrentQuestionTime=FQuestionTime*60 then
    begin
      if CheckAsk then
        inc(FTrueAsksCount);
      CheckBox1.Checked:=false;
      CheckBox2.Checked:=false;
      CheckBox3.Checked:=false;
      CheckBox4.Checked:=false;
      CheckBox5.Checked:=false;
      CheckBox6.Checked:=false;
      CheckBox7.Checked:=false;
      CheckBox8.Checked:=false;
      CheckBox9.Checked:=false;
      CheckBox10.Checked:=false;
      tmrQuestion.Enabled:=false;
      CurrentQuestion:=CurrentQuestion+1;
      if FCurrentQuestion>FQuestionsCount then
        begin
          EndOfTest;
          Exit
        end;
      ViewQuestion
    end
end;

procedure TTestForm.btnAskClick(Sender: TObject);
begin
  if CheckAsk then
    inc(FTrueAsksCount);
  CheckBox1.Checked:=false;
  CheckBox2.Checked:=false;
  CheckBox3.Checked:=false;
  CheckBox4.Checked:=false;
  CheckBox5.Checked:=false;
  CheckBox6.Checked:=false;
  CheckBox7.Checked:=false;
  CheckBox8.Checked:=false;
  CheckBox9.Checked:=false;
  CheckBox10.Checked:=false;
  inc(FCurrentQuestion);
  if FCurrentQuestion>FQuestionsCount then
    begin
      EndOfTest;
      Exit
    end;
  ViewQuestion
end;

function IsIn(Value: Integer; M: TAsks): Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=1 to 10 do
    if M[i]=Value then
      begin
        Result:=true;
        Break
      end
end;

function CheckAsk: Boolean;
begin
  Result:=true;
  with TestForm do
    begin
      if CheckBox1.Visible and not CheckBox1.Checked and IsIn(1,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox1.Visible and CheckBox1.Checked and not IsIn(1,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox2.Visible and not CheckBox2.Checked and IsIn(2,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox2.Visible and CheckBox2.Checked and not IsIn(2,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox3.Visible and not CheckBox3.Checked and IsIn(3,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox3.Visible and CheckBox3.Checked and not IsIn(3,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox4.Visible and not CheckBox4.Checked and IsIn(4,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox4.Visible and CheckBox4.Checked and not IsIn(4,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox5.Visible and not CheckBox5.Checked and IsIn(5,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox5.Visible and CheckBox5.Checked and not IsIn(5,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox6.Visible and not CheckBox6.Checked and IsIn(6,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox6.Visible and CheckBox6.Checked and not IsIn(6,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox7.Visible and not CheckBox7.Checked and IsIn(7,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox7.Visible and CheckBox7.Checked and not IsIn(7,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox8.Visible and not CheckBox8.Checked and IsIn(8,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox8.Visible and CheckBox8.Checked and not IsIn(8,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox9.Visible and not CheckBox9.Checked and IsIn(9,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox9.Visible and CheckBox9.Checked and not IsIn(9,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox10.Visible and not CheckBox10.Checked and IsIn(10,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end;
      if CheckBox10.Visible and CheckBox10.Checked and not IsIn(10,FTrueAsks) then
        begin
          Result:=false;
          Exit
        end
    end
end;

procedure TTestForm.EndOfTest;
var
  i,j: Integer;
begin
  tmrTest.Enabled:=false;
  tmrQuestion.Enabled:=false;
  i:=Round((FTrueAsksCount/FQuestionsCount)*12);
  if not DoSQL(Format(sqlGetCount,['wrk_no',FWorksTableName]),
    []) then
    {todo: EH!};
  j:=StrToInt(VarToStr(MainForm.ibq.FieldValues['count']));
  if not DoSQL(Format(sqlInsertIntoWorks,[FWorksTableName]),
    [j+1,
     FTestName,
     i,
     FTrueAsksCount
     ]) then
    {todo: EH!};
  MessageBox(Handle,PAnsiChar(txtYourResult+IntToStr(i)),PAnsiChar(txtInformation),
    MB_OK+MB_ICONINFORMATION);
  ModalResult:=mrOK
end;

end.
