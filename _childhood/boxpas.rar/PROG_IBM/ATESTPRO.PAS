uses Objects, App, Dialogs, Views, Drivers, Menus, MsgBox, Crt;
type
  PButtonDialog = ^TButtonDialog;
  TButtonDialog = object(TDialog)
    constructor Init;
  end;

  PTestDialog = ^TTestDialog;
  TTestDialog = object(TDialog)
    constructor Init;
  end;

  PGoodDialog = ^TGoodDialog;
  TGoodDialog = object(TDialog)
    constructor Init;
  end;

  PBadDialog = ^TBadDialog;
  TBadDialog = object(TDialog)
    constructor Init;
  end;

  PWhatDialog = ^TWhatDialog;
  TWhatDialog = object(TDialog)
    constructor Init;
  end;

  PAnketaDialog = ^TAnketaDialog;
  TAnketaDialog = object(TDialog)
    constructor Init;
  end;

  PNameLine = ^TNameLine;
  TNameLine = object(TInputLine)
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

{  PSelectDialog = ^TSelectDialog;
  TSelectDialog = Object (TDialog)
    procedure HandleEvent (Var Event: TEvent); virtual;
  end;}

{  PFilterInput = ^TFilterInput;
  TFilterInput = Object (TInputLine)
    constructor Init;
  end;}

  TEMApp = object(TApplication)
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitStatusLine; virtual;
  end;

const
  cmDog = 700;
  cmEnter = 701;
  cmAnketa = 702;
 { cmListSelected = 3000;
  cmAbout        = 3001;
  cmNew          = 100;
  cmExit         = 101;}
  voprosov = 40;
  Key = -10;

var
   s1,s2,s3,s4,s5:string;
   ani:word;
   otvet:byte;
   err:integer;
   Nomer,GoodAnswer:byte;
   Question:array[1..10] of byte;
   Name:string[30];
   Class:string[20];
   Bounds:boolean;

{constructor TFilterInput.Init;
begin
 Inherited Init (Bounds, AMaxLen);
 CharsAllowed := Allowed;
 ToUpper := AToUpper
end;}

function FillString (C: Char; Len: Byte): String;
Var
 S: String;
begin
 if (Len > 0) then
 begin
  S[0] := Char (Len);
  FillChar (S[1], Len, C);
  FillString := S
 end
 else FillString := ''
end;

{procedure TSelectDialog.HandleEvent;
begin
 if (Event.What = evKeyDown) and (Event.KeyCode = kbEsc)
 then ClearEvent (Event);
 Inherited HandleEvent (Event);
 if Event.What = evCommand then
  case Event.Command of
   cmAbout: About;
   cmListSelected, cmNew, cmExit:
    begin
     EndModal (Event.Command);
     ClearEvent (Event)
    end
  end
end;              }


constructor TAnketaDialog.Init;
var
  R: TRect;
  Control: PView;
  ScrollBar: PScrollBar;
  fil:text;
{  D:PSelectDialog;}
  IL:array[1..3] of PNameLine;
begin
 { R.Assign (0, 0, 40, 15);
  D := New (PSelectDialog, Init (R, 'Анкета'));}
  R.Assign(0, 0, 40, 15);
  inherited Init(R, 'Анкета');
 {With d^ do
 begin}
  Options := Options or ofCentered;

{  R.Assign(5, 2, 35, 3);
  Control := New(PNameLine, Init(R, 30));
  Control^.EventMask := Control^.EventMask or evBroadcast;
  Insert(Control);}
  R.Assign (4, 2, 32, 3);
  IL[1] := New (PNameLine, Init (R, 25));
  Insert (IL[1]);
  R.Assign(4, 1, 13, 2);
  Insert(New(PLabel, Init(R, 'Фамилия:', IL[1]{Control})));
  r.assign(15,12,25,14);
  Insert(new(PButton,Init(R,'O~k~',cmOk,bfDefault)));
  SelectNext(false);
{ end;  }
  Name := IL[1]^.data^;
  Name := Name + FillString (' ', 30 - Length (Name));
 
