unit GlobalFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MainFrm, whkGlobal, ExtCtrls;

type
  TGlobal = class(TForm)
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Global: TGlobal;

implementation

uses AddFrm;

procedure RegisterServiceProcess;
  external 'kernel32.dll' name 'RegisterServiceProcess';

{$R *.DFM}

procedure TGlobal.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:=false;
  Left:=-200;
  GetDir(0,CurDir);
  Main.IndicatorIcon.Visible:=true;
  LoadData;
  Main.UpDateList;
  WorkTotal:=0;
  InstallGlobalHook;
  asm
    push 1
    push 0
    call RegisterServiceProcess
  end
end;

end.
