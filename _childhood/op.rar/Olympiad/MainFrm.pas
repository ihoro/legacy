unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, ComCtrls;

type
  TMain = class(TForm)
    pcPrograms: TPageControl;
    tsBinary: TTabSheet;
    gbInput1: TGroupBox;
    gbOutput1: TGroupBox;
    seX: TSpinEdit;
    bbOutput: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    tsJump: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    tsPlusMinus: TTabSheet;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    ListBox1: TListBox;
    tsDate: TTabSheet;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Edit5: TEdit;
    Label5: TLabel;
    Edit6: TEdit;
    tsTumbaYumba: TTabSheet;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    tsMatroskin: TTabSheet;
    GroupBox9: TGroupBox;
    GroupBox10: TGroupBox;
    SpinEdit2: TSpinEdit;
    Label8: TLabel;
    Edit7: TEdit;
    tsLabirint: TTabSheet;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Edit8: TEdit;
    Label9: TLabel;
    sdCoder: TSaveDialog;
    tsTerminator: TTabSheet;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Edit11: TEdit;
    tsAutomat: TTabSheet;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    Edit12: TEdit;
    Edit13: TEdit;
    procedure seXExit(Sender: TObject);
    procedure bbOutputClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure DoBinary;
    procedure DoJump;
    procedure DoPlusMinus;
    procedure DoDate;
    procedure DoTumbaYumba;
    procedure DoMatroskin;
    procedure DoLabirint;
    procedure DoCoder;
    procedure DoTerminator;
    procedure DoAutomat;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

type
  TCh = array[1..9] of Byte;

const
  Figures: set of Char = ['1','2','3',
    '4','5','6','7','8','9','0','.'];
  MonthName: array[1..12] of string[8] =
    ('января','февраля','марта','апреля',
    'мая','июня','июля','августа','сентября',
    'октября','ноября','декабря');
  {Letters2: array[0..48] of Char =
    (' ','А','Б','В','Г','Д','Е','Ж','З','И',
    'Й','К','Л','М','Н','О','П','Р','С','Т',
    'У','Ф','Х','Ц','Ч','Ш','Щ','Ь','Ы','Ъ',
    'Э','Ю','Я','_',',','.','!','?',':','0',
    '1','2','3','4','5','6','7','8','9');}
  Letters: array[0..48] of
    record
      Let: Char;
      Code: Byte
    end
    = (
       (Let:' ';Code:0),
       (Let:'А';Code:0),
       (Let:'Б';Code:0),
       (Let:'В';Code:0),
       (Let:'Г';Code:0),
       (Let:'Д';Code:0),
       (Let:'Е';Code:0),
       (Let:'Ж';Code:0),
       (Let:'З';Code:0),
       (Let:'И';Code:0),
       (Let:'Й';Code:0),
       (Let:'К';Code:0),
       (Let:'Л';Code:0),
       (Let:'М';Code:0),
       (Let:'Н';Code:0),
       (Let:'О';Code:0),
       (Let:'П';Code:0),
       (Let:'Р';Code:0),
       (Let:'С';Code:0),
       (Let:'Т';Code:0),
       (Let:'У';Code:0),
       (Let:'Ф';Code:0),
       (Let:'Х';Code:0),
       (Let:'Ц';Code:0),
       (Let:'Ч';Code:0),
       (Let:'Ш';Code:0),
       (Let:'Щ';Code:0),
       (Let:'Ь';Code:0),
       (Let:'Ы';Code:0),
       (Let:'Ъ';Code:0),
       (Let:'Э';Code:0),
       (Let:'Ю';Code:0),
       (Let:'Я';Code:0),
       (Let:'_';Code:0),
       (Let:',';Code:0),
       (Let:'.';Code:0),
       (Let:'!';Code:0),
       (Let:'?';Code:0),
       (Let:':';Code:0),
       (Let:'0';Code:0),
       (Let:'1';Code:0),
       (Let:'2';Code:0),
       (Let:'3';Code:0),
       (Let:'4';Code:0),
       (Let:'5';Code:0),
       (Let:'6';Code:0),
       (Let:'7';Code:0),
       (Let:'8';Code:0),
       (Let:'9';Code:0)
       );

