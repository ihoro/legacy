unit LoginFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TLoginForm = class(TForm)
    leLogin: TLabeledEdit;
    lePassword: TLabeledEdit;
    btnLogin: TButton;
    btnExit: TButton;
    btnHelp: TButton;
    imgLogo: TImage;
    bvlLogin: TBevel;
    gbWelcome: TGroupBox;
    lblStudent: TLabel;
    btnLogout: TButton;
    lblWorks: TLabel;
    sgWorks: TStringGrid;
    btnGoTest: TButton;
    Bevel1: TBevel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGoTestClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    WorksTableName: string;
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;
  UserLogin: string;
  UserGroup: string;
  WorksCount: Integer;

implementation

{$R *.dfm}

uses
  MainFrm, TestFrm, global;

procedure TLoginForm.btnLoginClick(Sender: TObject);
var
  i: Integer;
begin
  if UpperCase(leLogin.Text)=usrAdmin then
    begin
      lePassword.Text:='!';
      Exit
    end;
  if UpperCase(leLogin.Text)=usrTeacher then
    begin
      srvConnect(usrTeacher,lePassword.Text);
      lePassword.Text:='!';
      Visible:=false;
      MainForm.ShowModal;
      srvDisconnect;
      Visible:=true;
      Exit
    end;
  // other users:
  srvConnect(usrStudent,pswStudent);
  if not CheckUser(leLogin.Text) then
    begin
      MessageBox(Handle,'Проверьте правильность ввода.','Ошибка подключения',
        MB_OK+MB_ICONERROR);
      srvDisconnect
    end
                                 else
    begin
      gbWelcome.Visible:=true;
      leLogin.Visible:=false;
      lePassword.Visible:=false;
      btnLogout.Visible:=true;
      btnExit.Visible:=false;
      with MainForm.ibq do
        begin
          lblStudent.Caption:=VarToStr(FieldValues['std_last_name'])+'  '+
            VarToStr(FieldValues['std_first_name'])+'  '+
            VarToStr(FieldValues['std_middle_name']);
          UserGroup:=VarToStr(FieldValues['std_group']);
          WorksTableName:=VarToStr(FieldValues['std_works']);
          if not DoSQL(Format(sqlGetPlansByGroup,[tnPlans,tnTests]),
            [UserGroup,
             DateToStr(Now){,
             TimeToStr(Now)}
             ]) then
            {todo: error here!};
          for i:=sgWorks.RowCount-1 downto 1 do
            sgWorks.Rows[i].Clear;
          sgWorks.RowCount:=1;
          WorksCount:=0;
          while not Eof do
            begin
              if not DoSQL2(Format(sqlGetWorkByTestName,[WorksTableName]),
                [VarToStr(FieldValues['pln_test_name'])
                 ]) then
                {todo: EH!};
              if not MainForm.ibq2.Eof and (VarToStr(FieldValues['pln_test_name'])=
                VarToStr(MainForm.ibq2.FieldValues['wrk_test_name'])) then
                begin
                  Next;
                  Continue
                end;
              sgWorks.RowCount:=sgWorks.RowCount+1;
              if sgWorks.RowCount=2 then
                sgWorks.FixedRows:=1;
              sgWorks.Rows[sgWorks.RowCount-1].Add(VarToStr(FieldValues['pln_date']));
              sgWorks.Rows[sgWorks.RowCount-1].Add(VarToStr(FieldValues['tst_subject']));
              sgWorks.Rows[sgWorks.RowCount-1].Add(VarToStr(FieldValues['pln_test_name']));
              sgWorks.Rows[sgWorks.RowCount-1].Add(VarToStr(FieldValues['tst_teacher']));
              sgWorks.Rows[sgWorks.RowCount-1].Add(VarToStr(FieldValues['pln_time']));
              inc(WorksCount);
              Next
            end;
          if sgWorks.RowCount=1 then
            begin
              sgWorks.RowCount:=2;
              sgWorks.FixedRows:=1
            end
        end;
      if (WorksCount=0) or (WorksCount>4) then
        lblWorks.Caption:=Format(txtWorks05,[WorksCount]);
      if WorksCount=1 then
        lblWorks.Caption:=Format(txtWorks1,[WorksCount]);
      if (WorksCount>1) and (WorksCount<5) then
        lblWorks.Caption:=Format(txtWorks234,[WorksCount]);
      if (WorksCount<>0) and (DateToStr(Now)=sgWorks.Rows[1][0]) then
        btnGoTest.Visible:=true
    end
end;

procedure TLoginForm.btnExitClick(Sender: TObject);
begin
  Close
end;

procedure TLoginForm.btnLogoutClick(Sender: TObject);
begin
  gbWelcome.Visible:=false;
  leLogin.Visible:=true;
  lePassword.Visible:=true;
  btnLogout.Visible:=false;
  btnExit.Visible:=true;
  btnGoTest.Visible:=false;
  srvDisconnect
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  sgWorks.ColWidths[0]:=numWorksCol0Width;
  sgWorks.ColWidths[1]:=numWorksCol1Width;
  sgWorks.ColWidths[2]:=numWorksCol2Width;
  sgWorks.ColWidths[3]:=numWorksCol3Width;
  sgWorks.ColWidths[4]:=numWorksCol4Width;
  sgWorks.Rows[0].Add(hPlanDate);
  sgWorks.Rows[0].Add(hSubject);
  sgWorks.Rows[0].Add(hTestName);
  sgWorks.Rows[0].Add(hTeacher);
  sgWorks.Rows[0].Add(hPlanTime);
end;

procedure TLoginForm.btnGoTestClick(Sender: TObject);
begin
  if MessageBox(Handle,PAnsiChar(txtGoTest),
    PAnsiChar(sgWorks.Rows[1][2]),MB_YESNO+MB_ICONQUESTION)<>IDYES then
    Exit;
  with TestForm do
    begin
      lblTestName.Caption:=sgWorks.Rows[1][1]+': '+sgWorks.Rows[1][2];
      FTestName:=sgWorks.Rows[1][2];
      FWorksTableName:=WorksTableName;
      LoginForm.Visible:=false;
      ShowModal;
      srvDisconnect;
      LoginForm.btnLoginClick(Self);
      LoginForm.Visible:=true
    end
end;

procedure TLoginForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if btnLogout.Visible then
    CanClose:=false
end;

end.
