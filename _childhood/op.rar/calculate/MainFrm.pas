unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Buttons, Registry, ExtCtrls;

type
  TMainForm = class(TForm)
    edtSumm: TEdit;
    edtPercent: TEdit;
    edtN: TEdit;
    lblStartSumm: TLabel;
    lblPercent: TLabel;
    lblN: TLabel;
    btnCalc: TButton;
    edtResult: TEdit;
    lblResult: TLabel;
    lblCopyright: TLabel;
    lblProgramName: TLabel;
    btnDelSumm: TButton;
    btnDelPercent: TButton;
    btnDelN: TButton;
    btnDelResult: TButton;
    XPManifest: TXPManifest;
    imgUp: TImage;
    imgUp2: TImage;
    imgMailMe: TImage;
    imgMailMe2: TImage;
    imgHelp: TImage;
    imgHelp2: TImage;
    procedure btnCalcClick(Sender: TObject);
    procedure btnDelSummClick(Sender: TObject);
    procedure btnDelPercentClick(Sender: TObject);
    procedure btnDelNClick(Sender: TObject);
    procedure btnDelResultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgUp2Click(Sender: TObject);
    procedure imgUpMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure edtSummMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure edtPercentMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure edtNMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure edtResultMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btnCalcMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btnDelSummMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btnDelPercentMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnDelNMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btnDelResultMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure lblProgramNameMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure lblStartSummMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure lblPercentMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure lblNMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure lblResultMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure lblCopyrightMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure imgMailMeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgMailMe2Click(Sender: TObject);
    procedure imgHelpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgHelp2Click(Sender: TObject);
  private
    FLastCalculated: Integer;
    procedure SetLastCalculated(Value: Integer);
  public
    FField: Integer;
    function Check4Empty: Boolean;
    procedure ResetColors;
    property LastCalculated: Integer read FLastCalculated write SetLastCalculated;
  end;

const
  e = 100000000; // ~7
  Numers: set of Char =
    ['0','1','2','3','4','5','6','7','8','9'];
  Numers_Symbols: set of Char =
    ['0','1','2','3','4','5','6','7','8','9','.',','];
  mailme: string = 'mailto:oivsoft@mail.ru';

  txtProgramName = 'Private Calculator';
  txtVersion = 'v1.08';

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btnCalcClick(Sender: TObject);
var
  n,i,j: Integer;
  s,r,p: Extended;
  ss: string;
begin
  ss:=edtSumm.Text;
  for i:=1 to Length(ss) do
    if not (ss[i] in Numers_Symbols) then
      begin
        MessageBox(Handle,PAnsiChar('Неправильный ввод поля "Start Summ"'),PAnsiChar('Ошибка'),
          MB_OK+MB_ICONERROR);
        Exit
      end;
  ss:=edtPercent.Text;
  for i:=1 to Length(ss) do
    if not (ss[i] in Numers_Symbols) then
      begin
        MessageBox(Handle,PAnsiChar('Неправильный ввод поля "Percent"'),PAnsiChar('Ошибка'),
          MB_OK+MB_ICONERROR);
        Exit
      end;
  ss:=edtN.Text;
  for i:=1 to Length(ss) do
    if not (ss[i] in Numers) then
      begin
        MessageBox(Handle,PAnsiChar('Неправильный ввод поля "N"'),PAnsiChar('Ошибка'),
          MB_OK+MB_ICONERROR);
        Exit
      end;
  ss:=edtResult.Text;
  for i:=1 to Length(ss) do
    if not (ss[i] in Numers_Symbols) then
      begin
        MessageBox(Handle,PAnsiChar('Неправильный ввод поля "Result"'),PAnsiChar('Ошибка'),
          MB_OK+MB_ICONERROR);
        Exit
      end;
  ss:=edtSumm.Text;
  if Pos('.',ss)<>0 then
    ss[Pos('.',ss)]:=',';
  edtSumm.Text:=ss;
  ss:=edtPercent.Text;
  if Pos('.',ss)<>0 then
    ss[Pos('.',ss)]:=',';
  edtPercent.Text:=ss;
  ss:=edtResult.Text;
  if Pos('.',ss)<>0 then
    ss[Pos('.',ss)]:=',';
  edtResult.Text:=ss;
  if not Check4Empty then
    Exit;
  case FField of
    1: begin
         p:=StrToFloat(edtPercent.Text);
         n:=StrToInt(edtN.Text);
         r:=StrToFloat(edtResult.Text);
         s:=Round(r/exp(n*ln(1+p/100))*e)/e;
         edtSumm.Text:=FloatToStr(s);
         LastCalculated:=1
       end;
    2: begin
         s:=StrToFloat(edtSumm.Text);
         n:=StrToInt(edtN.Text);
         r:=StrToFloat(edtResult.Text);
         p:=Round(100*(exp((1/n)*ln(r/s))-1)*e)/e;
         edtPercent.Text:=FloatToStr(p);
         LastCalculated:=2
       end;
    3: begin
         s:=StrToFloat(edtSumm.Text);
         p:=StrToFloat(edtPercent.Text);
         r:=StrToFloat(edtResult.Text);
         n:=Round(ln(r/s)/ln(1+p/100));
         edtN.Text:=IntToStr(n);
         LastCalculated:=3
       end;
    4: begin
         s:=StrToFloat(edtSumm.Text);
         p:=StrToFloat(edtPercent.Text);
         n:=StrToInt(edtN.Text);
         for i:=1 to n do
           s:=s+Round((s*p/100)*e)/e;
         edtResult.Text:=FloatToStr(s);
         LastCalculated:=4
       end
  end