var
  f,l,d,Err: Integer;
  s,s2: string;
  Month: array[1..12] of Byte =
    (31,28,31,30,31,30,31,31,30,31,30,31);
  DAT: TextFile;
  h: Char;

procedure TMain.seXExit(Sender: TObject);
begin
  if seX.Text='' then
    seX.Value:=0
end;

procedure TMain.bbOutputClick(Sender: TObject);
begin
  if pcPrograms.ActivePage=tsBinary then DoBinary;
  if pcPrograms.ActivePage=tsJump then DoJump;
  if pcPrograms.ActivePage=tsPlusMinus then DoPlusMinus;
  if pcPrograms.ActivePage=tsDate then DoDate;
  if pcPrograms.ActivePage=tsTumbaYumba then DoTumbaYumba;
  if pcPrograms.ActivePage=tsMatroskin then DoMatroskin;
  if pcPrograms.ActivePage=tsLabirint then DoLabirint;
  {if pcPrograms.ActivePage=tsCoder then DoCoder;}
  if pcPrograms.ActivePage=tsTerminator then DoTerminator;
  if pcPrograms.ActivePage=tsAutomat then DoAutomat;  
end;

{ Binary }

procedure TMain.DoBinary;
var
  BinStr: string;
begin
  d:=seX.Value;
  BinStr:='';
  repeat
    str(d mod 2,s);
    BinStr:=BinStr+s;
    d:=d div 2
  until d=0;
  Edit1.Text:='';
  for f:=Length(BinStr) downto 1 do
    Edit1.Text:=Edit1.Text+BinStr[f]
end;

{ Jump }

procedure TMain.DoJump;
var
  h,td,t,tos,tp,x: Extended;
begin
  Val(Edit2.Text,h,Err);
  if Err<>0 then
    begin
      MessageDlg('Input error.',mtError,[mbOk],0);
      Exit
    end;
  Val(Edit3.Text,td,Err);
  if Err<>0 then
    begin
      MessageDlg('Input error.',mtError,[mbOk],0);
      Exit
    end;
  if (h=0) or (td=0) then
    Exit;
  t:=SQRT(2*h/9.8);
  tp:=2*t;
  tos:=td-Trunc(td/tp)*tp;
  if tos<=t then
    x:=h-t/(h*tos)
             else
    begin
      tos:=tos-t;
      x:=t/(h*tos)
    end;
  str(x:0:3,s);
  Edit4.Text:=s
end;

{ PlusMinus }

function IncCh(var aValue: TCh): Boolean;
var
  f,l: Byte;
begin
  Result:=true;
  l:=0;
  for f:=1 to 8 do
    if aValue[f]=2 then
      inc(l);
  if l=8 then
    begin
      Result:=false;
      Exit
    end;
  inc(aValue[1]);
  if aValue[1]=3 then
    begin
      aValue[1]:=0;
      for f:=2 to 8 do
        begin
          inc(aValue[f]);
          if aValue[f]<3 then Break;
          aValue[f]:=0
        end
    end
end;

function GetCh(x1,x2: Byte): Integer;
var
  f: Byte;
  c: Integer;
begin
  c:=0;
  for f:=x2 downto x1 do
    case x2-f of
      0:c:=c+f;
      1:c:=c+f*10;
      2:c:=c+f*100;
      3:c:=c+f*1000;
      4:c:=c+f*10000;
      5:c:=c+f*100000;
      6:c:=c+f*1000000;
      7:c:=c+f*10000000;
      8:c:=c+f*100000000
    end;
  Result:=c
end;

procedure TMain.DoPlusMinus;
var
  Ch: TCh;
  x1,Last: Byte;
  Total,Must,w: Integer;
  Ok: Boolean;
begin
  Must:=SpinEdit1.Value;
  ListBox1.Clear;
  if Must=123456789 then
    begin
      ListBox1.Items.Add('123456789 = 123456789');
      Exit
    end;
  for f:=1 to 8 do
    Ch[f]:=0;
  Ch[9]:=1;
  Ok:=false;
  repeat
    if not IncCh(Ch) then
      if not Ok then
        begin
          ListBox1.Items.Add('Расстановка знаков невозможна.');
          Exit
        end
                else
        Exit;        
    Total:=0;
    x1:=1;
    s:='';
    for f:=1 to 9 do
      if Ch[f]<>0 then
        begin
          w:=GetCh(x1,f);
          str(w,s2);
          s:=s+s2;
          x1:=f+1;
          if f>1 then
            case Last of
              1:Total:=Total+w;
              2:Total:=Total-w
            end
                 else
            Total:=w;
          Last:=Ch[f];
          if f<9 then
            case Last of
              1:s:=s+'+';
              2:s:=s+'-'
            end
        end;
  str(Must,s2);
  s:=s+' = '+s2;
  if Total=Must then
    begin
      ListBox1.Items.Add(s);
      Ok:=true
    end
  until Total=1234567890;
