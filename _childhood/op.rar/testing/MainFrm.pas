unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, Grids,
  DBGrids, IBTable, ComCtrls, XPMan, ExtCtrls, Registry, ActnMan,
  ActnColorMaps, Menus, ToolWin, Buttons;

type
  TMainForm = class(TForm)
    ibdb: TIBDatabase;
    ibq: TIBQuery;
    IBTransaction: TIBTransaction;
    XPManifest: TXPManifest;
    btnExit: TButton;
    ibq2: TIBQuery;
    lblCountStudents: TLabel;
    sgStudents: TStringGrid;
    btnAddNewStudent: TButton;
    btnDeleteSelected: TButton;
    btnSaveModify: TButton;
    cbEditMode: TCheckBox;
    lblCountPlans: TLabel;
    lblTestsCount2: TLabel;
    sgPlans: TStringGrid;
    btnNewPlan: TButton;
    btnSaveModifyPlans: TButton;
    btnDeletePlan: TButton;
    cbEditMode2: TCheckBox;
    btnChooseTest: TButton;
    sgTests2: TStringGrid;
    lblTestsCount: TLabel;
    leTestName: TLabeledEdit;
    leTestSubject: TLabeledEdit;
    leTestTeacher: TLabeledEdit;
    leTimeTest: TLabeledEdit;
    gbQuestion: TGroupBox;
    lblQuestion: TLabel;
    memQuestion: TMemo;
    btnDelQ: TButton;
    btnNextQ: TButton;
    btnPrevQ: TButton;
    leAsks: TLabeledEdit;
    leTrueAsks: TLabeledEdit;
    leQTime: TLabeledEdit;
    btnNewTest: TButton;
    btnOpenTest: TButton;
    btnDeleteTest: TButton;
    sgTest: TStringGrid;
    sgTests: TStringGrid;
    btnCancel: TButton;
    lblStudent: TLabel;
    sgResults: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure ibdbLogin(Database: TIBDatabase;
      LoginParams: TStrings);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddNewStudentClick(Sender: TObject);
    procedure btnSaveModifyClick(Sender: TObject);
    procedure btnDeleteSelectedClick(Sender: TObject);
    procedure cbEditModeClick(Sender: TObject);
    procedure leTimeTestChange(Sender: TObject);
    procedure edtTimeQChange(Sender: TObject);
    procedure btnNewTestClick(Sender: TObject);
    procedure btnDeleteTestClick(Sender: TObject);
    procedure leTestNameExit(Sender: TObject);
    procedure leTimeTestExit(Sender: TObject);
    procedure leTestSubjectExit(Sender: TObject);
    procedure leTestTeacherExit(Sender: TObject);
    procedure btnNextQClick(Sender: TObject);
    procedure btnPrevQClick(Sender: TObject);
    procedure btnDelQClick(Sender: TObject);
    procedure memQuestionExit(Sender: TObject);
    procedure leAsksExit(Sender: TObject);
    procedure leTrueAsksExit(Sender: TObject);
    procedure leQTimeExit(Sender: TObject);
    procedure leQTimeChange(Sender: TObject);
    procedure btnOpenTestClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure sgTestsDblClick(Sender: TObject);
    procedure sgStudentsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure cbEditMode2Click(Sender: TObject);
    procedure btnNewPlanClick(Sender: TObject);
    procedure btnSaveModifyPlansClick(Sender: TObject);
    procedure sgPlansSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnDeletePlanClick(Sender: TObject);
    procedure btnChooseTestClick(Sender: TObject);
    procedure sgTests2DblClick(Sender: TObject);
    procedure sgPlansExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure sgPlansGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure sgStudentsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    // local fields:
    FOpenMode: Boolean;
    FOpenMode2: Boolean;
    FOldDelState: Boolean;
    CurrentTestTableName: string;
    // fields for properties:
    FCountStudents: Integer;
    FCountTests: Integer;
    FCountPlans: Integer;
    FCurrentTestQuestion: Integer;
    FCurrentTestQuestionsCount: Integer;
    FTempTestName: string;
    FCurrentRow: Integer;
    // function & procedures for r/w properties:
    function GetGlobalCounter: Integer;
    procedure SetGlobalCounter(Value: Integer);
    function GetGlobalCounter2: Integer;
    procedure SetGlobalCounter2(Value: Integer);
    procedure SetCountStudents(Value: Integer);
    procedure SetCurrentTestQuestion(Value: Integer);
    procedure SetCurrentTestQuestionsCount(Value: Integer);
    procedure SetCountTests(Value: Integer);
    procedure SetCountPlans(Value: Integer);
    // properties:
    property CountStudents: Integer read FCountStudents write SetCountStudents;
    property CountTests: Integer read FCountTests write SetCountTests;
    property CountPlans: Integer read FCountPlans write SetCountPlans;
    property GlobalCounter: Integer read GetGlobalCounter write SetGlobalCounter;
    property GlobalCounter2: Integer read GetGlobalCounter2 write SetGlobalCounter2;
    property CurrentTestQuestion: Integer read FCurrentTestQuestion write SetCurrentTestQuestion;
    property CurrentTestQuestionsCount: Integer read FCurrentTestQuestionsCount write SetCurrentTestQuestionsCount;
    property CurrentRow: Integer read FCurrentRow write FCurrentRow;
  public
    // public fields:
    _LoginParams: TStringList;
    // local function & procedures:
