uses Dos, App, Objects, Menus, Drivers, Views, StdDlg, Memory, Dialogs;
const
     cmWork = 203;
     cmDosShell = 204;
     cmCan = 205;
     cmDelete = 206;
     cmSearch = 207;
     cmEdit = 208;
     cmAdd = 209;

     WinCom1:TCommandSet = [cmSave,cmWork];
     WinCom2:TCommandSet = [cmOpen];
     LName = 25;
     LPhone = 11;
     LAddr = 40;
     {MaxLine = 300;}
     LLine = LName+LPhone+LAddr;
type
    DataType = file of record
                 Name:string[LName];
                 Phone:string[LPhone];
                 Addr:string[LAddr]
               end;
    PDlgWin = ^TDlgWin;
    TDlgWin = object(TDialog)
            procedure HandleEvent(var Event:TEvent); virtual;
              end;
    PWorkWin = ^TWorkWin;
    TWorkWin = object(TWindow)
             constructor Init(Bounds:TRect);
               end;
    TNoteBook = object(TApplication)
              PW:PWorkWin;
              procedure InitStatusLine; virtual;
              procedure InitMenuBar; virtual;
              procedure HandleEvent(var Event:TEvent); virtual;
              procedure FileOpen;
              procedure FileSave;
              procedure ChangeDir;
              procedure DosCall;
              procedure Work;
                end;
   PInterior = ^TInterior;
   TInterior = object(TScroller)
             PS:PStringCollection;
             Location:Word;
             constructor Init(var Bounds:TRect;HS,VS:PScrollBar);
             procedure Draw; virtual;
             procedure ReadFile;
             procedure HandleEvent(var Event:TEvent); virtual;
             destructor Done; virtual;
               end;

var
   DataFile:DataType;
   OpFileF:boolean;
   FileName:PathStr;
   WinOpen:boolean;
{   NLines:Word;
   Lines:array[1..MaxLine] of string[LLine];}

procedure TNoteBook.InitStatusLine;
var R:TRect;
begin
GetExtent(R);
R.A.Y:=R.B.Y-1;
StatusLine:=New(PStatusLine,Init(R,
            NewStatusDef(0,$FFFF,
            NewStatusKey('~Alt-X~ Выход',kbAltX,cmQuit,
            NewStatusKey('~F2~ Закрыть',kbF2,cmSave,
            NewStatusKey('~F3~ Открыть',kbF3,cmOpen,
            NewStatusKey('~F4~ Работа',kbF4,cmWork,
            NewStatusKey('~F10~ Меню',kbF10,cmMenu,
            nil))))),
            nil)));
DisableCommands(WinCom1)
end;
procedure TNoteBook.InitMenuBar;
var R:TRect;
begin
GetExtent(R);
R.B.Y:=R.A.Y+1;
MenuBar:=New(PMenuBar,Init(R,
         NewMenu(
         NewSubMenu('~F~ Файл',hcNoContext,
           NewMenu(
           NewItem('~1~ Открыть','F3',kbF3,cmOpen,hcNoContext,
           NewItem('~2~ Закрыть','F2',kbF2,cmSave,hcNoContext,
           NewItem('~3~ Сменить диск','',0,cmChangeDir,hcNoContext,
           NewLine(
           NewItem('~4~ Вызов ДОС','',0,cmDosShell,hcNoContext,
           NewItem('~5~ Конец работы','Alt-X',kbAltX,cmQuit,hcNoContext,
           nil))))))),
         NewItem('~W~ Работа','F4',kbF4,cmWork,hcNoContext,
         nil)))))
end;

procedure TNoteBook.FileOpen;
var
   PF:PFileDialog;
   Control:Word;
   s:PathStr;
begin
New(PF,Init('*.dat','Выберите нужный файл:','Имя файла',fdOpenButton,0));
Control:=DeskTop^.ExecView(PF);
case Control of
StdDlg.cmFileOpen,cmOk:
  begin
    PF^.GetFileName(s);
    FileName:=s;
    Assign(DataFile,s);
    {$I-}
    Reset(DataFile);
    if IOResult<>0 then
       Rewrite(DataFile);
    OpFileF:=true;
    {$I+}
    if OpFileF then
      begin
        DisableCommands(WinCom2);
        EnableCommands(WinCom1)
      end;
  end;
end;
Dispose(PF,Done)
end;
procedure TNoteBook.FileSave;
begin
Close(DataFile);
OpFileF:=false;
DisableCommands(WinCom1);
EnableCommands(WinCom2);
end;
procedure TNoteBook.ChangeDir;
var
   PD:PChDirDialog;
   Control:Word;
begin
New(PD,Init(cdNormal,0));
Control:=DeskTop^.ExecView(PD);
ChDir(PD^.DirInput^.Data^);
Dispose(PD,Done)
end;
procedure TNoteBook.DosCall;
const
     txt='Для возврата введите EXIT в ответ на приглашение ДОС...';