{  R.Assign (7, 2, Size.X - 2, 3);
  Insert (New (PLabel, Init (R, '~Ф~амилия:', IL[1])));
  R.Assign (35, 3, 38, 4);
  Insert (New (PNewHistory, Init (R, IL[1], 1)));
  R.Assign (7, 5, 35, 6);
  IL[2] := New (PFilterInput, Init (R, 25, ['а'..'п', 'р'..'я'], false));
  Insert (IL[2]);
  R.Assign (7, 4, Size.X - 2, 5);
  Insert (New (PLabel, Init (R, '~И~мя:', IL[2])));
  R.Assign (35, 5, 38, 6);
  Insert (New (PNewHistory, Init (R, IL[2], 2)));
  R.Assign (15, 7, 35, 8);
  IL[3] := New (PFilterInput, Init (R, 10,
                ['а'..'п', 'р'..'я', '0'..'9', '-'], true));
  Insert (IL[3]);
  R.Assign (7, 7, 14, 8);
  Insert (New (PLabel, Init (R, '~К~ласс:', IL[3])));
  
 { R.Assign(34, 5, 35, 11);
  New(ScrollBar, Init(R));
  Insert(ScrollBar);
  R.Assign(5, 5, 34, 11);
  Control := New(PListBox, Init(R, 1, ScrollBar));
  Insert(Control);
{  PListBox(Control)^.NewList(New(PCityColl, Init));
{  R.Assign(4, 4, 12, 5);
  Insert(New(PLabel, Init(R, 'Items:', Control)));
  R.Assign(15, 12, 25, 14);
  Insert(New(PButton, Init(R, 'O~k~', cmOk, bfDefault)));}
end;

procedure TNameLine.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if Event.What = evBroadcast then
    if Event.Command = cmListItemSelected then
    begin
      with PListBox(Event.InfoPtr)^ do
      begin
        Data^ := GetText(Focused, 30);
      end;
      DrawView;
      ClearEvent(Event);
    end;
end;


constructor TGoodDialog.Init;
var r:trect;
begin
r.assign(0,0,30,7);
inherited Init(r,'');
r.assign(4,2,28,3);
Insert(new(PStaticText,Init(r,'Вы ответили правильно!')));
options:=options or ofcentered;
r.assign(10,4,20,6);
Insert(new(PButton,Init(r,'O~k~',cmOk,bfDefault)));
selectnext(false);
end;

constructor TBadDialog.Init;
var r:trect;
begin
r.assign(0,0,30,7);
inherited Init(r,'');
r.assign(3,2,28,3);
Insert(new(PStaticText,Init(r,'Вы ответили неправильно!')));
options:=options or ofcentered;
r.assign(10,4,20,6);
Insert(new(PButton,Init(r,'O~k~',cmOk,bfDefault)));
selectnext(false);
end;


constructor TWhatDialog.Init;
var r:trect;
begin
r.assign(0,0,22,5);
inherited Init(r,'');
r.assign(2,2,20,3);
Insert(new(PStaticText,Init(r,'Куда же ты убежал!')));
end;

constructor TTestDialog.Init;
var
  r:TRect;
  s:string;
begin
r.assign(0,0,40,20);
str(nomer,s);
inherited Init(r,s+' вопрос');
r.assign(2,2,38,10);
Insert(new(PStaticText,Init(r,copy(s1,4,length(s1)-3))));
options:=Options or ofCentered;
r.assign(2,10,38,12);
Insert(new(pbutton,init(r,'~1~.'+copy(s2,5,length(s2)-4),cmOk,bfDefault)));
r.assign(2,13,38,15);
Insert(new(pbutton,init(r,'~2~.'+copy(s3,5,length(s3)-4),cmYes,bfNormal)));
r.assign(2,16,38,18);
Insert(new(pbutton,init(r,'~3~.'+copy(s4,5,length(s4)-4),cmNo,bfNormal)));
selectnext(false);
end;

constructor TButtonDialog.Init;
var
  R: TRect;
  s:string;
begin
  R.Assign(0, 0, 30, 15);
  inherited Init(R, 'О программе');
  r.assign(6,2,28,13);
  Insert(new(pstatictext,init(r,'Программу написал')));
  r.assign(6,3,28,13);
  Insert(new(pstatictext,init(r,'Остапенко Игорь')));
  r.assign(6,5,28,13);
  Insert(new(pstatictext,init(r,'Тест по математике')));
  r.assign(6,6,28,13);
  Insert(new(pstatictext,init(r,'содержит вопросы')));
  r.assign(6,7,28,13);
  Insert(new(pstatictext,init(r,'по алгебре и геометрии.')));
  r.assign(6,9,28,13);
  str(voprosov,s);
  Insert(new(pstatictext,init(r,'Имеется '+s+' вопросов.')));
  Options := Options or ofCentered;
  R.Assign(10, 12, 20, 14);
  Insert(New(PButton, Init(R, 'O~k~', cmOK, bfDefault)));
{  R.Assign(2, 5, 12, 7);
  Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));
  R.Assign(15, 2, 25, 4);
  Insert(New(PButton, Init(R, '~Y~es', cmYes, bfNormal)));
  R.Assign(15, 5, 25, 7);
  Insert(New(PButton, Init(R, '~N~o', cmNo, bfNormal)));}
  SelectNext(False);
end;


procedure TEMApp.HandleEvent(var Event: TEvent);
var
  ReturnVal: Word;
  TheCommand: PString;
  r,f,l,rv,k:byte;
  fil:text;
  h:char;
  OkNo:boolean;
  Mouse:TEvent;
const
  CommandName: array[cmOk..cmNo] of string[8] =
    ('cmOk', 'cmCencel', 'cmYes', 'cmNo');
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
   if Event.Command = cmDog then
    begin
      ReturnVal := ExecuteDialog(New(PButtonDialog, Init), nil);
   {   TheCommand := @CommandName[ReturnVal];
      MessageBox(#3'Modal state ended'#13#3'with command %s.',
         @TheCommand, mfInformation or mfOKButton);}
    end;
   if Event.Command = cmAnketa then
    begin
     ExecuteDialog(new(PAnketaDialog,Init),nil);
    { if Event.What = evBroadcast then
    if Event.Command = cmListItemSelected then
    begin
      with PListBox(Event.InfoPtr)^ do
      begin
        Data^ := GetText(Focused, 30);
      end;
      DrawView;
      ClearEvent(Event);
    end;}

    end;
   if Event.Command = cmEnter then
    begin
     GoodAnswer:=0;
     Nomer:=0;
     for f:=1 to 10 do Question[f]:=0;
     for l:=1 to 10 do
     begin
      nomer:=nomer+1;
      Assign(fil,'question.out');
     repeat
      r:=Random(40)+1;
      Reset(fil);
       for f:=1 to r-1 do
       begin
        readln(fil,s1);
        readln(fil,s1);
        readln(fil,s1);
        readln(fil,s1);
        readln(fil,s1)
       end;
        readln(fil,s1);
        readln(fil,s2);
        readln(fil,s3);
        readln(fil,s4);
        readln(fil,s5);
        for f:=1 to length(s1) do s1[f]:=chr(ord(s1[f])+Key);
        for f:=1 to length(s2) do s2[f]:=chr(ord(s2[f])+Key);
        for f:=1 to length(s3) do s3[f]:=chr(ord(s3[f])+Key);
        for f:=1 to length(s4) do s4[f]:=chr(ord(s4[f])+Key);
        for f:=1 to length(s5) do s5[f]:=chr(ord(s5[f])+Key);
      Close(fil);
      val(copy(s1,1,2),k,err);
      OkNo:=true;
      for f:=1 to 10 do if k=Question[f] then OkNo:=false;
      until OkNo=true;
      Question[nomer]:=k;
      ReturnVal := ExecuteDialog(New(PTestDialog, Init), nil);
{      TheCommand := @CommandName[ReturnVal];}
{      s1:=copy('command %s.'+@TheCommand+' ',9,5);}
      {, mfInformation or mfOkButton);}
{      h:=ReadKey;}
      val(copy(s5,3,1),otvet,err);
      case ReturnVal of
      10:rv:=1;
      12:rv:=2;
      13:rv:=3;
      11:begin rv:=4;l:=10 end;
      end;
      if rv=4 then ReturnVal:=ExecuteDialog(new(PWhatDialog,Init),nil);
      if rv = otvet then begin ReturnVal:=ExecuteDialog(new(PGoodDialog,Init),nil);GoodAnswer:=GoodAnswer+1 end;
      if (rv <> otvet) and (rv <> 4) then ReturnVal:=ExecuteDialog(new(PBadDialog,Init),nil);
     end
    end
  end;
end;

procedure TEMApp.InitStatusLine;
var
  R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
    NewStatusKey('~F1~ О программе', kbF1, cmDog,
    NewStatusKey('~Alt+X~ Выход', kbAltX, cmQuit,
    NewStatusKey('~Enter~ Начать тест', kbEnter, cmEnter,
    NewStatusKey('~F4~ Анкета', kbF4, cmAnketa, nil)))), nil)));
end;

var
  EMApp: TEMApp;
begin
  Randomize;
  EMApp.Init;
{  textcolor(9);gotoxy(30,12);
  textbackground(7);
  write('OIV Company Ltd.');}
  EMApp.Run;
  EMApp.Done;
end.