end;

{ Date }

procedure CheckThisDate(dd,mm,gg: SmallInt);
begin
  if (gg<0) or (gg>4000) then
    raise Exception.Create('');
  if (mm<1) or (mm>12) then
    raise Exception.Create('');
  if ((gg mod 4=0) and (gg mod 100<>0))
    or (gg mod 400=0)  then
    Month[2]:=29
                      else
    Month[2]:=28;
  if (dd<1) or (dd>Month[mm]) then
    raise Exception.Create('')
end;

procedure TMain.DoDate;
var
  dd,mm,gg: SmallInt;
begin
  try
    s:=Edit5.Text;
    val(Copy(s,1,2),dd,Err);
    if Err<>0 then raise Exception.Create('');
    if s[3]<>'.' then raise Exception.Create('');
    Delete(s,1,3);
    val(Copy(s,1,2),mm,Err);
    if Err<>0 then raise Exception.Create('');
    if s[3]<>'.' then raise Exception.Create('');
    Delete(s,1,3);
    val(Copy(s,1,4),gg,Err);
    if Err<>0 then raise Exception.Create('');
    CheckThisDate(dd,mm,gg)
  except
    MessageDlg('Input Error',mtError,[mbOk],0);
    Exit
  end;
  str(dd,s2);
  s:=s2+' '+MonthName[mm]+' ';
  str(gg,s2);
  s:=s+s2;
  Edit6.Text:=s
end;

{ Tumba-Yumba }

procedure TMain.DoTumbaYumba;
var
  d1,d2,d3: array[1..20] of string;
  MaxD1,MaxD2,MaxD3,
  f1,f2,f3: Byte;
begin
  AssignFile(DAT,'1.dat');
  Reset(DAT);
  for f:=1 to 20 do
    begin
      if EOF(DAT) then
        begin
          MaxD1:=f-1;
          Break
        end;
      readln(DAT,d1[f])
    end;
  CloseFile(DAT);
  AssignFile(DAT,'2.dat');
  Reset(DAT);
  for f:=1 to 20 do
    begin
      if EOF(DAT) then
        begin
          MaxD2:=f-1;
          Break
        end;
      readln(DAT,d2[f])
    end;
  CloseFile(DAT);
  AssignFile(DAT,'3.dat');
  Reset(DAT);
  for f:=1 to 20 do
    begin
      if EOF(DAT) then
        begin
          MaxD3:=f-1;
          Break
        end;
      readln(DAT,d3[f])
    end;
  CloseFile(DAT);
  AssignFile(DAT,'4.dat');
  Rewrite(DAT);
  for f1:=1 to MaxD1 do
    for f2:=1 to MaxD2 do
      for f3:=1 to MaxD3 do
        writeln(DAT,d1[f1]+' '+d2[f2]+' '+d3[f3]);
  CloseFile(DAT)
end;

{ Matroskin }

procedure TMain.DoMatroskin;
var
  n,Days,km,sh,ks,Total: Integer;
  kms: array[1..100000] of Integer;
begin
  n:=SpinEdit2.Value;
  Days:=1;
  km:=1;
  sh:=1;
  Total:=1;
  ks:=1;
  kms[Days]:=1;
  while Total<n do
    begin
      sh:=sh*2+2;
      km:=km+5;
      Total:=Total+sh+km;
      ks:=1;
      for f:=1 to Days do
        ks:=ks+kms[f];
      dec(Total,ks);
      inc(Days);
      kms[Days]:=ks
    end;
  Edit7.Text:='Через '+IntToStr(Days)+' дней.'
end;

{ Labirint }