//    function DelSpace(Value: string): string;
    function CheckNumer(Value: string): string;
    function CheckNumerDT(Value: string): string;
    function AreYouSure: Boolean;
    function SaveChanges: Boolean;
    procedure EditTestMode(Mode: Boolean);
    procedure OpenMode(Mode: Boolean);
    procedure OpenMode2(Mode: Boolean);
    // function & procedures with sql-sripts:
    function SortByNo(var Grid: TStringGrid; TableName: string): Boolean;
    function GetInfo(Param: string; var str: string; var int: Integer): Boolean;
    function SetInfo(Param: string; str: string; int: Integer): Boolean;
    function GetCountRowsInTable(PrimaryKey: string; TableName: string): Integer;
    procedure ViewAllStudents;
    procedure GetAllTests;
    procedure GetAllTests2;
    procedure ViewTest(TableName: string);
    procedure AddNewQuestion;
    procedure ViewQuestion;
    procedure ViewAllPlans;
    procedure ViewResultsByStudent;
  end;

var
  MainForm: TMainForm;

// global function & procedures:
function srvConnect(user: string; password: string): Boolean;
function srvDisconnect: Boolean;
function DoSQL(sqlScript: string; sqlParams: array of const): Boolean;
function DoSQL2(sqlScript: string; sqlParams: array of const): Boolean;
function Commit_plz: Boolean;
function CheckUser(UserName: string): Boolean;

implementation

{$R *.dfm}

uses
  LoginFrm, global;

procedure TMainForm.ibdbLogin(Database: TIBDatabase;
  LoginParams: TStrings);
begin
  LoginParams.Assign(_LoginParams)
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  _LoginParams.Free
end;

procedure TMainForm.ViewTest(TableName: string);
var
  i: Integer;
begin
  if not DoSQL(Format(sqlViewTest,[TableName]),
    []) then
    {todo: EH!};
  for i:=sgTest.RowCount-1 downto 1 do
    sgTest.Rows[i].Clear;
  sgTest.RowCount:=1;
  while not ibq.Eof do
    with ibq do
      begin
        sgTest.RowCount:=sgTest.RowCount+1;
        sgTest.Rows[sgTest.RowCount-1].Add(VarToStr(FieldValues['test_no']));
        sgTest.Rows[sgTest.RowCount-1].Add(VarToStr(FieldValues['test_question']));
        sgTest.Rows[sgTest.RowCount-1].Add(VarToStr(FieldValues['test_asks']));
        sgTest.Rows[sgTest.RowCount-1].Add(VarToStr(FieldValues['test_true_asks']));
        sgTest.Rows[sgTest.RowCount-1].Add(VarToStr(FieldValues['test_time']));
        Next
      end;
  CurrentTestQuestionsCount:=sgTest.RowCount-1;
  if CurrentTestQuestionsCount=0 then
    AddNewQuestion;
end;

procedure TMainForm.btnAddNewStudentClick(Sender: TObject);
var
  s: string;
begin
  if btnSaveModify.Enabled then
    if SaveChanges then
      btnSaveModifyClick(Self);
  with sgStudents do
    begin
      RowCount:=RowCount+1;
      if RowCount=2 then
        FixedRows:=1;
      Rows[RowCount-1][0]:=IntToStr(RowCount-1);
      Rows[RowCount-1][1]:=txtDefaultLogin;
      GlobalCounter2:=GlobalCounter2+1;
      s:=txtDefaultWorksTableName+IntToStr(GlobalCounter2);
      if not DoSQL(Format(sqlNewWorks,[s]),
        []) then
        {todo: error here!};
      if not DoSQL(Format(sqlSetGrant,['insert,select',s,usrStudent]),
        []) then
        {todo: EH!};
      if not DoSQL(Format(sqlAddNewStudent,[tnStudents]),
        [RowCount-1,
         txtDefaultLogin,
         '',
         '',
         '',
         '',
         numDefaultStudentCourse,
         s
         ]) then
        {todo: error here!};
      CountStudents:=CountStudents+1
    end;
  Commit_plz;
  ViewAllStudents
end;

procedure TMainForm.btnSaveModifyClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=1 to sgStudents.RowCount-1 do
    with sgStudents do
      if not DoSQL(Format(sqlSaveModifyStudents,[tnStudents]),
        [StrToInt(Rows[i][0]),
         Rows[i][1],
         Rows[i][2],
         Rows[i][3],
         Rows[i][4],
         Rows[i][5],
         Rows[i][6],
         StrToInt(Rows[i][0])
         ]) then
        {todo: error here!};
  Commit_plz;
  btnSaveModify.Enabled:=false;
end;