begin
DoneEvents;
DoneVideo;
DoneMemory;
SetMemTop(HeapPtr);
Writeln(txt);
SwapVectors;
Exec(GetEnv('COMSPEC'),'');
SwapVectors;
SetMemTop(HeapEnd);
InitMemory;
InitVideo;
InitEvents;
InitSysError;
Redraw
end;
procedure TInterior.ReadFile;
var
   k:integer;
   Data:DataType;
   s:string;
   f:text;
begin
PS:=New(PStringCollection,Init(100,10));
s:='notebook.pas';
Assign(f,s);
Reset(f);
{NLines:=0;}
while not (EOF(f) or LowMemory) do
  begin
    ReadLn(f,s);
    if s<>'' then PS^.Insert(NewStr(s));
  end;
Close(f);
Location:=0;
exit;
{Seek(DataFile,0);}
{NLines:=FileSize(DataFile);
if NLines>MaxLine then NLines:=MaxLine;}
{for k:=1 to NLines do}
{While not (EOF(DataFile) or LowMemory) do
  begin
    Read(DataFile,Data);
    With Data do
      begin
        s:=Name;
        while Length(s)<LName do s:=s+' ';
        s:=s+Phone;
        while Length(s) < (LName+LPhone) do s:=s+' ';
        s:=s+Addr
      end;
{   Lines[k]:=s}
{    if s<>'' then PS^.Insert(NewStr(s))
  end;
Location:=0}
end;

constructor TInterior.Init;
begin
Inherited Init(Bounds,HS,VS);
ReadFile;
GrowMode:=gfGrowHiX+gfGrowHiY;
SetLimit(LLine,PS^.Count)
end;

destructor TInterior.Done;
begin
Dispose(PS,Done);
Inherited Done
end;

procedure TInterior.Draw;
var
   n,k:integer;
   B:TDrawBuffer;
   P:PString;
   Color:byte;
begin
if Location<Delta.Y then Location:=Delta.Y;
if Location > (Delta.Y+pred(Size.Y)) then Location:=Delta.Y+pred(Size.Y);
for n:=0 to pred(Size.Y) do
  begin
    k:=Delta.Y+n;
    if Location=k then Color:=GetColor(2)
                  else Color:=GetColor(1);
    MoveChar(B,' ',Color,Size.X);
    if k<pred(PS^.Count) then
      begin
        P:=PS^.At(k);
        MoveStr(B,Copy(P^,Delta.X+1,Size.X),Color)
      end;
    WriteLine(0,n,Size.X,1,B)
  end;
end;

function Control:Word;
const
     X=1;
     L=13;
     DX=13;
     But:array[0..4] of string[13] = ('~1~ Выход','~2~ Убрать','~3~ Искать','~4~ Изменить','~5~ Добавить');
     Txt:array[0..3] of string[52] = (
     'Убрать - удалить запись, выделенную цветом',
     'Искать - искать запись, начинающуюся нужными буквами',
     'Изменить - изменить поле (поля) выделенной записи',
     'Добавить - добавить новую запись'
                                     );
var
   R:TRect;
   D:PDlgWin;
   k:integer;
begin
R.Assign(7,6,75,15);
D:=New(PDlgWin,Init(R,'Выберите продолжение:'));
With D^ do
begin
  for k:=0 to 3 do
    begin
      R.Assign(1,k+1,65,k+2);
      Insert(New(PStaticText,Init(R,#3+Txt[k])))
    end;
  for k:=0 to 4 do
    begin
      R.Assign(X+k*DX,6,X+k*DX+L,8);
      Insert(New(PButton,Init(R,But[k],cmCan+k,bfNormal)))
    end;
  SelectNext(false)
end;
Control:=DeskTop^.ExecView(D)
end;

procedure TInterior.HandleEvent;

procedure DeleteItem;
begin
end;
procedure AddItem(Edit:boolean);
begin
end;
{const
     Y=1;
     DY=2;
     L=LName+LPhone+LAddr;
var
   Data:DataType;
   R:TRect;
   InWin:PDialog;
   BName,BPhone,BAddr:PInputLine;
   Control,
   OldCount:Word;
   s:string;
   p:PString;
begin
Seek(DataFile,FileSize(DataFile));
repeat
if Edit then s:='Редактирование:'
        else
            begin
              Str(FileSize(DataFile)+1,s);
              While Length(s) < 3 do s:='0'+s;
              s:='Вводится запись N '+s
            end;
FillChar(Data,SizeOf(Data),' ');
R.Assign(15,5,65,16);
InWin:=New(PDialog,Init(R,s));
With InWin^ do
begin
  R.Assign(2,y+1,2+LName,y+2);
  BName:=New(PInputLine,Init(R,LName));
  Insert(BName);
  R.Assign(2,y,2+LName,y+1);
  Insert(New(PLabel,Init(R,'Имя:',BName)));
  R.Assign(2,y+dy+1,2+LPhone,y+dy+2);
  BPhone:=New(PInputLine,Init(R,LPhone));
  Insert(BPhone);
  R.Assign(2,y+dy,2+LPhone,y+dy+1);
  Insert(New(PLabel,Init(R,'Телефон:',BPhone)));
  R.Assign(2,y+2*dy+1,2+LAddr,y+2*dy+2);
  BAddr:=New(PInputLine,Init(R,LAddr));
  Insert(BAddr);
  R.Assign(2,y+2*dy,2+LAddr,y+2*dy+1);
  Insert(New(PLabel,Init(R,'Адрес:',BAddr)));
  R.Assign(2,y+3*dy+1,12,y+3*dy+3);
  Insert(New(PButton,Init(R,'Ввести',cmOk,bfDefault)));
  R.Assign(22,y+3*dy+1,32,y+3*dy+3);
  Insert(New(PButton,Init(R,'Выход',cmCancel,bfNormal)));
  SelectNext(false);
end;
if Edit then
 with Data do
  begin
    p:=PS^.At(Location);
    s:=p^;
    Name:=Copy(s,1,LName);
    Phone:=Copy(s,succ(LName),LPhone);
    Addr:=Copy(s,succ(LName+LPhone),LAddr);
    InWin^.SetData(Data);
  end;
Control:=DeskTop^.ExecView(InWin);
if Control=cmOk then with Data do
  begin
    if Edit then DeleteItem;
    Name:=BName^.Data^;
    Phone:=BPhone^.Data^;
    Addr:=BAddr^.Data^;
    s[0]:=chr(L);
    FillChar(s[1],L,' ');
    move(Name[1],s[1],Length(Name));
    move(Phone[1],s[succ(LName)],Length(Phone));
    move(Addr[1],s[succ(LName+LPhone)],Length(Addr));
    OldCount:=PS^.Count;
    PS^.Insert(NewStr(s));
    if OldCount<>PS^.Count then
        Write(DataFile,Data)
  end
until Edit or (Control=cmCancel);
Draw
end;}
procedure SearchItem;
begin
end;

var R:TPoint;
Label Cls;
begin
Inherited HandleEvent(Event);
case Event.What of
evCommand:case Event.Command of
            cmClose:begin
Cls:                 case Control of
                       cmCan,
                       cmCancel:EndModal(cmCancel);
                       cmEdit:AddItem(true);
                       cmDelete:DeleteItem;
                       cmSearch:SearchItem;
                       cmAdd:AddItem(false)
                     end
                    end;
            cmZoom:exit
          end;
evMouseDown:begin
              MakeLocal(MouseWhere,R);
              Location:=Delta.Y+R.Y;
              Draw
            end;
evKeyDown:case Event.KeyCode of
            kbEsc:goto Cls;
            kbGrayMinus:if Location>Delta.Y then
                                       begin
                                         dec(Location);
                                         Draw
                                       end;
            kbGrayPlus:if Location < (Delta.Y+pred(Size.Y)) then
                                       begin
                                         inc(Location);
                                         Draw
                                       end;
          end;
end;
end;
procedure TDlgWin.HandleEvent;
begin
Inherited HandleEvent(Event);
if Event.What = evCommand then
  EndModal(Event.Command);
end;

constructor TWorkWin.Init;
var
   HS,VS:PScrollBar;
   Interior:PInterior;
begin
TWindow.Init(Bounds,'Выберите нужную запись. Esc - переход к диалогу',0);
GetClipRect(Bounds);
Bounds.Grow(-1,-1);
VS:=StandardScrollBar(sbVertical+sbHandleKeyBoard);
HS:=StandardScrollBar(sbHorizontal+sbHandleKeyBoard);
Interior:=New(PInterior,Init(Bounds,HS,VS));
Insert(Interior)
end;

procedure TNoteBook.Work;
var
   R:TRect;
   Control:Word;
begin
R.Assign(0,0,80,23);
PW:=New(PWorkWin,Init(R));
Control:=DeskTop^.ExecView(PW);
Dispose(PW,Done);
WinOpen:=true
end;

procedure TNoteBook.HandleEvent;
begin
inherited HandleEvent(Event);
if Event.What = evCommand then
case Event.Command of
 cmOpen:begin
          FileOpen;
          if OpFileF then Work
        end;
 cmSave:FileSave;
 cmChangeDir:ChangeDir;
 cmDosShell:DosCall;
 cmWork:Work
else
    exit
end;
ClearEvent(Event)
end;

var NoteBook: TNoteBook;

begin
NoteBook.Init;
NoteBook.Run;
NoteBook.Done
end.