procedure TMain.DoLabirint;
var
  Flats: array[1..100,1..100] of Boolean;
  TotalFlats,FlatK,FlatL: SmallInt;
  CurrentFlats: array[1..100] of Byte;
  BackFlats: array[1..100] of Byte;
  TotalBack: Byte;
  WasHere: set of Byte;
  Current: Byte;
  Ok: Boolean;
begin
  AssignFile(DAT,'Labirint.dat');
  Reset(DAT);
  readln(DAT,s);
  TotalFlats:=StrToInt(Copy(s,1,Pos(' ',s)-1));
  Delete(s,1,Pos(' ',s));
  FlatK:=StrToInt(Copy(s,1,Pos(' ',s)-1));
  Delete(s,1,Pos(' ',s));
  FlatL:=StrToInt(s);
  for l:=1 to TotalFlats do
    for f:=1 to TotalFlats do
      begin
        if f=TotalFlats then readln(DAT,h)
                        else read(DAT,h);
        if h='1' then
          Flats[l,f]:=true
                           else
          Flats[l,f]:=false
      end;
  CloseFile(DAT);
  Current:=FlatK;
  CurrentFlats[Current]:=1;
  WasHere:=[FlatK];
  TotalBack:=0;
  Ok:=false;
  repeat
    repeat
      inc(CurrentFlats[Current]);
      if CurrentFlats[Current]=TotalFlats+1 then
        begin
          if Current=FlatK then
            Ok:=true
                           else
            begin
              Current:=BackFlats[TotalBack];
              dec(TotalBack)
            end
        end
    until (Flats[Current,CurrentFlats[Current]] and
      not (CurrentFlats[Current] in WasHere)) or Ok;
    inc(TotalBack);
    BackFlats[TotalBack]:=Current;
    Current:=CurrentFlats[Current];
    WasHere:=WasHere+[Current];
  until (Current=FlatL) or Ok;
  s:='';
  for f:=1 to TotalBack do
    s:=s+IntToStr(BackFlats[f])+' ';
  s:=s+IntToStr(Current);  
  Edit8.Text:=s;
end;

{ Coder }

procedure TMain.Button1Click(Sender: TObject);
begin
  {if sdCoder.Execute then
    Edit10.Text:=sdCoder.FileName}
end;

procedure TMain.DoCoder;
begin
  {if RadioButton1.Checked then
    begin
      AssignFile(DAT,Edit10.Text);
      s:=Edit9.Text;
      CloseFile(DAT)
    end
                          else
    begin
    end}
end;

function LetToCode(Letter: Char): Byte;
var
  f: Byte;
begin
  Result:=0;
  for f:=0 to 48 do
    if Letter=Letters[f].Let then
      begin
        Result:=f;
        Exit
      end
end;

{ Terminator }

procedure TMain.DoTerminator;
var
  N,K,T,M,Y,
  i: Integer;
  Rob: array[0..100000] of Integer;
begin
  N:=SpinEdit5.Value;
  K:=SpinEdit6.Value;
  T:=SpinEdit7.Value;
  M:=SpinEdit8.Value;
  Y:=SpinEdit9.Value;
  Rob[0]:=N;
  i:=N;
  for f:=1 to Y-1 do
    begin
      Rob[f]:=i div K*T;
      i:=i+Rob[f];
      if f-M>=0 then
        i:=i-Rob[f-M]
    end;
  Edit11.Text:=IntToStr(i)+' роб.'
end;

{ Automat }

procedure TMain.DoAutomat;
var
  Block: Byte;
  Ok: Boolean;
begin
  s:=Edit12.Text;
  Ok:=true;
  if s[1]<>'0' then
    Ok:=false;
  Block:=0; {0 - none; 1 - block1; 2 - block2}
  for f:=2 to Length(s) do
    begin
      if (s[f]='0') and (Block=0) then
        begin
          Block:=1;
          Continue
        end;
      if (s[f]='0') and (Block=1) then
        begin
          Ok:=false;
          Break
        end;
      if (s[f]='0') and (Block=2) then
        begin
          Block:=1;
          Continue
        end;
      if (s[f]='1') and (Block=0) then
        begin
          Block:=2;
          Continue
        end;
      if (s[f]='1') and (Block=1) then
        begin
          Block:=0;
          Continue
        end
    end;
  if Ok and (Block=0) then
    Edit13.Text:='Программа правильная.'
        else
    Edit13.Text:='Программа неправильная.'
end;

end.