procedure TMainForm.btnDeleteSelectedClick(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  if btnSaveModify.Enabled then
    if SaveChanges then
      btnSaveModifyClick(Self);
  for i:=sgStudents.Selection.Top to sgStudents.Selection.Bottom do
    begin
      if not DoSQL(Format(sqlGetWorksByNo,[tnStudents]),
        [StrToInt(sgStudents.Rows[i][0])
         ]) then
        {todo: EH!};
      s:=VarToStr(ibq.FieldValues['std_works']);  
      if not DoSQL(Format(sqlDeleteWorks,[s]),
        []) then
        {todo: error here!};
      if not DoSQL(Format(sqlDeleteSelectedStudents,[tnStudents]),
        [StrToInt(sgStudents.Rows[i][0])
         ]) then
        {todo: error here!};
    end;
  ViewAllStudents;
  SortByNo(sgStudents,tnStudents);
  ViewAllStudents;
  CountStudents:=sgStudents.RowCount-1
end;

function TMainForm.SortByNo(var Grid: TStringGrid; TableName: string): Boolean;
var
  i: Integer;
  s: string;
begin
  Result:=true;
  for i:=1 to Grid.RowCount-1 do
    with Grid do
      begin
        if TableName=tnStudents then
          s:=sqlSortStudents;
        if TableName=tnTests then
          s:=sqlSortTests;
        if Pos(txtDefaultTestTableName,TableName)<>0 then
          s:=sqlSortTest;
        if TableName=tnPlans then
          s:=sqlSortPlans;
        if not DoSQL(Format(s,[TableName]),
          [i,
           StrToInt(Rows[i][0])
           ]) then
          begin
            Result:=false;
            Break
          end
      end
end;

procedure TMainForm.ViewAllStudents;
var
  i: Integer;
begin
  with ibq do
    begin
      if not DoSQL(Format(sqlViewAllStudents,[tnStudents]),
        []) then
        {todo: error here!};
      for i:=sgStudents.RowCount-1 downto 1 do
        sgStudents.Rows[i].Clear;
      sgStudents.RowCount:=1;
      while not Eof do
        begin
          sgStudents.RowCount:=sgStudents.RowCount+1;
          if sgStudents.RowCount=2 then
            sgStudents.FixedRows:=1;
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_no']));
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_login']));
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_first_name']));
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_middle_name']));
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_last_name']));
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_group']));
          sgStudents.Rows[sgStudents.RowCount-1].Add(VarToStr(FieldValues['std_course']));
          Next
        end;
      if sgStudents.RowCount=1 then
        btnAddNewStudentClick(self)
    end
end;

procedure TMainForm.SetCountStudents(Value: Integer);
begin
  FCountStudents:=Value;
  lblCountStudents.Caption:=txtCountStudents+IntToStr(Value)+'.'
end;

{function TMainForm.DelSpace(Value: string): string;
var
  i: Integer;
begin
  for i:=Length(Value) downto 1 do
    if Value[i]=' ' then
      Delete(Value,i,1)
                    else
      Break;
  Result:=Value
end;}

procedure TMainForm.cbEditModeClick(Sender: TObject);
begin
  if cbEditMode.Checked then
    sgStudents.Options:=sgStudents.Options+[goAlwaysShowEditor]
                        else
    sgStudents.Options:=sgStudents.Options-[goAlwaysShowEditor]
end;

procedure TMainForm.leTimeTestChange(Sender: TObject);
begin
  leTimeTest.Text:=CheckNumer(leTimeTest.Text)
end;

procedure TMainForm.edtTimeQChange(Sender: TObject);
begin
  leQTime.Text:=CheckNumer(leQTime.Text)
end;

function TMainForm.CheckNumer(Value: string): string;
var
  i: Integer;
begin
  for i:=1 to Length(Value) do
    if not (Value[i] in Numer_set) then
      Delete(Value,i,1);
  Result:=Value
end;

procedure TMainForm.GetAllTests;
var
  i: Integer;
begin
  with ibq do
    begin
      if not DoSQL(Format(sqlGetAllTests,[tnTests]),
        []) then
        {todo: error here!};
      for i:=sgTests.RowCount-1 downto 1 do
        sgTests.Rows[i].Clear;
      sgTests.RowCount:=1;
      while not Eof do
        begin
          sgTests.RowCount:=sgTests.RowCount+1;
          if sgTests.RowCount=2 then
            sgTests.FixedRows:=1;
          sgTests.Rows[sgTests.RowCount-1].Add(VarToStr(FieldValues['tst_no']));
          sgTests.Rows[sgTests.RowCount-1].Add(VarToStr(FieldValues['tst_name']));
          Next
        end;
      CountTests:=sgTests.RowCount-1;
      if CountTests=0 then
        btnNewTestClick(Self)
    end
end;

procedure TMainForm.btnNewTestClick(Sender: TObject);
var
  s: string;
begin
  with sgTests do
    begin
      RowCount:=RowCount+1;
      if RowCount=2 then
        FixedRows:=1;
      Rows[RowCount-1][0]:=IntToStr(RowCount-1);
      GlobalCounter:=GlobalCounter+1;
      s:=txtDefaultTestTableName+IntToStr(GlobalCounter);
      if not DoSQL(Format(sqlNewTest,[s]),
        []) then
        {todo: error here!};
      if not DoSQL(Format(sqlAddNewTest,[tnTests]),
        [RowCount-1,
         txtDefaultTestName,
         '',
         '',
         s,
         numDefaultTestTime
         ]) then
        {todo: error here!};
      if not DoSQL(Format(sqlSetGrant,['select',s,usrStudent]),
        []) then
        {todo: EH!};
      CountTests:=CountTests+1
    end;
  Commit_plz;
  GetAllTests;
  if not FOpenMode then
    begin
      EditTestMode(true);
      CurrentTestTableName:=s;
      ViewTest(CurrentTestTableName);
      leTimeTest.Text:=IntToStr(numDefaultTestTime);
      CurrentTestQuestion:=1;
      ViewQuestion;
      leTestName.SetFocus
    end
end;

procedure TMainForm.btnDeleteTestClick(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  if not AreYouSure then
    Exit;
  if FOpenMode then
    begin
      i:=sgTests.Selection.Top;
      if not DoSQL(Format(sqlGetTableNameByNo,[tnTests]),
        [sgTests.Selection.Top
         ]) then
        {todo: EH!};
      s:=VarToStr(ibq.FieldValues['tst_table_name']);
      if not DoSQL(Format(sqlDeleteTest,[s]),
        []) then
        {todo: error here!};
      if not DoSQL(Format(sqlDeleteTests,[tnTests]),
        [s
         ]) then
        {todo: error here!};
      GetAllTests;
      SortByNo(sgTests,tnTests);
      GetAllTests;
      Commit_plz;
      CountTests:=sgTests.RowCount-1;
      if s=CurrentTestTableName then
        begin
          CurrentTestQuestionsCount:=0;
          CurrentTestQuestion:=0;
          EditTestMode(false);
          btnDeleteTest.Enabled:=true
        end;
      if i>CountTests then
        dec(i);  
      sgTests.Row:=i;  
      Exit
    end;
  {done: pomenya!!! toka tekushiy udalyat!}
  if not DoSQL(Format(sqlDeleteTest,[CurrentTestTableName]),
    []) then
    {todo: error here!};
  if not DoSQL(Format(sqlDeleteTests,[tnTests]),
    [CurrentTestTableName
     ]) then
    {todo: error here!};
  GetAllTests;
  SortByNo(sgTests,tnTests);
  GetAllTests;
  Commit_plz;
  CountTests:=sgTests.RowCount-1;
  CurrentTestQuestionsCount:=0;
  CurrentTestQuestion:=0;
  EditTestMode(false)
end;

function TMainForm.GetGlobalCounter: Integer;
var
  s: string;
  i: Integer;
begin
  GetInfo(infGlobalCounter,s,i);
  Result:=i
end;

procedure TMainForm.SetGlobalCounter(Value: Integer);
begin
  SetInfo(infGlobalCounter,'',Value)
end;

function TMainForm.GetInfo(Param: string; var str: string;
  var int: Integer): Boolean;
begin
  Result:=true;
  with ibq do
    begin
      if not DoSQL(Format(sqlGetInfo,[tnInfo]),
        [Param]) then
        begin
          Result:=false;
          Exit
        end;
      str:=VarToStr(FieldValues['inf_str_value']);
      int:=StrToInt(VarToStr(FieldValues['inf_int_value']))
    end
end;

function TMainForm.SetInfo(Param, str: string; int: Integer): Boolean;
begin
  Result:=true;
  if not DoSQL(Format(sqlSetInfo,[tnInfo]),
    [str,
     int,
     Param
     ]) then
    Result:=false
end;

function TMainForm.GetCountRowsInTable(PrimaryKey,
  TableName: string): Integer;
begin
  if not DoSQL(Format(sqlGetCountRowsInTable,[PrimaryKey,CurrentTestTableName]),
    []) then
    {todo: EH!};
  Result:=StrToInt(VarToStr(ibq.FieldValues['count']))
end;

function DoSQL(sqlScript: string;
  sqlParams: array of const): Boolean;
var
  i: Integer;
begin
  with MainForm.ibq do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlScript);
      for i:=Low(sqlParams) to High(sqlParams) do
        case sqlParams[i].VType of
          vtInteger: Params[i].AsInteger:=sqlParams[i].VInteger;
          vtChar: Params[i].AsString:=sqlParams[i].VChar;
          vtAnsiString: Params[i].AsString:=string(sqlParams[i].VAnsiString)
        end;
      try
        Open
      except
        Result:=false;
        Exit
      end
    end;
  Result:=true
end;

function DoSQL2(sqlScript: string;
  sqlParams: array of const): Boolean;
var
  i: Integer;
begin
  with MainForm.ibq2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlScript);
      for i:=Low(sqlParams) to High(sqlParams) do
        case sqlParams[i].VType of
          vtInteger: Params[i].AsInteger:=sqlParams[i].VInteger;
          vtChar: Params[i].AsString:=sqlParams[i].VChar;
          vtAnsiString: Params[i].AsString:=string(sqlParams[i].VAnsiString)
        end;
      try
        Open
      except
        Result:=false;
        Exit
      end
    end;
  Result:=true
