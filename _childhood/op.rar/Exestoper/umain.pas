unit umain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Gauges, StdCtrls, Registry;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Gauge1: TGauge;
    Label2: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Gauge1.Progress:=Gauge1.Progress+1;
if Gauge1.Progress=100 then Close
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Reg:=TRegistry.Create;
Reg.RootKey:=HKEY_CLASSES_ROOT;
Reg.OpenKey('.exe',false);
Reg.WriteString('','exefile');
Reg.CloseKey;
Reg.DeleteKey('ExeStoper');
Reg.Free
end;

end.