end;

function TMainForm.Check4Empty: Boolean;
var
  i: Integer;
begin
  Result:=true;
  i:=0;
  FField:=0;
  if edtSumm.Text='' then
    begin
      inc(i);
      FField:=1
    end;
  if edtPercent.Text='' then
    begin
      inc(i);
      FField:=2
    end;
  if edtN.Text='' then
    begin
      inc(i);
      FField:=3
    end;
  if edtResult.Text='' then
    begin
      inc(i);
      FField:=4
    end;
  if (i=2) or (i=3) or (i=4) then
    begin
      Result:=false;
      MessageBox(Handle,PAnsiChar('Не все поля заполнены.'+#10+'Должно быть заполнено 3 поля!'),
        PAnsiChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit
    end;
  if (i=0) and (FLastCalculated=0) then
    begin
      Result:=false;
      MessageBox(Handle,PAnsiChar('Должно быть заполнено 3 поля!'),
        PAnsiChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit
    end;
  if i=0 then
    FField:=FLastCalculated
end;

procedure TMainForm.btnDelSummClick(Sender: TObject);
begin
  edtSumm.Text:='';
  edtSumm.SetFocus
end;

procedure TMainForm.btnDelPercentClick(Sender: TObject);
begin
  edtPercent.Text:='';
  edtPercent.SetFocus
end;

procedure TMainForm.btnDelNClick(Sender: TObject);
begin
  edtN.Text:='';
  edtN.SetFocus
end;

procedure TMainForm.btnDelResultClick(Sender: TObject);
begin
  edtResult.Text:='';
  edtResult.SetFocus
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLastCalculated:=0;
  lblProgramName.Caption:=txtProgramName+' '+txtVersion
end;

procedure TMainForm.imgUp2Click(Sender: TObject);
begin
  edtSumm.Text:=edtResult.Text;
  edtResult.Text:=''
end;

procedure TMainForm.imgUpMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  imgUp2.Visible:=true;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.edtSummMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.edtPercentMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.edtNMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.edtResultMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.btnCalcMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.btnDelSummMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.btnDelPercentMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.btnDelNMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.btnDelResultMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.lblProgramNameMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.lblStartSummMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.lblPercentMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.lblNMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.lblResultMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.lblCopyrightMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgUp2.Visible:=false;
  imgMailMe2.Visible:=false;
  imgHelp2.Visible:=false
end;

procedure TMainForm.imgMailMeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgMailMe2.Visible:=true;
  imgHelp2.Visible:=false
end;

procedure TMainForm.imgMailMe2Click(Sender: TObject);
var
  Reg: TRegistry;
  s: string;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if not Reg.OpenKey('\software\clients\mail\',false) then
    begin
      Reg.RootKey:=HKEY_LOCAL_MACHINE;
      Reg.OpenKey('\software\clients\mail\',false)
    end;
  s:=Reg.ReadString('');
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  Reg.OpenKeyReadOnly('\software\clients\mail\'+s+'\protocols\mailto\shell\open\command\');
  s:=UpperCase(Reg.ReadString(''));
  s:=LowerCase(Copy(s,1,Pos('%1',s)-1))+mailme;
  WinExec(PAnsiChar(s),0);
  Reg.Free
end;

procedure TMainForm.SetLastCalculated(Value: Integer);
begin
  FLastCalculated:=Value;
  case Value of
    1: begin
         ResetColors;
         edtSumm.Font.Color:=clBlue
       end;
    2: begin
         ResetColors;
         edtPercent.Font.Color:=clBlue
       end;
    3: begin
         ResetColors;
         edtN.Font.Color:=clBlue
       end;
    4: begin
         ResetColors;
         edtResult.Font.Color:=clBlue
       end
  end
end;

procedure TMainForm.ResetColors;
begin
  edtSumm.Font.Color:=clWindowText;
  edtPercent.Font.Color:=clWindowText;
  edtN.Font.Color:=clWindowText;
  edtResult.Font.Color:=clWindowText
end;

procedure TMainForm.imgHelpMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  imgHelp2.Visible:=true
end;

procedure TMainForm.imgHelp2Click(Sender: TObject);
begin
  MessageBox(Handle,PAnsiChar(
    txtProgramName+' '+txtVersion+#10+#10+
    'Калькулятор для расчета сумм от сложных процентов, когда установленный'+#10+
    'процент от исходной суммы прибавляется к исходной сумме с каждым циклом.'+#10+
    'Точность расчета - 8 знаков после запятой.'+#10+
    '  - Start Summ - исходная сумма;'+#10+
    '  - Percent - установленный процент;'+#10+
    '  - N - количество циклов;'+#10+
    '  - Result - результат.'+#10+
    'Расчет производится для любых переменных перечисленных выше. Для этого'+#10+
    'в поля вводятся все числа кроме искомого. Результат выводится щелчком'+#10+
    'по кнопке "Calculate" или нажатием "Enter" на клавиатуре. После чего'+#10+
    'исходные данные можно изменять, и получать искомое число в том же поле.'+#10+
    'Для смены искомого числа его поле нужно оставить пустым. Для этого'+#10+
    'можно использовать кнопки "Х" соответственно для каждого поля.'+#10+
    'Щелчком по стрелке, число из окна "Result" передается в поле "Start Summ",'+#10+
    'а "Result" очищается.'+#10+#10+

    '            Copyright (c) 2004 by OIVSoft    mailto:oivsoft@mail.ru'
    ),PAnsiChar('О программе'),MB_OK+MB_ICONINFORMATION)
end;

end.