end;

function Commit_plz: Boolean;
begin
  if not DoSQL('commit;',[]) then
    {todo: error here!}
end;

procedure TMainForm.EditTestMode(Mode: Boolean);
begin
  if Mode then
    begin
      leTestName.Enabled:=true;
      leTestSubject.Enabled:=true;
      leTestTeacher.Enabled:=true;
      leTimeTest.Enabled:=true;
      gbQuestion.Enabled:=true;
      btnDeleteTest.Enabled:=true
    end
          else
    begin
      leTestName.Enabled:=false;
      leTestSubject.Enabled:=false;
      leTestTeacher.Enabled:=false;
      leTimeTest.Enabled:=false;
      gbQuestion.Enabled:=false;
      btnDeleteTest.Enabled:=false;
      leTestName.Text:='';
      leTestSubject.Text:='';
      leTestTeacher.Text:='';
      leTimeTest.Text:='';
      memQuestion.Lines.Clear;
      leAsks.Text:='';
      leTrueAsks.Text:='';
      leQTime.Text:=''
    end
end;

procedure TMainForm.leTestNameExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateTestName,[tnTests]),
    [leTestName.Text,
     CurrentTestTableName
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leTimeTestExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateTimeTest,[tnTests]),
    [StrToInt(leTimeTest.Text),
     CurrentTestTableName
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leTestSubjectExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateTestSubject,[tnTests]),
    [leTestSubject.Text,
     CurrentTestTableName
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leTestTeacherExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateTestTeacher,[tnTests]),
    [leTestTeacher.Text,
     CurrentTestTableName
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.ViewQuestion;
var
  s: string;
  i: Integer;
begin
  if not DoSQL(Format(sqlViewQuestion,[CurrentTestTableName]),
    [CurrentTestQuestion
    ]) then
    {todo: EH!};
  with ibq do
    begin
      memQuestion.Lines.Clear;
      s:=VarToStr(FieldValues['test_question']);
      i:=Pos(txtDefaultQuestionSplitter,s);
      while i<>0 do
        begin
          memQuestion.Lines.Add(Copy(s,1,i-1));
          System.Delete(s,1,i+Length(txtDefaultQuestionSplitter)-1);
          i:=Pos(txtDefaultQuestionSplitter,s);
          if Length(s)=Length(txtDefaultQuestionSplitter) then
            Break
        end;
      leAsks.Text:=VarToStr(FieldValues['test_asks']);
      leTrueAsks.Text:=VarToStr(FieldValues['test_true_asks']);
      leQTime.Text:=VarToStr(FieldValues['test_time'])
    end
end;

procedure TMainForm.SetCurrentTestQuestion(Value: Integer);
begin
  FCurrentTestQuestion:=Value;
  lblQuestion.Caption:=txtDefaultQuestion+IntToStr(Value)+'/'+
    IntToStr(CurrentTestQuestionsCount)
end;

procedure TMainForm.AddNewQuestion;
begin
  CurrentTestQuestionsCount:=CurrentTestQuestionsCount+1;
  if not DoSQL(Format(sqlAddNewQuestion,[CurrenttestTableName]),
    [CurrentTestQuestionsCount,
     '',
     '',
     txtDefaultQuestionTrueAsks,
     numDefaultQuestionTime
     ]) then
    {todo: EH!};
  CurrentTestQuestion:=CurrentTestQuestionsCount;
  Commit_plz
end;

procedure TMainForm.btnNextQClick(Sender: TObject);
begin
  if CurrentTestQuestion=CurrentTestQuestionsCount then
    AddNewQuestion
                                                   else
    CurrentTestQuestion:=CurrentTestQuestion+1;
  ViewQuestion
end;

procedure TMainForm.btnPrevQClick(Sender: TObject);
begin
  CurrentTestQuestion:=CurrentTestQuestion-1;
  if CurrentTestQuestion=0 then
    CurrentTestQuestion:=1;
  ViewQuestion  
end;

procedure TMainForm.btnDelQClick(Sender: TObject);
begin
{  if not AreYouSure then
    Exit;}
  if not DoSQL(Format(sqlDeleteQuestion,[CurrentTestTableName]),
    [CurrentTestQuestion
     ]) then
    {todo: EH!};
  ViewTest(CurrentTestTableName);
  SortByNo(sgTest,CurrentTestTableName);
  Commit_plz;
  if CurrentTestQuestion>CurrentTestQuestionsCount then
    CurrentTestQuestion:=CurrentTestQuestion-1;
  ViewQuestion
end;

procedure TMainForm.memQuestionExit(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  s:='';
  for i:=0 to memQuestion.Lines.Count-1 do
    s:=s+memQuestion.Lines[i]+txtDefaultQuestionSplitter;
  if not DoSQL(Format(sqlUpdateQuestion,[CurrentTestTableName]),
    [s,
     CurrentTestQuestion
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leAsksExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateQuestionAsks,[CurrentTestTableName]),
    [leAsks.Text,
     CurrentTestQuestion
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leTrueAsksExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateQuestionTrueAsks,[CurrentTestTableName]),
    [leTrueAsks.Text,
     CurrentTestQuestion
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leQTimeExit(Sender: TObject);
begin
  if not DoSQL(Format(sqlUpdateQuestionTime,[CurrentTestTableName]),
    [StrToInt(leQTime.Text),
     CurrentTestQuestion
     ]) then
    {todo: EH!};
  Commit_plz
end;

procedure TMainForm.leQTimeChange(Sender: TObject);
begin
  leQTime.Text:=CheckNumer(leQTime.Text)
end;

procedure TMainForm.SetCurrentTestQuestionsCount(Value: Integer);
begin
  FCurrentTestQuestionsCount:=Value;
  lblQuestion.Caption:=txtDefaultQuestion+IntToStr(Value)+'/'+
    IntToStr(CurrentTestQuestionsCount)
end;

procedure TMainForm.btnOpenTestClick(Sender: TObject);
begin
  if not FOpenMode then
    begin
      GetAllTests;
      FOldDelState:=btnDeleteTest.Enabled;
      btnDeleteTest.Enabled:=true
    end
                   else
    begin
      if not DoSQL(Format(sqlGetTableNameByNo,[tnTests]),
        [sgTests.Selection.Top
         ]) then
        {todo: EH!};
      CurrentTestTableName:=VarToStr(ibq.FieldValues['tst_table_name']);
      leTestName.Text:=VarToStr(ibq.FieldValues['tst_name']);
      leTestSubject.Text:=VarToStr(ibq.FieldValues['tst_subject']);
      leTestTeacher.Text:=VarToStr(ibq.FieldValues['tst_teacher']);
      leTimeTest.Text:=VarToStr(ibq.FieldValues['tst_time']);
      ViewTest(CurrentTestTableName);
      CurrentTestQuestionsCount:=GetCountRowsInTable('test_no',CurrentTestTableName);
      CurrentTestQuestion:=1;
      ViewQuestion;
      EditTestMode(true)
    end;
  OpenMode(FOpenMode);
end;

procedure TMainForm.OpenMode(Mode: Boolean);
begin
  if not Mode then
    begin
      sgTests.Visible:=true;
      sgTests.BringToFront;
      btnCancel.Visible:=true;
      FOpenMode:=true
    end
          else
    begin
      sgTests.Visible:=false;
      btnCancel.Visible:=false;
      FOpenMode:=false
    end
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  OpenMode(FOpenMode);
  btnDeleteTest.Enabled:=FOldDelState
end;

function TMainForm.AreYouSure: Boolean;
begin
  Result:=false;
  if MessageBox(Handle,PAnsiChar(txtAreYouSure),
    PAnsiChar(txtConfirmation),MB_YESNO+MB_ICONQUESTION)=IDYES then
    Result:=true
end;

procedure TMainForm.SetCountTests(Value: Integer);
begin
  FCountTests:=Value;
  lblTestsCount.Caption:=txtDefaultTestsCount+IntToStr(Value);
  lblTestsCount2.Caption:=txtDefaultTestsCount+IntToStr(Value)
end;

procedure TMainForm.sgTestsDblClick(Sender: TObject);
begin
  btnOpenTestClick(self)
end;

procedure TMainForm.sgStudentsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if ACol=6 then
    sgStudents.Rows[ARow][ACol]:=CheckNumer(Value);
  btnSaveModify.Enabled:=true  
end;

function TMainForm.SaveChanges: Boolean;
begin
  Result:=false;
  if MessageBox(Handle,PAnsiChar(txtSaveChanges),
    PAnsiChar(txtConfirmation),MB_YESNO+MB_ICONQUESTION)=IDYES then
    Result:=true
end;

procedure TMainForm.cbEditMode2Click(Sender: TObject);
begin
  if cbEditMode2.Checked then
    sgPlans.Options:=sgPlans.Options+[goAlwaysShowEditor]
                        else
    sgPlans.Options:=sgPlans.Options-[goAlwaysShowEditor]
end;

procedure TMainForm.ViewAllPlans;
var
  i: Integer;
begin
  with ibq do
    begin
      if not DoSQL(Format(sqlViewPlans,[tnPlans]),
        []) then
        {todo: error here!};
      for i:=sgPlans.RowCount-1 downto 1 do
        sgPlans.Rows[i].Clear;
      sgPlans.RowCount:=1;
      while not Eof do
        begin
          sgPlans.RowCount:=sgPlans.RowCount+1;
          if sgPlans.RowCount=2 then
            sgPlans.FixedRows:=1;
          sgPlans.Rows[sgPlans.RowCount-1].Add(VarToStr(FieldValues['pln_no']));
          sgPlans.Rows[sgPlans.RowCount-1].Add(VarToStr(FieldValues['pln_group']));
          sgPlans.Rows[sgPlans.RowCount-1].Add(VarToStr(FieldValues['pln_test_name']));
          sgPlans.Rows[sgPlans.RowCount-1].Add(VarToStr(FieldValues['pln_date']));
          sgPlans.Rows[sgPlans.RowCount-1].Add(VarToStr(FieldValues['pln_time']));
          Next
        end;
      CountPlans:=sgPlans.RowCount-1;
      if CountPlans=0 then
        btnNewPlanClick(Self)
    end
end;

procedure TMainForm.SetCountPlans(Value: Integer);
begin
  FCountPlans:=Value;
  lblCountPlans.Caption:=txtCountPlans+IntToStr(Value)
end;

procedure TMainForm.btnNewPlanClick(Sender: TObject);
begin
  if btnSaveModifyPlans.Enabled then
    if SaveChanges then
      btnSaveModifyPlansClick(Self);
  with sgPlans do
    begin
      RowCount:=RowCount+1;
      if RowCount=2 then
        FixedRows:=1;
      Rows[RowCount-1][0]:=IntToStr(RowCount-1);
      if not DoSQL(Format(sqlAddNewPlan,[tnPlans]),
        [RowCount-1,
         '',
         ''
         ]) then
        {todo: error here!};
      CountPlans:=CountPlans+1
    end;
  Commit_plz;
  ViewAllPlans
end;

procedure TMainForm.btnSaveModifyPlansClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=1 to sgPlans.RowCount-1 do
    with sgPlans do
      if not DoSQL(Format(sqlSaveModifyPlans,[tnPlans]),
        [StrToInt(Rows[i][0]),
         Rows[i][1],
         Rows[i][2],
         Rows[i][3],
         Rows[i][4],
         StrToInt(Rows[i][0])
         ]) then
        {todo: error here!};
  Commit_plz;
  btnSaveModifyPlans.Enabled:=false;
end;

procedure TMainForm.sgPlansSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  btnSaveModifyPlans.Enabled:=true;
  if ACol=2 then
    sgPlans.Rows[ARow][ACol]:=FTempTestName
end;

procedure TMainForm.btnDeletePlanClick(Sender: TObject);
var
  i: Integer;
begin
  if not AreYouSure then
    Exit;
  for i:=sgPlans.Selection.Top to sgPlans.Selection.Bottom do
    if not DoSQL(Format(sqlDeleteSelectedPlans,[tnPlans]),
      [StrToInt(sgPlans.Rows[i][0])
       ]) then
      {todo: error here!};
  ViewAllPlans;
  SortByNo(sgPlans,tnPlans);
  ViewAllPlans;
  CountPlans:=sgPlans.RowCount-1
end;

procedure TMainForm.btnChooseTestClick(Sender: TObject);
begin
  if not FOpenMode2 then
    GetAllTests2
                   else
    begin
      sgPlans.Rows[sgPlans.Row][2]:=sgTests2.Rows[sgTests2.Row][1];
      btnSaveModifyPlans.Enabled:=true
    end;
  OpenMode2(FOpenMode2)
end;

procedure TMainForm.OpenMode2(Mode: Boolean);
begin
  if not Mode then
    begin
      sgTests2.Visible:=true;
      btnNewPlan.Visible:=false;
      btnSaveModifyPlans.Visible:=false;
      btnDeletePlan.Visible:=false;
      cbEditMode2.Visible:=false;
      lblTestsCount2.Visible:=true;
      FOpenMode2:=true
    end
          else
    begin
      sgTests2.Visible:=false;
      btnNewPlan.Visible:=true;
      btnSaveModifyPlans.Visible:=true;
      btnDeletePlan.Visible:=true;
      cbEditMode2.Visible:=true;
      lblTestsCount2.Visible:=false;
      FOpenMode2:=false
    end
end;

procedure TMainForm.GetAllTests2;
var
  i: Integer;
begin
  with ibq do
    begin
      if not DoSQL(Format(sqlGetAllTests,[tnTests]),
        []) then
        {todo: error here!};
      for i:=sgTests2.RowCount-1 downto 1 do
        sgTests2.Rows[i].Clear;
      sgTests2.RowCount:=1;
      while not Eof do
        begin
          sgTests2.RowCount:=sgTests2.RowCount+1;
          if sgTests2.RowCount=2 then
            sgTests2.FixedRows:=1;
          sgTests2.Rows[sgTests2.RowCount-1].Add(VarToStr(FieldValues['tst_no']));
          sgTests2.Rows[sgTests2.RowCount-1].Add(VarToStr(FieldValues['tst_name']));
          Next
        end;
      CountTests:=sgTests2.RowCount-1;
      if CountTests=0 then
        btnNewTestClick(Self)
    end
end;

procedure TMainForm.sgTests2DblClick(Sender: TObject);
begin
  btnChooseTestClick(Self)
end;

procedure TMainForm.sgPlansExit(Sender: TObject);
var
  i: Integer;
begin
  for i:=1 to sgPlans.RowCount-1 do
    begin
      if Length(sgPlans.Rows[i][3])<10 then
        sgPlans.Rows[i][3]:=sgPlans.Rows[i][3]+'          ';
      sgPlans.Rows[i][3]:=CheckNumerDT(Copy(sgPlans.Rows[i][3],1,2))+'.'+
        CheckNumerDT(Copy(sgPlans.Rows[i][3],4,2))+'.'+CheckNumerDT(Copy(sgPlans.Rows[i][3],7,4));
      if Copy(sgPlans.Rows[i][3],1,2)='00' then
        sgPlans.Rows[i][3]:='01'+Copy(sgPlans.Rows[i][3],3,8);
      if Copy(sgPlans.Rows[i][3],4,2)='00' then
        sgPlans.Rows[i][3]:=Copy(sgPlans.Rows[i][3],1,3)+'01'+Copy(sgPlans.Rows[i][3],6,5);
      if StrToInt(Copy(sgPlans.Rows[i][3],7,4))<2000 then
        sgPlans.Rows[i][3]:=Copy(sgPlans.Rows[i][3],1,6)+'2000';

      if Length(sgPlans.Rows[i][4])<8 then
        sgPlans.Rows[i][4]:=sgPlans.Rows[i][4]+'        ';
      sgPlans.Rows[i][4]:=CheckNumerDT(Copy(sgPlans.Rows[i][4],1,2))+':'+
        CheckNumerDT(Copy(sgPlans.Rows[i][4],4,2))+':'+CheckNumerDT(Copy(sgPlans.Rows[i][4],7,2))
    end
end;

function TMainForm.CheckNumerDT(Value: string): string;
var
  i: Integer;
begin
  for i:=1 to Length(Value) do
    if not (Value[i] in Numer_set) then
      Value[i]:='0';
  Result:=Value
end;

function CheckUser(UserName: string): Boolean;
begin
  if not DoSQL(Format(sqlGetUserByLogin,[tnStudents]),
    [UserName
     ]) then
    {todo: EH!};
  Result:=false;
  with MainForm.ibq do
    if (not Eof) and (UpperCase(UserName)=UpperCase(VarToStr(FieldValues['std_login']))) then
      Result:=true
end;

function srvConnect(user: string; password: string): Boolean;
begin
  with MainForm do
    begin
      _LoginParams.Free;
      _LoginParams:=TStringList.Create;
      _LoginParams.Values['user_name']:=user;
      _LoginParams.Values['password']:=password;
      try
        ibdb.Connected:=true;
        ibtransaction.Active:=true;
        ibq.SQL.Clear;
        ibq.SQL.Add(sqlCommandOnConnect);
        ibq.Active:=true
      except
        MessageBox(Handle,'Ошибка соединения.','error',MB_ICONERROR+MB_OK);
        Exit
      end
    end
end;

function srvDisconnect: Boolean;
begin
  MainForm.ibdb.Connected:=false
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  CurrentRow:=1;
  // read students:
  ViewAllStudents;
  SortByNo(sgStudents,tnStudents);
  ViewAllStudents;
  CountStudents:=sgStudents.RowCount-1;
  if sgStudents.RowCount=1 then
    btnAddNewStudentClick(self);
  // read tests:
  GetAllTests;
  SortByNo(sgTests,tnTests);
  GetAllTests;
  CountTests:=sgTests.RowCount-1;
  // read plans:
  ViewAllPlans;
  SortByNo(sgPlans,tnPlans);
  ViewAllPlans;
  CountPlans:=sgPlans.RowCount-1;
  if sgPlans.RowCount=1 then
    btnNewPlanClick(self);

  btnNewTest.Enabled:=true;
  btnOpenTest.Enabled:=true;
  btnDeleteTest.Enabled:=true;
  btnAddNewStudent.Enabled:=true;
  btnDeleteSelected.Enabled:=true;
  cbEditMode.Enabled:=true;
  cbEditMode2.Enabled:=true;
  btnNewPlan.Enabled:=true;
  btnChooseTest.Enabled:=true;
  btnDeletePlan.Enabled:=true;
  sgStudents.Enabled:=true;
  sgPlans.Enabled:=true;

  btnSaveModify.Enabled:=false;
  btnSaveModifyPlans.Enabled:=false;

  lblQuestion.Caption:='';
  lblCountStudents.Caption:='';
  lblCountPlans.Caption:='';
  lblCountStudents.Caption:='';

  FOpenMode:=false;
  EditTestMode(FOpenMode);
  sgStudents.Rows[0].Add(hNomer);
  sgStudents.Rows[0].Add(hStudentLogin);
  sgStudents.Rows[0].Add(hStudentFirstName);
  sgStudents.Rows[0].Add(hStudentMiddleName);
  sgStudents.Rows[0].Add(hStudentLastName);
  sgStudents.Rows[0].Add(hStudentGroup);
  sgStudents.Rows[0].Add(hStudentCourse);
  sgStudents.ColWidths[0]:=numStudentsCol0Width;
  sgStudents.ColWidths[1]:=numStudentsCol1Width;
  sgStudents.ColWidths[2]:=numStudentsCol2Width;
  sgStudents.ColWidths[3]:=numStudentsCol3Width;
  sgStudents.ColWidths[4]:=numStudentsCol4Width;
  sgStudents.ColWidths[5]:=numStudentsCol5Width;
  sgStudents.ColWidths[6]:=numStudentsCol6Width;
  sgTests.Rows[0].Add(hNomer);
  sgTests.Rows[0].Add(hTestName);
  sgTests.ColWidths[0]:=numTestsCol0Width;
  sgTests.ColWidths[1]:=numTestsCol1Width;
  sgTests2.Rows[0].Add(hNomer);
  sgTests2.Rows[0].Add(hTestName);
  sgTests2.ColWidths[0]:=numTestsCol0Width;
  sgTests2.ColWidths[1]:=numTestsCol1Width;
  sgPlans.Rows[0].Add(hNomer);
  sgPlans.Rows[0].Add(hStudentGroup);
  sgPlans.Rows[0].Add(hTestName);
  sgPlans.Rows[0].Add(hPlanDate);
  sgPlans.Rows[0].Add(hPlanTime);
  sgPlans.ColWidths[0]:=numPlansCol0Width;
  sgPlans.ColWidths[1]:=numPlansCol1Width;
  sgPlans.ColWidths[2]:=numPlansCol2Width;
  sgPlans.ColWidths[3]:=numPlansCol3Width;
  sgPlans.ColWidths[4]:=numPlansCol4Width
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  reg: TRegistry;
  s: string;
begin
  pswStudent:=chr(64)+chr(115)+chr(116)+chr(117)+chr(100)+chr(101)+chr(110)+
  chr(116)+chr(95)+chr(112)+chr(97)+chr(115)+chr(115)+chr(49)+chr(64);
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  reg.OpenKey(keyMain,false);
  s:=reg.ReadString(regServerName);
  s:='\\'+s+'\'+reg.ReadString(regDataBasePath);
  ibdb.DatabaseName:=s;
  reg.Free;
  _LoginParams:=TStringList.Create;
  btnSaveModify.Enabled:=false
end;

procedure TMainForm.btnExitClick(Sender: TObject);
begin
  if AreYouSure then
    ModalResult:=mrOK
end;

function TMainForm.GetGlobalCounter2: Integer;
var
  s: string;
  i: Integer;
begin
  GetInfo(infGlobalCounter2,s,i);
  Result:=i
end;

procedure TMainForm.SetGlobalCounter2(Value: Integer);
begin
  SetInfo(infGlobalCounter2,'',Value)
end;

procedure TMainForm.sgPlansGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  FTempTestName:=Value
end;

procedure TMainForm.sgStudentsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow<>CurrentRow then
    CurrentRow:=ARow
end;

procedure TMainForm.ViewResultsByStudent;
var
  s: string;
  i: Integer;
begin
  lblStudent.Caption:=sgStudents.Rows[CurrentRow][4]+' '+
    sgStudents.Rows[CurrentRow][2]+' '+
    sgStudents.Rows[CurrentRow][3]+'. '+txtResults;
  sgResults.ColCount:=2;
  sgResults.ColWidths[0]:=numResultsByStudentCol0Width;
  sgResults.ColWidths[1]:=numResultsByStudentCol1Width;
  sgResults.Rows[0][0]:=hTestName;
  sgResults.Rows[0][1]:=hResult;
  if not DoSQL(Format(sqlGetWorksByNo,[tnStudents]),
    [CurrentRow
     ]) then
    {todo: EH!};
  s:=VarToStr(ibq.FieldValues['std_works']);
  if not DoSQL(Format(sqlGetResults,[s]),
    []) then
    {todo: EH!};
  for i:=sgResults.RowCount-1 downto 1 do
    sgResults.Rows[i].Clear;
  sgResults.RowCount:=1;
  with ibq do
    while not Eof do
      begin
        sgResults.RowCount:=sgResults.RowCount+1;
        if sgResults.RowCount=2 then
          sgResults.FixedRows:=1;
        sgResults.Rows[sgResults.RowCount-1].Add(VarToStr(FieldValues['wrk_test_name']));
        sgResults.Rows[sgResults.RowCount-1].Add(VarToStr(FieldValues['wrk_result']));
        Next
      end;
  if sgResults.RowCount=1 then
    begin
      sgResults.RowCount:=2;
      sgResults.FixedRows:=1
    end
end;

{todo: !!!! viewResultsByStudent !!!! procedure TMainForm.pcTabsChange(Sender: TObject);
begin
  if pcTabs.ActivePage=tsResults then
    ViewResultsByStudent
end;}

end.
