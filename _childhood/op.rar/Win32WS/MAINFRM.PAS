unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Registry;

type
  TMain = class(TForm)
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TSpisok = array[1..100] of string[128];
  TWndSpisok = array[1..100] of HWnd;

var
  Main: TMain;
  Reg: TRegistry;

  OldWndSpisok,
  WndSpisok: TWndSpisok;

  OldWndTotal,
  WndTotal: Byte;

  OldSpisok,
  Spisok,
  OpenSpisok,
  CloseSpisok,
  ModifySpisok: TSpisok;

  OldTotal,
  Total,
  OpenTotal,
  CloseTotal,
  ModifyTotal: Byte;

  CaptionStr: string;
  s: string;

  DataFile: TextFile;
  DataFileName: string;


implementation

{$R *.DFM}

procedure RegisterServiceProcess;
  external 'kernel32.dll'
  name 'RegisterServiceProcess';

procedure TMain.FormCreate(Sender: TObject);
begin
  asm
    push 1
    push 0
    call RegisterServiceProcess
  end;
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\TaskMon',false);
  DataFileName:=Reg.ReadString('DFN');
  Reg.CloseKey;
  Reg.Free;
  OldTotal:=0;
  Total:=0;
  OldWndTotal:=0;
  WndTotal:=0;
  AssignFile(DataFile,DataFileName);
  {$I-}
  Reset(DataFile);
  if IOResult<>0 then
    begin
      Rewrite(DataFile);
      CloseFile(DataFile)
    end
                else
    CloseFile(DataFile);            
  {$I+}
  AppEnd(DataFile);
  Writeln(DataFile,'');
  Writeln(DataFile,'----------------------');
  Writeln(DataFile,'');
  Writeln(DataFile,DateTimeToStr(Now)+' - Программа включена при загрузке компьютера.');
  Writeln(DataFile,'')
end;

function NotInOldSpisok(CS: string): Boolean;
var
  f: Byte;
begin
  Result:=true;
  for f:=1 to OldTotal do
    if CS=OldSpisok[f] then
      begin
        Result:=false;
        Exit
      end
end;

function NotInOldWndSpisok(w: HWnd): Boolean;
var
  f: Byte;
begin
  Result:=true;
  for f:=1 to OldWndTotal do
    if w=OldWndSpisok[f] then
      begin
        Result:=false;
        Exit
      end
end;

procedure TMain.TimerTimer(Sender: TObject);
var
  Wnd: HWnd;
  Buff: array[0..127] of Char;
  f,l: SmallInt;
  Ok: Boolean;
begin
  OpenTotal:=0;
  CloseTotal:=0;
  ModifyTotal:=0;
  OldSpisok:=Spisok;
  OldTotal:=Total;
  Total:=0;
  OldWndSpisok:=WndSpisok;
  OldWndTotal:=WndTotal;
  WndTotal:=0;
  Wnd:=GetWindow(Handle,gw_HWndFirst);
  while Wnd<>0 do
    begin
      if (Wnd<>Application.Handle) and
        IsWindowVisible(Wnd) and
        (GetWindow(Wnd,gw_Owner) = 0) and
        (GetWindowText(Wnd,Buff,SizeOf(Buff))<>0) then
        begin
          GetWindowText(Wnd,Buff,SizeOf(Buff));
          CaptionStr:=StrPas(Buff);
          if NotInOldWndSpisok(Wnd) then
            begin
              inc(OpenTotal);
              OpenSpisok[OpenTotal]:=CaptionStr
            end
                                    else
            if NotInOldSpisok(CaptionStr) then
              begin
                inc(ModifyTotal);
                ModifySpisok[ModifyTotal]:=CaptionStr
              end;
          inc(Total);
          Spisok[Total]:=CaptionStr;
          inc(WndTotal);
          WndSpisok[WndTotal]:=Wnd
        end;
      Wnd:=GetWindow(Wnd,gw_HWndNext)
    end;
  for f:=1 to OldWndTotal do
    begin
      Ok:=true;
      for l:=1 to WndTotal do
        if OldWndSpisok[f]=WndSpisok[l] then
          Ok:=false;
      if Ok then
        begin
          inc(CloseTotal);
          CloseSpisok[CloseTotal]:=OldSpisok[f]
        end
    end;
  if (OpenTotal<>0) or
    (ModifyTotal<>0) or
    (CloseTotal<>0) then
    begin
      Writeln(DataFile,DateTimeToStr(Now)+' :');
      if OpenTotal<>0 then
        for f:=1 to OpenTotal do
          Writeln(DataFile,'Opened: '+OpenSpisok[f]);
      if ModifyTotal<>0 then
        for f:=1 to ModifyTotal do
          Writeln(DataFile,'Modified: '+ModifySpisok[f]);
      if CloseTotal<>0 then
        for f:=1 to CloseTotal do
          Writeln(DataFile,'Closed: '+CloseSpisok[f]);
      Writeln(DataFile,'')
    end
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  CloseFile(DataFile)
end;

end.
